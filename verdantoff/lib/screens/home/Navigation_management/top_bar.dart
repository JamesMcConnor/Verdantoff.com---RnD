import 'package:flutter/material.dart';

/// **TopBar Widget**
/// A reusable app bar that displays a title and a notification button.
///
/// Features:
/// - Displays a title at the left side.
/// - Shows a **notification bell** icon on the right.
/// - Executes a callback function when the bell icon is tapped.
class TopBar extends StatelessWidget {
  final String title; // The title text displayed on the app bar
  final VoidCallback onNotificationTap; // Callback function when notification icon is tapped

  const TopBar({
    required this.title,
    required this.onNotificationTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: Colors.green, // Background color of the app bar
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distributes title and button at both ends
        children: [
          // App Bar Title
          Text(
            title,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.black, // Title text color
            ),
          ),

          // Notification Bell Icon
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white), // Bell icon with white color
            onPressed: onNotificationTap, // Executes callback when tapped
          ),
        ],
      ),
    );
  }
}
