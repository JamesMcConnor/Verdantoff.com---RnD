import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/p2p_chat/p2p_message_model.dart';

/// Function to recall (withdraw) a sent message in Firestore.
///
/// - [chatId]: The unique ID of the chat session where the message was sent.
/// - [messageId]: The unique ID of the message to be recalled.
/// - Returns: A `Future<void>` indicating the completion of the recall operation.
///
/// This function performs the following steps:
/// 1. Retrieves a Firestore instance.
/// 2. Gets the current authenticated user's ID.
/// 3. Retrieves the message document from Firestore.
/// 4. Checks if the message exists; if not, throws an error.
/// 5. Converts the document data into a `P2PMessage` model.
/// 6. Ensures that only the sender can recall their own messages.
/// 7. Ensures that the recall is performed within the allowed timeframe.
/// 8. Updates the `isRecalled` field in the message document to `true`.
/// 9. Retrieves the chat document to check if the recalled message is the last message.
/// 10. If the recalled message is the latest, updates the `lastMessage` field in the chat document.
/// 11. Logs a success message.
/// 12. Catches and logs any errors that occur during the process.
Future<void> recallMessageFunction(String chatId, String messageId) async {
  try {
    // Get a Firestore instance
    final firestore = FirebaseFirestore.instance;

    // Get the currently authenticated user's ID
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    // Retrieve the message document from Firestore
    final messageDoc = await firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .get();

    // Check if the message exists; throw an error if it does not
    if (!messageDoc.exists) throw Exception('[ERROR] Message not found.');

    // Convert the Firestore document data into a `P2PMessage` model
    final message = P2PMessage.fromMap(messageDoc.id, messageDoc.data()!);

    // Ensure only the sender can recall their own messages
    if (message.senderId != currentUserId) {
      throw Exception('[ERROR] Permission denied: Cannot recall others\' messages.');
    }

    // Ensure the recall action is performed within the allowed timeframe
    if (DateTime.now().isAfter(message.editableUntil)) {
      throw Exception('[ERROR] Cannot recall message: Time limit exceeded.');
    }

    // Update the message document in Firestore to mark it as recalled
    await firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .update({'isRecalled': true});

    // Retrieve the chat document from Firestore
    final chatDoc = await firestore.collection('chats').doc(chatId).get();
    if (!chatDoc.exists) throw Exception('[ERROR] Chat not found.');

    // Extract the last message details from the chat document
    Map<String, dynamic> lastMessage = chatDoc['lastMessage'] ?? {};

    // If the recalled message is the last message in the chat, update its `isRecalled` status
    if (lastMessage['id'] == messageId) {
      lastMessage['isRecalled'] = true;

      // Update the `lastMessage` field in the chat document
      await firestore.collection('chats').doc(chatId).update({'lastMessage': lastMessage});
    }

    // Log success message
    print('[INFO] Message recalled successfully and chat list updated.');
  } catch (e) {
    // Log an error message in case of failure
    print('[ERROR] Failed to recall message: $e');

    // Rethrow the exception for higher-level error handling
    rethrow;
  }
}
