import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../../../services/G2G_chat/G2G_members_service.dart';

class GroupJoinRequestsManageVM extends ChangeNotifier {
  final String groupId;
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  final G2GMembersService _membersService = G2GMembersService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<JoinRequest> requests = [];
  bool isLoading = true;

  GroupJoinRequestsManageVM(this.groupId) {
    fetchJoinRequests();
  }

  /// Fetches the pending join requests from Firestore
  Future<void> fetchJoinRequests() async {
    isLoading = true;
    notifyListeners();

    final snapshot = await _firestore
        .collection('groups')
        .doc(groupId)
        .collection('joinRequests')
        .where('status', isEqualTo: 'pending')
        .orderBy('requestedAt', descending: false)
        .get();

    final List<JoinRequest> loadedRequests = [];

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final userId = data['userId'] as String;
      final requestedAt = (data['requestedAt'] as Timestamp).toDate();
      final requestId = doc.id;

      // Get user basic info (avatar and username) from 'users' collection
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final userData = userDoc.data() as Map<String, dynamic>?;

      final avatar = userData?['avatar'] ?? '';
      final username = userData?['userName'] ?? 'Unknown';

      loadedRequests.add(JoinRequest(
        requestId: requestId,
        userId: userId,
        username: username,
        avatar: avatar,
        requestedAt: requestedAt,
      ));
    }

    requests = loadedRequests;
    isLoading = false;
    notifyListeners();
  }

  /// Approves a join request
  Future<void> approve(String userId) async {
    try {
      final request = requests.firstWhere((r) => r.userId == userId);
      await _membersService.approveJoinRequest(groupId, request.requestId, currentUserId);
      requests.removeWhere((r) => r.userId == userId);
      notifyListeners();
    } catch (e) {
      print('Error approving join request: $e');
    }
  }

  /// Rejects a join request
  Future<void> reject(String userId) async {
    try {
      final request = requests.firstWhere((r) => r.userId == userId);
      await _membersService.rejectJoinRequest(groupId, request.requestId, currentUserId);
      requests.removeWhere((r) => r.userId == userId);
      notifyListeners();
    } catch (e) {
      print('Error rejecting join request: $e');
    }
  }
}

class JoinRequest {
  final String requestId;
  final String userId;
  final String username;
  final String avatar;
  final DateTime requestedAt;

  JoinRequest({
    required this.requestId,
    required this.userId,
    required this.username,
    required this.avatar,
    required this.requestedAt,
  });
}
