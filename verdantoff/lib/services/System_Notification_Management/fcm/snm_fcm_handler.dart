import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../../../main.dart';
import '../manager/snm_notification_router.dart';

class SNMFCMHandler {
  // Handle notification tap behavior
  static void handleNotificationTap(RemoteMessage message) {
    if (message.data.isNotEmpty) {
      // Extract payload data
      Map<String, dynamic> payload = message.data;

      // Delegate navigation to the notification router
      if (navigatorKey.currentContext != null) {
        SNMNotificationRouter.handleNotificationTap(navigatorKey.currentContext!, payload);
      } else {
        print("Error: navigatorKey.currentContext is null.");
      }
    }
  }
}
