import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/p2p_chat/p2p_message_model.dart';

/// Function to retrieve all messages from a specific chat session in Firestore.
///
/// - [chatId]: The unique ID of the chat session whose messages need to be retrieved.
/// - Returns: A `Future<List<P2PMessage>>` containing a list of messages sorted chronologically.
///
/// This function performs the following steps:
/// 1. Retrieves a Firestore instance.
/// 2. Queries the Firestore `messages` subcollection within the given chat.
/// 3. Orders the messages by the `timestamp` field in ascending order (oldest to newest).
/// 4. Converts each Firestore document into a `P2PMessage` model instance.
/// 5. Returns the list of messages.
/// 6. Catches and logs any errors that may occur during the process.
Future<List<P2PMessage>> getMessagesFunction(String chatId) async {
  try {
    // Get a Firestore instance
    final firestore = FirebaseFirestore.instance;

    // Query Firestore to retrieve all messages for the given chat
    final querySnapshot = await firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false) // Sort by timestamp (oldest to newest)
        .get();

    // Convert Firestore documents into a list of P2PMessage objects
    return querySnapshot.docs
        .map((doc) => P2PMessage.fromMap(doc.id, doc.data()))
        .toList();
  } catch (e) {
    // Log an error message in case of failure
    print('[ERROR] Failed to fetch messages: $e');

    // Rethrow the exception for higher-level error handling
    rethrow;
  }
}
