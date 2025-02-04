import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/Navigation_management/home_screen.dart';
import '../screens/auth/forgot_password.dart';
import '../screens/home/Notification_screen/notifications_screen.dart';
import '../screens/home/Contacts/user_search_screen.dart';
import '../screens/home/person_chats_screen/person_chats_screen.dart';
import '../screens/user/send_friend_request_screen.dart';
import '../screens/user/user_detail_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Static Routes
final Map<String, WidgetBuilder> staticRoutes = {
  '/auth/login': (context) => LoginScreen(),
  '/auth/register': (context) => RegisterScreen(),
  '/auth/forgot-password': (context) => ForgotPasswordScreen(),
  '/notifications': (context) => NotificationScreen(),
  '/user-search': (context) => UserSearchScreen(),
};

// Get the `userName` of the currently logged in user
Future<String?> _getUserName() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return null;

  try {
    DocumentSnapshot userDoc =
    await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    return userDoc['userName'] as String?;
  } catch (e) {
    print('[ERROR] Failed to fetch user name: $e');
    return null;
  }
}

// Dynamic Routes
Route<dynamic>? generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/home':
      return MaterialPageRoute(
        builder: (context) => FutureBuilder<String?>(
          future: _getUserName(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.hasError || snapshot.data == null) {
              return LoginScreen(); // If getting userName fails, return to the login page
            }
            return HomeScreen(); // Return HomeScreen directly (no longer passing userName)
          },
        ),
      );

    case '/user-detail':
      if (settings.arguments is Map<String, dynamic>) {
        final user = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => UserDetailScreen(user: user),
        );
      }
      return _errorRoute('Invalid arguments for /user-detail');

    case '/send-friend-request':
      if (settings.arguments is Map<String, dynamic>) {
        final user = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => SendFriendRequestScreen(user: user),
        );
      }
      return _errorRoute('Invalid arguments for /send-friend-request');

    case '/person_chats_screen':
      if (settings.arguments is Map<String, dynamic>) {
        final chatArgs = settings.arguments as Map<String, dynamic>;
        if (chatArgs.containsKey('chatId') &&
            chatArgs.containsKey('friendName') &&
            chatArgs.containsKey('friendId')) {
          return MaterialPageRoute(
            builder: (context) => PersonChatsScreen(
              chatId: chatArgs['chatId'] as String,
              friendName: chatArgs['friendName'] as String,
              friendId: chatArgs['friendId'] as String,
            ),
          );
        }
      }
      return _errorRoute('Invalid arguments for /person_chats_screen');

    default:
      return _errorRoute('Route not defined: ${settings.name}');
  }
}

/// Default Error Route
Route<dynamic> _errorRoute(String message) {
  return MaterialPageRoute(
    builder: (context) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(child: Text(message)),
    ),
  );
}
