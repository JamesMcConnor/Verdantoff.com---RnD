/// Update the specified session
/// Responsible for updating certain fields of the session
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/p2p_chat/p2p_chat_model.dart';

Future<void> updateChatFunction(String chatId, P2PChat updates) async {
  final firestore = FirebaseFirestore.instance;

  try {
    final chatRef = firestore.collection('chats').doc(chatId);
    await chatRef.update(updates.toMap());

    print('[INFO] Chat updated successfully.');
  } catch (e) {
    print('[ERROR] Failed to update chat: $e');
    rethrow;
  }
}
