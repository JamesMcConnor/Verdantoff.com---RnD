import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'notification_helper.dart';

class FriendRequestSender {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Check if there are any outstanding friend requests
  Future<bool> checkExistingRequest(String senderId, String receiverId) async {
    try {
      final querySnapshot = await _firestore
          .collection('friend_requests')
          .where('senderId', isEqualTo: senderId)
          .where('receiverId', isEqualTo: receiverId)
          .where('status', isEqualTo: 'pending')
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('[ERROR] Failed to check existing friend requests: $e');
      return false;
    }
  }

  Future<void> sendFriendRequest({
    required String senderId,
    required String receiverId,
    required String message,
    required String alias,
  }) async {
    try {
      if (await checkExistingRequest(senderId, receiverId)) {
        throw Exception('[ERROR] A friend request is already pending.');
      }

      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) throw Exception('[ERROR] User not logged in.');

      final senderDoc = await _firestore.collection('users').doc(senderId).get();
      final senderName = senderDoc.exists ? (senderDoc.data()?['userName'] ?? 'Unknown User') : 'Unknown User';

      final receiverDoc = await _firestore.collection('users').doc(receiverId).get();
      final receiverName = receiverDoc.exists ? (receiverDoc.data()?['userName'] ?? 'Unknown User') : 'Unknown User';

      final expiresAt = DateTime.now().add(Duration(days: 7));

      final friendRequestRef = await _firestore.collection('friend_requests').add({
        'senderId': senderId,
        'senderName': senderName, // The sender's username obtained from the users collection
        'receiverId': receiverId,
        'receiverName': receiverName, // Recipient Name
        'message': message,
        'alias': alias, // Recipient Notes
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
        'expiresAt': expiresAt,
        'updatedAt': null,
        'updatedBy': null,
      });

      await NotificationHelper.addNotification(
        receiverId,
        'friend_request',
        senderId,
        'You have a new friend request.',
        relatedId: friendRequestRef.id, // add relatedId
      );

      print('[INFO] Friend request sent successfully.');
    } catch (e) {
      throw Exception('[ERROR] Failed to send friend request: $e');
    }
  }



}
