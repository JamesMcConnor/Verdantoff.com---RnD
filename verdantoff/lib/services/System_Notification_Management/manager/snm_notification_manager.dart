import 'package:firebase_messaging/firebase_messaging.dart';
import '../fcm/snm_fcm_service.dart';
import '../local/snm_local_notification_service.dart';
import '../local/snm_local_notification_formatter.dart';

class SNMNotificationManager {
  static final SNMNotificationManager _instance = SNMNotificationManager._internal();
  factory SNMNotificationManager() => _instance;
  SNMNotificationManager._internal();

  final SNMFCMService _fcmService = SNMFCMService();
  final SNMLocalNotificationService _localNotificationService = SNMLocalNotificationService();

  // Initialize notification services
  Future<void> initialize() async {
    await _fcmService.initializeFCM();
    await _localNotificationService.initialize();
  }

  // Determine whether to use local or remote notifications
  Future<void> sendNotification({
    required String title,
    required String body,
    required String messageType,
    required Map<String, dynamic> payload,
  }) async {
    // Format message content
    String formattedBody = SNMLocalNotificationFormatter.formatNotificationContent(messageType);

    // If app is in foreground, show local notification
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message == null) {
        _localNotificationService.showNotification(
          title: title,
          body: formattedBody,
          payload: payload,
        );
      }
    });
  }

  // Request notification permissions
  Future<void> requestPermissions() async {
    await _fcmService.initializeFCM();
  }
}
