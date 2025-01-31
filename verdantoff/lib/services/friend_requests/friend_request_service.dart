import 'friend_request_sender.dart';
import 'friend_request_handler.dart';
import 'friend_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendRequestService {
  final FriendRequestSender _sender = FriendRequestSender();
  final FriendRequestHandler _handler = FriendRequestHandler();
  final FriendManager _manager = FriendManager();

  /// Sends a friend request.
  Future<void> sendFriendRequest(String receiverId, String message, String alias) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      throw Exception('[ERROR] User not logged in.');
    }

    // Use the current user's ID as the sender ID.
    return _sender.sendFriendRequest(
      senderId: currentUser.uid,
      receiverId: receiverId,
      message: message,
      alias: alias,
    );
  }

  /// Accepts a friend request.
  Future<void> acceptFriendRequest(String requestId) {
    return _handler.acceptFriendRequest(requestId);
  }

  /// Rejects a friend request.
  Future<void> rejectFriendRequest(String requestId) {
    return _handler.rejectFriendRequest(requestId);
  }

  /// Deletes a friend.
  Future<void> deleteFriend(String friendId) {
    return _manager.deleteFriend(friendId);
  }
}
