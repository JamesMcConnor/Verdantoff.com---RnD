import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/friend_requests/friend_request_sender.dart';


class SendFriendRequestScreen extends StatefulWidget {
  final Map<String, dynamic> user; // Target user information

  const SendFriendRequestScreen({required this.user});

  @override
  _SendFriendRequestScreenState createState() =>
      _SendFriendRequestScreenState();
}

class _SendFriendRequestScreenState extends State<SendFriendRequestScreen> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _aliasController = TextEditingController();
  bool _isLoading = false; // Loading Status
  String? _currentUserName;

  @override
  void initState() {
    super.initState();
    _aliasController.text = widget.user['userName'] ?? ''; // Default Aliases
    _fetchCurrentUserName();
  }

  /// Get the username of the currently logged in user
  Future<void> _fetchCurrentUserName() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

        setState(() {
          _currentUserName = userDoc['userName']?.toString() ?? 'User';
          _messageController.text = 'Hi, I am $_currentUserName';
        });
      }
    } catch (e) {
      print('[ERROR] Failed to fetch current user name: $e');
      _messageController.text = 'Hi, I am User';
    }
  }

  /// Send a friend request
  Future<void> _sendRequest() async {
    if (_isLoading) return;

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You must be logged in to send friend requests.')),
      );
      return;
    }

    final senderId = currentUser.uid;
    final receiverId = widget.user['uid'];
    final message = _messageController.text.trim();
    final alias = _aliasController.text.trim();

    if (receiverId.isEmpty || message.isEmpty || alias.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Message and alias cannot be empty.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final friendRequestSender = FriendRequestSender();
      await friendRequestSender.sendFriendRequest(
        senderId: senderId,
        receiverId: receiverId,
        message: message,
        alias: alias,
      );

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Request Sent'),
          content: Text('Friend request sent successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog box
                Navigator.pop(context); // Return to the previous page
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Send Friend Request')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: widget.user['avatar'] != null
                      ? NetworkImage(widget.user['avatar'])
                      : null,
                  child: widget.user['avatar'] == null
                      ? Icon(Icons.person)
                      : null,
                ),
                SizedBox(width: 16),
                Text(
                  widget.user['userName'] ?? 'Unknown User',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16),
            TextField(
              controller: _messageController,
              decoration: InputDecoration(
                labelText: 'Message',
                border: OutlineInputBorder(),
                hintText: 'Add a message...',
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _aliasController,
              decoration: InputDecoration(
                labelText: 'Alias',
                border: OutlineInputBorder(),
                hintText: 'Set an alias for this friend...',
              ),
            ),
            Spacer(),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _sendRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: TextStyle(fontSize: 18),
                ),
                child: Text('Send Request'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
