import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../VM/owner/group_chat_settings_owner_vm.dart';
import 'edit_group_name_screen.dart';
import 'edit_announcement_screen.dart';
import 'Group_joinRequests_mange_screen.dart';
import 'owner_manage_members_screen.dart';

class GroupChatSettingsOwnerPage extends StatelessWidget {
  final String groupId;

  GroupChatSettingsOwnerPage({required this.groupId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GroupChatSettingsOwnerVM(groupId),
      child: Scaffold(
        appBar: AppBar(
            title: Text('Owner Settings')
        ),
        body: Consumer<GroupChatSettingsOwnerVM>(
          builder: (context, vm, _) {
            if (vm.isLoading) return Center(child: CircularProgressIndicator());

            return RefreshIndicator(
              onRefresh: vm.refreshGroupDetails,
              child: ListView(
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
                    onTap: () => Navigator.push(context, MaterialPageRoute(
                      builder: (_) => EditGroupNameScreen(groupId: groupId),
                    )),
                  ),
                  ListTile(
                    leading: Icon(Icons.announcement),
                    title: Text('Edit Announcement'),
                    onTap: () => Navigator.push(context, MaterialPageRoute(
                      builder: (_) => EditGroupAnnouncementScreen(groupId: groupId),
                    )),
                  ),
                  ListTile(
                    leading: Icon(Icons.people),
                    title: Text('Manage Members'),
                    onTap: () => Navigator.push(context, MaterialPageRoute(
                      builder: (_) => OwnerManageMembersScreen(groupId: groupId),
                    )),
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
                    leading: Icon(Icons.delete_forever),
                    title: Text('Delete Group'),
                    textColor: Colors.red,
                    onTap: () => vm.deleteGroup(context),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
