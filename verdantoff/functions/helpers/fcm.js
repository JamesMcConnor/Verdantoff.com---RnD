/**
 * Shared helper for FCM token lookup + safe multicast send.
 */
const admin = require("./admin");
const messaging = admin.messaging();

exports.getFcmTokens = async (uids) => {
  const out = [];
  const db = admin.firestore();
  for (const uid of uids) {
    const snap = await db.collection("users").doc(uid).get();
    const tok = snap.exists ? snap.get("fcmToken") : null;
    if (tok) out.push(tok);
  }
  return out;
};

exports.sendMulticastSafe = async (payload) => {
  if (typeof messaging.sendMulticast === "function") {
    return messaging.sendMulticast(payload);
  }
  if (typeof messaging.sendEachForMulticast === "function") {
    return messaging.sendEachForMulticast(payload);
  }
  throw new Error("FCM multicast API not available");
};
