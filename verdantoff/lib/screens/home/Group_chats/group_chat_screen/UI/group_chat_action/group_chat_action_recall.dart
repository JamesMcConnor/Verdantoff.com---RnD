import 'package:flutter/material.dart';
import '../../../../../../services/G2G_chat/G2G_message_service.dart';

class GroupChatActionRecall {
  static Future<void> recallMessage({
    required BuildContext context,
    required String groupId,
    required String messageId,
    required VoidCallback onSuccess,
  }) async {
    try {
      await G2GMessageService().recallMessage(groupId, messageId);
      onSuccess();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to recall message: $e')),
        );
      }
    }
  }
}
