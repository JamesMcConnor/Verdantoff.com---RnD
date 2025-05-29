import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';                       // navigatorKey
import '../model/snm_notification_model.dart';
import '../manager/snm_notification_router.dart';

/// Central entry-point for **every** FCM click / local-banner click.
class SNMFCMHandler {
  /* ───────────── handles system-banner & cold-start taps ────────────── */
  static Future<void> handleNotificationTap(RemoteMessage m) async {
    if (m.data.isEmpty) return;

    final notif = SNMNotificationModel.fromRemote(m.data);

    void _route() {
      final ctx = navigatorKey.currentContext;
      if (ctx != null) {
        SNMNotificationRouter.handleNotificationTap(ctx, notif);
      } else {
        debugPrint('[FCM] Navigator not ready – dropping tap for ${notif.id}');
      }
    }

    if (navigatorKey.currentContext == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _route());
    } else {
      _route();
    }
  }

  /* ───────────── handles taps on **local** in-app banners ───────────── */
  static Future<void> handleNotificationTapFromData(
      Map<String, dynamic> d,
      ) async {
    final fake = RemoteMessage(data: d);
    await handleNotificationTap(fake);
  }
}
