import 'package:cloud_firestore/cloud_firestore.dart';
import 'group_last_message_model.dart';
import 'group_message_model.dart';

class GroupModel {
  String groupId;
  String groupCode;
  String name;
  String announcement;
  DateTime createdAt;
  String createdBy;
  DateTime updatedAt;
  String updatedBy;
  Map<String, String> roles;
  GroupLastMessageModel? lastMessage;

  GroupModel({
    required this.groupId,
    required this.groupCode,
    required this.name,
    required this.announcement,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
    required this.roles,
    this.lastMessage,
  });

  factory GroupModel.fromFirestore(String id, Map<String, dynamic> data) {
    final rawLastMessage = data['lastMessage'];
    return GroupModel(
      groupId: id,
      groupCode: data['groupCode'],
      name: data['name'],
      announcement: data['announcement'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      createdBy: data['createdBy'],
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      updatedBy: data['updatedBy'],
      roles: Map<String, String>.from(data['roles'] ?? {}),
      lastMessage: rawLastMessage is Map<String, dynamic>
          ? GroupLastMessageModel.fromMap(rawLastMessage)
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'groupCode': groupCode,
      'name': name,
      'announcement': announcement,
      'createdAt': createdAt,
      'createdBy': createdBy,
      'updatedAt': updatedAt,
      'updatedBy': updatedBy,
      'roles': roles,
      if (lastMessage != null) 'lastMessage': lastMessage!.toMap(),
    };
  }
}
