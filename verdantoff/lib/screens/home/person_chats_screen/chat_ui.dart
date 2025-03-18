import 'package:flutter/material.dart';
import '../../../services/models/p2p_chat/p2p_message_model.dart';
import 'Chat_logic/chat_state_manager.dart';
import 'chat_area.dart';
import 'bottom_input.dart';
import 'top_bar.dart';

class ChatUI extends StatelessWidget {
  final ChatStateManager chatStateManager;

  const ChatUI({Key? key, required this.chatStateManager}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TopBar(
          friendName: chatStateManager.friendName,
          friendId: chatStateManager.friendId,
          onBack: () => Navigator.pop(context),
        ),
        ValueListenableBuilder<List<P2PMessage>>(
          valueListenable: chatStateManager.messages,
          builder: (context, messages, _) {
            return ChatArea(
              messages: messages,
              friendName: chatStateManager.friendName,
              chatId: chatStateManager.chatId,
              onNewMessage: (P2PMessage newMessage) {
                chatStateManager.messages.value = [
                  ...chatStateManager.messages.value,
                  newMessage,
                ];
              },
            );
          },
        ),
        BottomInput(
          controller: chatStateManager.messageController,
          onSendMessage: chatStateManager.sendMessage,
        ),
      ],
    );
  }
}