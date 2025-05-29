import '../model/snm_notification_model.dart';

/// Turns any [SNMNotificationModel] into a short text body suitable for
/// heads-up notifications.
class SNMLocalNotificationFormatter {
  /// **Preferred single entry-point** used by the manager.
  static String format(SNMNotificationModel n) =>
      _formatNotificationContent(n);

  /* ────────────────────────────────────────────────────────────────────── */

  static String _formatNotificationContent(SNMNotificationModel n) {
    switch (n.type) {
    /* chat ------------------------------------------------------------ */
      case 'chat_message':
      case 'text':
        return 'sent a message';
      case 'image':
        return 'sent an image';
      case 'audio':
        return 'sent a voice message';
      case 'video':
        return 'sent a video';
      case 'sticker':
        return 'sent a sticker';

    /* calls ----------------------------------------------------------- */
      case 'incoming_call':
      case 'voice_call':
      case 'video_call':
        switch (n.callType) {
          case 'voice':
            return 'is calling you (Voice)';
          case 'video':
            return 'is calling you (Video)';
          case 'screen':
            return 'wants to share screen';
          default:
            return 'is calling you';
        }

    /* fallback -------------------------------------------------------- */
      default:
        return 'sent a message';
    }
  }
  /// Deprecated alias kept so older calls won’t crash.
  @Deprecated('Use SNMLocalNotificationFormatter.format instead')
  static String formatNotificationContent(SNMNotificationModel n) => format(n);
}
