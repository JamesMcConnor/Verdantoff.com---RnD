import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../../services/G2G_chat/G2G_roles_service.dart';
import '../../../../../services/G2G_chat/G2G_service.dart';
import '../../../../../services/models/G2G_chat/group_model.dart';
import '../../Get_Friend_List_Service.dart';

class GroupCreateViewModel extends ChangeNotifier {
  final TextEditingController groupNameController = TextEditingController();
  final G2GService _groupService = G2GService();
  final G2GRolesService _rolesService = G2GRolesService();
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;

  List<Friend> selectedFriends = [];
  bool isCreating = false;

  void updateSelectedFriends(List<Friend> friends) {
    selectedFriends = friends;
    notifyListeners();
  }

  Future<void> createGroup() async {
    if (groupNameController.text.trim().isEmpty) return;

    isCreating = true;
    notifyListeners();

    final newGroupId = FirebaseFirestore.instance.collection('groups').doc().id;
    final now = DateTime.now();

    final group = GroupModel(
      groupId: newGroupId,
      groupCode: newGroupId.substring(0, 6).toUpperCase(),
      name: groupNameController.text.trim(),
      announcement: '',
      createdAt: now,
      createdBy: currentUserId,
      updatedAt: now,
      updatedBy: currentUserId,
      roles: {currentUserId: 'owner'},
    );

    await _groupService.createGroup(group);
    await _rolesService.assignOwnerAutomatically(newGroupId, currentUserId);

    for (var friend in selectedFriends) {
      await _rolesService.groupsCollection
          .doc(newGroupId)
          .collection('members')
          .doc(friend.friendId)
          .set({
        'nickname': friend.alias,
        'joinedAt': now,
        'invitedBy': currentUserId,
        'role': 'member',
        'unreadCount': 0,
      });

      await _rolesService.groupsCollection.doc(newGroupId).update({
        'roles.${friend.friendId}': 'member',
      });
    }

    isCreating = false;
    notifyListeners();
  }

  @override
  void dispose() {
    groupNameController.dispose();
    super.dispose();
  }
}
