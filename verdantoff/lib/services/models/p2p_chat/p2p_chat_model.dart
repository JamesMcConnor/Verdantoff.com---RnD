import 'package:cloud_firestore/cloud_firestore.dart';

class P2PChat {
  final String id; // Chat ID
  final String type; // "direct"
  final List<String> participants; // List of user IDs
  final DateTime createdAt; // Creation time
  final DateTime updatedAt; // Last updated time
  final Map<String, dynamic> lastMessage; // Last message summary
  final Map<String, int> unreadCounts; // Unread message count
  final String? alias; // Alias for the friend (not stored in Firestore)

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

  /// Convert Firestore data to model
  factory P2PChat.fromMap(String id, Map<String, dynamic> data) {
    return P2PChat(
      id: id,
      type: data['type'] ?? 'direct',
      participants: List<String>.from(data['participants'] ?? []),
      createdAt: (data['createdAt'] != null) ? (data['createdAt'] as Timestamp).toDate() : DateTime.now(),
      updatedAt: (data['updatedAt'] != null) ? (data['updatedAt'] as Timestamp).toDate() : DateTime.now(),
      lastMessage: Map<String, dynamic>.from(data['lastMessage'] ?? {}),
      unreadCounts: Map<String, int>.from(data['unreadCounts'] ?? {}),
    );
  }

  /// Convert model to Firestore data
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

  /// Copy with method to dynamically set alias
  P2PChat copyWith({String? alias, Map<String, dynamic>? lastMessage}) {
    return P2PChat(
      id: id,
      type: type,
      participants: participants,
      createdAt: createdAt,
      updatedAt: updatedAt,
      lastMessage: lastMessage ?? this.lastMessage, // Only update if provided
      unreadCounts: unreadCounts,
      alias: alias ?? this.alias,
    );
  }
}
