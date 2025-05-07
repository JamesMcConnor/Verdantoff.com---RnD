import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../select_friends/UI/select_friends_screen.dart';
import '../VM/group_create_vm.dart';

class GroupCreateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GroupCreateViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create New Group'),
        ),
        body: Consumer<GroupCreateViewModel>(
          builder: (context, vm, child) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: vm.groupNameController,
                  decoration: InputDecoration(
                    labelText: 'Group Name',
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  child: Text('Invite Friends'),
                  onPressed: () async {
                    final selectedFriends = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SelectFriendsScreen(
                          initialSelected: vm.selectedFriends,
                        ),
                      ),
                    );

                    if (selectedFriends != null) {
                      vm.updateSelectedFriends(selectedFriends);
                    }
                  },
                ),
                SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: vm.selectedFriends.length,
                    itemBuilder: (context, index) {
                      final friend = vm.selectedFriends[index];
                      return ListTile(
                        leading: Icon(Icons.person),
                        title: Text(friend.alias),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  child: Text('Create Group'),
                  onPressed: vm.isCreating
                      ? null
                      : () async {
                    await vm.createGroup();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
