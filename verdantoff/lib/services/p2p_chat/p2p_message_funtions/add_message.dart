import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/p2p_chat/p2p_message_model.dart';


Future<P2PMessage> addMessageFunction(String chatId, P2PMessage message) async {
  try {
    final firestore = FirebaseFirestore.instance;
    final messagesRef = firestore.collection('chats').doc(chatId).collection('messages');
    final newMessageRef = messagesRef.doc();

    final messageMap = message.copyWith(id: newMessageRef.id).toMap();
    await newMessageRef.set(messageMap);

    await firestore.collection('chats').doc(chatId).update({
      'lastMessage': {
        'id': newMessageRef.id,
        'content': message.content,
        'senderId': message.senderId,
        'type': message.type,
        'timestamp': message.timestamp,
        'isRecalled': message.isRecalled,
      },
      'updatedAt': FieldValue.serverTimestamp(),
      'unreadCounts.${message.senderId}': 0,
      'unreadCounts.${messageMap['receiverId']}': FieldValue.increment(1),
    });

    print('[INFO] Message added successfully.');
    return message.copyWith(id: newMessageRef.id);
  } catch (e) {
    print('[ERROR] Failed to add message: $e');
    rethrow;
  }
}
