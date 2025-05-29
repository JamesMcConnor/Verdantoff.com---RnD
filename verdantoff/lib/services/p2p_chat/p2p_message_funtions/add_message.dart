import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/p2p_chat/p2p_message_model.dart';

/// Function to send and store a new message in Firestore.
///
/// - [chatId]: The unique ID of the chat session where the message will be added.
/// - [message]: The `P2PMessage` object containing message details.
/// - Returns: A `Future<P2PMessage>` with the saved message, including its Firestore-generated ID.
///
/// This function performs the following steps:
/// 1. Retrieves a Firestore instance.
/// 2. Gets a reference to the `messages` subcollection inside the specified chat document.
/// 3. Generates a new document reference for the message.
/// 4. Copies the message object and assigns the newly generated message ID.
/// 5. Saves the message data to Firestore.
/// 6. Updates the chat document with:
///    - The latest message details (`lastMessage` field).
///    - The chat’s `updatedAt` timestamp.
///    - Resets the sender’s unread count.
///    - Increments the recipient’s unread count.
/// 7. Logs a success message and returns the message object with its new ID.
/// 8. Catches and logs any errors that occur during the process.
Future<P2PMessage> addMessageFunction(String chatId, P2PMessage message) async {
  try {
    // Get a Firestore instance
    final firestore = FirebaseFirestore.instance;

    // Get a reference to the messages subcollection inside the chat document
    final messagesRef = firestore.collection('chats').doc(chatId).collection('messages');

    // Generate a new document reference for the message
    final newMessageRef = messagesRef.doc();

    // Create a new message map with the Firestore-generated message ID
    final messageMap = message.copyWith(id: newMessageRef.id).toMap();

    // Save the message to Firestore
    await newMessageRef.set(messageMap);

    // Update the parent chat document with the latest message details
    await firestore.collection('chats').doc(chatId).update({
      'lastMessage': {
        'id': newMessageRef.id, // Store the new message ID
        'content': message.content, // Store the message content
        'senderId': message.senderId, // Store sender's ID
        'type': message.type, // Store message type (e.g., text, image)
        'timestamp': message.timestamp, // Store message timestamp
        'isRecalled': message.isRecalled, // Store message recall status
      },
      'updatedAt': FieldValue.serverTimestamp(), // Update the last modified timestamp
      'unreadCounts.${message.senderId}': 0, // Reset unread count for the sender
      'unreadCounts.${messageMap['receiverId']}': FieldValue.increment(1), // Increment unread count for the recipient
    });

    // Log success message
    print('[INFO] Message added successfully.');

    // Return the message object with the assigned Firestore ID
    return message.copyWith(id: newMessageRef.id);
  } catch (e) {
    // Log an error message in case of failure
    print('[ERROR] Failed to add message: $e');

    // Rethrow the exception for higher-level error handling
    rethrow;
  }
}
