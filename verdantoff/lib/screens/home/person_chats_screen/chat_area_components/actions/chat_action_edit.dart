import '../../../../../../services/p2p_services.dart';
import 'package:flutter/material.dart';

class ChatActionEdit {
  static Future<void> editMessage(
      BuildContext context,
      String chatId,
      String messageId,
      String initialContent,
      Function onNewMessage,
      ) async {
    final TextEditingController _editController =
    TextEditingController(text: initialContent);

    // Debug: Log initial content
    print('[DEBUG] Initial content: $initialContent');

    final newContent = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Message'),
          content: TextField(
            controller: _editController,
            decoration: const InputDecoration(hintText: 'Enter new message'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, _editController.text),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (newContent != null && newContent.trim().isNotEmpty) {
      try {
        // Debug: Log new content before update
        print('[DEBUG] New content: $newContent');

        await P2PServices().messageService.editMessage(chatId, messageId, newContent);
        onNewMessage(); // Refresh message list
        print('[DEBUG] Message edited successfully.');
      } catch (e) {
        if (context.mounted) { // Ensure context is valid
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to edit message: $e')),
          );
        }
        print('[ERROR] Failed to edit message: $e');
      }
    }
  }
}
