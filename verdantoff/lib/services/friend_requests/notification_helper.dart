import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationHelper {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> addNotification(
      String receiverId,
      String type,
      String from,
      String message, {
        String? relatedId,
      }) async {
    try {
      await _firestore.collection('notifications').add({
        'receiverId': receiverId,
        'type': type,
        'from': from,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'pending',
        'relatedId': relatedId, // Add the relatedId field
      });
      print('[INFO] Notification added successfully.');
    } catch (e) {
      print('[ERROR] Failed to add notification: $e');
      throw e;
    }
  }



  static Future<void> updateNotificationStatus(String relatedId, String type, String status) async {
    final relatedNotification = await _firestore
        .collection('notifications')
        .where('relatedId', isEqualTo: relatedId)
        .where('type', isEqualTo: 'friend_request')
        .get();

    if (relatedNotification.docs.isNotEmpty) {
      final notificationId = relatedNotification.docs.first.id;
      await _firestore.collection('notifications').doc(notificationId).update({
        'type': type,
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }
}
