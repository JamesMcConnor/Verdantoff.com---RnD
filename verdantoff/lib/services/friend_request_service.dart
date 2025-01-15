import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Service class for handling friend requests and managing friend relationships.
class FriendRequestService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Sends a friend request from the current user to the specified receiver.
  Future<void> sendFriendRequest(String receiverId, String message, String alias) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      throw Exception('[ERROR] User not logged in.');
    }

    try {
      // Check for an existing pending request.
      final existingRequest = await _firestore
          .collection('friend_requests')
          .where('senderId', isEqualTo: currentUser.uid)
          .where('receiverId', isEqualTo: receiverId)
          .where('status', isEqualTo: 'pending')
          .get();

      if (existingRequest.docs.isNotEmpty) {
        throw Exception('[ERROR] You have already sent a friend request to this user.');
      }

      final expiresAt = DateTime.now().add(Duration(days: 7));

      // Add the friend request to Firestore.
      await _firestore.collection('friend_requests').add({
        'senderId': currentUser.uid,
        'senderName': currentUser.displayName ?? 'Unknown User',
        'receiverId': receiverId,
        'message': message,
        'alias': alias,
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
        'expiresAt': expiresAt,
      });

      // Add a notification for the receiver.
      await _firestore.collection('notifications').add({
        'receiverId': receiverId,
        'type': 'friend_request',
        'from': currentUser.uid,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
        'relatedId': receiverId,
        'status': 'pending',
      });

      print('[INFO] Friend request sent successfully.');
    } catch (e) {
      print('[ERROR] Failed to send friend request: $e');
      throw Exception('Failed to send friend request: $e');
    }
  }

  /// Accepts a friend request and adds both users to each other's friend list.
  Future<void> acceptFriendRequest(String requestId) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      throw Exception('[ERROR] User not logged in.');
    }

    try {
      final requestDoc = await _firestore.collection('friend_requests').doc(requestId).get();

      if (!requestDoc.exists) {
        throw Exception('[ERROR] Friend request does not exist.');
      }

      final requestData = requestDoc.data();
      if (requestData == null || requestData['status'] != 'pending') {
        throw Exception('[ERROR] Invalid or already processed friend request.');
      }

      final senderId = requestData['senderId'];
      final receiverId = requestData['receiverId'];
      final alias = requestData['alias'] ?? 'Friend';
      final timestamp = DateTime.now().toIso8601String();

      if (receiverId != currentUser.uid) {
        throw Exception('[ERROR] Unauthorized action.');
      }

      final batch = _firestore.batch();

      // Add sender to receiver's friend list.
      batch.set(
        _firestore.collection('friends').doc(receiverId),
        {
          'friends': FieldValue.arrayUnion([
            {'friendId': senderId, 'alias': alias, 'addedAt': timestamp}
          ])
        },
        SetOptions(merge: true),
      );

      // Add receiver to sender's friend list.
      batch.set(
        _firestore.collection('friends').doc(senderId),
        {
          'friends': FieldValue.arrayUnion([
            {'friendId': receiverId, 'alias': 'Friend', 'addedAt': timestamp}
          ])
        },
        SetOptions(merge: true),
      );

      // Update friend request status.
      batch.update(
        _firestore.collection('friend_requests').doc(requestId),
        {'status': 'accepted'},
      );

      // Update related notification status.
      final relatedNotification = await _firestore
          .collection('notifications')
          .where('relatedId', isEqualTo: requestId)
          .where('type', isEqualTo: 'friend_request')
          .get();

      if (relatedNotification.docs.isNotEmpty) {
        final notificationId = relatedNotification.docs.first.id;
        batch.update(
          _firestore.collection('notifications').doc(notificationId),
          {'type': 'friend_request_accepted', 'status': 'accepted'},
        );
      }

      await batch.commit();
      print('[INFO] Friend request accepted successfully.');
    } catch (e) {
      print('[ERROR] Failed to accept friend request: $e');
      throw Exception('Failed to accept friend request: $e');
    }
  }

  /// Rejects a friend request without adding users to each other's friend lists.
  Future<void> rejectFriendRequest(String requestId) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      throw Exception('[ERROR] User not logged in.');
    }

    try {
      final requestDoc = await _firestore.collection('friend_requests').doc(requestId).get();

      if (!requestDoc.exists || requestDoc['status'] != 'pending') {
        throw Exception('[ERROR] Invalid or already processed friend request.');
      }

      final senderId = requestDoc['senderId'];

      final batch = _firestore.batch();

      // Update friend request status.
      batch.update(
        _firestore.collection('friend_requests').doc(requestId),
        {'status': 'rejected'},
      );

      // Update related notification status.
      final relatedNotification = await _firestore
          .collection('notifications')
          .where('relatedId', isEqualTo: requestId)
          .where('type', isEqualTo: 'friend_request')
          .get();

      if (relatedNotification.docs.isNotEmpty) {
        final notificationId = relatedNotification.docs.first.id;
        batch.update(
          _firestore.collection('notifications').doc(notificationId),
          {'type': 'friend_request_rejected', 'status': 'rejected'},
        );
      }

      await batch.commit();
      print('[INFO] Friend request rejected successfully.');
    } catch (e) {
      print('[ERROR] Failed to reject friend request: $e');
      throw Exception('Failed to reject friend request: $e');
    }
  }
}
