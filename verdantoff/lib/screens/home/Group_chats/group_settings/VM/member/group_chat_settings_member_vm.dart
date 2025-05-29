import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../../services/G2G_chat/G2G_members_service.dart';
import '../../../../../../services/G2G_chat/G2G_nickname_service.dart';
import '../../../../../../services/G2G_chat/G2G_service.dart';
import '../../UI/member/group_chat_settings_viewMember_screen.dart';

class GroupChatSettingsMemberVM extends ChangeNotifier {
  final String groupId;
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  final G2GService _groupService = G2GService();
  final G2GNicknameService _nicknameService = G2GNicknameService();
  final G2GMembersService _membersService = G2GMembersService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String groupName = '';
  String announcement = '';
  String groupCode = '';
  bool isLoading = true;

  GroupChatSettingsMemberVM(this.groupId) {
    loadGroupInfo();
  }

  Future<void> loadGroupInfo() async {
    isLoading = true;
    notifyListeners();

    final group = await _groupService.getGroupDetails(groupId);
    groupName = group?.name ?? '';
    announcement = group?.announcement ?? '';
    groupCode = group?.groupCode ?? '';

    isLoading = false;
    notifyListeners();
  }

  Future<void> refreshGroupInfo() async {
    await loadGroupInfo();
  }

  void editMyNickname(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Edit Nickname'),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Save'),
            onPressed: () async {
              await _nicknameService.setMyNickname(groupId, currentUserId, controller.text);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void viewMembers(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GroupChatSettingsViewMemberScreen(groupId: groupId),
      ),
    );
  }

  void leaveGroup(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Confirm Exit'),
        content: Text('Are you sure you want to leave the group?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Exit'),
            onPressed: () async {
              await _membersService.leaveGroup(groupId, currentUserId);
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close page
            },
          ),
        ],
      ),
    );
  }
}
