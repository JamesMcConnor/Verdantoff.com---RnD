import 'package:firebase_messaging/firebase_messaging.dart';

class SNMNotificationSettings {
  static final SNMNotificationSettings _instance = SNMNotificationSettings._internal();
  factory SNMNotificationSettings() => _instance;
  SNMNotificationSettings._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    NotificationSettings settings = await _firebaseMessaging.getNotificationSettings();
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  // Ask users to re-enable notifications
  void promptToEnableNotifications() {
    print("⚠️ Please enable notifications in your device settings.");
  }
}
