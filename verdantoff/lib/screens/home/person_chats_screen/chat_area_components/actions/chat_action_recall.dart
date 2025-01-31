import '../../../../../../services/p2p_services.dart';
import 'package:flutter/material.dart';

class ChatActionRecall {
  static Future<void> recallMessage(
      BuildContext context,
      String chatId,
      String messageId,
      Function onNewMessage,
      ) async {
    try {
      // Debug log: log received parameters
      print('[DEBUG] recallMessage called with chatId: $chatId, messageId: $messageId');
      await P2PServices().messageService.recallMessage(chatId, messageId);

      // Debug log: Successfully withdrawn message
      print('[DEBUG] Message recalled successfully.');
      onNewMessage();
    } catch (e) {
      // Debug Log: Error Messages
      print('[ERROR] Failed to recall message: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to recall message: $e')),
        );
      }
    }
  }
}
