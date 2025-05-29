import 'dart:convert';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../fcm/snm_fcm_handler.dart';
import '../model/snm_notification_model.dart';

class SNMLocalNotificationService {
  static final SNMLocalNotificationService _i =
  SNMLocalNotificationService._internal();
  factory SNMLocalNotificationService() => _i;
  SNMLocalNotificationService._internal();

  final _plugin = FlutterLocalNotificationsPlugin();

  /// Android channel id used by all in-app banners.
  static const _channelId = 'verdant_chat';
  static const _channelName = 'Verdant Notifications';

  /* ───────────────────────── Init ─────────────────────────────── */

  Future<void> initialise() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    final settings = InitializationSettings(android: androidInit);

    await _plugin.initialize(
      settings,
      // When user taps **local** banner (foreground) – forward to router.
      onDidReceiveNotificationResponse: (resp) async {
        if (resp.payload == null) return;
        // parse back to model and let FCM handler drive navigation
        // → reuse one path regardless of local/system banner origin
        final data = jsonDecode(resp.payload!);
        await SNMFCMHandler.handleNotificationTapFromData(data);
      },
    );

    if (Platform.isAndroid) {
      const channel = AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: 'High-priority chat & call notifications',
        importance: Importance.high,
        playSound: true,
      );
      await _plugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  }

  /* ──────────────────────── Show banner ───────────────────────── */

  Future<void> showNotification({
    required SNMNotificationModel model,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );

    final details = NotificationDetails(android: androidDetails);

    await _plugin.show(
      // Use hashCode as temp id (fine for single-banner apps)
      model.hashCode,
      model.title,
      body,
      details,
      payload: jsonEncode(model.toJson()),
    );
  }
}
