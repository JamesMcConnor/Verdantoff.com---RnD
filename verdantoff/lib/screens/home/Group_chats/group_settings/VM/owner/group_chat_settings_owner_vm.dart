import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../../../services/G2G_chat/G2G_nickname_service.dart';
import '../../../../../../services/G2G_chat/G2G_service.dart';


class GroupChatSettingsOwnerVM extends ChangeNotifier {
  final String groupId;
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  final G2GService _g2gService = G2GService();
  final G2GNicknameService _nicknameService = G2GNicknameService();

  String groupName = '';
  String announcement = '';
  String groupCode = '';
  bool isLoading = true;

  GroupChatSettingsOwnerVM(this.groupId) {
    fetchGroupDetails();
  }

  Future<void> fetchGroupDetails() async {
    isLoading = true;
    notifyListeners();

    final group = await _g2gService.getGroupDetails(groupId);
    groupName = group?.name ?? '';
    announcement = group?.announcement ?? '';
    groupCode = group?.groupCode ?? '';

    isLoading = false;
    notifyListeners();
  }

  Future<void> refreshGroupDetails() => fetchGroupDetails();

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

  void deleteGroup(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Confirm Delete Group'),
        content: Text('This action cannot be undone.'),
        actions: [
          TextButton(child: Text('Cancel'), onPressed: () => Navigator.pop(context)),
          TextButton(
            child: Text('Delete', style: TextStyle(color: Colors.red)),
            onPressed: () async {
              await _g2gService.deleteGroup(groupId);
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // close settings page
              Navigator.pop(context); // return to chats/home
            },
          ),
        ],
      ),
    );
  }
}
