
import '../models/p2p_chat/p2p_message_model.dart';
import 'p2p_message_funtions/add_message.dart';
import 'p2p_message_funtions/edit_message.dart';
import 'p2p_message_funtions/get_messages.dart';
import 'p2p_message_funtions/mark_message_as_read.dart';
import 'p2p_message_funtions/recall_message.dart';

class P2PMessageService {
  Future<P2PMessage> addMessage(String chatId, P2PMessage message) {
    return addMessageFunction(chatId, message);
  }

  Future<List<P2PMessage>> getMessages(String chatId) {
    return getMessagesFunction(chatId);
  }

  Future<void> recallMessage(String chatId, String messageId) {
    return recallMessageFunction(chatId, messageId);
  }

  Future<void> editMessage(String chatId, String messageId, String newContent) {
    return editMessageFunction(chatId, messageId, newContent);
  }
  Future<void> markMessageAsRead(String chatId, String messageId, String userId) {
    return markMessageAsReadFunction(chatId, messageId, userId);
  }

}
