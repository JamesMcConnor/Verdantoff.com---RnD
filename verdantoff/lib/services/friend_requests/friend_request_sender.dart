import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'notification_helper.dart';

/// Friend Request Sender
/// This class is responsible for sending friend requests and checking for existing requests.

class FriendRequestSender {
  /// Firestore instance for database operations.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Checks if a friend request is already pending between the sender and receiver.
  ///
  /// - [senderId]: The ID of the user sending the request.
  /// - [receiverId]: The ID of the user receiving the request.
  /// - Returns: A `Future<bool>` indicating whether a pending request already exists.
  ///
  /// This function performs the following steps:
  /// 1. Queries Firestore for existing friend requests where:
  ///    - The `senderId` matches the sender.
  ///    - The `receiverId` matches the receiver.
  ///    - The status is "pending."
  /// 2. If a matching request is found, returns `true`, otherwise returns `false`.
  /// 3. Catches and logs any errors that occur during the query.
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

  /// Sends a friend request from one user to another.
  ///
  /// - [senderId]: The ID of the user sending the request.
  /// - [receiverId]: The ID of the user receiving the request.
  /// - [message]: A custom message sent with the request.
  /// - [alias]: A custom alias or note for the recipient.
  /// - Returns: A `Future<void>` indicating the completion of the operation.
  ///
  /// This function performs the following steps:
  /// 1. Checks if a pending friend request already exists between the sender and receiver.
  /// 2. If a request exists, throws an exception.
  /// 3. Verifies that the user is logged in.
  /// 4. Fetches the sender’s username from the `users` collection.
  /// 5. Fetches the receiver’s username from the `users` collection.
  /// 6. Sets an expiration date for the friend request (7 days from now).
  /// 7. Creates a new friend request document in Firestore with:
  ///    - Sender and receiver details.
  ///    - Custom message and alias.
  ///    - Status set to "pending."
  ///    - Timestamp of request creation.
  ///    - Expiration date.
  /// 8. Adds a notification for the receiver using `NotificationHelper`.
  /// 9. Logs success or throws an error if the operation fails.
  Future<void> sendFriendRequest({
    required String senderId,
    required String receiverId,
    required String message,
    required String alias,
  }) async {
    try {
      // Check if a pending friend request already exists
      if (await checkExistingRequest(senderId, receiverId)) {
        throw Exception('[ERROR] A friend request is already pending.');
      }

      // Ensure the user is logged in
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) throw Exception('[ERROR] User not logged in.');

      // Retrieve the sender's username from Firestore
      final senderDoc = await _firestore.collection('users').doc(senderId).get();
      final senderName = senderDoc.exists ? (senderDoc.data()?['userName'] ?? 'Unknown User') : 'Unknown User';

      // Retrieve the receiver's username from Firestore
      final receiverDoc = await _firestore.collection('users').doc(receiverId).get();
      final receiverName = receiverDoc.exists ? (receiverDoc.data()?['userName'] ?? 'Unknown User') : 'Unknown User';

      // Set an expiration date for the friend request (7 days from now)
      final expiresAt = DateTime.now().add(Duration(days: 7));

      // Create a new friend request document in Firestore
      final friendRequestRef = await _firestore.collection('friend_requests').add({
        'senderId': senderId,
        'senderName': senderName, // Sender's username
        'receiverId': receiverId,
        'receiverName': receiverName, // Receiver's username
        'message': message, // Custom message included with the request
        'alias': alias, // Custom alias or note for the recipient
        'status': 'pending', // Initial status of the request
        'timestamp': FieldValue.serverTimestamp(), // Timestamp of when the request was sent
        'expiresAt': expiresAt, // Expiration date for the request
        'updatedAt': null, // Initially null, updated when request is accepted or rejected
        'updatedBy': null, // Initially null, updated by the user who processes the request
      });

      // Send a notification to the receiver about the new friend request
      await NotificationHelper.addNotification(
        receiverId,
        'friend_request',
        senderId,
        'You have a new friend request.',
        relatedId: friendRequestRef.id, // Attach friend request ID to the notification
      );

      // Log success message
      print('[INFO] Friend request sent successfully.');
    } catch (e) {
      throw Exception('[ERROR] Failed to send friend request: $e');
    }
  }
}
