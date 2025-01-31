/// Create a new session
/// Responsible for initializing a new session and storing it in the database
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/p2p_chat/p2p_chat_model.dart';

Future<String> createChatFunction(List<String> participants) async {
  final firestore = FirebaseFirestore.instance;

  try {
    final chatRef = firestore.collection('chats').doc();

    final newChat = P2PChat(
      id: chatRef.id,
      type: 'direct',
      participants: participants,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      lastMessage: {},
      unreadCounts: {for (var user in participants) user: 0},
    );

    await chatRef.set(newChat.toMap());

    print('[INFO] Chat created successfully.');
    return chatRef.id;
  } catch (e) {
    print('[ERROR] Failed to create chat: $e');
    rethrow;
  }
}
