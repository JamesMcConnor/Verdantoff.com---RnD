import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Friend Manager
/// This class is responsible for managing friend relationships, including deleting friends.

class FriendManager {
  /// Firestore instance for database operations.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Deletes a friend from the user's friend list and vice versa.
  ///
  /// - [friendId]: The ID of the friend to be removed.
  /// - Returns: A `Future<void>` indicating the completion of the deletion process.
  ///
  /// This function performs the following steps:
  /// 1. Checks if the user is logged in.
  /// 2. Uses a Firestore batch operation to ensure atomic updates.
  /// 3. Retrieves the current user's friend list from Firestore.
  /// 4. Removes the specified friend from the current user's friend list.
  /// 5. Retrieves the specified friend's friend list from Firestore.
  /// 6. Removes the current user from the specified friend's friend list.
  /// 7. Commits the batch operation to update both users' friend lists.
  /// 8. Logs success or throws an error if the operation fails.
  Future<void> deleteFriend(String friendId) async {
    // Get the currently logged-in user
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) throw Exception('[ERROR] User not logged in.');

    try {
      // Create a Firestore batch to perform multiple updates atomically
      final batch = _firestore.batch();

      // Get the current user's friends document reference
      final currentUserFriendsRef = _firestore.collection('friends').doc(currentUser.uid);
      final currentUserFriendsSnapshot = await currentUserFriendsRef.get();

      // If the current user's friends list exists, remove the specified friend
      if (currentUserFriendsSnapshot.exists) {
        final friends = currentUserFriendsSnapshot.data()?['friends'] as List<dynamic> ?? [];
        final updatedFriends = friends.where((friend) => friend['friendId'] != friendId).toList();

        batch.update(currentUserFriendsRef, {'friends': updatedFriends});
      }

      // Get the specified friend's friends document reference
      final friendUserFriendsRef = _firestore.collection('friends').doc(friendId);
      final friendUserFriendsSnapshot = await friendUserFriendsRef.get();

      // If the specified friend's friends list exists, remove the current user
      if (friendUserFriendsSnapshot.exists) {
        final friends = friendUserFriendsSnapshot.data()?['friends'] as List<dynamic> ?? [];
        final updatedFriends = friends.where((friend) => friend['friendId'] != currentUser.uid).toList();

        batch.update(friendUserFriendsRef, {'friends': updatedFriends});
      }

      // Commit the batch update to Firestore
      await batch.commit();
      print('[INFO] Friend deleted successfully.');
    } catch (e) {
      throw Exception('[ERROR] Failed to delete friend: $e');
    }
  }
}
