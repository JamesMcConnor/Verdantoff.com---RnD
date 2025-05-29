import 'package:cloud_firestore/cloud_firestore.dart';

class G2GNicknameService {
  final CollectionReference groupsCollection =
  FirebaseFirestore.instance.collection('groups');

  /// Sets or updates the nickname of the current user within a specific group
  Future<void> setMyNickname(
      String groupId, String userId, String nickname) async {
    await groupsCollection
        .doc(groupId)
        .collection('members')
        .doc(userId)
        .update({
      'nickname': nickname,
    });
  }

  /// Allows Owner or Admin to change another member's nickname
  Future<void> changeMemberNickname(String groupId, String targetUserId,
      String newNickname, String updatedBy) async {
    await groupsCollection
        .doc(groupId)
        .collection('members')
        .doc(targetUserId)
        .update({
      'nickname': newNickname,
    });

    await groupsCollection.doc(groupId).update({
      'updatedAt': FieldValue.serverTimestamp(),
      'updatedBy': updatedBy,
    });
  }
}
