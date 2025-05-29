/// Get the user's session list
/// This function retrieves all chat sessions that a user is involved in
/// based on their user ID.

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/p2p_chat/p2p_chat_model.dart';

/// Function to retrieve all chat sessions associated with a specific user.
///
/// - [userId]: The ID of the user whose chat sessions need to be fetched.
/// - Returns: A `Future<List<P2PChat>>` containing a list of chat sessions.
///
/// This function performs the following steps:
/// 1. Queries Firestore for all chats where the user is a participant.
/// 2. Orders the results by `updatedAt` in descending order (latest chats first).
/// 3. Maps Firestore documents to `P2PChat` model instances.
/// 4. Returns the list of chat objects.
/// 5. Handles any errors that may occur during the process.
Future<List<P2PChat>> getChatsFunction(String userId) async {
  // Get a Firestore instance
  final firestore = FirebaseFirestore.instance;

  try {
    // Query Firestore for chats where the user is a participant
    final querySnapshot = await firestore
        .collection('chats')
        .where('participants', arrayContains: userId) // Check if the user is in the chat
        .orderBy('updatedAt', descending: true) // Sort by last updated timestamp (most recent first)
        .get();

    // Convert Firestore documents into a list of P2PChat objects
    return querySnapshot.docs.map((doc) {
      return P2PChat.fromMap(doc.id, doc.data());
    }).toList();
  } catch (e) {
    // Log an error message in case of failure
    print('[ERROR] Failed to fetch chats: $e');

    // Rethrow the exception for higher-level error handling
    rethrow;
  }
}
