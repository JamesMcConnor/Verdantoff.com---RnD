import 'friend_request_sender.dart';
import 'friend_request_handler.dart';
import 'friend_manager_Delete.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Friend Request Service
/// This class provides a high-level interface for managing friend-related actions.
/// It acts as a bridge between different friend management components.

class FriendRequestService {
  /// Instance of `FriendRequestSender` responsible for sending friend requests.
  final FriendRequestSender _sender = FriendRequestSender();

  /// Instance of `FriendRequestHandler` responsible for accepting and rejecting friend requests.
  final FriendRequestHandler _handler = FriendRequestHandler();

  /// Instance of `FriendManager` responsible for deleting friends.
  final FriendManager _manager = FriendManager();

  /// Sends a friend request from the currently logged-in user to another user.
  ///
  /// - [receiverId]: The ID of the user receiving the friend request.
  /// - [message]: A custom message sent with the friend request.
  /// - [alias]: A custom alias or note for the recipient.
  /// - Returns: A `Future<void>` indicating the completion of the operation.
  ///
  /// This function performs the following steps:
  /// 1. Checks if the user is logged in.
  /// 2. Retrieves the logged-in user's ID.
  /// 3. Calls `_sender.sendFriendRequest()` to send the request.
  Future<void> sendFriendRequest(String receiverId, String message, String alias) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    // Ensure the user is logged in before proceeding
    if (currentUser == null) {
      throw Exception('[ERROR] User not logged in.');
    }

    // Use the current user's ID as the sender ID and send the friend request
    return _sender.sendFriendRequest(
      senderId: currentUser.uid,
      receiverId: receiverId,
      message: message,
      alias: alias,
    );
  }

  /// Accepts a pending friend request.
  ///
  /// - [requestId]: The unique ID of the friend request being accepted.
  /// - Returns: A `Future<void>` indicating the completion of the operation.
  ///
  /// This function calls `_handler.acceptFriendRequest()` to:
  /// 1. Validate the request status.
  /// 2. Add both users to each other's friend lists.
  /// 3. Update the request status in Firestore.
  Future<void> acceptFriendRequest(String requestId) {
    return _handler.acceptFriendRequest(requestId);
  }

  /// Rejects a pending friend request.
  ///
  /// - [requestId]: The unique ID of the friend request being rejected.
  /// - Returns: A `Future<void>` indicating the completion of the operation.
  ///
  /// This function calls `_handler.rejectFriendRequest()` to:
  /// 1. Validate the request status.
  /// 2. Update the request status to "rejected" in Firestore.
  Future<void> rejectFriendRequest(String requestId) {
    return _handler.rejectFriendRequest(requestId);
  }

  /// Deletes a friend from the user's friend list.
  ///
  /// - [friendId]: The ID of the friend to be removed.
  /// - Returns: A `Future<void>` indicating the completion of the operation.
  ///
  /// This function calls `_manager.deleteFriend()` to:
  /// 1. Remove the friend from both users' friend lists in Firestore.
  Future<void> deleteFriend(String friendId) {
    return _manager.deleteFriend(friendId);
  }
}
