class GroupChatDisplayModel {
  final String groupId;
  final String groupName;
  final String lastMessageContent;
  final String lastMessageSenderName;
  final DateTime updatedAt;
  final int unreadCount;
  final bool isLastMessageRecalled;

  GroupChatDisplayModel({
    required this.groupId,
    required this.groupName,
    required this.lastMessageContent,
    required this.lastMessageSenderName,
    required this.updatedAt,
    required this.unreadCount,
    required this.isLastMessageRecalled,
  });

  /// generates an abbreviation from group name
  String get groupInitial {
    if (groupName.isEmpty) return 'G';
    return groupName.substring(0, 1).toUpperCase();
  }
}
