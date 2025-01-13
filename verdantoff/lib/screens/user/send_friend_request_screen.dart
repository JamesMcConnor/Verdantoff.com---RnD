import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SendFriendRequestScreen extends StatefulWidget {
  final Map<String, dynamic> user; // 目标用户信息

  const SendFriendRequestScreen({required this.user});

  @override
  _SendFriendRequestScreenState createState() => _SendFriendRequestScreenState();
}

class _SendFriendRequestScreenState extends State<SendFriendRequestScreen> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _aliasController = TextEditingController();
  String? _currentUserName; // 当前登录用户的用户名

  @override
  void initState() {
    super.initState();
    _fetchCurrentUserName();
    _aliasController.text = widget.user['userName']; // 默认别名为目标用户的用户名
  }

  Future<void> _fetchCurrentUserName() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

        setState(() {
          _currentUserName = userDoc['userName'] ?? 'User';
          _messageController.text = 'I am $_currentUserName';
        });
      }
    } catch (e) {
      print('Error fetching current user name: $e');
      _messageController.text = 'I am User';
    }
  }

  void _sendRequest() async {
    // 模拟发送请求逻辑
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text('Friend request sent successfully!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // 关闭对话框
              Navigator.pop(context); // 返回到用户详情页面
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
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
            // 发送好友请求消息
            TextField(
              controller: _messageController,
              decoration: InputDecoration(
                labelText: 'Send Friend Request Message',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            // 设置别名
            TextField(
              controller: _aliasController,
              decoration: InputDecoration(
                labelText: 'Set Alias',
                border: OutlineInputBorder(),
              ),
            ),
            Spacer(),
            // 发送按钮
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _sendRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 16.0), // 增大按钮尺寸
                  textStyle: TextStyle(fontSize: 18), // 增大文字字体
                ),
                child: Text('Send'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
