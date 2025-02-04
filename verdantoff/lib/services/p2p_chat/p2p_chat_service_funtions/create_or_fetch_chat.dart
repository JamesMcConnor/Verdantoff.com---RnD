/// Create or get an existing session
/// Check if there is an existing session, create one if not
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/p2p_chat/p2p_chat_model.dart';
import 'create_chat.dart';

Future<String> createOrFetchChatFunction(List<String> participants) async {
  final firestore = FirebaseFirestore.instance;

  try {
    participants.sort();

    final querySnapshot = await firestore
        .collection('chats')
        .where('type', isEqualTo: 'direct')
        .where('participants', arrayContains: participants[0])
        .get();

    for (var doc in querySnapshot.docs) {
      final data = P2PChat.fromMap(doc.id, doc.data());
      final existingParticipants = data.participants..sort();

      if (existingParticipants.toSet().containsAll(participants)) {
        return doc.id;
      }
    }

    return await createChatFunction(participants);
  } catch (e) {
    print('[ERROR] Failed to create or fetch chat: $e');
    rethrow;
  }
}
