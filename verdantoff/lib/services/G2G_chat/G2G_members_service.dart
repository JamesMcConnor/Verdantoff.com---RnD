import 'package:cloud_firestore/cloud_firestore.dart';

class G2GMembersService {
  final CollectionReference groupsCollection =
  FirebaseFirestore.instance.collection('groups');

  /// Invites a user directly to join the group
  Future<void> inviteUserToGroup(
      String groupId, String invitedUserId, String invitedByUserId) async {
    await groupsCollection
        .doc(groupId)
        .collection('members')
        .doc(invitedUserId)
        .set({
      'nickname': '',
      'joinedAt': FieldValue.serverTimestamp(),
      'invitedBy': invitedByUserId,
      'role': 'member',
      'unreadCount': 0,
    });

    await groupsCollection.doc(groupId).update({
      'roles.$invitedUserId': 'member',
      'updatedAt': FieldValue.serverTimestamp(),
      'updatedBy': invitedByUserId,
    });
  }

  /// Searches for a group by its unique groupCode
  Future<DocumentSnapshot?> searchGroupByCode(String groupCode) async {
    QuerySnapshot snapshot = await groupsCollection
        .where('groupCode', isEqualTo: groupCode)
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty ? snapshot.docs.first : null;
  }

  /// Sends a join request to the group
  Future<void> sendJoinRequest(String groupId, String userId) async {
    await groupsCollection.doc(groupId).collection('joinRequests').add({
      'userId': userId,
      'requestedAt': FieldValue.serverTimestamp(),
      'status': 'pending',
      'reviewedBy': null,
      'reviewedAt': null,
    });
  }
  /// Approves a user's join request and sets their nickname from their user profile
  Future<void> approveJoinRequest(
      String groupId, String requestId, String approvedBy) async {
    final DocumentReference requestRef =
    groupsCollection.doc(groupId).collection('joinRequests').doc(requestId);

    final DocumentSnapshot requestSnapshot = await requestRef.get();
    final String userId = requestSnapshot['userId'];

    // Get the user's fullName as nickname
    final DocumentSnapshot<Map<String, dynamic>> userSnapshot =
    await FirebaseFirestore.instance.collection('users').doc(userId).get();

    String nickname = '';
    if (userSnapshot.exists) {
      final userData = userSnapshot.data();
      nickname = userData?['fullName'] ?? '';
    }

    WriteBatch batch = FirebaseFirestore.instance.batch();

    batch.update(requestRef, {
      'status': 'approved',
      'reviewedBy': approvedBy,
      'reviewedAt': FieldValue.serverTimestamp(),
    });

    batch.set(groupsCollection.doc(groupId).collection('members').doc(userId), {
      'nickname': nickname,
      'joinedAt': FieldValue.serverTimestamp(),
      'invitedBy': approvedBy,
      'role': 'member',
      'unreadCount': 0,
    });

    batch.update(groupsCollection.doc(groupId), {
      'roles.$userId': 'member',
      'updatedAt': FieldValue.serverTimestamp(),
      'updatedBy': approvedBy,
    });

    await batch.commit();
  }



  /// Rejects a user's join request
  Future<void> rejectJoinRequest(
      String groupId, String requestId, String rejectedBy) async {
    await groupsCollection
        .doc(groupId)
        .collection('joinRequests')
        .doc(requestId)
        .update({
      'status': 'rejected',
      'reviewedBy': rejectedBy,
      'reviewedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Removes a member from the group
  Future<void> removeMemberFromGroup(
      String groupId, String userId, String removedBy) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    batch.delete(
        groupsCollection.doc(groupId).collection('members').doc(userId));

    batch.update(groupsCollection.doc(groupId), {
      'roles.$userId': FieldValue.delete(),
      'updatedAt': FieldValue.serverTimestamp(),
      'updatedBy': removedBy,
    });

    await batch.commit();
  }

  /// Allows a member to leave the group voluntarily
  Future<void> leaveGroup(String groupId, String userId) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    batch.delete(
        groupsCollection.doc(groupId).collection('members').doc(userId));

    batch.update(groupsCollection.doc(groupId), {
      'roles.$userId': FieldValue.delete(),
      'updatedAt': FieldValue.serverTimestamp(),
      'updatedBy': userId,
    });

    await batch.commit();
  }
}
