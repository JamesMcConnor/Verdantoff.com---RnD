import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/snm_notification_model.dart';
import '../fcm/snm_fcm_handler.dart';

/// A callback supplied by [SNMNotificationManager] telling this service
/// **how to surface** a message while the app is in foreground.
typedef ForegroundHandler = Future<void> Function(SNMNotificationModel n);

class SNMFCMService {
  /* ───────── singleton ───────── */
  static final SNMFCMService _i = SNMFCMService._internal();
  factory SNMFCMService() => _i;
  SNMFCMService._internal();

  final _fcm = FirebaseMessaging.instance;

  /* ──────────────────────────────────────────────────────────────────── */
  ///  Boot-strap:
  ///   • ask for permissions (Android 13+)
  ///   • upload / refresh the FCM token
  ///   • wire listeners (foreground + tap / cold-start)
  Future<void> initialiseFCM({required ForegroundHandler onForeground}) async {
    /* permissions */
    await _fcm.requestPermission(alert: true, sound: true, badge: true);

    /* token management */
    _fcm.onTokenRefresh.listen(_saveToken);
    final token = await _fcm.getToken();
    if (token != null) _saveToken(token);

    /* foreground messages */
    FirebaseMessaging.onMessage.listen((m) async {
      final n = SNMNotificationModel.fromRemote(m.data);
      await onForeground(n);
    });

    /* taps / cold-start */
    FirebaseMessaging.onMessageOpenedApp
        .listen(SNMFCMHandler.handleNotificationTap);

    final initial = await _fcm.getInitialMessage();
    if (initial != null) await SNMFCMHandler.handleNotificationTap(initial);
  }

  /* ───────── save token to Firestore ───────── */
  Future<void> _saveToken(String token) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set({'fcmToken': token}, SetOptions(merge: true));
  }
}
