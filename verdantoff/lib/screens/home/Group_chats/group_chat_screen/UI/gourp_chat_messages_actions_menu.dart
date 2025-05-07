import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../message_read_status/UI/message_read_status_screen.dart';
import '../VM/group_chat_vm.dart';
import 'group_chat_action/group_chat_action_edit.dart';
import 'group_chat_action/group_chat_action_recall.dart';

class GroupChatMessagesActionsMenu extends StatelessWidget {
  final String groupId;
  final ChatMessage message;
  final bool isMine;

  const GroupChatMessagesActionsMenu({
    required this.groupId,
    required this.message,
    required this.isMine,
  });

  bool get isEditable => DateTime.now().isBefore(message.editableUntil);

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<GroupChatViewModel>(context, listen: false);

    return Wrap(
      children: [
        ListTile(
          leading: const Icon(Icons.copy),
          title: const Text('Copy'),
          onTap: () {
            Navigator.pop(context);
            Clipboard.setData(ClipboardData(text: message.content));
          },
        ),
        ListTile(
          leading: const Icon(Icons.format_quote),
          title: const Text('Quote (Future)'),
          onTap: () => Navigator.pop(context),
        ),
        ListTile(
          leading: const Icon(Icons.forward),
          title: const Text('Forward (Future)'),
          onTap: () => Navigator.pop(context),
        ),
        ListTile(
          leading: const Icon(Icons.remove_red_eye),
          title: const Text('Who Read'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MessageReadStatusScreen(
                  groupId: groupId,
                  messageId: message.messageId,
                ),
              ),
            );
          },
        ),

        if (isMine && isEditable && !message.isRecalled) ...[
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit'),
            onTap: () {
              Navigator.pop(context);
              GroupChatActionEdit.showEditDialog(
                context: context,
                groupId: groupId,
                messageId: message.messageId,
                initialContent: message.content,
                onSuccess: () => vm.fetchMessages(),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Recall'),
            onTap: () {
              Navigator.pop(context);
              GroupChatActionRecall.recallMessage(
                context: context,
                groupId: groupId,
                messageId: message.messageId,
                onSuccess: () => vm.fetchMessages(),
              );
            },
          ),
        ],
      ],
    );
  }
}
