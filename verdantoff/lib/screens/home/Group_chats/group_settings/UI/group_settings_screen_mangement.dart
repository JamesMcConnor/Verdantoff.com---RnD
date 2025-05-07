import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../VM/group_settings_management_vm.dart';
import 'owner/group_chat_settings_owner_page.dart';
import 'admin/group_chat_settings_admin_page.dart';
import 'member/group_chat_settings_member_page.dart';

class GroupSettingsScreenManagement extends StatelessWidget {
  final String groupId;

  GroupSettingsScreenManagement({required this.groupId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GroupSettingsManagementViewModel(groupId),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Group Settings'),
        ),
        body: Consumer<GroupSettingsManagementViewModel>(
          builder: (context, vm, child) {
            if (vm.isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (vm.role == 'owner') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => GroupChatSettingsOwnerPage(groupId: groupId)),
                );
              } else if (vm.role == 'admin') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => GroupChatSettingsAdminPage(groupId: groupId)),
                );
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => GroupChatSettingsMemberPage(groupId: groupId)),
                );
              }
            });

            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
