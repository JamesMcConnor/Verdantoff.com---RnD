import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Service for updating the alias (nickname) of a friend in the user's friend list.
class EditFriendAliasService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Updates the alias (nickname) for a specific friend in the current user's friend list.
  ///
  /// - [friendId]: The user ID of the friend whose alias should be updated.
  /// - [newAlias]: The new alias (nickname) to set.
  /// - Throws an exception if the user is not logged in or the update fails.
  static Future<void> updateFriendAlias(String friendId, String newAlias) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) throw Exception('[ERROR] User not logged in.');

    try {
      final currentUserRef = _firestore.collection('friends').doc(currentUser.uid);
      final currentUserSnapshot = await currentUserRef.get();

      if (!currentUserSnapshot.exists) {
        throw Exception('[ERROR] Friend list not found.');
      }

      final friendsList = List<Map<String, dynamic>>.from(
          currentUserSnapshot.data()?['friends'] ?? []);

      // Find the friend and update the alias
      final updatedFriendsList = friendsList.map((friend) {
        if (friend['friendId'] == friendId) {
          return {...friend, 'alias': newAlias};
        }
        return friend;
      }).toList();

      await currentUserRef.update({'friends': updatedFriendsList});
      print('[INFO] Alias updated successfully.');
    } catch (e) {
      print('[ERROR] Failed to update friend alias: $e');
      throw Exception('Failed to update friend alias.');
    }
  }
}
