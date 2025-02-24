/// Create or get an existing session
/// This function checks if a chat session already exists between the given participants.
/// If a session is found, it returns the chat ID. Otherwise, it creates a new chat session.

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/p2p_chat/p2p_chat_model.dart';
import 'create_chat.dart';

/// Function to create or fetch an existing peer-to-peer chat session.
///
/// - [participants]: A list of user IDs that will be part of the chat.
/// - Returns: A `Future<String>` containing the chat ID (existing or newly created).
///
/// This function performs the following steps:
/// 1. Sorts the participants list to ensure consistent ordering.
/// 2. Queries Firestore to find an existing chat where:
///    - The chat type is "direct".
///    - At least one participant matches.
/// 3. Iterates through the results to check if any chat contains the exact participants.
/// 4. If a matching chat is found, returns its ID.
/// 5. If no existing chat is found, calls `createChatFunction` to create a new one.
/// 6. Handles any errors that may occur.
Future<String> createOrFetchChatFunction(List<String> participants) async {
  // Get a Firestore instance
  final firestore = FirebaseFirestore.instance;

  try {
    // Ensure a consistent order for participant IDs
    participants.sort();

    // Query Firestore for existing direct chat sessions that include the first participant
    final querySnapshot = await firestore
        .collection('chats')
        .where('type', isEqualTo: 'direct') // Ensure it's a one-on-one chat
        .where('participants', arrayContains: participants[0]) // Check if at least one participant is in the chat
        .get();

    // Iterate through retrieved chat sessions
    for (var doc in querySnapshot.docs) {
      final data = P2PChat.fromMap(doc.id, doc.data()); // Convert Firestore data to P2PChat model
      final existingParticipants = data.participants..sort(); // Sort participants for comparison

      // Check if the retrieved chat contains the exact same participants
      if (existingParticipants.toSet().containsAll(participants)) {
        return doc.id; // Return the chat ID if an exact match is found
      }
    }

    // If no matching chat is found, create a new one
    return await createChatFunction(participants);
  } catch (e) {
    // Log an error message in case of failure
    print('[ERROR] Failed to create or fetch chat: $e');

    // Rethrow the exception for higher-level error handling
    rethrow;
  }
}
