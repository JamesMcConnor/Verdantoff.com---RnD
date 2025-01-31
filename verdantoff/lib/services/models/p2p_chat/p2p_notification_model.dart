//Defining the Notification Data Model
import 'package:cloud_firestore/cloud_firestore.dart';

class P2PNotification {
  final String id; // notify ID
  final String receiverId; // Recipient ID
  final String type; // Notification type, such as friend_request
  final String from; // User ID from which the notification originated
  final String message; // Notification content
  final DateTime timestamp; // Notification time
  final String status; // Notification status, such as pending, accepted
  final String? relatedId; // Association ID, such as friend request ID

  P2PNotification({
    required this.id,
    required this.receiverId,
    required this.type,
    required this.from,
    required this.message,
    required this.timestamp,
    required this.status,
    this.relatedId,
  });

  // Convert Firestore data to models
  factory P2PNotification.fromMap(String id, Map<String, dynamic> data) {
    return P2PNotification(
      id: id,
      receiverId: data['receiverId'] ?? '',
      type: data['type'] ?? 'unknown',
      from: data['from'] ?? '',
      message: data['message'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      status: data['status'] ?? 'pending',
      relatedId: data['relatedId'],
    );
  }

  // Converting Models to Firestore Data
  Map<String, dynamic> toMap() {
    return {
      'receiverId': receiverId,
      'type': type,
      'from': from,
      'message': message,
      'timestamp': timestamp,
      'status': status,
      'relatedId': relatedId,
    };
  }
}
