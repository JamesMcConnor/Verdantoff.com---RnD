//Responsibilities: Manage chat related notifications.
// Add new notifications.
// Update notification status.
// Query user notifications.

import 'package:cloud_firestore/cloud_firestore.dart';

class P2PNotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Adds a notification for a specific user.
  /// [receiverId] - ID of the user to receive the notification.
  /// [type] - Type of the notification (e.g., friend_request).
  /// [relatedId] - Related ID for the notification (e.g., message ID).
  Future<void> addNotification(String receiverId, String type, String relatedId) async {
    try {
      final notificationRef = _firestore.collection('notifications').doc();

      await notificationRef.set({
        'receiverId': receiverId,
        'type': type,
        'relatedId': relatedId,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'pending',
      });

      print('[INFO] Notification added successfully.');
    } catch (e) {
      print('[ERROR] Failed to add notification: $e');
      rethrow;
    }
  }

  /// Updates the status of a notification.
  /// [notificationId] - ID of the notification to update.
  /// [status] - New status for the notification.
  Future<void> updateNotificationStatus(String notificationId, String status) async {
    try {
      final notificationRef = _firestore.collection('notifications').doc(notificationId);

      await notificationRef.update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      print('[INFO] Notification status updated successfully.');
    } catch (e) {
      print('[ERROR] Failed to update notification status: $e');
      rethrow;
    }
  }

  /// Retrieves notifications for a specific user.
  /// [userId] - ID of the user.
  Future<List<Map<String, dynamic>>> getNotifications(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('notifications')
          .where('receiverId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();

      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('[ERROR] Failed to fetch notifications: $e');
      rethrow;
    }
  }
}
