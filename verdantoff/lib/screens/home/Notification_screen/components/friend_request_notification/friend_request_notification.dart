import 'package:flutter/material.dart';
import '../../../../user/Show_User_Info_To_People/Show_User_Info_To_People_Screen.dart';
import 'confirm_friend_screen.dart';

class FriendRequestNotification extends StatelessWidget {
  final String notificationId;
  final Map<String, dynamic> notificationData;
  final String senderName;
  final String senderAvatar;
  final String message;

  const FriendRequestNotification({
    Key? key,
    required this.notificationId,
    required this.notificationData,
    required this.senderName,
    required this.senderAvatar,
    required this.message,
  }) : super(key: key);

  /// Navigate to sender's profile page
  void _viewSenderProfile(BuildContext context) {
    final senderId = notificationData['from'];
    if (senderId != null && senderId.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ShowUserInfoToPeopleScreen(userId: senderId),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String status = notificationData['status'] ?? 'pending';

    return Card(
      child: ListTile(
        leading: GestureDetector(
          onTap: () => _viewSenderProfile(context),
          child: CircleAvatar(
            backgroundImage: senderAvatar.isNotEmpty ? NetworkImage(senderAvatar) : null,
            child: senderAvatar.isEmpty ? Icon(Icons.person) : null,
          ),
        ),
        title: GestureDetector(
          onTap: () => _viewSenderProfile(context),
          child: Text(senderName),
        ),
        subtitle: Text(message),
        trailing: status == 'pending'
            ? TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ConfirmFriendScreen(
                  notificationId: notificationId,
                  notificationData: notificationData,
                  senderName: senderName,
                  senderAvatar: senderAvatar,
                ),
              ),
            );
          },
          child: Text("View"),
        )
            : Text(
          status == 'accepted' ? 'Added' : 'Rejected',
          style: TextStyle(color: status == 'accepted' ? Colors.green : Colors.red),
        ),
      ),
    );
  }
}
