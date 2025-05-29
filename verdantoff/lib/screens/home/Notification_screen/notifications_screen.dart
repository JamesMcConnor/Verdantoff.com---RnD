import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'utils/notification_service.dart';
import 'components/friend_request_notification/friend_request_notification.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
        stream: NotificationService.getUserNotifications(currentUser.uid),
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
              final notificationData = notification.data() as Map<String, dynamic>;

              // Use stored data first
              final storedSenderName = notificationData['fromName'];
              final storedAvatar = notificationData['avatar'];
              final storedMessage = notificationData['message'] ?? 'You have a new notification.';

              // If sender name is missing, fetch details dynamically
              if (storedSenderName == null || storedSenderName == 'Unknown User') {
                return FutureBuilder<Map<String, dynamic>>(
                  future: NotificationService.fetchSenderDetails(notification.id, notificationData),
                  builder: (context, senderSnapshot) {
                    if (senderSnapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox.shrink(); // Hide while loading
                    }

                    final senderDetails = senderSnapshot.data ?? {};
                    final senderName = senderDetails['senderName'] ?? 'Unknown User';
                    final senderAvatar = senderDetails['avatar'] ?? '';
                    final message = senderDetails['message'] ?? storedMessage;

                    return FriendRequestNotification(
                      notificationId: notification.id,
                      notificationData: notificationData,
                      senderName: senderName,
                      senderAvatar: senderAvatar,
                      message: message,
                    );
                  },
                );
              }

              // If `fromName` is available, use it directly
              return FriendRequestNotification(
                notificationId: notification.id,
                notificationData: notificationData,
                senderName: storedSenderName,
                senderAvatar: storedAvatar ?? '',
                message: storedMessage,
              );
            },
          );
        },
      ),
    );
  }
}
