//this page not use
import 'package:flutter/material.dart';
import '../../../../../services/friend_requests/friend_request_service.dart';
import '../../utils/notification_service.dart';
import 'nickname_edit_screen.dart';

class FriendRequestNotificationLogic extends StatelessWidget {
  final String notificationId;
  final Map<String, dynamic> notificationData;
  final FriendRequestService _friendRequestService = FriendRequestService();

  FriendRequestNotificationLogic({
    Key? key,
    required this.notificationId,
    required this.notificationData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final status = notificationData['status'] ?? 'pending';

    if (status != 'pending') return SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.check, color: Colors.green),
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NicknameEditScreen(
                  notificationId: notificationId,
                  notificationData: notificationData,
                ),
              ),
            );
          },
        ),
        IconButton(
          icon: Icon(Icons.close, color: Colors.red),
          onPressed: () async {
            try {
              String senderId = notificationData['from']; // Sender's ID
              String receiverId = notificationData['receiverId']; // Receiver's ID

              await _friendRequestService.rejectFriendRequest(notificationData['relatedId']);

              // Fix: Pass receiver first (who is rejecting), sender second
              await NotificationService.updateNotification(
                notificationId,
                'rejected',
                'friend_request_rejected',
                receiverId, // The one rejecting
                senderId,   // The original sender who should be notified
              );

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
}