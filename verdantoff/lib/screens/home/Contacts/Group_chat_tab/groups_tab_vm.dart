import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../services/G2G_chat/G2G_listing_service.dart';
import '../../../../services/models/G2G_chat/group_model.dart';

class GroupsTabViewModel extends ChangeNotifier {
  final G2GListingService _listingService = G2GListingService();
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  List<_GroupListItem> groups = [];
  bool isLoading = false;

  GroupsTabViewModel() {
    fetchUserGroups();
  }

  Future<void> fetchUserGroups() async {
    isLoading = true;
    notifyListeners();

    final groupDataList = await _listingService.getMyGroupsWithUnreadCounts(currentUserId);

    groups = groupDataList.map((data) {
      final group = data['group'] as GroupModel;
      final unreadCount = data['unreadCount'] as int;
      return _GroupListItem(
        groupId: group.groupId,
        groupname: group.name,
        unreadCount: unreadCount,
      );
    }).toList();

    isLoading = false;
    notifyListeners();
  }
}

class _GroupListItem {
  final String groupId;
  final String groupname;
  final int unreadCount;

  _GroupListItem({
    required this.groupId,
    required this.groupname,
    required this.unreadCount,
  });
}
