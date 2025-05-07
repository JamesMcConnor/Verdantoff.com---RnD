import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// ViewModel for viewing members (Member role users)
class ViewMembersVM extends ChangeNotifier {
  final String groupId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Member> members = [];
  bool isLoading = true;

  ViewMembersVM(this.groupId) {
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

    // Sort by role: owner > admin > member
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
