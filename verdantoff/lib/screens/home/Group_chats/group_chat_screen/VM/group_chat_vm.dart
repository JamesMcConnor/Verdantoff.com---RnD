import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../services/G2G_chat/G2G_message_service.dart';
import '../../../../../services/G2G_chat/G2G_service.dart';
import '../../../../../services/models/G2G_chat/group_message_model.dart';

class GroupChatViewModel extends ChangeNotifier {
  final String groupId;
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  final G2GMessageService _messageService = G2GMessageService();
  final G2GService _groupService = G2GService();

  String groupName = '';
  List<ChatMessage> messages = [];
  TextEditingController messageController = TextEditingController();

  bool _disposed = false;

  GroupChatViewModel(this.groupId) {
    fetchGroupDetails();
    fetchMessages();
  }

  Future<void> editMessage(String messageId, String newContent) async {
    await _messageService.editMessage(groupId, messageId, newContent);
  }

  Future<void> recallMessage(String messageId) async {
    await _messageService.recallMessage(groupId, messageId);
  }

  void markMessagesAsRead(String currentUserId) {
    for (var msg in messages) {
      if (!msg.readBy.contains(currentUserId)) {
        _messageService.markMessageAsRead(groupId, msg.messageId, currentUserId);
      }
    }
  }

  void fetchGroupDetails() async {
    final group = await _groupService.getGroupDetails(groupId);
    groupName = group?.name ?? 'Unknown Group';
    if (!_disposed) notifyListeners();
  }

  void fetchMessages() {
    _messageService.groupsCollection
        .doc(groupId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .listen((snapshot) async {
      final msgs = await Future.wait(snapshot.docs.map((doc) async {
        final data = doc.data();
        final senderId = data['senderId'] as String;

        final memberDoc = await _messageService.groupsCollection
            .doc(groupId)
            .collection('members')
            .doc(senderId)
            .get();

        final userDoc = await _groupService.usersCollection.doc(senderId).get();

        final nickname = memberDoc.data()?['nickname'] ??
            (userDoc.data() as Map<String, dynamic>?)?['fullName'] ??
            'Unknown';

        final avatar = (userDoc.data() as Map<String, dynamic>?)?['avatar'] ?? '';

        return ChatMessage(
          messageId: doc.id,
          senderId: senderId,
          senderNickname: nickname,
          senderAvatar: avatar,
          content: data['content'] as String,
          isEdited: data['isEdited'] ?? false,
          isRecalled: data['isRecalled'] ?? false,
          readBy: List<String>.from(data['readBy'] ?? []),
          editableUntil: (data['editableUntil'] as Timestamp).toDate(),
        );
      }).toList());

      messages = msgs;
      if (!_disposed) notifyListeners();
    });
  }

  void sendTextMessage() async {
    final content = messageController.text.trim();
    if (content.isEmpty) return;

    final message = GroupMessageModel(
      messageId: _messageService.groupsCollection.doc().id,
      senderId: currentUserId,
      type: 'text',
      content: content,
      attachments: [],
      timestamp: DateTime.now(),
      editableUntil: DateTime.now().add(Duration(minutes: 1)),
      readBy: [],
      isEdited: false,
      isRecalled: false,
    );

    await _messageService.sendTextMessage(groupId, message);
    messageController.clear();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

class ChatMessage {
  final String messageId;
  final String senderId;
  final String senderNickname;
  final String senderAvatar;
  final String content;
  final bool isEdited;
  final bool isRecalled;
  final List<String> readBy;
  final DateTime editableUntil;

  ChatMessage({
    required this.messageId,
    required this.senderId,
    required this.senderNickname,
    required this.senderAvatar,
    required this.content,
    required this.editableUntil,
    this.isEdited = false,
    this.isRecalled = false,
    this.readBy = const [],
  });
}
