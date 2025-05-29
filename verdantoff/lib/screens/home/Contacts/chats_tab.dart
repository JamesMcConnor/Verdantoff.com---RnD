import 'package:flutter/material.dart';

class ChatsTab extends StatelessWidget {
  final List<Map<String, String>> chats = [
    {'chatType': 'Created', 'name': 'My Chat Room'},
    {'chatType': 'Managed', 'name': 'Admin Group'},
    {'chatType': 'Joined', 'name': 'Community Chat'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final chat = chats[index];
        return ListTile(
          title: Text(chat['name']!),
          subtitle: Text('Type: ${chat['chatType']}'),
          leading: Icon(Icons.chat),
          onTap: () {
            // Future implementation
          },
        );
      },
    );
  }
}
