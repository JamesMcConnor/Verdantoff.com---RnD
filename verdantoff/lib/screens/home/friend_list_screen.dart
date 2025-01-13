import 'package:flutter/material.dart';

class FriendListScreen extends StatefulWidget {
  @override
  _FriendListScreenState createState() => _FriendListScreenState();
}

class _FriendListScreenState extends State<FriendListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  final Map<String, List<String>> _friendsGrouped = {
    'A': ['Alice', 'Aaron'],
    'B': ['Bob', 'Brian'],
    'C': ['Charlie', 'Cathy'],
    // 添加更多分组数据...
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // 滚动到对应字母分组
  void _scrollToLetter(String letter) {
    final index = _friendsGrouped.keys.toList().indexOf(letter);
    if (index >= 0) {
      final offset = index * 50.0; // 每组的高度（可以调整）
      _scrollController.animateTo(
        offset,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // TabBar 区域
          TabBar(
            controller: _tabController,
            labelColor: Colors.green,
            unselectedLabelColor: Colors.black,
            indicatorColor: Colors.green,
            tabs: const [
              Tab(text: 'Friends'),
              Tab(text: 'Groups'),
              Tab(text: 'Tags'),
            ],
          ),

          // TabBarView 内容
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildFriendsList(),
                _buildGroupsList(),
                _buildChatsList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 构建好友列表
  Widget _buildFriendsList() {
    return Stack(
      children: [
        ListView.builder(
          controller: _scrollController,
          itemCount: _friendsGrouped.keys.length + 3, // 加 3 是为了顶部按钮
          itemBuilder: (context, index) {
            if (index == 0) {
              return _buildTopButton(
                icon: Icons.person_add,
                text: 'New Friends',
                onTap: () {
                  Navigator.pushNamed(context, '/user-search');
                },
              );
            } else if (index == 1) {
              return _buildTopButton(
                icon: Icons.group_add,
                text: 'New Group',
                onTap: () {
                  // 跳转到新分组页面（未来实现）
                },
              );
            } else if (index == 2) {
              return _buildTopButton(
                icon: Icons.settings,
                text: 'Custom Server',
                onTap: () {
                  // 跳转到自定义服务页面（未来实现）
                },
              );
            } else {
              // 渲染好友列表
              final letter = _friendsGrouped.keys.elementAt(index - 3);
              final friends = _friendsGrouped[letter]!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    color: Colors.grey[200],
                    child: Text(
                      letter,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ...friends.map((friend) => ListTile(
                    title: Text(friend),
                    leading: CircleAvatar(child: Text(friend[0])),
                    onTap: () {
                      // 点击好友后的操作
                    },
                  )),
                ],
              );
            }
          },
        ),

        // 右侧字母列表
        Positioned(
          right: 0,
          top: 10,
          bottom: 10,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _friendsGrouped.keys.map((letter) {
              return GestureDetector(
                onTap: () => _scrollToLetter(letter),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    letter,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // 顶部按钮生成方法
  Widget _buildTopButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(
        text,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      onTap: onTap,
    );
  }

  // 构建分组列表
  Widget _buildGroupsList() {
    final List<Map<String, dynamic>> groups = [
      {'groupName': 'Family', 'members': ['Alice', 'Bob']},
      {'groupName': 'Work', 'members': ['Charlie', 'David']},
    ];

    return ListView.builder(
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups[index];
        return ListTile(
          title: Text(group['groupName']),
          subtitle: Text('Members: ${(group['members'] as List<String>).join(', ')}'),
          leading: Icon(Icons.group),
          onTap: () {
            // 点击分组后的操作
          },
        );
      },
    );
  }

  // 构建群聊列表
  Widget _buildChatsList() {
    final chats = [
      {'chatType': 'Created', 'name': 'My Chat Room'},
      {'chatType': 'Managed', 'name': 'Admin Group'},
      {'chatType': 'Joined', 'name': 'Community Chat'},
    ];

    return ListView.builder(
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final chat = chats[index];
        return ListTile(
          title: Text(chat['name']!),
          subtitle: Text('Type: ${chat['chatType']}'),
          leading: Icon(Icons.chat),
          onTap: () {
            // 点击群聊后的操作
          },
        );
      },
    );
  }
}
