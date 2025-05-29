import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../VM/admin/group_chat_settings_admin_vm.dart';
import '../owner/Group_joinRequests_mange_screen.dart';
import 'admin_manage_members_screen.dart';

class GroupChatSettingsAdminPage extends StatelessWidget {
  final String groupId;

  GroupChatSettingsAdminPage({required this.groupId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GroupChatSettingsAdminVM(groupId),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Admin Settings'),
        ),
        body: Consumer<GroupChatSettingsAdminVM>(
          builder: (context, vm, _) {
            if (vm.isLoading) return Center(child: CircularProgressIndicator());

            return ListView(
              children: [
                ListTile(
                  title: Text('Group Name'),
                  subtitle: Text(vm.groupName),
                ),
                ListTile(
                  title: Text('Announcement'),
                  subtitle: Text(vm.announcement.isNotEmpty ? vm.announcement : 'No announcement'),
                ),
                ListTile(
                  title: Text('Group Code'),
                  subtitle: Text(vm.groupCode),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Edit Group Name'),
                  onTap: () => vm.editGroupName(context),
                ),
                ListTile(
                  leading: Icon(Icons.announcement),
                  title: Text('Edit Announcement'),
                  onTap: () => vm.editAnnouncement(context),
                ),
                ListTile(
                  leading: Icon(Icons.people),
                  title: Text('Manage Members'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AdminManageMembersScreen(groupId: groupId),
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.person_add),
                  title: Text('Approve Join Requests'),
                  onTap: () => Navigator.push(context, MaterialPageRoute(
                    builder: (_) => GroupJoinRequestsManageScreen(groupId: groupId),
                  )),
                ),
                ListTile(
                  leading: Icon(Icons.edit_note),
                  title: Text('Change My Nickname'),
                  onTap: () => vm.changeMyNickname(context),
                ),
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Exit Group'),
                  onTap: () => vm.leaveGroup(context),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
