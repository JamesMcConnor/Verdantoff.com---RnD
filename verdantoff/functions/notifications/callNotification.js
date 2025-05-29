const {onDocumentWritten} = require("firebase-functions/v2/firestore");
const admin = require("../helpers/admin");
const {getFcmTokens, sendMulticastSafe} = require("../helpers/fcm");

exports.sendCallNotification = onDocumentWritten(
    {document: "calls/{callId}"},
    async (event) => {
      const callId = event.params.callId;
      const afterSnap = event.data?.after;
      const beforeSnap = event.data?.before;

      /* 1 ─ call deleted / invalid --------------------------------------- */
      if (!afterSnap?.exists) return null;
      const after = afterSnap.data();
      const before = beforeSnap?.exists ? beforeSnap.data() : null;

      if (after.status !== "ringing") return null;

      /* 2 ─ Calculate the list of UIDs that need to be pushed */
      let targets = [];
      if (!before || before.status !== "ringing") {
      // (a) first join ringing
        targets = (after.invitedUids || []).filter((u) => u !== after.hostId);
      } else {
      // (b) Add invitees in ringing state
        const prev = new Set(before.invitedUids || []);
        for (const uid of after.invitedUids || []) {
          if (!prev.has(uid) && uid !== after.hostId) targets.push(uid);
        }
      }
      if (targets.length === 0) return null;

      /* 2-b Exclude joined members (If joinedAt is set,considered joined)*/
      const joinedSnap = await admin
          .firestore()
          .collection(`calls/${callId}/participants`)
          .where("joinedAt", "!=", null)
          .get();

      for (const doc of joinedSnap.docs) {
        const i = targets.indexOf(doc.id);
        if (i >= 0) targets.splice(i, 1);
      }
      if (targets.length === 0) return null;

      /* 3 ─ get FCM token*/
      const tokens = await getFcmTokens(targets);
      if (tokens.length === 0) {
        console.log("No tokens for", targets);
        return null;
      }

      /* 4 ─  caller name (optional)*/
      let hostName = null;
      try {
        const hostDoc = await admin
            .firestore()
            .doc(`users/${after.hostId}`)
            .get();
        hostName = hostDoc.exists ? hostDoc.get("displayName") || null : null;
      } catch (e) {
        console.error("[sendCallNotification] host fetch error:", e);
      }

      /* 5 ─ sent FCM  */
      const payload = {
        tokens,
        notification: {
          title: hostName ? `${hostName} is calling…` : "Incoming call",
          body:
          after.type === "voice" ?
            "Voice call" :
            after.type === "video" ?
            "Video call" :
            "Screen-share request",
        },
        data: {
          type: "incoming_call",
          callId,
          callType: after.type,
          hostId: after.hostId,
          route: "/call/incoming",
          click_action: "FLUTTER_NOTIFICATION_CLICK",
        },
      };

      await sendMulticastSafe(payload);
      console.log(`📞 Push sent → ${targets.length} user(s) for call ${callId}`);
      return null;
    },
);
