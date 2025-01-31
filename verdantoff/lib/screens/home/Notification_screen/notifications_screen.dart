import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../services/friend_requests/friend_request_service.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FriendRequestService _friendRequestService = FriendRequestService();

  @override
  Widget build(BuildContext context) {
    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Notifications')),
        body: Center(child: Text('You need to log in to view notifications.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .where('receiverId', isEqualTo: currentUser.uid)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading notifications: ${snapshot.error}',
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No notifications.'));
          }

          final notifications = snapshot.data!.docs;

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              final notificationData =
              notification.data() as Map<String, dynamic>;

              return FutureBuilder<String>(
                future: _fetchOrUpdateSenderName(notification.id, notificationData),
                builder: (context, nameSnapshot) {
                  final senderName = nameSnapshot.data ?? 'Unknown User';

                  return Card(
                    child: ListTile(
                      title: Text(senderName),
                      subtitle: _getNotificationSubtitle(notificationData),
                      trailing: _getNotificationActions(
                          notificationData, notification.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  /// Get or update the `fromName` field to ensure the correct sender name is displayed in notifications.
  Future<String> _fetchOrUpdateSenderName(
      String notificationId, Map<String, dynamic> notificationData) async {
    if (notificationData.containsKey('fromName') &&
        notificationData['fromName'] != null) {
      return notificationData['fromName'];
    }

    final senderId = notificationData['from'] ?? '';
    if (senderId.isEmpty) return 'Unknown User';

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(senderId)
          .get();

      final senderName =
      userDoc.exists ? (userDoc.data()?['userName'] ?? 'Unknown User') : 'Unknown User';

      // Update the `fromName` field in notifications
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(notificationId)
          .update({'fromName': senderName});

      return senderName;
    } catch (e) {
      print('[ERROR] Failed to fetch sender name: $e');
      return 'Unknown User';
    }
  }

  /// Returns the notification's subtitle
  Widget _getNotificationSubtitle(Map<String, dynamic> notificationData) {
    final type = notificationData['type'] ?? 'unknown';
    switch (type) {
      case 'friend_request':
        final status = notificationData['status'] ?? 'pending';
        if (status == 'accepted') {
          return Text('You have accepted this friend request.');
        } else if (status == 'rejected') {
          return Text('You have rejected this friend request.');
        }
        return Text(notificationData['message'] ?? 'You have a new friend request.');
      case 'friend_request_accepted':
        return Text('Your friend request has been accepted.');
      case 'friend_request_rejected':
        return Text('Your friend request has been rejected.');
      default:
        return Text('You have a new notification.');
    }
  }

  /// Return the action button for pending friend requests
  Widget? _getNotificationActions(Map<String, dynamic> notificationData, String notificationId) {
    final type = notificationData['type'] ?? 'unknown';
    final status = notificationData['status'] ?? 'pending';

    if (type == 'friend_request' && status == 'pending') {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.check, color: Colors.green),
            onPressed: () async {
              try {
                await _friendRequestService.acceptFriendRequest(notificationData['relatedId']);
                await _updateNotification(notificationId, 'accepted', 'friend_request_accepted');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Friend request accepted!')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to accept request: $e')),
                );
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.close, color: Colors.red),
            onPressed: () async {
              try {
                await _friendRequestService.rejectFriendRequest(notificationData['relatedId']);
                await _updateNotification(notificationId, 'rejected', 'friend_request_rejected');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Friend request rejected.')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to reject request: $e')),
                );
              }
            },
          ),
        ],
      );
    }
    return null; // There is no action button for other types or non-pending requests
  }

  /// Update notification status and type
  Future<void> _updateNotification(String notificationId, String status, String type) async {
    try {
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(notificationId)
          .update({'status': status, 'type': type});
      print('[INFO] Notification $notificationId updated: status=$status, type=$type');
    } catch (e) {
      print('[ERROR] Failed to update notification: $e');
    }
  }
}
