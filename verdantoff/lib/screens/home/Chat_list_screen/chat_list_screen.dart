import 'package:flutter/material.dart';
import 'chat_list_UI.dart';
import 'chat_list_screen_controller.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final ChatListScreenController _controller = ChatListScreenController();

  @override
  void initState() {
    super.initState();
    _controller.loadChats();       // Loading personal chat
    _controller.loadGroupChats(); // Loading group chat
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (query) {
                _controller.searchChats(query);
                _controller.searchGroupChats(query);
              },
              decoration: InputDecoration(
                hintText: 'Search Contacts or Groups',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(child: ChatListUI(controller: _controller)),
        ],
      ),
    );
  }
}
