import 'package:flutter/material.dart';
import '../../../services/models/G2G_chat/GroupChats_DisplayOnChatsList.dart';

class GroupChatListItemUI extends StatelessWidget {
  final GroupChatDisplayModel groupChat;

  const GroupChatListItemUI({Key? key, required this.groupChat}) : super(key: key);

  /// Format time (only display time today, other display date)
  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    if (now.difference(timestamp).inDays == 0) {
      return "${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}";
    } else {
      return "${timestamp.month}/${timestamp.day}/${timestamp.year}";
    }
  }

  /// Get group abbreviation
  String _getGroupAbbreviation(String name) {
    if (name.length == 1) return name;
    return name.substring(0, 2).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blueGrey[200],
        child: Text(
          _getGroupAbbreviation(groupChat.groupName),
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      title: Text(groupChat.groupName, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(
        groupChat.isLastMessageRecalled
            ? 'Message recalled'
            : "${groupChat.lastMessageSenderName}: ${groupChat.lastMessageContent}",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontStyle: groupChat.isLastMessageRecalled ? FontStyle.italic : FontStyle.normal,
          color: groupChat.isLastMessageRecalled ? Colors.grey : Colors.black,
        ),
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _formatTime(groupChat.updatedAt),
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          if (groupChat.unreadCount > 0)
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                groupChat.unreadCount.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
        ],
      ),
      onTap: () {
        Navigator.pushNamed(
          context,
          '/group_chat_screen',
          arguments: {
            'groupId': groupChat.groupId,
            'groupName': groupChat.groupName
          },
        );
      },
    );
  }
}
