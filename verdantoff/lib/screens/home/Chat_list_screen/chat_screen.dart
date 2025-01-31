// The chat page displays the chat message list and the send message input box.
import 'package:flutter/material.dart';
import '../Navigation_management/top_bar.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Box
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search by name...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
        // Placeholder chat content
        Expanded(
          child: ListView.builder(
            itemCount: 10, // Number of sample entries
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: Text('User $index'),
                subtitle: Text('Last message...'),
                onTap: () {
                  // Jump to the chat details page (to be implemented in the future)
                },
              );
            },
          ),
        ),
      ],
    );
  }
}