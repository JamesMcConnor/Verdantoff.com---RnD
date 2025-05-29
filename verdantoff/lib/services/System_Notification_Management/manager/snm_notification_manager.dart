import '../fcm/snm_fcm_service.dart';
import '../model/snm_notification_model.dart';
import '../local/snm_local_notification_service.dart';
import '../local/snm_local_notification_formatter.dart';

/// High-level façade that wires everything together.
///
/// * Initialised once from **main.dart**
/// * Shows an **in-app** banner when a push arrives while the app is
///   foregrounded (Android system banners only appear in background).
class SNMNotificationManager {
  static final SNMNotificationManager _i = SNMNotificationManager._internal();
  factory SNMNotificationManager() => _i;
  SNMNotificationManager._internal();

  /// Call **once** from `main.dart`.
  Future<void> initialise() async {
    await SNMLocalNotificationService().initialise();
    await SNMFCMService().initialiseFCM(onForeground: _handleForeground);
  }

  /* ───────────── foreground helper ───────────── */

  Future<void> _handleForeground(SNMNotificationModel n) async {
    final body = SNMLocalNotificationFormatter.format(n);
    await SNMLocalNotificationService()
        .showNotification(model: n, body: body);
  }
}
