import 'package:cloud_firestore/cloud_firestore.dart';

class P2PMessage {
  final String id; // message ID
  final String senderId; // send ID
  final String type; // Message Type，like text, image
  final String content; // Message content
  final List<Map<String, dynamic>> attachments; // Attachment Information
  final DateTime timestamp; // Message time
  final DateTime editableUntil; // Modifiable deadline
  final bool isRecalled; // Whether it was withdrawn
  final List<String> isReadBy; // Read user list
  final bool isEdited; // Has it been edited?

  P2PMessage({
    required this.id,
    required this.senderId,
    required this.type,
    required this.content,
    required this.attachments,
    required this.timestamp,
    required this.editableUntil,
    required this.isRecalled,
    required this.isReadBy,
    required this.isEdited,
  });

  // Convert Firestore data to models
  factory P2PMessage.fromMap(String id, Map<String, dynamic> data) {
    try {
      return P2PMessage(
        id: id,
        senderId: data['senderId'] ?? '',
        type: data['type'] ?? 'text',
        content: data['content'] ?? '',
        attachments: List<Map<String, dynamic>>.from(data['attachments'] ?? []),
        timestamp: (data['timestamp'] as Timestamp).toDate(),
        editableUntil: (data['editableUntil'] as Timestamp).toDate(),
        isRecalled: data['isRecalled'] ?? false,
        isReadBy: List<String>.from(data['isReadBy'] ?? []),
        isEdited: data['isEdited'] ?? false,
      );
    } catch (e) {
      throw Exception('[ERROR] Failed to parse message: $e');
    }
  }


  // Converting Models to Firestore Data
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'type': type,
      'content': content,
      'attachments': attachments,
      'timestamp': timestamp,
      'editableUntil': editableUntil,
      'isRecalled': isRecalled,
      'isReadBy': isReadBy,
      'isEdited': isEdited,
    };
  }

  // Implementing the copyWith Method
  P2PMessage copyWith({
    String? id,
    String? senderId,
    String? type,
    String? content,
    List<Map<String, dynamic>>? attachments,
    DateTime? timestamp,
    DateTime? editableUntil,
    bool? isRecalled,
    List<String>? isReadBy,
    bool? isEdited,
  }) {
    return P2PMessage(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      type: type ?? this.type,
      content: content ?? this.content,
      attachments: attachments ?? this.attachments,
      timestamp: timestamp ?? this.timestamp,
      editableUntil: editableUntil ?? this.editableUntil,
      isRecalled: isRecalled ?? this.isRecalled,
      isReadBy: isReadBy ?? this.isReadBy,
      isEdited: isEdited ?? this.isEdited,
    );
  }
}
