/// Create a new session
/// This function is responsible for initializing a new peer-to-peer chat session
/// and storing it in the Firestore database.

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/p2p_chat/p2p_chat_model.dart';

/// Function to create a new chat session in Firestore.
///
/// - [participants]: A list of user IDs that will be part of the chat.
/// - Returns: A `Future<String>` containing the unique chat ID.
///
/// This function performs the following steps:
/// 1. Generates a new unique document reference for the chat.
/// 2. Creates a `P2PChat` object with initial values.
/// 3. Stores the chat object in the Firestore `chats` collection.
/// 4. Returns the generated chat ID if successful.
/// 5. Catches and prints any errors that occur during the process.
Future<String> createChatFunction(List<String> participants) async {
  // Get a Firestore instance
  final firestore = FirebaseFirestore.instance;

  try {
    // Generate a unique document reference for the new chat session
    final chatRef = firestore.collection('chats').doc();

    // Create a new chat instance with default values
    final newChat = P2PChat(
      id: chatRef.id, // Assign the generated document ID as the chat ID
      type: 'direct', // Set chat type to "direct" (one-on-one chat)
      participants: participants, // List of participant user IDs
      createdAt: DateTime.now(), // Set the chat creation timestamp
      updatedAt: DateTime.now(), // Set the last update timestamp
      lastMessage: {}, // Initialize lastMessage as an empty object
      unreadCounts: {for (var user in participants) user: 0}, // Initialize unread message count for each participant
    );

    // Store the newly created chat in Firestore
    await chatRef.set(newChat.toMap());

    // Log a success message
    print('[INFO] Chat created successfully.');

    // Return the chat ID
    return chatRef.id;
  } catch (e) {
    // Log an error message in case of failure
    print('[ERROR] Failed to create chat: $e');

    // Rethrow the exception to allow higher-level handling
    rethrow;
  }
}
