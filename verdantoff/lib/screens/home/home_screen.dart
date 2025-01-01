import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore 用于获取用户名
import 'chat_screen.dart'; // Chats 页面
import 'friend_list_screen.dart'; // Contacts 页面
import 'discover_screen.dart'; // Discover 页面
import 'me_screen.dart'; // Me 页面
import 'top_bar.dart'; // 引入顶部栏组件
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  final String? userName; // 接收用户名
  const HomeScreen({this.userName}); // 构造函数

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int _currentIndex = 0; // 当前页面索引
  String? userName;

  final List<Widget> _pages = [
    ChatScreen(), // Chats 页面
    FriendListScreen(), // Contacts 页面
    DiscoverScreen(), // Discover 页面
    MeScreen(), // Me 页面
  ];

  @override
  void initState() {
    super.initState();
    userName = widget.userName; // 从构造函数接收
    if (userName == null) {
      _fetchUserName(); // 如果为 null，从 Firestore 获取
    }
    _showWelcomeMessage(); // 显示欢迎消息
  }

  Future<void> _fetchUserName() async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid != null) {
        DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(uid).get();
        setState(() {
          userName = userDoc['userName'] ?? 'User';
        });
      }
    } catch (e) {
      print('Failed to fetch user name: $e');
      setState(() {
        userName = 'Unknown User';
      });
    }
  }

  void _showWelcomeMessage() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (userName != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Welcome, $userName!'),
            duration: const Duration(seconds: 3), // 显示时间为 3 秒
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 使用 TopBar 组件，显示用户名
          TopBar(
            title: _currentIndex == 0
                ? 'Chats'
                : _currentIndex == 1
                ? 'Contacts'
                : _currentIndex == 2
                ? 'Discover'
                : 'Welcome, $userName',
            onNotificationTap: () {
              Navigator.pushNamed(context, '/notifications'); // 跳转到通知页面
            },
          ),
          Expanded(child: _pages[_currentIndex]), // 显示当前页面
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // 切换页面
          });
        },
        selectedItemColor: Colors.green, // 选中项字体颜色
        unselectedItemColor: Colors.black, // 未选中项字体颜色
        type: BottomNavigationBarType.fixed, // 确保文字始终显示
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: 'Contacts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Me',
          ),
        ],
      ),
    );
  }
}
