import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendManager {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> deleteFriend(String friendId) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) throw Exception('[ERROR] User not logged in.');

    try {
      final batch = _firestore.batch();

      final currentUserFriendsRef = _firestore.collection('friends').doc(currentUser.uid);
      final currentUserFriendsSnapshot = await currentUserFriendsRef.get();

      if (currentUserFriendsSnapshot.exists) {
        final friends = currentUserFriendsSnapshot.data()?['friends'] as List<dynamic> ?? [];
        final updatedFriends = friends.where((friend) => friend['friendId'] != friendId).toList();

        batch.update(currentUserFriendsRef, {'friends': updatedFriends});
      }

      final friendUserFriendsRef = _firestore.collection('friends').doc(friendId);
      final friendUserFriendsSnapshot = await friendUserFriendsRef.get();

      if (friendUserFriendsSnapshot.exists) {
        final friends = friendUserFriendsSnapshot.data()?['friends'] as List<dynamic> ?? [];
        final updatedFriends = friends.where((friend) => friend['friendId'] != currentUser.uid).toList();

        batch.update(friendUserFriendsRef, {'friends': updatedFriends});
      }

      await batch.commit();
      print('[INFO] Friend deleted successfully.');
    } catch (e) {
      throw Exception('[ERROR] Failed to delete friend: $e');
    }
  }
}
