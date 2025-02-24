import 'package:cloud_firestore/cloud_firestore.dart';

/// Function to increment the unread message count for a user in a specific chat.
///
/// - [chatId]: The unique ID of the chat session.
/// - [userId]: The user ID for whom the unread message count should be updated.
/// - Returns: A `Future<void>` indicating the update operation is complete.
///
/// This function performs the following steps:
/// 1. Retrieves a reference to the chat document using `chatId`.
/// 2. Calls Firestore's `update()` method to increment the unread message count for the given `userId`.
/// 3. Logs a success message upon successful update.
/// 4. Catches and logs any errors that occur during the update process.
Future<void> updateUnreadCountsFunction(String chatId, String userId) async {
  // Get a Firestore instance
  final firestore = FirebaseFirestore.instance;

  try {
    // Get a reference to the chat document in Firestore
    final chatRef = firestore.collection('chats').doc(chatId);

    // Increment the unread count for the specified user
    await chatRef.update({
      'unreadCounts.$userId': FieldValue.increment(1), // Increase unread count by 1
    });

    // Log success message
    print('[INFO] Unread counts updated successfully.');
  } catch (e) {
    // Log an error message in case of failure
    print('[ERROR] Failed to update unread counts: $e');

    // Rethrow the exception for higher-level error handling
    rethrow;
  }
}
