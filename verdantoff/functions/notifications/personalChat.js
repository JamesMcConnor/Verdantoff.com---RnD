const {onDocumentCreated} = require("firebase-functions/v2/firestore");
const admin = require("../helpers/admin");
const {getFcmTokens, sendMulticastSafe} = require("../helpers/fcm");


exports.personalChat = onDocumentCreated(
    "chats/{chatId}/messages/{messageId}",
    async (event) => {
      const snap = event.data;
      if (!snap) return null;

      const msg = snap.data();
      const chatId = event.params.chatId;
      const senderId = msg.senderId;

      // Fetch participants
      const chatDoc = await admin.firestore()
          .collection("chats").doc(chatId).get();
      if (!chatDoc.exists) return null;
      const participants = chatDoc.get("participants") || [];
      const recipientIds = participants.filter((id) => id !== senderId);

      const tokens = await getFcmTokens(recipientIds);
      if (tokens.length === 0) return null;

      const payload = {
        tokens,
        notification: {
          title: "New Message",
          body: msg.type === "text" ? msg
              .content : `New ${msg.type} message`,
        },
        data: {
          chatId,
          senderId,
          messageType: msg.type,
          timestamp: String(msg.timestamp || Date.now()),
          click_action: "FLUTTER_NOTIFICATION_CLICK",
        },
      };
      await sendMulticastSafe(payload);
      return null;
    },
);
