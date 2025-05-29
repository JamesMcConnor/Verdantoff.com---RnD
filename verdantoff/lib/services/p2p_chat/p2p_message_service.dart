/// P2P Message Service
/// This service class provides an abstraction layer for managing peer-to-peer (P2P) messages.
/// It encapsulates all message-related functions, simplifying their usage throughout the application.

import '../models/p2p_chat/p2p_message_model.dart';
import 'p2p_message_funtions/add_message.dart';
import 'p2p_message_funtions/edit_message.dart';
import 'p2p_message_funtions/get_messages.dart';
import 'p2p_message_funtions/mark_message_as_read.dart';
import 'p2p_message_funtions/recall_message.dart';

/// Service class for handling peer-to-peer messaging operations.
class P2PMessageService {
  /// Sends a new message in a specific chat session and stores it in Firestore.
  ///
  /// - [chatId]: The unique ID of the chat session where the message is sent.
  /// - [message]: The `P2PMessage` object containing the message details.
  /// - Returns: A `Future<P2PMessage>` with the saved message, including its Firestore-generated ID.
  Future<P2PMessage> addMessage(String chatId, P2PMessage message) {
    return addMessageFunction(chatId, message);
  }

  /// Retrieves all messages from a specific chat session.
  ///
  /// - [chatId]: The unique ID of the chat session.
  /// - Returns: A `Future<List<P2PMessage>>` containing a list of messages sorted chronologically.
  Future<List<P2PMessage>> getMessages(String chatId) {
    return getMessagesFunction(chatId);
  }

  /// Recalls (withdraws) a message from a chat session if it is still within the editable timeframe.
  ///
  /// - [chatId]: The unique ID of the chat session where the message was sent.
  /// - [messageId]: The unique ID of the message to be recalled.
  /// - Returns: A `Future<void>` indicating the completion of the recall operation.
  Future<void> recallMessage(String chatId, String messageId) {
    return recallMessageFunction(chatId, messageId);
  }

  /// Edits an existing message in a chat session if it is still within the editable timeframe.
  ///
  /// - [chatId]: The unique ID of the chat session containing the message.
  /// - [messageId]: The unique ID of the message to be edited.
  /// - [newContent]: The updated content for the message.
  /// - Returns: A `Future<void>` indicating the completion of the edit operation.
  Future<void> editMessage(String chatId, String messageId, String newContent) {
    return editMessageFunction(chatId, messageId, newContent);
  }

  /// Marks a specific message as read by a user.
  ///
  /// - [chatId]: The unique ID of the chat session.
  /// - [messageId]: The unique ID of the message to be marked as read.
  /// - [userId]: The ID of the user who has read the message.
  /// - Returns: A `Future<void>` indicating the completion of the update operation.
  Future<void> markMessageAsRead(String chatId, String messageId, String userId) {
    return markMessageAsReadFunction(chatId, messageId, userId);
  }
}
