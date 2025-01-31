/// Get the user's session list
/// Get all related sessions based on the user ID
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/p2p_chat/p2p_chat_model.dart';

Future<List<P2PChat>> getChatsFunction(String userId) async {
  final firestore = FirebaseFirestore.instance;

  try {
    final querySnapshot = await firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .orderBy('updatedAt', descending: true)
        .get();

    return querySnapshot.docs.map((doc) {
      return P2PChat.fromMap(doc.id, doc.data());
    }).toList();
  } catch (e) {
    print('[ERROR] Failed to fetch chats: $e');
    rethrow;
  }
}
