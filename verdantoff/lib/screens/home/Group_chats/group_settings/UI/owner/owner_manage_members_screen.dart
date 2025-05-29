import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../VM/owner/owner_manage_members_vm.dart';

class OwnerManageMembersScreen extends StatelessWidget {
  final String groupId;

  OwnerManageMembersScreen({required this.groupId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OwnerManageMembersVM(groupId),
      child: Scaffold(
        appBar: AppBar(title: Text('Manage Members')),
        body: Consumer<OwnerManageMembersVM>(
          builder: (context, vm, _) {
            if (vm.isLoading) return Center(child: CircularProgressIndicator());

            return RefreshIndicator(
              onRefresh: vm.refreshMembers,
              child: ListView.builder(
                itemCount: vm.members.length,
                itemBuilder: (context, index) {
                  final member = vm.members[index];
                  final currentUserId = vm.currentUserId;
                  final isSelf = member.userId == currentUserId;

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(member.avatar),
                    ),
                    title: Text(member.nickname.isNotEmpty ? member.nickname : member.username),
                    subtitle: Text('Role: ${member.role}'),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) => vm.handleAction(context, value, member.userId),
                      itemBuilder: (context) {
                        List<PopupMenuEntry<String>> items = [];

                        // Everyone can change nickname
                        items.add(
                          PopupMenuItem(value: 'nickname', child: Text('Change Nickname')),
                        );

                        if (!isSelf) {
                          if (member.role == 'member') {
                            // Only promote members
                            items.add(
                              PopupMenuItem(value: 'promote', child: Text('Promote to Admin')),
                            );
                          }
                          if (member.role == 'admin') {
                            // Only demote admins
                            items.add(
                              PopupMenuItem(value: 'demote', child: Text('Demote to Member')),
                            );
                          }
                          // Only transfer ownership to others
                          items.add(
                            PopupMenuItem(value: 'transfer', child: Text('Transfer Ownership')),
                          );

                          // Only remove others
                          items.add(
                            PopupMenuItem(value: 'remove', child: Text('Remove from Group')),
                          );
                        }

                        return items;
                      },
                    ),
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
