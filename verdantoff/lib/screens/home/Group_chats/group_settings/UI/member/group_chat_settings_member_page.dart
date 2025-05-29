import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../VM/member/group_chat_settings_member_vm.dart';


class GroupChatSettingsMemberPage extends StatelessWidget {
  final String groupId;

  GroupChatSettingsMemberPage({required this.groupId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GroupChatSettingsMemberVM(groupId),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Group Info'),
        ),
        body: Consumer<GroupChatSettingsMemberVM>(
          builder: (context, vm, _) {
            if (vm.isLoading) return Center(child: CircularProgressIndicator());

            return RefreshIndicator(
              onRefresh: vm.refreshGroupInfo,
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
                    title: Text('Edit My Nickname'),
                    onTap: () => vm.editMyNickname(context),
                  ),
                  ListTile(
                    leading: Icon(Icons.people),
                    title: Text('View Members'),
                    onTap: () => vm.viewMembers(context),
                  ),
                  ListTile(
                    leading: Icon(Icons.exit_to_app),
                    title: Text('Exit Group'),
                    onTap: () => vm.leaveGroup(context),
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
