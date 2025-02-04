import 'package:flutter/material.dart';
import '../../../services/models/p2p_chat/p2p_chat_model.dart';

class ChatListItemUI extends StatelessWidget {
  final P2PChat chat;

  const ChatListItemUI({Key? key, required this.chat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(chat.alias != null ? chat.alias![0] : 'U'),
      ),
      title: Text(chat.alias ?? 'Unknown'),
      subtitle: Text(
        chat.lastMessage['content'] ?? 'No messages yet',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        formatLastMessageTime(chat.updatedAt),
        style: TextStyle(fontSize: 12, color: Colors.grey),
      ),
      onTap: () {
        Navigator.pushNamed(
          context,
          '/person_chats_screen',
          arguments: {
            'chatId': chat.id,
            'friendName': chat.alias ?? 'Unknown',
            'friendId': chat.participants.firstWhere((id) => id != chat.id),
          },
        );
      },
    );
  }

  /// Formats the timestamp for last message
  String formatLastMessageTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      return "${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}";
    } else {
      return "${timestamp.month}/${timestamp.day}/${timestamp.year}";
    }
  }
}