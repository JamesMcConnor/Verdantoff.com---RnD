import 'package:flutter/material.dart';
import '../../services/user_service.dart';

class UserSearchScreen extends StatefulWidget {
  @override
  _UserSearchScreenState createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final UserService _userService = UserService();
  bool _isSearchingByEmail = true; // 是否按邮箱搜索
  bool _isLoading = false;
  String? _errorMessage;
  List<Map<String, dynamic>> _searchResults = []; // 搜索结果

  /// 执行用户搜索
  Future<void> _searchUsers() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a valid search query.';
        return;
      });
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _searchResults = [];
    });

    try {
      if (_isSearchingByEmail) {
        // 按邮箱搜索
        final user = await _userService.searchByEmail(query);
        if (user != null) {
          setState(() {
            _searchResults = [user]; // 将单个用户结果放入列表
          });
        } else {
          setState(() {
            _errorMessage = 'No users found.';
          });
        }
      } else {
        // 按用户名搜索
        final users = await _userService.searchByUserName(query);
        if (users.isNotEmpty) {
          setState(() {
            _searchResults = users;
          });
        } else {
          setState(() {
            _errorMessage = 'No users found.';
          });
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Search failed: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 切换搜索方式
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isSearchingByEmail = true;
                    });
                  },
                  child: Text('Search by Email'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isSearchingByEmail ? Colors.green : Colors.grey,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isSearchingByEmail = false;
                    });
                  },
                  child: Text('Search by Username'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: !_isSearchingByEmail ? Colors.green : Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            // 搜索输入框
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: _isSearchingByEmail ? 'Enter Email' : 'Enter Username',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchUsers,
                ),
              ),
            ),
            SizedBox(height: 16),
            if (_isLoading)
              CircularProgressIndicator(),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            if (_searchResults.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final user = _searchResults[index];

                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: user['avatar'] != null
                              ? NetworkImage(user['avatar'])
                              : null,
                          child: user['avatar'] == null
                              ? Icon(Icons.person)
                              : null,
                        ),
                        title: Text(user['userName'] ?? 'Unknown User'),
                        subtitle: Text(user['email'] ?? 'No Email'),
                        trailing: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/send-friend-request',
                              arguments: user,
                            );
                          },
                          child: Text('Add Friend'),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
