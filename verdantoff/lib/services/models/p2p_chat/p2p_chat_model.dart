//Define the session data model
import 'package:cloud_firestore/cloud_firestore.dart';

class P2PChat {
  final String id; // Session ID
  final String type; // "direct"
  final List<String> participants; // Participant ID List
  final DateTime createdAt; // Session creation time
  final DateTime updatedAt; // Last updated
  final Map<String, dynamic> lastMessage; // Latest News Summary
  final Map<String, int> unreadCounts; // Unread message count per participant

  P2PChat({
    required this.id,
    required this.type,
    required this.participants,
    required this.createdAt,
    required this.updatedAt,
    required this.lastMessage,
    required this.unreadCounts,
  });

  // Convert Firestore data to models
  factory P2PChat.fromMap(String id, Map<String, dynamic> data) {
    return P2PChat(
      id: id,
      type: data['type'] ?? 'direct',
      participants: List<String>.from(data['participants'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      lastMessage: Map<String, dynamic>.from(data['lastMessage'] ?? {}),
      unreadCounts: Map<String, int>.from(data['unreadCounts'] ?? {}),
    );
  }

  // Converting Models to Firestore Data
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
}
