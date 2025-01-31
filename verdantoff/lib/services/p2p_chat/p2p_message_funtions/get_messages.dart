import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/p2p_chat/p2p_message_model.dart';


Future<List<P2PMessage>> getMessagesFunction(String chatId) async {
  try {
    final firestore = FirebaseFirestore.instance;
    final querySnapshot = await firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .get();

    return querySnapshot.docs
        .map((doc) => P2PMessage.fromMap(doc.id, doc.data()))
        .toList();
  } catch (e) {
    print('[ERROR] Failed to fetch messages: $e');
    rethrow;
  }
}
