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
      body: ChatListUI(controller: _controller),
    );
  }
}
