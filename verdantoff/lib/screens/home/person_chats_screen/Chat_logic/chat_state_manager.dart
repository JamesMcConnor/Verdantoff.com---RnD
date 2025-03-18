import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../../../../services/models/p2p_chat/p2p_message_model.dart';
import '../../../../services/p2p_services.dart';

class ChatStateManager {
  final String chatId;
  final String friendName;
  final String friendId;

  final TextEditingController messageController = TextEditingController();
  final P2PServices _p2pServices = P2PServices();

  final ValueNotifier<List<P2PMessage>> messages = ValueNotifier([]);
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _messageSubscription;

  ChatStateManager({
    required this.chatId,
    required this.friendName,
    required this.friendId,
  });

  void initializeChat() {
    _messageSubscription = FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .listen((snapshot) {
      final newMessages = snapshot.docs.map((doc) {
        try {
          return P2PMessage.fromMap(doc.id, doc.data());
        } catch (e) {
          print('[ERROR] Failed to parse message: $e');
          return null;
        }
      }).whereType<P2PMessage>().toList();

      messages.value = List.from(newMessages);
      markMessagesAsRead();
    });
  }

  void markMessagesAsRead() {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) return;

    for (final message in messages.value) {
      if (!message.isReadBy.contains(currentUserId)) {
        _p2pServices.messageService.markMessageAsRead(chatId, message.id, currentUserId);
      }
    }
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserId == null || text.isEmpty) return;

    try {
      final newMessage = P2PMessage(
        id: '',
        senderId: currentUserId,
        type: 'text',
        content: text,
        attachments: [],
        timestamp: DateTime.now(),
        editableUntil: DateTime.now().add(Duration(minutes: 1)),
        isRecalled: false,
        isReadBy: [],
        isEdited: false,
      );

      await _p2pServices.messageService.addMessage(chatId, newMessage);
      messageController.clear();
    } catch (e) {
      print('[ERROR] Failed to send message: $e');
    }
  }

  void dispose() {
    _messageSubscription?.cancel();
    messageController.dispose();
  }
}