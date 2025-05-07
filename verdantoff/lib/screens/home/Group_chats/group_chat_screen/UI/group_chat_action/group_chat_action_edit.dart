import 'package:flutter/material.dart';
import '../../../../../../services/G2G_chat/G2G_message_service.dart';

class GroupChatActionEdit {
  static Future<void> showEditDialog({
    required BuildContext context,
    required String groupId,
    required String messageId,
    required String initialContent,
    required VoidCallback onSuccess,
  }) async {
    final controller = TextEditingController(text: initialContent);

    final newContent = await showDialog<String>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Edit Message'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Enter new message'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final result = controller.text.trim();
                Navigator.pop(ctx, result);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (newContent != null && newContent.isNotEmpty) {
      try {
        await G2GMessageService().editMessage(groupId, messageId, newContent);
        onSuccess();
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to edit message: $e')),
          );
        }
      }
    }
  }
}
