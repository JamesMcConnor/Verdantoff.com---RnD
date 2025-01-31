import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../../services/models/p2p_chat/p2p_message_model.dart';
import 'chat_area_message_bubble.dart';
import 'chat_area_action_menu.dart';

class ChatAreaMessageList extends StatefulWidget {
  final List<P2PMessage> messages;
  final String friendName;
  final String chatId;
  final void Function(P2PMessage) onNewMessage;

  const ChatAreaMessageList({
    Key? key,
    required this.messages,
    required this.friendName,
    required this.chatId,
    required this.onNewMessage,
  }) : super(key: key);

  @override
  _ChatAreaMessageListState createState() => _ChatAreaMessageListState();
}

class _ChatAreaMessageListState extends State<ChatAreaMessageList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void didUpdateWidget(covariant ChatAreaMessageList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.messages.length != oldWidget.messages.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return widget.messages.isEmpty
        ? const Center(
      child: Text(
        'No messages yet. Start the conversation!',
        style: TextStyle(color: Colors.grey, fontSize: 16.0),
      ),
    )
        : ListView.builder(
      controller: _scrollController,
      reverse: true,
      padding: const EdgeInsets.all(8.0),
      itemCount: widget.messages.length,
      itemBuilder: (context, index) {
        final message = widget.messages[widget.messages.length - index - 1];
        final isMe = message.senderId == currentUserId;

        return GestureDetector(
          onLongPress: () => _showActionMenu(context, message),
          child: ChatAreaMessageBubble(
            message: message,
            isMe: isMe,
            friendName: widget.friendName,
          ),
        );
      },
    );
  }

  void _showActionMenu(BuildContext context, P2PMessage message) {
    showDialog(
      context: context,
      builder: (_) => ChatAreaActionMenu(
        message: message,
        chatId: widget.chatId,
        onNewMessage: widget.onNewMessage,
      ),
    );
  }
}
