
import '../models/p2p_chat/p2p_chat_model.dart';
import 'p2p_chat_service_funtions/create_chat.dart';
import 'p2p_chat_service_funtions/create_or_fetch_chat.dart';
import 'p2p_chat_service_funtions/get_chats.dart';
import 'p2p_chat_service_funtions/update_chat.dart';
import 'p2p_chat_service_funtions/update_unread_counts.dart';

class P2PChatService {
  Future<String> createChat(List<String> participants) {
    return createChatFunction(participants);
  }

  Future<void> updateChat(String chatId, P2PChat updates) {
    return updateChatFunction(chatId, updates);
  }

  Future<List<P2PChat>> getChats(String userId) {
    return getChatsFunction(userId);
  }

  Future<void> updateUnreadCounts(String chatId, String userId) {
    return updateUnreadCountsFunction(chatId, userId);
  }

  Future<String> createOrFetchChat(List<String> participants) {
    return createOrFetchChatFunction(participants);
  }
}
