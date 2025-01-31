import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'notification_helper.dart';

class FriendRequestHandler {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> acceptFriendRequest(String requestId) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) throw Exception('[ERROR] User not logged in.');

    try {
      final requestDoc = await _firestore.collection('friend_requests').doc(requestId).get();
      if (!requestDoc.exists) throw Exception('[ERROR] Friend request does not exist.');

      final requestData = requestDoc.data();
      if (requestData == null || requestData['status'] != 'pending') {
        throw Exception('[ERROR] Invalid or already processed friend request.');
      }

      final senderId = requestData['senderId'] as String?; // sent ID
      final senderAlias = requestData['alias'] as String? ?? 'Friend'; // Notes set by the sender for the receiver
      final senderName = requestData['senderName'] as String? ?? 'Unknown User'; // Sender Username
      final receiverAlias = currentUser.displayName ?? 'Unknown User'; // Recipient User Name
      final timestamp = DateTime.now().toIso8601String();

      final batch = _firestore.batch();

      // Update the recipient's friend list, using the sender's username as the nickname
      batch.set(
        _firestore.collection('friends').doc(currentUser.uid),
        {
          'friends': FieldValue.arrayUnion([
            {'friendId': senderId, 'alias': senderName, 'addedAt': timestamp, 'status': 'active'}
          ])
        },
        SetOptions(merge: true),
      );

      // Update the sender's friend list, using the note set by the receiver
      batch.set(
        _firestore.collection('friends').doc(senderId),
        {
          'friends': FieldValue.arrayUnion([
            {'friendId': currentUser.uid, 'alias': senderAlias, 'addedAt': timestamp, 'status': 'active'}
          ])
        },
        SetOptions(merge: true),
      );

      // Update friend request status
      batch.update(
        _firestore.collection('friend_requests').doc(requestId),
        {'status': 'accepted', 'updatedAt': FieldValue.serverTimestamp(), 'updatedBy': currentUser.uid},
      );

      // Update notification status
      try {
        await NotificationHelper.updateNotificationStatus(requestId, 'friend_request_accepted', 'accepted');
      } catch (e) {
        print('[WARN] Failed to update notification status: $e');
      }

      await batch.commit();
      print('[INFO] Friend request accepted successfully.');
    } catch (e) {
      throw Exception('[ERROR] Failed to accept friend request: $e');
    }
  }


  Future<void> rejectFriendRequest(String requestId) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) throw Exception('[ERROR] User not logged in.');

    try {
      final requestDoc = await _firestore.collection('friend_requests').doc(requestId).get();
      if (!requestDoc.exists) throw Exception('[ERROR] Friend request does not exist.');

      final batch = _firestore.batch();

      batch.update(
        _firestore.collection('friend_requests').doc(requestId),
        {'status': 'rejected', 'updatedAt': FieldValue.serverTimestamp(), 'updatedBy': currentUser.uid},
      );

      try {
        await NotificationHelper.updateNotificationStatus(requestId, 'friend_request_rejected', 'rejected');
      } catch (e) {
        print('[WARN] Failed to update notification status: $e');
      }

      await batch.commit();
      print('[INFO] Friend request rejected successfully.');
    } catch (e) {
      throw Exception('[ERROR] Failed to reject friend request: $e');
    }
  }
}
