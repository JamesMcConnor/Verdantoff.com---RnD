import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../user/Show_User_Info_To_People/Show_User_Info_To_People_Screen.dart';
import '../../VM/member/group_chat_settings_viewMember_vm.dart';

class GroupChatSettingsViewMemberScreen extends StatelessWidget {
  final String groupId;

  GroupChatSettingsViewMemberScreen({required this.groupId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ViewMembersVM(groupId),
      child: Scaffold(
        appBar: AppBar(title: Text('Group Members')),
        body: Consumer<ViewMembersVM>(
          builder: (context, vm, _) {
            if (vm.isLoading) return Center(child: CircularProgressIndicator());

            return RefreshIndicator(
              onRefresh: vm.refreshMembers,
              child: ListView.builder(
                itemCount: vm.members.length,
                itemBuilder: (context, index) {
                  final member = vm.members[index];

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(member.avatar),
                    ),
                    title: Text(
                      member.nickname.isNotEmpty ? member.nickname : member.username,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Role: ${member.role}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ShowUserInfoToPeopleScreen(userId: member.userId),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
