import 'package:flutter/material.dart';
import 'Show_User_Info_To_People_Services.dart';

class ShowUserInfoToPeopleScreen extends StatefulWidget {
  final String userId; // User ID to fetch info

  ShowUserInfoToPeopleScreen({required this.userId});

  @override
  _ShowUserInfoToPeopleScreenState createState() => _ShowUserInfoToPeopleScreenState();
}

class _ShowUserInfoToPeopleScreenState extends State<ShowUserInfoToPeopleScreen> {
  Map<String, dynamic>? _userInfo;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    try {
      final userInfo = await ShowUserInfoToPeopleServices.getUserInfo(widget.userId);
      if (mounted) {
        setState(() {
          _userInfo = userInfo;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Information'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _hasError
          ? Center(child: Text('Failed to load user information.'))
          : _buildUserInfo(),
    );
  }

  Widget _buildUserInfo() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: _userInfo?['avatar'] != null
                ? NetworkImage(_userInfo!['avatar'])
                : null,
            child: _userInfo?['avatar'] == null ? Icon(Icons.person, size: 50) : null,
          ),
          SizedBox(height: 10),
          Text(
            _userInfo?['fullName'] ?? 'Unknown Name',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text('@${_userInfo?['userName'] ?? 'Unknown'}', style: TextStyle(fontSize: 18, color: Colors.grey)),

          Divider(height: 30, thickness: 1),

          _infoRow('Email', _userInfo?['email']),
          _infoRow('Birthday', _userInfo?['birthday']),
          _infoRow('Country', _userInfo?['country']),
          _infoRow('Industry', _userInfo?['industry']),
          _infoRow('Role', _userInfo?['role']),
          _infoRow('Joined', _formatDate(_userInfo?['createdAt'])),

          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back),
            label: Text('Back'),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, dynamic value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Text(value != null ? value.toString() : 'N/A', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  String _formatDate(dynamic timestamp) {
    if (timestamp is String) return timestamp.split('T')[0];
    return 'Unknown';
  }
}
