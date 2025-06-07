import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionManager {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // ──────────────────  Notification  ──────────────────
  Future<bool> requestNotificationPermission() async {
    bool androidGranted = true;

    if (Platform.isAndroid && (await Permission.notification.status).isDenied) {
      androidGranted = (await Permission.notification.request()).isGranted;
    }

    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    final fcmGranted =
        settings.authorizationStatus == AuthorizationStatus.authorized;

    final granted = androidGranted && fcmGranted;
    print(granted
        ? '✅ Notification permission granted'
        : '❌ Notification permission denied');
    return granted;
  }

  Future<bool> checkNotificationPermission() async {
    final androidGranted = !Platform.isAndroid ||
        (await Permission.notification.status).isGranted;
    final settings = await _firebaseMessaging.getNotificationSettings();
    final fcmGranted =
        settings.authorizationStatus == AuthorizationStatus.authorized;
    return androidGranted && fcmGranted;
  }

  // ────────────────  Background Execution (Android)  ─────────────────
  Future<bool> requestBackgroundExecution() async {
    if (!Platform.isAndroid) return true;

    if (await FlutterBackground.hasPermissions) {
      print('✅ Background permission already granted');
      return true;
    }

    const androidConfig = FlutterBackgroundAndroidConfig(
      notificationTitle: 'Background Service',
      notificationText: 'App is running in background to receive messages.',
      notificationImportance: AndroidNotificationImportance.high,
      notificationIcon: AndroidResource(
        name: 'ic_launcher',
        defType: 'drawable',
      ),
    );

    final ok = await FlutterBackground.initialize(androidConfig: androidConfig);
    print(ok
        ? '✅ Background permission granted'
        : '❌ Background permission denied');
    return ok;
  }

  Future<bool> checkBackgroundExecution() async {
    if (!Platform.isAndroid) return true;
    return FlutterBackground.hasPermissions;
  }


  Future<void> requestAllPermissions() async {
    await Future.wait([
      requestNotificationPermission(),
      requestBackgroundExecution(),
    ]);
  }

  Future<bool> checkAllPermissions() async {
    final results = await Future.wait<bool>([
      checkNotificationPermission(),
      checkBackgroundExecution(),
    ]);
    return results.every((granted) => granted);
  }
}
