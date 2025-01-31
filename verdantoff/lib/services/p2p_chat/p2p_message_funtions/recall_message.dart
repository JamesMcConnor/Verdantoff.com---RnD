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

    if (message.senderId != currentUserId) {
      throw Exception('[ERROR] Permission denied: Cannot recall others\' messages.');
    }

    if (DateTime.now().isAfter(message.editableUntil)) {
      throw Exception('[ERROR] Cannot recall message: Time limit exceeded.');
    }

    await firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .update({'isRecalled': true});

    print('[INFO] Message recalled successfully.');
  } catch (e) {
    print('[ERROR] Failed to recall message: $e');
    rethrow;
  }
}
