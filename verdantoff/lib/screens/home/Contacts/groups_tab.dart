import 'package:flutter/material.dart';

class GroupsTab extends StatelessWidget {
  final List<Map<String, dynamic>> groups = [
    {'groupName': 'Family', 'members': ['Alice', 'Bob']},
    {'groupName': 'Work', 'members': ['Charlie', 'David']},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups[index];
        return ListTile(
          title: Text(group['groupName']),
          subtitle: Text('Members: ${(group['members'] as List<String>).join(', ')}'),
          leading: Icon(Icons.group),
          onTap: () {
            // Future implementation
          },
        );
      },
    );
  }
}
