import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../VM/group_profile_vm.dart';

class GroupProfileScreen extends StatelessWidget {
  final String groupId;

  GroupProfileScreen({required this.groupId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GroupProfileViewModel(groupId),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Group Information'),
        ),
        body: Consumer<GroupProfileViewModel>(
          builder: (context, vm, child) {
            if (vm.isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (vm.group == null) {
              return Center(child: Text('Group not found.'));
            }

            final group = vm.group!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Group Name:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(group.name),
                  SizedBox(height: 12),

                  Text('Group Code:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(group.groupCode),
                  SizedBox(height: 12),

                  Text('Announcement:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(group.announcement.isNotEmpty ? group.announcement : 'None'),
                  SizedBox(height: 12),

                  Text('Created At:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(group.createdAt.toLocal().toString()),
                  SizedBox(height: 12),

                  Text('Created By:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(group.createdBy),
                  SizedBox(height: 12),

                  Text('Roles:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...group.roles.entries.map((entry) => Text('${entry.key}: ${entry.value}')),
                  Spacer(),

                  Center(
                    child: ElevatedButton(
                      child: Text('Request to Join'),
                      onPressed: vm.hasRequested ? null : () async {
                        await vm.sendJoinRequest();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Join request sent successfully')),
                        );
                      },
                    ),
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
