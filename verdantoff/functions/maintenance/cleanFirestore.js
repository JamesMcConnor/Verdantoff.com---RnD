/**
 * Daily cleanup: old signalling + old ended calls.
 * Path: functions/cleanFirestore.js
 */

const {onSchedule} = require("firebase-functions/v2/scheduler");
const admin = require("../helpers/admin");

exports.cleanFirestore = onSchedule("every 24 hours", async () => {
  const db = admin.firestore();
  const now = Date.now();
  const sigCutoff = new Date(now - 24 * 60 * 60 * 1000); // 24 h
  const callCutoff = new Date(now - 7 * 24 * 60 * 60 * 1000); // 7 d

  const calls = await db.collection("calls").get();
  for (const call of calls.docs) {
    const data = call.data();

    // 1) prune old signalling docs
    const oldSig = await call.ref
        .collection("signalling")
        .where("ts", "<", sigCutoff)
        .get();

    const batch = db.batch();
    oldSig.forEach((doc) => batch.delete(doc.ref));

    // 2) full delete for very old ended calls
    const endedAt = data.endedAt ? data.endedAt.toDate() : null;
    if (data.status === "ended" && endedAt && endedAt < callCutoff) {
      batch.delete(call.ref);
    }
    await batch.commit();
  }
});
