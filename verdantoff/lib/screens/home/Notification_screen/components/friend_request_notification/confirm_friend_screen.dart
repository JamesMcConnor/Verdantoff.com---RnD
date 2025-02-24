import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../services/friend_requests/friend_request_service.dart';
import '../../utils/notification_service.dart';
import 'nickname_edit_screen.dart';

class ConfirmFriendScreen extends StatefulWidget {
  final String notificationId;
  final Map<String, dynamic> notificationData;
  final String senderName;
  final String senderAvatar;

  ConfirmFriendScreen({
    required this.notificationId,
    required this.notificationData,
    required this.senderName,
    required this.senderAvatar,
  });

  @override
  _ConfirmFriendScreenState createState() => _ConfirmFriendScreenState();
}

class _ConfirmFriendScreenState extends State<ConfirmFriendScreen> {
  final FriendRequestService _friendRequestService = FriendRequestService();
  String friendRequestMessage = 'Loading message...';

  @override
  void initState() {
    super.initState();
    _fetchFriendRequestMessage();
  }

  /// Fetch the original message from `friend_requests` using `relatedId`
  Future<void> _fetchFriendRequestMessage() async {
    try {
      final String relatedId = widget.notificationData['relatedId'];
      final doc = await FirebaseFirestore.instance.collection('friend_requests').doc(relatedId).get();

      if (doc.exists) {
        setState(() {
          friendRequestMessage = doc.data()?['message'] ?? 'No message provided.';
        });
      } else {
        setState(() {
          friendRequestMessage = 'No message found.';
        });
      }
    } catch (e) {
      setState(() {
        friendRequestMessage = 'Failed to load message.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Friend Request')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: widget.senderAvatar.isNotEmpty ? NetworkImage(widget.senderAvatar) : null,
              child: widget.senderAvatar.isEmpty ? Icon(Icons.person, size: 50) : null,
            ),
            SizedBox(height: 10),
            Text('@${widget.senderName}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Divider(height: 30, thickness: 1),

            // Display the fetched friend request message
            Text(friendRequestMessage),

            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NicknameEditScreen(
                          notificationId: widget.notificationId,
                          notificationData: widget.notificationData,
                        ),
                      ),
                    );
                  },
                  child: Text('Go Confirm'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      String senderId = widget.notificationData['from'];
                      String receiverId = widget.notificationData['receiverId'];

                      await _friendRequestService.rejectFriendRequest(widget.notificationData['relatedId']);

                      await NotificationService.updateNotification(
                        widget.notificationId,
                        'rejected',
                        'friend_request_rejected',
                        senderId,
                        receiverId,
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Friend request rejected.')),
                      );

                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to reject request: $e')),
                      );
                    }
                  },
                  child: Text('Reject', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
