import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/p2p_chat/p2p_message_model.dart';

Future<void> recallMessageFunction(String chatId, String messageId) async {
  try {
    final firestore = FirebaseFirestore.instance;
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    final messageDoc = await firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .get();

    if (!messageDoc.exists) throw Exception('[ERROR] Message not found.');

    final message = P2PMessage.fromMap(messageDoc.id, messageDoc.data()!);

    // Only the sender can withdraw a message
    if (message.senderId != currentUserId) {
      throw Exception('[ERROR] Permission denied: Cannot recall others\' messages.');
    }

    // Exceeding the editing time, no withdrawal is allowed
    if (DateTime.now().isAfter(message.editableUntil)) {
      throw Exception('[ERROR] Cannot recall message: Time limit exceeded.');
    }

    // Updates a message in the `messages` collection
    await firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .update({'isRecalled': true});

    // Get the `lastMessage` of the `chats` collection
    final chatDoc = await firestore.collection('chats').doc(chatId).get();
    if (!chatDoc.exists) throw Exception('[ERROR] Chat not found.');

    Map<String, dynamic> lastMessage = chatDoc['lastMessage'] ?? {};

    // If `lastMessage.id` and `messageId` are the same, update `isRecalled`
    if (lastMessage['id'] == messageId) {
      lastMessage['isRecalled'] = true;

      // Synchronously update `lastMessage` of `chats` collection
      await firestore.collection('chats').doc(chatId).update({'lastMessage': lastMessage});
    }

    print('[INFO] Message recalled successfully and chat list updated.');
  } catch (e) {
    print('[ERROR] Failed to recall message: $e');
    rethrow;
  }
}
