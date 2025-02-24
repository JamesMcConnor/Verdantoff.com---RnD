import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/p2p_chat/p2p_chat_model.dart';

/// Function to update a chat session in Firestore.
///
/// - [chatId]: The unique ID of the chat to be updated.
/// - [updates]: A `P2PChat` object containing the updated values.
/// - Returns: A `Future<void>` indicating the update operation is complete.
///
/// This function performs the following steps:
/// 1. Retrieves a reference to the chat document using its `chatId`.
/// 2. Calls Firestore's `update()` method to update the chat fields with new values.
/// 3. Logs a success message upon successful update.
/// 4. Catches and logs any errors that occur during the process.
Future<void> updateChatFunction(String chatId, P2PChat updates) async {
  // Get a Firestore instance
  final firestore = FirebaseFirestore.instance;

  try {
    // Get a reference to the chat document in Firestore
    final chatRef = firestore.collection('chats').doc(chatId);

    // Update the chat document with new values
    await chatRef.update(updates.toMap());

    // Log success message
    print('[INFO] Chat updated successfully.');
  } catch (e) {
    // Log an error message in case of failure
    print('[ERROR] Failed to update chat: $e');

    // Rethrow the exception for higher-level error handling
    rethrow;
  }
}
