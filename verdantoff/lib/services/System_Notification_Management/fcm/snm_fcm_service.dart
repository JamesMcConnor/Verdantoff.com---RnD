import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:verdantoff/services/System_Notification_Management/fcm/snm_fcm_handler.dart';

import '../local/snm_local_notification_service.dart';

class SNMFCMService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // Initialize FCM and handle token updates
  Future<void> initializeFCM() async {


    // Handle token refresh
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      print("🔄 FCM Token refreshed: $newToken");
      _updateTokenInFirestore(newToken);
    });

    // Fetch the latest token and store it
    await _getFCMToken();

    // Listen for foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📩 New foreground message received: ${message.messageId}");
      // Show local notification
      if (message.notification != null) {
        SNMLocalNotificationService().showNotification(
          title: message.notification!.title ?? "New Notification",
          body: message.notification!.body ?? "Tap to view",
          payload: message.data,
        );
      }
    });

    // Handle notification tap events
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("🔔 Notification tapped");
      SNMFCMHandler.handleNotificationTap(message);
    });

    // Handle notifications when app was closed
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        print("🔔 Notification received while app was closed");
        SNMFCMHandler.handleNotificationTap(message);
      }
    });
  }


  // Get the latest FCM token and store it in Firestore
  Future<void> _getFCMToken() async {
    String? token = await _firebaseMessaging.getToken();
    if (token != null) {
      print("📌 Current FCM Token: $token");
      await _updateTokenInFirestore(token);
    } else {
      print("❌ Failed to retrieve FCM token");
    }
  }

  // Update Firestore with the latest FCM token, ensuring correctness
  Future<void> _updateTokenInFirestore(String newToken) async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? "";
    if (userId.isEmpty) {
      print("❌ User ID is empty, cannot update FCM token");
      return;
    }

    DocumentReference userDoc =
    FirebaseFirestore.instance.collection('users').doc(userId);

    try {
      DocumentSnapshot docSnapshot = await userDoc.get();
      if (docSnapshot.exists) {
        Map<String, dynamic>? userData = docSnapshot.data() as Map<String, dynamic>?;
        if (userData != null && userData.containsKey('fcmToken')) {
          String? oldToken = userData['fcmToken'];
          if (oldToken != newToken) {
            await userDoc.update({'fcmToken': newToken});
            print("✅ Firestore FCM Token updated: $newToken");
          } else {
            print("ℹ️ FCM Token is already up to date.");
          }
        } else {
          await userDoc.set({'fcmToken': newToken}, SetOptions(merge: true));
          print("✅ Firestore FCM Token created: $newToken");
        }
      } else {
        await userDoc.set({'fcmToken': newToken});
        print("✅ New Firestore document created with FCM Token: $newToken");
      }
    } catch (e) {
      print("❌ Failed to update Firestore FCM Token: $e");
    }
  }
}
