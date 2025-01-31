import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/p2p_chat/p2p_message_model.dart';


Future<void> editMessageFunction(String chatId, String messageId, String newContent) async {
  try {
    final firestore = FirebaseFirestore.instance;
    final messageRef = firestore.collection('chats').doc(chatId).collection('messages').doc(messageId);
    final messageDoc = await messageRef.get();

    if (!messageDoc.exists) throw Exception('[ERROR] Message not found.');

    final message = P2PMessage.fromMap(messageDoc.id, messageDoc.data()!);

    if (DateTime.now().isAfter(message.editableUntil)) {
      throw Exception('[ERROR] Message is no longer editable.');
    }

    await messageRef.update({'content': newContent, 'isEdited': true});

    final chatRef = firestore.collection('chats').doc(chatId);
    final chatDoc = await chatRef.get();
    final lastMessage = chatDoc.data()?['lastMessage'];

    if (lastMessage != null && lastMessage['id'] == messageId) {
      await chatRef.update({
        'lastMessage': {
          ...lastMessage,
          'content': newContent,
        },
      });
    }

    print('[INFO] Message edited successfully.');
  } catch (e) {
    print('[ERROR] Failed to edit message: $e');
    rethrow;
  }
}
