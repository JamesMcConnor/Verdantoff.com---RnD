class GroupMemberModel {
  String userId;
  String nickname;
  DateTime joinedAt;
  String? invitedBy;
  String role;
  int unreadCount;

  GroupMemberModel({
    required this.userId,
    required this.nickname,
    required this.joinedAt,
    this.invitedBy,
    required this.role,
    required this.unreadCount,
  });

  factory GroupMemberModel.fromFirestore(String id, Map<String, dynamic> data) {
    return GroupMemberModel(
      userId: id,
      nickname: data['nickname'],
      joinedAt: data['joinedAt'].toDate(),
      invitedBy: data['invitedBy'],
      role: data['role'],
      unreadCount: data['unreadCount'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'nickname': nickname,
      'joinedAt': joinedAt,
      'invitedBy': invitedBy,
      'role': role,
      'unreadCount': unreadCount,
    };
  }
}
