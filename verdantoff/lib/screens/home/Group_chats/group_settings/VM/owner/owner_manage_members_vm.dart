import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../../services/G2G_chat/G2G_members_service.dart';
import '../../../../../../services/G2G_chat/G2G_nickname_service.dart';
import '../../../../../../services/G2G_chat/G2G_roles_service.dart';

class OwnerManageMembersVM extends ChangeNotifier {
  final String groupId;
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  final G2GNicknameService _nicknameService = G2GNicknameService();
  final G2GMembersService _membersService = G2GMembersService();
  final G2GRolesService _rolesService = G2GRolesService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Member> members = [];
  bool isLoading = true;

  OwnerManageMembersVM(this.groupId) {
    fetchMembers();
  }

  /// Fetches all group members and sorts them: Owner first, then Admins, then Members
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

      // Fetch user's basic info from users collection
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

    // Sort members: owner > admin > member
    loadedMembers.sort((a, b) {
      int rank(String role) {
        if (role == 'owner') return 0;
        if (role == 'admin') return 1;
        return 2;
      }
      return rank(a.role).compareTo(rank(b.role));
    });

    members = loadedMembers;
    isLoading = false;
    notifyListeners();
  }

  /// Refreshes the member list manually
  Future<void> refreshMembers() async {
    await fetchMembers();
  }

  /// Handles user action triggered from the UI
  void handleAction(BuildContext context, String action, String targetUserId) {
    if (targetUserId == currentUserId && (action == 'promote' || action == 'demote' || action == 'remove')) {
      // Prevent owner from promoting/demoting/removing themselves
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You cannot perform this action on yourself.")),
      );
      return;
    }

    switch (action) {
      case 'nickname':
        _changeNickname(context, targetUserId);
        break;
      case 'promote':
        _promoteToAdmin(context, targetUserId);
        break;
      case 'demote':
        _demoteToMember(context, targetUserId);
        break;
      case 'transfer':
        _transferOwnership(context, targetUserId);
        break;
      case 'remove':
        _removeMember(context, targetUserId);
        break;
    }
  }

  /// Changes a member's nickname
  void _changeNickname(BuildContext context, String userId) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Change Nickname'),
        content: TextField(controller: controller),
        actions: [
          TextButton(child: Text('Cancel'), onPressed: () => Navigator.pop(context)),
          TextButton(
            child: Text('Confirm'),
            onPressed: () async {
              await _nicknameService.changeMemberNickname(groupId, userId, controller.text, currentUserId);
              Navigator.pop(context);
              refreshMembers();
            },
          ),
        ],
      ),
    );
  }

  /// Promotes a member to Admin
  void _promoteToAdmin(BuildContext context, String userId) async {
    final member = members.firstWhere((m) => m.userId == userId);
    if (member.role == 'admin') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("This member is already an Admin.")),
      );
      return;
    }
    await _rolesService.promoteToAdmin(groupId, userId, currentUserId);
    refreshMembers();
  }

  /// Demotes an Admin back to Member
  void _demoteToMember(BuildContext context, String userId) async {
    final member = members.firstWhere((m) => m.userId == userId);
    if (member.role == 'member') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("This member is already a Member.")),
      );
      return;
    }
    await _rolesService.demoteToMember(groupId, userId, currentUserId);
    refreshMembers();
  }

  /// Transfers group ownership to another user
  void _transferOwnership(BuildContext context, String newOwnerId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Confirm Transfer'),
        content: Text('Transfer ownership to this member? You will become an Admin.'),
        actions: [
          TextButton(child: Text('Cancel'), onPressed: () => Navigator.pop(context)),
          TextButton(
            child: Text('Transfer'),
            onPressed: () async {
              await _rolesService.transferOwnership(groupId, currentUserId, newOwnerId);
              Navigator.pop(context);
              Navigator.pop(context); // Go back twice to refresh settings
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  /// Removes a member from the group
  void _removeMember(BuildContext context, String userId) async {
    await _membersService.removeMemberFromGroup(groupId, userId, currentUserId);
    refreshMembers();
  }
}

/// Member model representing each group member
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
