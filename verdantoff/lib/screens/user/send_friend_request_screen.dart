import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SendFriendRequestScreen extends StatefulWidget {
  final Map<String, dynamic> user; // 目标用户信息

  const SendFriendRequestScreen({required this.user});

  @override
  _SendFriendRequestScreenState createState() =>
      _SendFriendRequestScreenState();
}

class _SendFriendRequestScreenState extends State<SendFriendRequestScreen> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _aliasController = TextEditingController();
  bool _isLoading = false; // 加载状态
  String? _currentUserName;

  @override
  void initState() {
    super.initState();
    print('widget.user: ${widget.user}');
    _fetchCurrentUserName();
    _aliasController.text = widget.user['userName'] ?? ''; // 默认别名
  }

  /// 获取当前登录用户的用户名
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
      print('Error fetching current user name: $e');
      _messageController.text = 'Hi, I am User';
    }
  }

  /// 检查是否已有未处理的好友请求
  Future<bool> _checkExistingRequest(String senderId, String receiverId) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('friend_requests')
          .where('senderId', isEqualTo: senderId)
          .where('receiverId', isEqualTo: receiverId)
          .where('status', isEqualTo: 'pending')
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking existing request: $e');
      return false;
    }
  }

  /// 发送好友请求逻辑
  Future<void> _sendRequest() async {
    if (_isLoading) return; // 防止重复点击

    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You must be logged in to send friend requests.')),
      );
      return;
    }

    final currentUserId = currentUser.uid;
    final receiverId = widget.user['uid'];

    if (receiverId == null || receiverId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('The target user is invalid.')),
      );
      return;
    }

    final message = _messageController.text.trim();
    final alias = _aliasController.text.trim();

    if (message.isEmpty || alias.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Message and alias cannot be empty.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 检查是否已有未处理的好友请求
      if (await _checkExistingRequest(currentUserId, receiverId)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('A friend request is already pending.')),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // 创建好友请求记录
      final friendRequestRef = await FirebaseFirestore.instance
          .collection('friend_requests')
          .add({
        'senderId': currentUserId,
        'receiverId': receiverId,
        'message': message,
        'alias': alias,
        'status': 'pending',
        'expiresAt': DateTime.now().add(Duration(days: 7)).toUtc(),
        'timestamp': FieldValue.serverTimestamp(),
      });

      // 创建通知记录
      await FirebaseFirestore.instance.collection('notifications').add({
        'receiverId': receiverId,
        'type': 'friend_request',
        'relatedId': friendRequestRef.id,
        'message': 'You have a new friend request from $_currentUserName',
        'timestamp': FieldValue.serverTimestamp(),
      });

      // 显示成功提示并返回上一页面
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Request Sent'),
          content: Text('Friend request sent successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 关闭对话框
                Navigator.pop(context); // 返回上一页面
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send friend request: ${e.toString()}')),
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
