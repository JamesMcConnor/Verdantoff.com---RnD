/**
 * Push to owners + admins when someone requests to join a group.
 * Trigger: onCreate of /groups/{id}/joinRequests/{reqId}
 */
const {onDocumentCreated} =
  require("firebase-functions/v2/firestore");
const admin = require("../../helpers/admin");
const {getFcmTokens, sendMulticastSafe} = require("../../helpers/fcm");
if (!admin.apps.length) admin.initializeApp();

exports.groupJoinRequest = onDocumentCreated(
    "groups/{groupId}/joinRequests/{reqId}",
    async (event) => {
      const data = event.data ? event.data.data() : null;
      if (!data) return null;

      const groupId = event.params.groupId;
      const requesterUid = data.userId;

      // ---- fetch roles map from group root ------------------------------
      const groupDoc = await admin
          .firestore()
          .collection("groups")
          .doc(groupId)
          .get();
      if (!groupDoc.exists) return null;

      const rolesMap = groupDoc.get("roles") || {};
      const adminUids = [
        ...(rolesMap.owner || []),
        ...(rolesMap.admin || []),
      ].filter((uid) => uid !== requesterUid); // don't notify requester

      if (adminUids.length === 0) return null;

      const tokens = await getFcmTokens(adminUids);
      if (tokens.length === 0) return null;

      const payload = {
        tokens,
        notification: {
          title: groupDoc.get("name") || "Group Join Request",
          body: `User wants to join your group`,
        },
        data: {
          groupId,
          reqId: event.params.reqId,
          type: "join_request",
          click_action: "FLUTTER_NOTIFICATION_CLICK",
        },
      };

      await sendMulticastSafe(payload);
      return null;
    },
);
