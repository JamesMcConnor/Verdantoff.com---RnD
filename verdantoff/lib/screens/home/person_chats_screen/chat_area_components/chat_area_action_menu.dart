import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../../services/models/p2p_chat/p2p_message_model.dart';
import 'actions/chat_action_copy.dart';
import 'actions/chat_action_recall.dart';
import 'actions/chat_action_edit.dart';

class ChatAreaActionMenu extends StatelessWidget {
  final P2PMessage message;
  final String chatId;
  final void Function(P2PMessage) onNewMessage;

  const ChatAreaActionMenu({
    Key? key,
    required this.message,
    required this.chatId,
    required this.onNewMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Debugging: Log `editableUntil` and its type
    print('[DEBUG] editableUntil raw value: ${message.editableUntil}, type: ${message.editableUntil.runtimeType}');

    final isEditable = DateTime.now().isBefore(message.editableUntil); // Using the model's fields
    print('[DEBUG] isEditable: $isEditable');

    final isMe = message.senderId == FirebaseAuth.instance.currentUser?.uid;

    return AlertDialog(
      contentPadding: const EdgeInsets.all(8.0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.copy),
            title: const Text('Copy'),
            onTap: () {
              Navigator.pop(context);
              ChatActionCopy.copyMessage(message.content); // Get content from the model
            },
          ),
          ListTile(
            leading: const Icon(Icons.forward),
            title: const Text('Forward'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.format_quote),
            title: const Text('Quote'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          if (isMe && isEditable)
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit'),
              onTap: () async {
                Navigator.pop(context);
                await ChatActionEdit.editMessage(
                  context,
                  chatId,
                  message.id,
                  message.content,
                  onNewMessage, // Refresh message list
                );
              },
            ),
          if (isMe && isEditable)
            ListTile(
              leading: const Icon(Icons.undo),
              title: const Text('Recall'),
              onTap: () async {
                Navigator.pop(context);
                print('[DEBUG] Attempting to recall message with chatId: $chatId, messageId: ${message.id}');
                await ChatActionRecall.recallMessage(
                  context,
                  chatId,
                  message.id, // Using the model's fields
                  onNewMessage,
                );
              },
            ),
        ],
      ),
    );
  }
}
