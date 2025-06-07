import 'package:flutter/material.dart';
import 'friends_tab.dart';
import 'Group_chat_tab/groups_tab.dart';

class FriendListScreen extends StatefulWidget {
  @override
  _FriendListScreenState createState() => _FriendListScreenState();
}

class _FriendListScreenState extends State<FriendListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: Colors.green,
            unselectedLabelColor: Colors.black,
            indicatorColor: Colors.green,
            tabs: const [
              Tab(text: 'Friends'),
              Tab(text: 'Groups'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                FriendsTab(),
                GroupsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
