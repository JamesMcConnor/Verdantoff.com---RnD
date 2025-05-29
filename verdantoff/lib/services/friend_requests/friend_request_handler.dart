import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../screens/home/Notification_screen/utils/notification_service.dart';
import 'notification_helper.dart';

/// Friend Request Handler
/// This class is responsible for handling friend requests, including accepting and rejecting them.

class FriendRequestHandler {
  /// Firestore instance for database operations.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Accepts a friend request and adds both users to each other's friend lists.
  ///
  /// - [requestId]: The unique ID of the friend request being accepted.
  /// - Returns: A `Future<void>` indicating the completion of the operation.
  ///
  /// This function performs the following steps:
  /// 1. Checks if the user is logged in.
  /// 2. Fetches the friend request document from Firestore.
  /// 3. Verifies that the request exists and is still pending.
  /// 4. Extracts sender and recipient information.
  /// 5. Uses a Firestore batch operation to:
  ///    - Add the sender to the recipient's friend list.
  ///    - Add the recipient to the sender's friend list.
  ///    - Update the friend request status to "accepted."
  /// 6. Calls `NotificationHelper` to update the notification status.
  /// 7. Commits the batch operation to Firestore.
  /// 8. Logs success or throws an error if the operation fails.
  Future<void> acceptFriendRequest(String requestId) async {
    // Get the currently logged-in user
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) throw Exception('[ERROR] User not logged in.');

    try {
      // Retrieve the friend request document from Firestore
      final requestDoc = await _firestore.collection('friend_requests').doc(requestId).get();
      if (!requestDoc.exists) throw Exception('[ERROR] Friend request does not exist.');

      final requestData = requestDoc.data();
      if (requestData == null || requestData['status'] != 'pending') {
        throw Exception('[ERROR] Invalid or already processed friend request.');
      }

      // Extract sender and receiver details from the request
      final senderId = requestData['senderId'] as String; // Sender's user ID
      final senderAlias = requestData['alias'] as String? ?? 'Friend'; // Sender's custom alias for the recipient
      final senderName = requestData['senderName'] as String? ?? 'Unknown User'; // Sender's username
      final receiverAlias = currentUser.displayName ?? 'Unknown User'; // Recipient's username
      final receiverId = currentUser.uid;
      final timestamp = DateTime.now().toIso8601String(); // Current timestamp

      // Create a Firestore batch to perform multiple updates atomically
      final batch = _firestore.batch();

      // Add sender to the recipient's friend list (using sender's username as alias)
      batch.set(
        _firestore.collection('friends').doc(receiverId),
        {
          'friends': FieldValue.arrayUnion([
            {'friendId': senderId, 'alias': senderName, 'addedAt': timestamp, 'status': 'active'}
          ])
        },
        SetOptions(merge: true),
      );

      // Add recipient to the sender's friend list (using alias set by sender)
      batch.set(
        _firestore.collection('friends').doc(senderId),
        {
          'friends': FieldValue.arrayUnion([
            {'friendId': receiverId, 'alias': senderAlias, 'addedAt': timestamp, 'status': 'active'}
          ])
        },
        SetOptions(merge: true),
      );

      // Update friend request status to "accepted"
      batch.update(
        _firestore.collection('friend_requests').doc(requestId),
        {'status': 'accepted', 'updatedAt': FieldValue.serverTimestamp(), 'updatedBy': receiverId},
      );

      // ✅ Update Notifications for Both Users
      await NotificationService.updateNotification(
        requestId, // Using friend request ID as notification ID
        'accepted',
        'friend_request_accepted',
        senderId, // Sender who should receive the notification
        receiverId, // Receiver who accepted the request
      );

      // Commit the batch update to Firestore
      await batch.commit();
      print('[INFO] Friend request accepted successfully.');
    } catch (e) {
      throw Exception('[ERROR] Failed to accept friend request: $e');
    }
  }


  /// Rejects a friend request and updates its status in Firestore.
  ///
  /// - [requestId]: The unique ID of the friend request being rejected.
  /// - Returns: A `Future<void>` indicating the completion of the operation.
  ///
  /// This function performs the following steps:
  /// 1. Checks if the user is logged in.
  /// 2. Fetches the friend request document from Firestore.
  /// 3. Verifies that the request exists.
  /// 4. Uses a Firestore batch operation to:
  ///    - Update the friend request status to "rejected."
  /// 5. Calls `NotificationHelper` to update the notification status.
  /// 6. Commits the batch operation to Firestore.
  /// 7. Logs success or throws an error if the operation fails.
  Future<void> rejectFriendRequest(String requestId) async {
    // Get the currently logged-in user
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) throw Exception('[ERROR] User not logged in.');

    try {
      // Retrieve the friend request document from Firestore
      final requestDoc = await _firestore.collection('friend_requests').doc(requestId).get();
      if (!requestDoc.exists) throw Exception('[ERROR] Friend request does not exist.');

      // Create a Firestore batch to perform updates atomically
      final batch = _firestore.batch();

      // Update the friend request status to "rejected"
      batch.update(
        _firestore.collection('friend_requests').doc(requestId),
        {'status': 'rejected', 'updatedAt': FieldValue.serverTimestamp(), 'updatedBy': currentUser.uid},
      );

      // Update notification status for the sender
      try {
        await NotificationHelper.updateNotificationStatus(requestId, 'friend_request_rejected', 'rejected');
      } catch (e) {
        print('[WARN] Failed to update notification status: $e');
      }

      // Commit the batch update to Firestore
      await batch.commit();
      print('[INFO] Friend request rejected successfully.');
    } catch (e) {
      throw Exception('[ERROR] Failed to reject friend request: $e');
    }
  }
}
