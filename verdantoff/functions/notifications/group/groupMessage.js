/**
 * Send FCM push when groups/{id}/messages/{messageId} is created.
 * Payload goes to all members (role = owner|admin|member)
 * EXCEPT the senderId stored in message.senderId.
 */
const {onDocumentCreated} = require("firebase-functions/v2/firestore");
const admin = require("../../helpers/admin");
const {getFcmTokens, sendMulticastSafe} = require("../../helpers/fcm");
if (!admin.apps.length) admin.initializeApp();

exports.groupMessage = onDocumentCreated(
    {document: "groups/{groupId}/messages/{messageId}"},
    async (event) => {
      const messageData = event.data ? event.data.data() : null;
      if (!messageData) return null;

      const groupId = event.params.groupId;
      const senderId = messageData.senderId;

      // Get group info
      const groupSnap = await admin
          .firestore()
          .collection("groups")
          .doc(groupId)
          .get();
      if (!groupSnap.exists) return null;
      const groupData = groupSnap.data();

      // Collect all member UIDs excluding sender
      const membersSnap = await admin
          .firestore()
          .collection(`groups/${groupId}/members`)
          .get();

      const recipientIds = membersSnap.docs
          .map((doc) => doc.id)
          .filter((uid) => uid !== senderId);

      if (recipientIds.length === 0) return null;

      const tokens = await getFcmTokens(recipientIds);
      if (tokens.length === 0) return null;

      // Fetch sender nickname (optional improvement)
      const senderDoc = await admin
          .firestore()
          .doc(`groups/${groupId}/members/${senderId}`)
          .get();
      const senderNickname = senderDoc.exists?
       senderDoc.data().nickname || "Someone":
        "Someone";

      const payload = {
        tokens,
        notification: {
          title: groupData.name || "Group Message",
          body:
          messageData.type === "text"?
           `${senderNickname}: ${messageData.content}`:
            `${senderNickname} sent a ${messageData.type}`,
        },
        data: {
          groupId,
          messageId: event.params.messageId,
          senderId,
          messageType: messageData.type,
          timestamp: String(
          messageData.timestamp?
           messageData.timestamp.toMillis():
             Date.now(),
          ),
          click_action: "FLUTTER_NOTIFICATION_CLICK",
        },
      };

      await sendMulticastSafe(payload);
      return null;
    },
);
