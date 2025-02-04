import 'package:flutter/material.dart';
import '../Chat_list_screen/chat_list_screen_controller.dart';
import 'chat_list_item_UI.dart';

class ChatListUI extends StatelessWidget {
  final ChatListScreenController controller;

  const ChatListUI({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: controller.chatsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
          return const Center(child: Text("No chats available"));
        }

        final chats = snapshot.data as List;

        return ListView.builder(
          itemCount: chats.length,
          itemBuilder: (context, index) {
            return ChatListItemUI(chat: chats[index]);
          },
        );
      },
    );
  }
}
