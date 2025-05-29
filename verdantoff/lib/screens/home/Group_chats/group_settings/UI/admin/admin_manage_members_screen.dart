import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../VM/admin/admin_manage_members_vm.dart';

class AdminManageMembersScreen extends StatelessWidget {
  final String groupId;

  AdminManageMembersScreen({required this.groupId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminManageMembersVM(groupId),
      child: Scaffold(
        appBar: AppBar(title: Text('Manage Members')),
        body: Consumer<AdminManageMembersVM>(
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
                  final isOwner = member.role == 'owner';
                  final isMember = member.role == 'member';

                  return ListTile(
                    leading: CircleAvatar(backgroundImage: NetworkImage(member.avatar)),
                    title: Text(member.nickname.isNotEmpty ? member.nickname : member.username),
                    subtitle: Text('Role: ${member.role}'),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) => vm.handleAction(context, value, member.userId, member.nickname),
                      itemBuilder: (context) {
                        List<PopupMenuEntry<String>> items = [];

                        // Only allow changing nickname if not owner
                        if (!isOwner) {
                          items.add(
                            PopupMenuItem(value: 'nickname', child: Text('Change Nickname')),
                          );
                        }

                        // Only allow demote if the user is Admin (not owner, not member) and not self
                        if (!isSelf && !isOwner && !isMember && member.role == 'admin') {
                          items.add(
                            PopupMenuItem(value: 'demote', child: Text('Demote to Member')),
                          );
                        }

                        // Only allow remove if the target is member (and not owner, not self)
                        if (!isSelf && !isOwner && isMember) {
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
