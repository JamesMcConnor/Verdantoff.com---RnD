import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../VM/group_profile_vm.dart';
import 'package:intl/intl.dart';

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
            // Show loading indicator while data is being fetched
            if (vm.isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            // Show error if group not found
            if (vm.group == null) {
              return Center(child: Text('Group not found.'));
            }

            final group = vm.group!;
            // Format creation date as yyyy-MM-dd (only date part)
            final dateStr = DateFormat('yyyy-MM-dd').format(group.createdAt.toLocal());

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Group name
                  Text('Group Name:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(group.name),
                  SizedBox(height: 12),

                  // Group code
                  Text('Group Code:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(group.groupCode),
                  SizedBox(height: 12),

                  // Announcement
                  Text('Announcement:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(group.announcement.isNotEmpty ? group.announcement : 'None'),
                  SizedBox(height: 12),

                  // Created At (only date part)
                  Text('Created At:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(dateStr),
                  SizedBox(height: 12),

                  // Created By (display user name, not uid)
                  Text('Created By:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(vm.getUserName(group.createdBy)),
                  SizedBox(height: 12),

                  // Roles (display user name, not uid)
                  Text('Roles:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...group.roles.entries.map((entry) => Text(
                      '${vm.getUserName(entry.key)}: ${entry.value}'
                  )),
                  Spacer(),

                  // "Request to Join" button
                  Center(
                    child: ElevatedButton(
                      child: Text('Request to Join'),
                      onPressed: vm.hasRequested
                          ? null
                          : () async {
                        await vm.sendJoinRequest();
                        // Check if context is still mounted before using it
                        if (!context.mounted) return;
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
