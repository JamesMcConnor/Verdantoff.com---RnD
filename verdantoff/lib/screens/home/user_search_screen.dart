import 'package:flutter/material.dart';
import '../../services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  void _searchUsers() async {
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
    });

    try {
      final user = _isSearchingByEmail
          ? await _userService.searchByEmail(query)
          : (await _userService.searchByUserName(query)).isNotEmpty
          ? (await _userService.searchByUserName(query)).first
          : null;

      if (user != null) {
        Navigator.pushNamed(
          context,
          '/user-detail',
          arguments: user,
        );
      } else {
        setState(() {
          _errorMessage = 'User not found.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Search failed. Please try again.';
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
            if (_searchController.text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    Icon(Icons.person_add, color: Colors.green),
                    SizedBox(width: 8),
                    Text(
                      'Search: "${_searchController.text}"',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 16),
            if (_isLoading) CircularProgressIndicator(),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
//