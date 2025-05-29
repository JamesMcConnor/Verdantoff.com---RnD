import 'package:cloud_firestore/cloud_firestore.dart';

class G2GRolesService {
  final CollectionReference groupsCollection =
  FirebaseFirestore.instance.collection('groups');

  /// Automatically assigns the creator as the group owner
  Future<void> assignOwnerAutomatically(String groupId, String ownerId) async {
    await groupsCollection.doc(groupId).update({
      'roles.$ownerId': 'owner',
      'updatedAt': FieldValue.serverTimestamp(),
      'updatedBy': ownerId,
    });

    // Add owner to members subcollection
    await groupsCollection
        .doc(groupId)
        .collection('members')
        .doc(ownerId)
        .set({
      'nickname': '',
      'joinedAt': FieldValue.serverTimestamp(),
      'invitedBy': null,
      'role': 'owner',
      'unreadCount': 0,
    });
  }

  /// Promotes a member to admin
  Future<void> promoteToAdmin(String groupId, String userId, String updatedBy) async {
    await groupsCollection.doc(groupId).update({
      'roles.$userId': 'admin',
      'updatedAt': FieldValue.serverTimestamp(),
      'updatedBy': updatedBy,
    });

    await groupsCollection
        .doc(groupId)
        .collection('members')
        .doc(userId)
        .update({'role': 'admin'});
  }

  /// Demotes an admin back to member
  Future<void> demoteToMember(String groupId, String userId, String updatedBy) async {
    await groupsCollection.doc(groupId).update({
      'roles.$userId': 'member',
      'updatedAt': FieldValue.serverTimestamp(),
      'updatedBy': updatedBy,
    });

    await groupsCollection
        .doc(groupId)
        .collection('members')
        .doc(userId)
        .update({'role': 'member'});
  }

  /// Transfers ownership of the group to another user
  Future<void> transferOwnership(
      String groupId, String currentOwnerId, String newOwnerId) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    // Set new owner role
    batch.update(groupsCollection.doc(groupId), {
      'roles.$newOwnerId': 'owner',
      'roles.$currentOwnerId': 'admin',
      'updatedAt': FieldValue.serverTimestamp(),
      'updatedBy': currentOwnerId,
    });

    // Update members subcollection roles
    batch.update(
        groupsCollection.doc(groupId).collection('members').doc(newOwnerId),
        {'role': 'owner'});

    batch.update(
        groupsCollection.doc(groupId).collection('members').doc(currentOwnerId),
        {'role': 'admin'});

    await batch.commit();
  }

  /// Retrieves all roles within the group
  Future<Map<String, String>> getGroupRoles(String groupId) async {
    DocumentSnapshot snapshot = await groupsCollection.doc(groupId).get();

    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      Map<String, dynamic> rolesDynamic = data['roles'] ?? {};

      // Convert dynamic map to strongly-typed Map<String, String>
      return rolesDynamic.map((key, value) => MapEntry(key, value as String));
    }

    return {};
  }
}
