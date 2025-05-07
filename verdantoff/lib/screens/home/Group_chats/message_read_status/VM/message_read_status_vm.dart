import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageReadStatusViewModel extends ChangeNotifier {
  final String groupId;
  final String messageId;

  List<GroupMember> readMembers = [];
  bool isLoading = true;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  MessageReadStatusViewModel(this.groupId, this.messageId) {
    fetchReadMembers();
  }

  Future<void> fetchReadMembers() async {
    isLoading = true;
    notifyListeners();

    // Step 1: Fetch the message document
    final messageDoc = await _firestore
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .doc(messageId)
        .get();

    final List<dynamic> readByIds = messageDoc.data()?['readBy'] ?? [];

    // Step 2: Fetch member nicknames and avatars
    final List<GroupMember> members = [];

    for (String userId in readByIds) {
      final memberDoc = await _firestore
          .collection('groups')
          .doc(groupId)
          .collection('members')
          .doc(userId)
          .get();

      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (memberDoc.exists && userDoc.exists) {
        members.add(GroupMember(
          userId: userId,
          nickname: memberDoc.data()?['nickname'] ?? userDoc.data()?['fullName'] ?? 'Unknown',
          avatarUrl: userDoc.data()?['avatar'] ?? '',
        ));
      }
    }

    readMembers = members;
    isLoading = false;
    notifyListeners();
  }
}

class GroupMember {
  final String userId;
  final String nickname;
  final String avatarUrl;

  GroupMember({
    required this.userId,
    required this.nickname,
    required this.avatarUrl,
  });
}
