import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../../services/G2G_chat/G2G_members_service.dart';
import '../../../../../../services/G2G_chat/G2G_nickname_service.dart';
import '../../../../../../services/G2G_chat/G2G_service.dart';


class GroupChatSettingsAdminVM extends ChangeNotifier {
  final String groupId;
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  final G2GService _groupService = G2GService();
  final G2GMembersService _membersService = G2GMembersService();
  final G2GNicknameService _nicknameService = G2GNicknameService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String groupName = '';
  String announcement = '';
  String groupCode = '';
  bool isLoading = true;

  GroupChatSettingsAdminVM(this.groupId) {
    loadGroupDetails();
  }

  Future<void> loadGroupDetails() async {
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
    await loadGroupDetails();
  }

  void editGroupName(BuildContext context) {
    final controller = TextEditingController(text: groupName);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Edit Group Name'),
        content: TextField(controller: controller),
        actions: [
          TextButton(child: Text('Cancel'), onPressed: () => Navigator.pop(context)),
          TextButton(
            child: Text('Save'),
            onPressed: () async {
              await _groupService.setGroupName(groupId, controller.text, currentUserId);
              Navigator.pop(context);
              loadGroupDetails();
            },
          ),
        ],
      ),
    );
  }

  void editAnnouncement(BuildContext context) {
    final controller = TextEditingController(text: announcement);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Edit Announcement'),
        content: TextField(controller: controller),
        actions: [
          TextButton(child: Text('Cancel'), onPressed: () => Navigator.pop(context)),
          TextButton(
            child: Text('Save'),
            onPressed: () async {
              await _groupService.updateGroupAnnouncement(groupId, controller.text, currentUserId);
              Navigator.pop(context);
              loadGroupDetails();
            },
          ),
        ],
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
          TextButton(child: Text('Cancel'), onPressed: () => Navigator.pop(context)),
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
  void changeMyNickname(BuildContext context) {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Set My Nickname'),
        content: TextField(controller: controller),
        actions: [
          TextButton(child: Text('Cancel'), onPressed: () => Navigator.pop(context)),
          TextButton(
            child: Text('Confirm'),
            onPressed: () async {
              await _nicknameService.setMyNickname(groupId, currentUserId, controller.text);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
