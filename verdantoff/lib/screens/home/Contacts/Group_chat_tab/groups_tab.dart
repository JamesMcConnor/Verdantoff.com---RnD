import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Group_chats/group_chat_screen/UI/group_chat_screen.dart';
import '../../Group_chats/group_create/UI/group_create_screen.dart';
import '../../Group_chats/group_search/UI/group_search_screen.dart';
import 'groups_tab_vm.dart';

class GroupsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GroupsTabViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Groups'),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => GroupSearchScreen()));
              },
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => GroupCreateScreen()));
              },
            ),
          ],
        ),
        body: Consumer<GroupsTabViewModel>(
          builder: (context, vm, child) {
            if (vm.isLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (vm.groups.isEmpty) {
              return Center(child: Text('No groups joined yet.'));
            }
            return ListView.builder(
              itemCount: vm.groups.length,
              itemBuilder: (context, index) {
                final group = vm.groups[index];
                return ListTile(
                  leading: Icon(Icons.group),
                  title: Text(group.groupname),
                  trailing: group.unreadCount > 0
                      ? CircleAvatar(
                    radius: 12,
                    child: Text(
                      group.unreadCount.toString(),
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    backgroundColor: Colors.redAccent,
                  )
                      : null,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GroupChatScreen(
                            groupId: group.groupId,
                            groupName: group.groupname,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
