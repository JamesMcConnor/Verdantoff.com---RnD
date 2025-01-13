import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../settings/edit_profile_screen.dart';

class MeScreen extends StatefulWidget {
  @override
  _MeScreenState createState() => _MeScreenState();
}

class _MeScreenState extends State<MeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Future<DocumentSnapshot> _userDataFuture;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    _userDataFuture = FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser?.uid)
        .get();
  }

  Future<void> _signOut(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, '/auth/login');
  }

  Future<void> _deleteAccount(BuildContext context) async {
    final confirmation = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Account'),
        content: Text(
          'Are you sure you want to delete your account? This action is irreversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmation == true) {
      final uid = _auth.currentUser?.uid;
      if (uid != null) {
        await FirebaseFirestore.instance.collection('users').doc(uid).delete();
        await _auth.currentUser?.delete();
        Navigator.pushReplacementNamed(context, '/auth/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            FutureBuilder<DocumentSnapshot>(
              future: _userDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasData && snapshot.data != null) {
                  final userData = snapshot.data!.data() as Map<String, dynamic>;
                  return Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: userData['avatar'] != null
                            ? NetworkImage(userData['avatar'])
                            : null,
                        child: userData['avatar'] == null
                            ? Icon(Icons.person, size: 50)
                            : null,
                      ),
                      SizedBox(height: 16),
                      Text(
                        userData['userName'] ?? 'Username',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        userData['email'] ?? 'No Email',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  );
                }
                return Text('Unable to load user data');
              },
            ),
            SizedBox(height: 32),
            ListTile(
              leading: Icon(Icons.edit, color: Colors.blue),
              title: Text('Edit Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfileScreen()),
                ).then((isUpdated) {
                  if (isUpdated == true) {
                    setState(() {
                      _loadUserData(); // 刷新数据
                    });
                  }
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.green),
              title: Text('Settings'),
              onTap: () {
                // 设置页面逻辑
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.orange),
              title: Text('Sign Out'),
              onTap: () => _signOut(context),
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('Delete Account'),
              onTap: () => _deleteAccount(context),
            ),
          ],
        ),
      ),
    );
  }
}
