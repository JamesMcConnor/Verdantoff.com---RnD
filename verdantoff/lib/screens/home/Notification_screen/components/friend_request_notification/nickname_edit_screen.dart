import 'package:flutter/material.dart';
import '../../../../../services/friend_requests/friend_request_service.dart';
import '../../../../../services/friend_requests/edit_friend_alias_service.dart';
import '../../utils/notification_service.dart';

class NicknameEditScreen extends StatefulWidget {
  final String notificationId;
  final Map<String, dynamic> notificationData;

  NicknameEditScreen({required this.notificationId, required this.notificationData});

  @override
  _NicknameEditScreenState createState() => _NicknameEditScreenState();
}

class _NicknameEditScreenState extends State<NicknameEditScreen> {
  final TextEditingController _nicknameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nicknameController.text = widget.notificationData['senderName'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Set Nickname')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nicknameController,
              decoration: InputDecoration(labelText: 'Enter a nickname'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String senderId = widget.notificationData['from']; // Sender's ID
                String receiverId = widget.notificationData['receiverId']; // Receiver's ID

                //Accept Friend Request
                await FriendRequestService().acceptFriendRequest(widget.notificationData['relatedId']);

                //Update Friend Alias
                await EditFriendAliasService.updateFriendAlias(senderId, _nicknameController.text.trim());

                //Update Notifications for both Sender and Receiver
                await NotificationService.updateNotification(
                  widget.notificationId,
                  'accepted',
                  'friend_request_accepted',
                  senderId, // The original sender who should receive the notification
                  receiverId, // The receiver who accepted the request
                );

                Navigator.of(context)..pop()..pop();
              },
              child: Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }
}
