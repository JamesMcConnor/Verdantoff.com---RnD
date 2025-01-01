// A placeholder page showing missed calls and unread messages.
import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Text(
          'No new notifications',
          style: TextStyle(fontSize: 16.0, color: Colors.grey),
        ),
      ),
    );
  }
}
