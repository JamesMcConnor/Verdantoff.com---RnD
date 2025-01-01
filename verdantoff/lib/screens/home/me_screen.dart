import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MeScreen extends StatefulWidget {
  @override
  _MeScreenState createState() => _MeScreenState();
}

class _MeScreenState extends State<MeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _signOut(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, '/auth/login');
  }

  Future<void> _deleteAccount(BuildContext context) async {
    final confirmation = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Account'),
        content: Text('Are you sure you want to delete your account? This action is irreversible.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmation == true) {
      try {
        final uid = _auth.currentUser?.uid;
        if (uid != null) {
          // 删除 Firestore 中的用户数据
          await _firestore.collection('users').doc(uid).delete();
        }
        // 删除 Firebase Auth 用户
        await _auth.currentUser?.delete();
        // 返回登录页面
        Navigator.pushReplacementNamed(context, '/auth/login');
      } catch (e) {
        print('Error deleting account: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete account. Please try again.')),
        );
      }
    }
  }

  Future<void> _changeUserName(BuildContext context) async {
    final TextEditingController _usernameController = TextEditingController();

    final newName = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Change Username'),
        content: TextField(
          controller: _usernameController,
          decoration: InputDecoration(labelText: 'Enter new username'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, _usernameController.text.trim()),
            child: Text('Save'),
          ),
        ],
      ),
    );

    if (newName != null && newName.isNotEmpty) {
      try {
        final uid = _auth.currentUser?.uid;
        if (uid != null) {
          await _firestore.collection('users').doc(uid).update({'userName': newName});
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Username updated successfully!')),
          );
          setState(() {}); // 更新页面显示
        }
      } catch (e) {
        print('Error updating username: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update username. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40), // 距离顶部的间距
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.green,
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: FutureBuilder<DocumentSnapshot>(
                future: _firestore.collection('users').doc(_auth.currentUser?.uid).get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasData && snapshot.data != null) {
                    final userName = snapshot.data!['userName'] ?? 'User';
                    return Text(
                      'Welcome, $userName',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    );
                  }
                  return Text(
                    'Welcome, User',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  );
                },
              ),
            ),
            SizedBox(height: 32),
            ListTile(
              leading: Icon(Icons.edit, color: Colors.blue),
              title: Text('Edit Username'),
              onTap: () => _changeUserName(context), // 修改用户名
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('Delete Account'),
              onTap: () => _deleteAccount(context), // 删除账户
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text('Sign Out'),
              onTap: () => _signOut(context), // 注销
            ),
          ],
        ),
      ),
    );
  }
}
