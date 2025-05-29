import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/p2p_chat/p2p_message_model.dart';

/// Function to edit an existing message in Firestore.
///
/// - [chatId]: The unique ID of the chat session containing the message.
/// - [messageId]: The unique ID of the message to be edited.
/// - [newContent]: The updated content for the message.
/// - Returns: A `Future<void>` indicating the completion of the edit operation.
///
/// This function performs the following steps:
/// 1. Retrieves a Firestore instance.
/// 2. Gets a reference to the specific message document in Firestore.
/// 3. Fetches the message document to check if it exists.
/// 4. If the message does not exist, throws an exception.
/// 5. Converts the document data into a `P2PMessage` object.
/// 6. Checks if the message is still within its editable timeframe (`editableUntil`).
/// 7. If the edit deadline has passed, throws an exception.
/// 8. Updates the message content and sets `isEdited` to `true`.
/// 9. Retrieves the parent chat document to check if the edited message is the latest one.
/// 10. If the edited message is the latest, updates the `lastMessage` field in the chat document.
/// 11. Logs a success message.
/// 12. Catches and logs any errors that occur during the process.
Future<void> editMessageFunction(String chatId, String messageId, String newContent) async {
  try {
    // Get a Firestore instance
    final firestore = FirebaseFirestore.instance;

    // Get a reference to the specific message document in Firestore
    final messageRef = firestore.collection('chats').doc(chatId).collection('messages').doc(messageId);

    // Fetch the message document from Firestore
    final messageDoc = await messageRef.get();

    // Check if the message exists; throw an error if it does not
    if (!messageDoc.exists) throw Exception('[ERROR] Message not found.');

    // Convert the Firestore document data into a `P2PMessage` model
    final message = P2PMessage.fromMap(messageDoc.id, messageDoc.data()!);

    // Check if the message is still editable
    if (DateTime.now().isAfter(message.editableUntil)) {
      throw Exception('[ERROR] Message is no longer editable.');
    }

    // Update the message content and mark it as edited
    await messageRef.update({'content': newContent, 'isEdited': true});

    // Get a reference to the chat document
    final chatRef = firestore.collection('chats').doc(chatId);
    final chatDoc = await chatRef.get();

    // Retrieve the last message stored in the chat document
    final lastMessage = chatDoc.data()?['lastMessage'];

    // If the edited message is the latest message in the chat, update the chat's `lastMessage` field
    if (lastMessage != null && lastMessage['id'] == messageId) {
      await chatRef.update({
        'lastMessage': {
          ...lastMessage, // Preserve other fields
          'content': newContent, // Update content only
        },
      });
    }

    // Log success message
    print('[INFO] Message edited successfully.');
  } catch (e) {
    // Log an error message in case of failure
    print('[ERROR] Failed to edit message: $e');

    // Rethrow the exception for higher-level error handling
    rethrow;
  }
}
