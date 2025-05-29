import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a peer-to-peer (P2P) chat session between two users.
/// This model is used to store and manage chat-related metadata.
class P2PChat {
  /// Unique identifier for the chat session.
  final String id;

  /// Type of chat. Defaults to "direct" for one-on-one messaging.
  final String type;

  /// List of participant user IDs. Should contain exactly two users for P2P chats.
  final List<String> participants;

  /// Timestamp indicating when the chat was created.
  final DateTime createdAt;

  /// Timestamp indicating when the chat was last updated.
  final DateTime updatedAt;

  /// Stores a summary of the last message exchanged in the chat.
  /// This can be used for quick previews in the chat list.
  final Map<String, dynamic> lastMessage;

  /// A map storing the unread message count for each participant.
  /// The keys are user IDs, and the values are the number of unread messages.
  final Map<String, int> unreadCounts;

  /// Optional alias for the chat participant (e.g., a friend’s custom name).
  /// This field is not stored in Firestore but can be dynamically set.
  final String? alias;

  /// Constructor for initializing a `P2PChat` instance.
  P2PChat({
    required this.id,
    required this.type,
    required this.participants,
    required this.createdAt,
    required this.updatedAt,
    required this.lastMessage,
    required this.unreadCounts,
    this.alias, // Alias is optional and dynamically fetched
  });

  /// Factory constructor to create a `P2PChat` instance from Firestore data.
  ///
  /// - [id]: Unique chat ID.
  /// - [data]: A map containing chat details retrieved from Firestore.
  ///
  /// Converts Firestore timestamps to `DateTime` objects and initializes the chat model.
  factory P2PChat.fromMap(String id, Map<String, dynamic> data) {
    return P2PChat(
      id: id,
      type: data['type'] ?? 'direct', // Defaults to 'direct' if not specified
      participants: List<String>.from(data['participants'] ?? []), // Ensures a valid list
      createdAt: (data['createdAt'] != null)
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(), // Defaults to the current timestamp if null
      updatedAt: (data['updatedAt'] != null)
          ? (data['updatedAt'] as Timestamp).toDate()
          : DateTime.now(), // Defaults to the current timestamp if null
      lastMessage: Map<String, dynamic>.from(data['lastMessage'] ?? {}), // Stores last message details
      unreadCounts: Map<String, int>.from(data['unreadCounts'] ?? {}), // Maps unread message counts
    );
  }

  /// Converts the `P2PChat` instance into a map that can be stored in Firestore.
  /// This method ensures that all required fields are serialized correctly.
  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'participants': participants,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'lastMessage': lastMessage,
      'unreadCounts': unreadCounts,
    };
  }

  /// Creates a copy of the current `P2PChat` instance with optional modifications.
  ///
  /// - [alias]: A new alias to be assigned.
  /// - [lastMessage]: Updated last message details.
  ///
  /// This method allows for immutable updates without modifying the original object.
  P2PChat copyWith({String? alias, Map<String, dynamic>? lastMessage}) {
    return P2PChat(
      id: id,
      type: type,
      participants: participants,
      createdAt: createdAt,
      updatedAt: updatedAt,
      lastMessage: lastMessage ?? this.lastMessage, // Only update if provided
      unreadCounts: unreadCounts,
      alias: alias ?? this.alias, // Keep the existing alias if not updated
    );
  }
}
