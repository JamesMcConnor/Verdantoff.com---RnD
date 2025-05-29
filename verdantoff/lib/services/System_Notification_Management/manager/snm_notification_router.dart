import 'package:flutter/material.dart';
import '../model/snm_notification_model.dart';

class SNMNotificationRouter {
  /// Call **once** from FCM on-tap and on-message-opened-app.
  static Future<void> handleNotificationTap(
      BuildContext context, SNMNotificationModel n) async {
    switch (n.type) {
    /* ----------------- CHAT ----------------------------------------- */
      case 'chat_message':
        if (n.data['chatId'] != null) {
          Navigator.pushNamed(
            context,
            '/person_chats_screen',
            arguments: {
              'chatId'    : n.data['chatId'],
              'friendName': n.data['senderName'] ?? 'Friend',
              'friendId'  : n.data['senderId'],
            },
          );
        }
        break;

    /* ----------------- FRIEND REQUEST ------------------------------- */
      case 'friend_request':
        Navigator.pushNamed(context, '/friends_tab');
        break;

    /* ----------------- INCOMING CALL -------------------------------- */
    // unified entry point for *any* call payload (voice / video / screen)
      case 'incoming_call':
      case 'voice_call':   // legacy alias
      case 'video_call':
        if (n.callId != null) {
          Navigator.pushNamed(
            context,
            '/call/incoming',
            arguments: {
              'callId'  : n.callId,
              'callType': n.callType,
              'hostId'  : n.hostId,
            },
          );
        }
        break;

    /* ----------------- DEFAULT / UNKNOWN --------------------------- */
      default:
      // Optionally show a toast or log
        debugPrint('⚠️ Unknown notification type: ${n.type}');
    }
  }
}
