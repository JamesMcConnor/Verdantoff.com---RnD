import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // 添加这行导入
import 'chat_ui.dart';
import 'Chat_logic/chat_state_manager.dart';

class PersonChatsScreen extends StatefulWidget {
  final String chatId;
  final String friendName;
  final String friendId;

  const PersonChatsScreen({
    Key? key,
    required this.chatId,
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
    _chatStateManager = ChatStateManager(
      chatId: widget.chatId,
      friendName: widget.friendName,
      friendId: widget.friendId,
    );
    _chatStateManager.initializeChat();
  }

  @override
  void dispose() {
    _chatStateManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Provider<ChatStateManager>.value( // 添加 Provider
      value: _chatStateManager,
      child: Scaffold(
        body: ChatUI(chatStateManager: _chatStateManager),
      ),
    );
  }
}
