import 'package:flutter/material.dart';
import 'chat_ui.dart';
import 'Chat_logic/chat_state_manager.dart';

class PersonChatsScreen extends StatefulWidget {
  final String friendName;
  final String friendId;

  const PersonChatsScreen({
    Key? key,
    required this.friendName,
    required this.friendId,
  }) : super(key: key);

  @override
  _PersonChatsScreenState createState() => _PersonChatsScreenState();
}

class _PersonChatsScreenState extends State<PersonChatsScreen> {
  late final ChatStateManager _chatStateManager;

  @override
  void initState() {
    super.initState();
    _chatStateManager = ChatStateManager(friendName: widget.friendName, friendId: widget.friendId);
    _chatStateManager.initializeChat();
  }

  @override
  void dispose() {
    _chatStateManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatUI(chatStateManager: _chatStateManager),
    );
  }
}
