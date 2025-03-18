import 'package:flutter/material.dart';

class SNMNotificationRouter {
  // Handle navigation when a notification is tapped
  static void handleNotificationTap(BuildContext context, Map<String, dynamic> payload) {
    if (payload.containsKey('type')) {
      String notificationType = payload['type'];

      switch (notificationType) {
        case 'chat_message':
          _navigateToChatScreen(context, payload['chatId']);
          break;
        case 'friend_request':
          _navigateToFriendRequests(context);
          break;
        case 'voice_call':
          _navigateToVoiceCall(context, payload);
          break;
        case 'video_call':
          _navigateToVideoCall(context, payload);
          break;
        default:
          print("⚠️ Unknown notification type: $notificationType");
      }
    }
  }

  // Navigate to chat screen
  static void _navigateToChatScreen(BuildContext context, String? chatId) {
    if (chatId != null) {
      Navigator.pushNamed(context, '/person_chats_screen', arguments: chatId);
    }
  }

  // Navigate to friend request screen
  static void _navigateToFriendRequests(BuildContext context) {
    Navigator.pushNamed(context, '/friends_tab');
  }

  // Navigate to voice call screen
  static void _navigateToVoiceCall(BuildContext context, Map<String, dynamic> data) {
    Navigator.pushNamed(context, '/voice_call_screen', arguments: data);
  }

  // Navigate to video call screen
  static void _navigateToVideoCall(BuildContext context, Map<String, dynamic> data) {
    Navigator.pushNamed(context, '/video_call_screen', arguments: data);
  }
}
