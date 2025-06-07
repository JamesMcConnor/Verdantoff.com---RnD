import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
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
    final isEditable = DateTime.now().isBefore(message.editableUntil);
    final isMe = message.senderId == FirebaseAuth.instance.currentUser?.uid;
    final hasFile = message.fileMeta != null && message.fileMeta!['url'] != null;
    final isRecalled = message.isRecalled; // Check recall status

    return AlertDialog(
      contentPadding: const EdgeInsets.all(8.0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Only show file actions if not recalled
          if (hasFile && message.type == 'image' && !isRecalled)
            ListTile(
              leading: const Icon(Icons.zoom_in),
              title: const Text('View Full Image'),
              onTap: () {
                Navigator.pop(context);
                _viewFullImage(context, message);
              },
            ),
          if (hasFile && !isRecalled) // Add recall check here
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text('Download'),
              onTap: () {
                Navigator.pop(context);
                _downloadFile(context, message);
              },
            ),
          ListTile(
            leading: const Icon(Icons.copy),
            title: const Text('Copy'),
            onTap: () {
              Navigator.pop(context);
              ChatActionCopy.copyMessage(message.content);
            },
          ),
          // Only show edit/recall if not recalled and within edit window
          if (isMe && isEditable && !isRecalled)
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
                  onNewMessage,
                );
              },
            ),
          if (isMe && isEditable && !isRecalled)
            ListTile(
              leading: const Icon(Icons.undo),
              title: const Text('Recall'),
              onTap: () async {
                Navigator.pop(context);
                await ChatActionRecall.recallMessage(
                  context,
                  chatId,
                  message.id,
                  onNewMessage,
                );
              },
            ),
        ],
      ),
    );
  }

  void _viewFullImage(BuildContext context, P2PMessage message) {
    // Prevent viewing recalled images
    if (message.isRecalled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This image has been recalled')),
      );
      return;
    }

    final url = message.fileMeta!['url'] as String;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(),
          body: Center(
            child: InteractiveViewer(
              minScale: 0.1,
              maxScale: 4.0,
              child: Image.network(url),
            ),
          ),
        ),
      ),
    );
  }

  void _downloadFile(BuildContext context, P2PMessage message) {
    // Prevent downloading recalled files
    if (message.isRecalled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This file has been recalled')),
      );
      return;
    }

    final url = message.fileMeta!['url'] as String;
    final fileName = message.fileMeta!['fileName'] as String? ?? 'file';

    if (message.type == 'image') {
      launch(url);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Download File'),
          content: Text('Would you like to download "$fileName"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                launch(url);
              },
              child: const Text('Download'),
            ),
          ],
        ),
      );
    }
  }
}
