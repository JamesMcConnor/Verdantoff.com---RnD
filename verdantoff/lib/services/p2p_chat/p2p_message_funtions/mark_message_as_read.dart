/// Update the read status of the message
/// This function marks a specific message as read by adding the user ID
/// to the `isReadBy` field in Firestore.

import 'package:cloud_firestore/cloud_firestore.dart';

/// Function to mark a message as read in Firestore.
///
/// - [chatId]: The unique ID of the chat session.
/// - [messageId]: The unique ID of the message to be marked as read.
/// - [userId]: The ID of the user who has read the message.
/// - Returns: A `Future<void>` indicating the update operation is complete.
///
/// This function performs the following steps:
/// 1. Retrieves a Firestore instance.
/// 2. Gets a reference to the specific message document in Firestore.
/// 3. Updates the message document by adding the `userId` to the `isReadBy` array.
/// 4. Logs a success message when the operation is successful.
/// 5. Catches and logs any errors that occur during the update process.
Future<void> markMessageAsReadFunction(String chatId, String messageId, String userId) async {
  // Get a Firestore instance
  final firestore = FirebaseFirestore.instance;

  try {
    // Get a reference to the specific message document in Firestore
    final messageRef = firestore.collection('chats').doc(chatId).collection('messages').doc(messageId);

    // Update the message document to mark it as read by adding the user ID to the `isReadBy` array
    await messageRef.update({
      'isReadBy': FieldValue.arrayUnion([userId]), // Adds user ID to the array without duplication
    });

    // Log success message
    print('[INFO] Message marked as read by user $userId.');
  } catch (e) {
    // Log an error message in case of failure
    print('[ERROR] Failed to mark message as read: $e');

    // Rethrow the exception for higher-level error handling
    rethrow;
  }
}
