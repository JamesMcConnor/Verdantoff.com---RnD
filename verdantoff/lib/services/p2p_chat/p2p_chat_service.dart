/// P2P Chat Service
/// This service class provides an abstraction layer for managing peer-to-peer (P2P) chat sessions.
/// It encapsulates the chat-related functions, making them easier to use throughout the application.

import '../models/p2p_chat/p2p_chat_model.dart';
import 'p2p_chat_service_funtions/create_chat.dart';
import 'p2p_chat_service_funtions/create_or_fetch_chat.dart';
import 'p2p_chat_service_funtions/get_chats.dart';
import 'p2p_chat_service_funtions/update_chat.dart';
import 'p2p_chat_service_funtions/update_unread_counts.dart';

/// Service class for handling peer-to-peer chat operations.
class P2PChatService {
  /// Creates a new chat session.
  ///
  /// - [participants]: A list of user IDs who will be part of the chat.
  /// - Returns: A `Future<String>` containing the unique chat ID of the created session.
  Future<String> createChat(List<String> participants) {
    return createChatFunction(participants);
  }

  /// Updates an existing chat session with new data.
  ///
  /// - [chatId]: The unique ID of the chat session to be updated.
  /// - [updates]: A `P2PChat` object containing the updated fields.
  /// - Returns: A `Future<void>` indicating the completion of the update operation.
  Future<void> updateChat(String chatId, P2PChat updates) {
    return updateChatFunction(chatId, updates);
  }

  /// Retrieves all chat sessions associated with a given user.
  ///
  /// - [userId]: The ID of the user whose chat sessions need to be fetched.
  /// - Returns: A `Future<List<P2PChat>>` containing a list of chat objects.
  Future<List<P2PChat>> getChats(String userId) {
    return getChatsFunction(userId);
  }

  /// Updates the unread message count for a specific user in a chat session.
  ///
  /// - [chatId]: The unique ID of the chat session.
  /// - [userId]: The user ID whose unread count should be updated.
  /// - Returns: A `Future<void>` indicating the completion of the update operation.
  Future<void> updateUnreadCounts(String chatId, String userId) {
    return updateUnreadCountsFunction(chatId, userId);
  }

  /// Retrieves an existing chat session between the specified participants or creates a new one if it doesn't exist.
  ///
  /// - [participants]: A list of user IDs who will be part of the chat.
  /// - Returns: A `Future<String>` containing the unique chat ID.
  Future<String> createOrFetchChat(List<String> participants) {
    return createOrFetchChatFunction(participants);
  }
}
