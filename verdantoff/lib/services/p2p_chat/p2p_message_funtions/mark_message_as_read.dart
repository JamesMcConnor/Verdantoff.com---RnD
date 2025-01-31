/// Update the read status of the message
/// Mark the specified message as read
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> markMessageAsReadFunction(String chatId, String messageId, String userId) async {
  final firestore = FirebaseFirestore.instance;

  try {
    final messageRef = firestore.collection('chats').doc(chatId).collection('messages').doc(messageId);

    await messageRef.update({
      'isReadBy': FieldValue.arrayUnion([userId]),
    });

    print('[INFO] Message marked as read by user $userId.');
  } catch (e) {
    print('[ERROR] Failed to mark message as read: $e');
    rethrow;
  }
}
