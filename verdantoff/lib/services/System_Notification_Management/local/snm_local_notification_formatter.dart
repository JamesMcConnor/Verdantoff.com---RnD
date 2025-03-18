class SNMLocalNotificationFormatter {
  // Format notification content based on message type
  static String formatNotificationContent(String messageType) {
    switch (messageType) {
      case 'text':
        return "sent a message";
      case 'image':
        return "sent an image";
      case 'audio':
        return "sent a voice message";
      case 'video':
        return "sent a video";
      case 'sticker':
        return "sent a sticker";
      case 'voice_call':
        return "is calling you (Voice Call)";
      case 'video_call':
        return "is calling you (Video Call)";
      default:
        return "sent a message";
    }
  }
}
