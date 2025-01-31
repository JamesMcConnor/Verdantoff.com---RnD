/// Update unread count
/// Update the number of unread messages based on the session ID and user ID
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> updateUnreadCountsFunction(String chatId, String userId) async {
  final firestore = FirebaseFirestore.instance;

  try {
    final chatRef = firestore.collection('chats').doc(chatId);

    await chatRef.update({
      'unreadCounts.$userId': FieldValue.increment(1),
    });

    print('[INFO] Unread counts updated successfully.');
  } catch (e) {
    print('[ERROR] Failed to update unread counts: $e');
    rethrow;
  }
}
