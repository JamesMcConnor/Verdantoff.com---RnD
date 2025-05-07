import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../../services/G2G_chat/G2G_members_service.dart';
import '../../../../../services/G2G_chat/G2G_service.dart';
import '../../../../../services/models/G2G_chat/group_model.dart';

class GroupProfileViewModel extends ChangeNotifier {
  final String groupId;
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;

  final G2GService _groupService = G2GService();
  final G2GMembersService _membersService = G2GMembersService();

  GroupModel? group;
  bool isLoading = true;
  bool hasRequested = false;

  GroupProfileViewModel(this.groupId) {
    fetchGroupDetails();
  }

  Future<void> fetchGroupDetails() async {
    isLoading = true;
    notifyListeners();

    group = await _groupService.getGroupDetails(groupId);

    // Optionally check if user already requested to join
    final joinRequestSnapshot = await _membersService.groupsCollection
        .doc(groupId)
        .collection('joinRequests')
        .where('userId', isEqualTo: currentUserId)
        .where('status', isEqualTo: 'pending')
        .get();

    hasRequested = joinRequestSnapshot.docs.isNotEmpty;

    isLoading = false;
    notifyListeners();
  }

  Future<void> sendJoinRequest() async {
    await _membersService.sendJoinRequest(groupId, currentUserId);
    hasRequested = true;
    notifyListeners();
  }
}
