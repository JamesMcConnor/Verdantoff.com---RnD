enum SNMNotificationType {
  chatMessage,
  friendRequest,
  voiceCall,
  videoCall,
  systemAlert,  // Future extension for system notifications
}

// Convert enum to string
String notificationTypeToString(SNMNotificationType type) {
  return type.toString().split('.').last;
}

// Convert string back to enum
SNMNotificationType stringToNotificationType(String type) {
  switch (type) {
    case 'chatMessage':
      return SNMNotificationType.chatMessage;
    case 'friendRequest':
      return SNMNotificationType.friendRequest;
    case 'voiceCall':
      return SNMNotificationType.voiceCall;
    case 'videoCall':
      return SNMNotificationType.videoCall;
    case 'systemAlert':
      return SNMNotificationType.systemAlert;
    default:
      throw Exception("Unknown notification type: $type");
  }
}
