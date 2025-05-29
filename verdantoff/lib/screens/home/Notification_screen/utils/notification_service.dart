import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetches notifications for the current user.
  static Stream<QuerySnapshot> getUserNotifications(String userId) {
    return _firestore
        .collection('notifications')
        .where('receiverId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  /// Fetches sender details including name and avatar.
  static Future<Map<String, dynamic>> fetchSenderDetails(String notificationId, Map<String, dynamic> notificationData) async {
    final senderId = notificationData['from'] ?? '';
    if (senderId.isEmpty) return {'senderName': 'Unknown User', 'avatar': ''};

    try {
      final userDoc = await _firestore.collection('users').doc(senderId).get();
      final senderName = userDoc.exists ? (userDoc.data()?['userName'] ?? 'Unknown User') : 'Unknown User';
      final senderAvatar = userDoc.exists ? (userDoc.data()?['avatar'] ?? '') : '';

      await _firestore.collection('notifications').doc(notificationId).update({
        'fromName': senderName,
        'avatar': senderAvatar,
      });

      return {'senderName': senderName, 'avatar': senderAvatar};
    } catch (e) {
      print('[ERROR] Failed to fetch sender details: $e');
      return {'senderName': 'Unknown User', 'avatar': ''};
    }
  }

  /// Updates the notification status and ensures both sender and receiver get correct messages.
  static Future<void> updateNotification(String notificationId, String status, String type, String senderId, String receiverId) async {
    try {
      final senderDoc = await _firestore.collection('users').doc(senderId).get();
      final receiverDoc = await _firestore.collection('users').doc(receiverId).get();

      final senderName = senderDoc.exists ? (senderDoc.data()?['userName'] ?? 'Unknown User') : 'Unknown User';
      final receiverName = receiverDoc.exists ? (receiverDoc.data()?['userName'] ?? 'Unknown User') : 'Unknown User';

      final senderAvatar = senderDoc.exists ? (senderDoc.data()?['avatar'] ?? '') : '';
      final receiverAvatar = receiverDoc.exists ? (receiverDoc.data()?['avatar'] ?? '') : '';

      String receiverMessage;
      String senderMessage;

      if (status == 'accepted') {
        receiverMessage = 'You are now friends with "$senderName".';
        senderMessage = 'Your friend request has been accepted by "$receiverName".';
      } else if (status == 'rejected') {
        receiverMessage = 'You have rejected "$senderName"’s friend request.';
        senderMessage = 'Your friend request to "$receiverName" was rejected.';
      } else {
        receiverMessage = 'You have a new friend request.';
        senderMessage = 'A new friend request was sent.';
      }

      await _firestore.collection('notifications').doc(notificationId).update({
        'status': status,
        'type': type,
        'message': receiverMessage,
      });

      await _firestore.collection('notifications').add({
        'receiverId': senderId,
        'from': receiverId,
        'fromName': receiverName,
        'avatar': receiverAvatar,
        'status': status,
        'message': senderMessage,
        'timestamp': FieldValue.serverTimestamp(),
      });

      print('[INFO] Notification updated: status=$status, type=$type');
    } catch (e) {
      print('[ERROR] Failed to update notification: $e');
    }
  }

}
