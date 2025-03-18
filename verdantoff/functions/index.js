const {onDocumentCreated} = require("firebase-functions/v2/firestore");
const admin = require("firebase-admin");

admin.initializeApp();
const messaging = admin.messaging();

exports.sendChatNotification = onDocumentCreated(
    "chats/{chatId}/messages/{messageId}",
    async (event) => {
      const snapshot = event.data;
      if (!snapshot) {
        console.log("❌ No data in event.");
        return;
      }
      const messageData = snapshot.data();
      const chatId = event.params.chatId;
      if (!messageData) return null;

      const senderId = messageData.senderId;
      const content =
      messageData.content || "You have a new message";
      const timestamp = messageData.timestamp;
      const type = messageData.type;

      // Fetch chat participants from Firestore
      const chatDoc = await admin.firestore()
          .collection("chats")
          .doc(chatId)
          .get();
      if (!chatDoc.exists) {
        console.log("❌ Chat document not found.");
        return null;
      }
      const chatData = chatDoc.data();
      const participants = chatData.participants || [];

      // Exclude sender from recipients (using original IDs)
      const recipientIds = participants.filter((id) => id !== senderId);
      console.log("📌 Sender ID:", senderId);
      console.log("📌 Participants:", participants);
      console.log("📌 Recipient IDs:", recipientIds);

      // Fetch FCM tokens for each recipient
      const tokens = [];
      const invalidTokens = [];
      for (const recipientId of recipientIds) {
        const userDoc = await admin.firestore()
            .collection("users")
            .doc(recipientId)
            .get();
        if (userDoc.exists && userDoc.data().fcmToken) {
          tokens.push(userDoc.data().fcmToken);
          console.log(
              `📌 Fetched token for recipient ${recipientId}: ` +
          userDoc.data().fcmToken,
          );
        } else {
          console.log(
              `ℹ️ No FCM token found for recipient ${recipientId}`,
          );
        }
      }
      if (tokens.length === 0) {
        console.log("❌ No valid FCM tokens, cancelling push notification.");
        return null;
      }

      // Construct push notification payload
      const payload = {
        tokens: tokens,
        notification: {
          title: "New Message",
          body: type === "text" ? content : `New ${type} message`,
        },
        data: {
          chatId: chatId,
          senderId: senderId,
          messageType: type,
          timestamp: timestamp.toString(),
          click_action: "FLUTTER_NOTIFICATION_CLICK",
        },
      };

      try {
        let response;
        if (typeof messaging.sendMulticast === "function") {
          response = await messaging.sendMulticast(payload);
        } else if (
          typeof messaging.sendEachForMulticast === "function"
        ) {
          response = await messaging.sendEachForMulticast(payload);
        } else {
          throw new Error("No multicast sending function available.");
        }
        console.log(
            "📩 Notification sent: Success: " +
          response.successCount +
          ", Failure: " +
          response.failureCount,
        );
        response.responses.forEach((res, idx) => {
          if (!res.success) {
            console.error(
                "❌ Failed to send notification to token: " +
              tokens[idx],
                res.error,
            );
            if (
              res.error.code ===
            "messaging/registration-token-not-registered"
            ) {
              invalidTokens.push(tokens[idx]);
            }
          }
        });
        // Remove invalid tokens from Firestore
        for (const token of invalidTokens) {
          const userSnapshot = await admin.firestore()
              .collection("users")
              .where("fcmToken", "==", token)
              .get();
          userSnapshot.forEach(async (doc) => {
            await doc.ref.update({
              fcmToken: admin.firestore.FieldValue.delete(),
            });
            console.log("🗑️ Removed invalid FCM Token: " + token);
          });
        }
      } catch (error) {
        console.error("❌ Notification sending error:", error);
      }
      return null;
    },
);
