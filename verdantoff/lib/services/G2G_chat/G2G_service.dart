import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/G2G_chat/group_model.dart';


class G2GService {
  final CollectionReference groupsCollection =
  FirebaseFirestore.instance.collection('groups');
  final CollectionReference usersCollection =
  FirebaseFirestore.instance.collection('users');


  /// Creates a new group with initial data
  Future<void> createGroup(GroupModel group) async {
    await groupsCollection.doc(group.groupId).set(group.toFirestore());
  }

  /// Updates the group's name
  Future<void> setGroupName(String groupId, String newName, String updatedBy) async {
    await groupsCollection.doc(groupId).update({
      'name': newName,
      'updatedAt': FieldValue.serverTimestamp(),
      'updatedBy': updatedBy,
    });
  }

  /// Updates or sets the group's announcement
  Future<void> updateGroupAnnouncement(String groupId, String announcement, String updatedBy) async {
    await groupsCollection.doc(groupId).update({
      'announcement': announcement,
      'updatedAt': FieldValue.serverTimestamp(),
      'updatedBy': updatedBy,
    });
  }

  /// Retrieves detailed information of a specific group
  Future<GroupModel?> getGroupDetails(String groupId) async {
    DocumentSnapshot snapshot = await groupsCollection.doc(groupId).get();
    if (snapshot.exists) {
      return GroupModel.fromFirestore(
          snapshot.id, snapshot.data() as Map<String, dynamic>);
    }
    return null;
  }

  /// Deletes the group and all associated subcollections
  Future<void> deleteGroup(String groupId) async {
    // Delete members subcollection
    var members = await groupsCollection.doc(groupId).collection('members').get();
    for (var member in members.docs) {
      await member.reference.delete();
    }

    // Delete joinRequests subcollection
    var requests = await groupsCollection.doc(groupId).collection('joinRequests').get();
    for (var request in requests.docs) {
      await request.reference.delete();
    }

    // Delete messages subcollection
    var messages = await groupsCollection.doc(groupId).collection('messages').get();
    for (var message in messages.docs) {
      await message.reference.delete();
    }

    // Finally, delete the group document itself
    await groupsCollection.doc(groupId).delete();
  }
}
