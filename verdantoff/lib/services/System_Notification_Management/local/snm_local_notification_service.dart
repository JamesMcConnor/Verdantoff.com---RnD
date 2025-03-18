import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';

class SNMLocalNotificationService {
  static final SNMLocalNotificationService _instance = SNMLocalNotificationService._internal();
  factory SNMLocalNotificationService() => _instance;
  SNMLocalNotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Android Initialization
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // Initialize plugin
    final InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await _notificationsPlugin.initialize(settings);

    // Create notification channels for Android
    if (Platform.isAndroid) {
      _createNotificationChannel();
    }
  }

  // Create Android Notification Channels
  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'chat_notifications', // Channel ID
      'Chat Notifications', // Channel Name
      description: 'Notifications for new messages',
      importance: Importance.high,
      playSound: true,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  // Display local notification
  Future<void> showNotification({
    required String title,
    required String body,
    required Map<String, dynamic> payload,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'chat_notifications', // Channel ID
      'Chat Notifications',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails details = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      0, // Notification ID
      title,
      body,
      details,
      payload: payload.toString(),
    );
  }
}

