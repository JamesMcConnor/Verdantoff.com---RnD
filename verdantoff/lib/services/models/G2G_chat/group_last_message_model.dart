import 'package:cloud_firestore/cloud_firestore.dart';

class GroupLastMessageModel {
  final String messageId;
  final String content;
  final String senderId;
  final String senderName;
  final bool isEdited;
  final bool isRecalled;
  final DateTime updatedAt;

  GroupLastMessageModel({
    required this.messageId,
    required this.content,
    required this.senderId,
    required this.senderName,
    required this.isEdited,
    required this.isRecalled,
    required this.updatedAt,
  });

  factory GroupLastMessageModel.fromMap(Map<String, dynamic> data) {
    return GroupLastMessageModel(
      messageId: data['messageId'],
      content: data['content'],
      senderId: data['senderId'],
      senderName: data['senderName'],
      isEdited: data['isEdited'] ?? false,
      isRecalled: data['isRecalled'] ?? false,
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'content': content,
      'senderId': senderId,
      'senderName': senderName,
      'isEdited': isEdited,
      'isRecalled': isRecalled,
      'updatedAt': updatedAt,
    };
  }
}
