import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents an individual message in a peer-to-peer (P2P) chat.
/// This model is used to store and manage message-related metadata.
class P2PMessage {
  /// Unique identifier for the message.
  final String id;

  /// ID of the user who sent the message.
  final String senderId;

  /// Type of message (e.g., "text", "image", "video", "file").
  final String type;

  /// Message content (applies to text messages).
  final String content;

  /// List of attachments associated with the message.
  /// Each attachment is stored as a map containing relevant metadata (e.g., URL, file type).
  final List<Map<String, dynamic>> attachments;

  /// Timestamp indicating when the message was sent.
  final DateTime timestamp;

  /// Deadline until which the message can be edited.
  /// Once this timestamp has passed, editing is no longer allowed.
  final DateTime editableUntil;

  /// Indicates whether the message has been recalled (deleted for both users).
  final bool isRecalled;

  /// List of user IDs who have read this message.
  final List<String> isReadBy;

  /// Indicates whether the message has been edited.
  final bool isEdited;

  /// Constructor for initializing a `P2PMessage` instance.
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

  /// Factory constructor to create a `P2PMessage` instance from Firestore data.
  ///
  /// - [id]: Unique message ID.
  /// - [data]: A map containing message details retrieved from Firestore.
  ///
  /// Converts Firestore timestamps to `DateTime` objects and initializes the message model.
  factory P2PMessage.fromMap(String id, Map<String, dynamic> data) {
    try {
      return P2PMessage(
        id: id,
        senderId: data['senderId'] ?? '', // Defaults to an empty string if senderId is null
        type: data['type'] ?? 'text', // Defaults to 'text' if type is not specified
        content: data['content'] ?? '', // Defaults to an empty string if content is null
        attachments: List<Map<String, dynamic>>.from(data['attachments'] ?? []), // Ensures a valid list
        timestamp: (data['timestamp'] as Timestamp).toDate(), // Converts Firestore Timestamp to DateTime
        editableUntil: (data['editableUntil'] as Timestamp).toDate(), // Converts Firestore Timestamp to DateTime
        isRecalled: data['isRecalled'] ?? false, // Defaults to false if not provided
        isReadBy: List<String>.from(data['isReadBy'] ?? []), // Ensures a valid list
        isEdited: data['isEdited'] ?? false, // Defaults to false if not provided
      );
    } catch (e) {
      throw Exception('[ERROR] Failed to parse message: $e'); // Handles any parsing errors
    }
  }

  /// Converts the `P2PMessage` instance into a map that can be stored in Firestore.
  ///
  /// This method ensures that all required fields are serialized correctly.
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

  /// Creates a copy of the current `P2PMessage` instance with optional modifications.
  ///
  /// - [id]: A new message ID (optional).
  /// - [senderId]: New sender ID (optional).
  /// - [type]: Updated message type (optional).
  /// - [content]: Updated message content (optional).
  /// - [attachments]: Updated list of attachments (optional).
  /// - [timestamp]: Updated timestamp (optional).
  /// - [editableUntil]: Updated edit deadline (optional).
  /// - [isRecalled]: Whether the message has been recalled (optional).
  /// - [isReadBy]: Updated list of users who have read the message (optional).
  /// - [isEdited]: Whether the message has been edited (optional).
  ///
  /// This method allows for immutable updates without modifying the original object.
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
