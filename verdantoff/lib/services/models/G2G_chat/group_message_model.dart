class GroupMessageModel {
  String messageId;
  String senderId;
  String type; // text, image, link, voice
  String content;
  List<dynamic> attachments;
  DateTime timestamp;
  DateTime editableUntil;
  bool isEdited;
  bool isRecalled;
  List<String> readBy;

  GroupMessageModel({
    required this.messageId,
    required this.senderId,
    required this.type,
    required this.content,
    required this.attachments,
    required this.timestamp,
    required this.editableUntil,
    this.isEdited = false,
    this.isRecalled = false,
    required this.readBy,
  });

  factory GroupMessageModel.fromFirestore(String id, Map<String, dynamic> data) {
    return GroupMessageModel(
      messageId: id,
      senderId: data['senderId'],
      type: data['type'],
      content: data['content'],
      attachments: data['attachments'] ?? [],
      timestamp: data['timestamp'].toDate(),
      editableUntil: data['editableUntil'].toDate(),
      isEdited: data['isEdited'] ?? false,
      isRecalled: data['isRecalled'] ?? false,
      readBy: List<String>.from(data['readBy'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'senderId': senderId,
      'type': type,
      'content': content,
      'attachments': attachments,
      'timestamp': timestamp,
      'editableUntil': editableUntil,
      'isEdited': isEdited,
      'isRecalled': isRecalled,
      'readBy': readBy,
    };
  }
}
