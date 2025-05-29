import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../settings/edit_profile/edit_profile_screen.dart';

/// MeScreen represents the user's profile page where they can:
/// - View their profile information (username, email, avatar)
/// - Edit their profile
/// - Access settings
/// - Sign out
/// - Delete their account
class MeScreen extends StatefulWidget {
  @override
  _MeScreenState createState() => _MeScreenState();
}

class _MeScreenState extends State<MeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Authentication instance
  late Future<DocumentSnapshot> _userDataFuture; // Future to fetch user data from Firestore

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load user data when the screen is initialized
  }

  /// Loads user data from Firestore using the authenticated user's UID.
  void _loadUserData() {
    _userDataFuture = FirebaseFirestore.instance
        .collection('users') // Reference to the 'users' collection in Firestore
        .doc(_auth.currentUser?.uid) // Get the document corresponding to the current user
        .get(); // Retrieve the document data
  }

  /// Signs out the user and navigates back to the login screen.
  Future<void> _signOut(BuildContext context) async {
    await _auth.signOut(); // Sign out from Firebase
    Navigator.pushReplacementNamed(context, '/auth/login'); // Redirect to login screen
  }

  /// Deletes the user's account after showing a confirmation dialog.
  Future<void> _deleteAccount(BuildContext context) async {
    // Show a confirmation dialog before deleting the account
    final confirmation = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Account'),
        content: Text(
          'Are you sure you want to delete your account? This action is irreversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), // Cancel deletion
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true), // Confirm deletion
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    // If the user confirms, delete their account from Firestore and Firebase Authentication
    if (confirmation == true) {
      final uid = _auth.currentUser?.uid;
      if (uid != null) {
        await FirebaseFirestore.instance.collection('users').doc(uid).delete(); // Delete user data from Firestore
        await _auth.currentUser?.delete(); // Delete the Firebase Authentication account
        Navigator.pushReplacementNamed(context, '/auth/login'); // Redirect to login screen
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        automaticallyImplyLeading: false, // Removes the back button from the AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            /// FutureBuilder is used to fetch and display user data dynamically.
            FutureBuilder<DocumentSnapshot>(
              future: _userDataFuture,
              builder: (context, snapshot) {
                // Show a loading indicator while fetching data
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                // If data is retrieved successfully, display user details
                if (snapshot.hasData && snapshot.data != null) {
                  final userData = snapshot.data!.data() as Map<String, dynamic>;

                  return Column(
                    children: [
                      // Display user profile picture or default icon if no avatar is set
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: userData['avatar'] != null
                            ? NetworkImage(userData['avatar']) // Load avatar from network
                            : null,
                        child: userData['avatar'] == null
                            ? Icon(Icons.person, size: 50) // Default icon if no avatar
                            : null,
                      ),
                      SizedBox(height: 16),

                      // Display username (fallback to 'Username' if null)
                      Text(
                        userData['userName'] ?? 'Username',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),

                      // Display user email (fallback to 'No Email' if null)
                      Text(
                        userData['email'] ?? 'No Email',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  );
                }

                // Show an error message if user data cannot be loaded
                return Text('Unable to load user data');
              },
            ),

            SizedBox(height: 32),

            /// List of profile options for the user
            ListTile(
              leading: Icon(Icons.edit, color: Colors.blue), // Edit Profile icon
              title: Text('Edit Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfileScreen()), // Navigate to Edit Profile screen
                ).then((isUpdated) {
                  if (isUpdated == true) {
                    setState(() {
                      _loadUserData(); // Reload user data when returning from the edit screen
                    });
                  }
                });
              },
            ),

            ListTile(
              leading: Icon(Icons.settings, color: Colors.green), // Settings icon
              title: Text('Settings'),
              onTap: () {
                // Navigate to the settings screen (to be implemented)
              },
            ),

            ListTile(
              leading: Icon(Icons.logout, color: Colors.orange), // Sign out icon
              title: Text('Sign Out'),
              onTap: () => _signOut(context), // Call the sign-out function
            ),

            ListTile(
              leading: Icon(Icons.delete, color: Colors.red), // Delete account icon
              title: Text('Delete Account'),
              onTap: () => _deleteAccount(context), // Call the delete account function
            ),
          ],
        ),
      ),
    );
  }
}
