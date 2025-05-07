import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../../services/G2G_chat/G2G_members_service.dart';
import '../../../../../../services/G2G_chat/G2G_nickname_service.dart';
import '../../../../../../services/G2G_chat/G2G_roles_service.dart';


class AdminManageMembersVM extends ChangeNotifier {
  final String groupId;
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  final G2GNicknameService _nicknameService = G2GNicknameService();
  final G2GMembersService _membersService = G2GMembersService();
  final G2GRolesService _rolesService = G2GRolesService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Member> members = [];
  bool isLoading = true;

  AdminManageMembersVM(this.groupId) {
    fetchMembers();
  }

  Future<void> fetchMembers() async {
    isLoading = true;
    notifyListeners();

    final snapshot = await _firestore.collection('groups')
        .doc(groupId)
        .collection('members')
        .get();

    final List<Member> loadedMembers = [];

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final userId = doc.id;
      final nickname = data['nickname'] ?? '';
      final role = data['role'] ?? 'member';

      final userDoc = await _firestore.collection('users').doc(userId).get();
      final userData = userDoc.data() as Map<String, dynamic>?;

      final avatar = userData?['avatar'] ?? '';
      final username = userData?['userName'] ?? 'Unknown';

      loadedMembers.add(Member(
        userId: userId,
        nickname: nickname,
        username: username,
        avatar: avatar,
        role: role,
      ));
    }

    members = loadedMembers;
    isLoading = false;
    notifyListeners();
  }

  Future<void> refreshMembers() async {
    await fetchMembers();
  }
  void handleAction(BuildContext context, String action, String targetUserId, String oldNickname) {
    switch (action) {
      case 'nickname':
        _changeNickname(context, targetUserId, oldNickname);
        break;
      case 'demote':
        _demoteToMember(context, targetUserId);
        break;
      case 'remove':
        _removeMember(context, targetUserId);
        break;
    }
  }

  void _changeNickname(BuildContext context, String userId, String oldNickname) {
    final controller = TextEditingController(text: oldNickname);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Change Nickname'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: 'Enter new nickname'),
        ),
        actions: [
          TextButton(child: Text('Cancel'), onPressed: () => Navigator.pop(context)),
          TextButton(
            child: Text('Confirm'),
            onPressed: () async {
              if (controller.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Nickname cannot be empty')));
                return;
              }
              await _nicknameService.changeMemberNickname(groupId, userId, controller.text.trim(), currentUserId);
              Navigator.pop(context);
              refreshMembers();
            },
          ),
        ],
      ),
    );
  }


  void _demoteToMember(BuildContext context, String userId) async {
    await _rolesService.demoteToMember(groupId, userId, currentUserId);
    refreshMembers();
  }

  void _removeMember(BuildContext context, String userId) async {
    await _membersService.removeMemberFromGroup(groupId, userId, currentUserId);
    refreshMembers();
  }
}

class Member {
  final String userId;
  final String nickname;
  final String username;
  final String avatar;
  final String role;

  Member({
    required this.userId,
    required this.nickname,
    required this.username,
    required this.avatar,
    required this.role,
  });
}
