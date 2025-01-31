import 'package:flutter/material.dart';
import 'chat_area_components/chat_area_message_list.dart';
import '../../../../services/models/p2p_chat/p2p_message_model.dart';

class ChatArea extends StatelessWidget {
  final List<P2PMessage> messages;
  final String friendName;
  final String chatId;
  final Function(P2PMessage) onNewMessage;

  const ChatArea({
    Key? key,
    required this.messages,
    required this.friendName,
    required this.chatId,
    required this.onNewMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ChatAreaMessageList(
        messages: messages,
        friendName: friendName,
        chatId: chatId,
        onNewMessage: onNewMessage,
      ),
    );
  }
}
