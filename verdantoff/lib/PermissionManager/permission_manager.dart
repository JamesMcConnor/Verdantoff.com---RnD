import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionManager {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  // Used to record whether the background initialization is successful
  bool _isBackgroundInitialized = false;

  /// Request notification permission using Firebase Messaging.
  Future<bool> requestNotificationPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    bool granted = settings.authorizationStatus == AuthorizationStatus.authorized;
    if (granted) {
      print("✅ Notification permission granted");
    } else {
      print("❌ Notification permission denied");
    }
    return granted;
  }

  /// Check if notification permission has been granted.
  Future<bool> checkNotificationPermission() async {
    NotificationSettings settings = await _firebaseMessaging.getNotificationSettings();
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  /// Request background execution permission for Android using flutter_background.
  Future<bool> requestBackgroundExecution() async {
    final androidConfig = FlutterBackgroundAndroidConfig(
      notificationTitle: "Background Service",
      notificationText: "App is running in background to receive messages.",
      notificationImportance: AndroidNotificationImportance.high,
      notificationIcon: AndroidResource(name: 'ic_launcher', defType: 'drawable'),
    );


    bool result = await FlutterBackground.initialize(androidConfig: androidConfig);
    _isBackgroundInitialized = result;  // Record initialization results
    if (result) {
      print("✅ Background execution permission granted");
    } else {
      print("❌ Background execution permission denied");
    }
    return result;
  }

  /// Check the background running status
  /// Here, the status recorded by _isBackgroundInitialized is returned, indicating whether the background initialization is successful.
  Future<bool> checkBackgroundExecution() async {
    return _isBackgroundInitialized;
  }

  /// Request location permission using permission_handler.
  Future<bool> requestLocationPermission() async {
    PermissionStatus status = await Permission.location.request();
    bool granted = status.isGranted;
    if (granted) {
      print("✅ Location permission granted");
    } else {
      print("❌ Location permission denied");
    }
    return granted;
  }

  /// Check if location permission is granted.
  Future<bool> checkLocationPermission() async {
    PermissionStatus status = await Permission.location.status;
    return status.isGranted;
  }

  /// Request all required permissions.
  Future<void> requestAllPermissions() async {
    await requestNotificationPermission();
    await requestBackgroundExecution();
    await requestLocationPermission();
  }

  /// Check if all required permissions have been granted.
  Future<bool> checkAllPermissions() async {
    bool notificationGranted = await checkNotificationPermission();
    bool backgroundGranted = await checkBackgroundExecution();
    bool locationGranted = await checkLocationPermission();
    return notificationGranted && backgroundGranted && locationGranted;
  }
}
