import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import '../Chat_list_screen/chat_list_screen.dart';
import '../Contacts/friend_list_screen.dart';
import '../Calendar/discover_screen.dart';
import '../Me_screen/me_screen.dart';
import 'top_bar.dart';

/// HomeScreen is the main landing page of the app after login.
/// It contains a bottom navigation bar that allows users to switch
/// between different sections: Chats, Contacts, Calendar, and Profile.
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Authentication instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance

  int _currentIndex = 0; // Tracks the currently selected tab index
  String? userName; // Stores the logged-in user's name

  /// List of pages corresponding to the bottom navigation bar items.
  final List<Widget> _pages = [
    ChatListScreen(), // Chat list screen
    FriendListScreen(), // Contact list screen
    DiscoverScreen(), // Calendar or discovery section
    MeScreen(), // User profile section
  ];

  @override
  void initState() {
    super.initState();
    _fetchUserName(); // Fetch user data on screen initialization
  }

  /// Fetches the user's `userName` from Firestore.
  Future<void> _fetchUserName() async {
    final user = _auth.currentUser; // Get the currently logged-in user
    if (user == null) return; // If no user is logged in, return

    try {
      // Retrieve the user's document from Firestore
      DocumentSnapshot userDoc =
      await _firestore.collection('users').doc(user.uid).get();

      // Convert document data to a Map
      final userData = userDoc.data() as Map<String, dynamic>?;

      // Update the userName state
      setState(() {
        userName = userData?['userName'] ?? 'User'; // Default to 'User' if null
      });
    } catch (e) {
      print('[ERROR] Failed to fetch user name: $e');
      setState(() {
        userName = 'Unknown User'; // Default in case of an error
      });
    }
  }

  /// Handles the back button press to minimize the app instead of exiting.
  /// On Android, this ensures the app runs in the background instead of closing.
  Future<bool> _handleBackPressed() async {
    try {
      await SystemNavigator.pop(); // Minimize the app
      return false; // Prevent default back behavior
    } catch (e) {
      print('[ERROR] Failed to minimize app: $e');
      return true; // Allow default behavior if minimization fails
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges(), // Listen for authentication state changes
      builder: (context, snapshot) {
        // Show a loading indicator while checking authentication state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // If user is not logged in, redirect to the login screen
        if (!snapshot.hasData || snapshot.data == null) {
          Future.microtask(() {
            Navigator.pushReplacementNamed(context, '/auth/login');
          });
          return const Scaffold(); // Return an empty Scaffold to prevent UI issues
        }

        return WillPopScope(
          onWillPop: _handleBackPressed, // Override back button behavior
          child: Scaffold(
            body: Column(
              children: [
                // Top navigation bar with dynamic title based on the selected tab
                TopBar(
                  title: _currentIndex == 0
                      ? 'Chats'
                      : _currentIndex == 1
                      ? 'Contacts'
                      : _currentIndex == 2
                      ? 'Calendar'
                      : 'Me',
                  onNotificationTap: () {
                    // Navigate to the notifications screen
                    Navigator.pushNamed(context, '/notifications');
                  },
                ),

                // Display the selected page from the `_pages` list
                Expanded(child: _pages[_currentIndex]),
              ],
            ),

            // Bottom navigation bar for tab navigation
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentIndex, // Highlight the selected tab
              onTap: (index) {
                setState(() {
                  _currentIndex = index; // Update selected tab
                });
              },
              selectedItemColor: Colors.green, // Color for selected tab
              unselectedItemColor: Colors.black, // Color for unselected tabs
              type: BottomNavigationBarType.fixed, // Keep labels visible

              /// Defines the bottom navigation bar items
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
                  label: 'Calendar',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Me',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
