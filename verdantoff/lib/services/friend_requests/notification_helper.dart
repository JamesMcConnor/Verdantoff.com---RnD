import 'package:cloud_firestore/cloud_firestore.dart';

/// Notification Helper
/// This class provides utility functions for managing notifications.
/// It handles adding new notifications and updating the status of existing ones.

class NotificationHelper {
  /// Firestore instance for database operations.
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Adds a new notification to Firestore.
  ///
  /// - [receiverId]: The ID of the user receiving the notification.
  /// - [type]: The type of notification (e.g., `friend_request`).
  /// - [from]: The ID of the user who triggered the notification.
  /// - [message]: The content of the notification.
  /// - [relatedId] (optional): The ID of the related entity (e.g., friend request ID).
  /// - Returns: A `Future<void>` indicating the completion of the operation.
  ///
  /// This function performs the following steps:
  /// 1. Creates a new notification document in Firestore.
  /// 2. Stores the notification details, including:
  ///    - Receiver ID
  ///    - Notification type
  ///    - Sender ID
  ///    - Message content
  ///    - Timestamp of creation
  ///    - Status (defaults to "pending")
  ///    - Related entity ID (if provided)
  /// 3. Logs success or throws an error if the operation fails.
  static Future<void> addNotification(
      String receiverId,
      String type,
      String from,
      String message, {
        String? relatedId,
      }) async {
    try {
      await _firestore.collection('notifications').add({
        'receiverId': receiverId, // The user who will receive the notification
        'type': type, // Type of notification (e.g., friend request)
        'from': from, // The user who initiated the notification
        'message': message, // Notification content
        'timestamp': FieldValue.serverTimestamp(), // Automatically set the creation time
        'status': 'pending', // Default status for new notifications
        'relatedId': relatedId, // The ID of the related entity (if applicable)
      });

      // Log success message
      print('[INFO] Notification added successfully.');
    } catch (e) {
      // Log error message in case of failure
      print('[ERROR] Failed to add notification: $e');
      throw e;
    }
  }

  /// Updates the status of an existing notification in Firestore.
  ///
  /// - [relatedId]: The ID of the related entity (e.g., friend request ID).
  /// - [type]: The new type of the notification (e.g., `friend_request_accepted` or `friend_request_rejected`).
  /// - [status]: The new status of the notification (e.g., `accepted` or `rejected`).
  /// - Returns: A `Future<void>` indicating the completion of the operation.
  ///
  /// This function performs the following steps:
  /// 1. Searches Firestore for a notification matching the given `relatedId` and `friend_request` type.
  /// 2. If a matching notification exists, updates its:
  ///    - Type (e.g., `friend_request_accepted` or `friend_request_rejected`).
  ///    - Status (e.g., `accepted` or `rejected`).
  ///    - `updatedAt` timestamp to reflect the latest change.
  /// 3. Does nothing if no matching notification is found.
  static Future<void> updateNotificationStatus(String relatedId, String type, String status) async {
    // Query Firestore to find the notification related to the given entity
    final relatedNotification = await _firestore
        .collection('notifications')
        .where('relatedId', isEqualTo: relatedId) // Find notification with matching related ID
        .where('type', isEqualTo: 'friend_request') // Ensure it's a friend request notification
        .get();

    // If at least one matching notification exists, update its status
    if (relatedNotification.docs.isNotEmpty) {
      final notificationId = relatedNotification.docs.first.id; // Get the first matching notification's ID

      await _firestore.collection('notifications').doc(notificationId).update({
        'type': type, // Update notification type (e.g., accepted or rejected)
        'status': status, // Update notification status
        'updatedAt': FieldValue.serverTimestamp(), // Update the timestamp
      });
    }
  }
}
