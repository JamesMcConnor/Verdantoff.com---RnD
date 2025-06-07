import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../services/G2G_chat/G2G_members_service.dart';
import '../../../../../services/G2G_chat/G2G_service.dart';
import '../../../../../services/models/G2G_chat/group_model.dart';

/// ViewModel for the Group-Profile page.
///
/// It loads group details, resolves user-names, and allows the
/// current user to send a join-request.
///
/// All `notifyListeners()` calls are wrapped in `safeNotify()` to
/// make sure we never update listeners after the ViewModel has
/// been disposed (which happens as soon as the page is popped).
class GroupProfileViewModel extends ChangeNotifier {
  // ---------------------------------------------------------------------------
  // Immutable fields
  // ---------------------------------------------------------------------------
  final String groupId;
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  final G2GService _groupService = G2GService();
  final G2GMembersService _membersService = G2GMembersService();

  // ---------------------------------------------------------------------------
  // Mutable state exposed to the UI
  // ---------------------------------------------------------------------------
  GroupModel? group;
  bool isLoading = true;
  bool hasRequested = false;

  /// Map from uid -> userName
  Map<String, String> userNameMap = {};

  // ---------------------------------------------------------------------------
  // Internal lifecycle flag
  // ---------------------------------------------------------------------------
  bool _disposed = false;

  // ---------------------------------------------------------------------------
  // Constructor
  // ---------------------------------------------------------------------------
  GroupProfileViewModel(this.groupId) {
    fetchGroupDetails();
  }

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Loads group data + user-names and checks whether the user
  /// has already sent a join-request.
  Future<void> fetchGroupDetails() async {
    isLoading = true;
    safeNotify();

    // --- 1) Load the group document -----------------------------------------
    group = await _groupService.getGroupDetails(groupId);

    // If the widget has been popped while awaiting, abort early
    if (_disposed) return;

    // --- 2) Collect all user IDs we need to resolve --------------------------
    final Set<String> allUids = {};
    if (group?.createdBy != null) allUids.add(group!.createdBy);
    if (group?.roles != null) allUids.addAll(group!.roles.keys);

    // --- 3) Resolve user names from 'users' collection -----------------------
    userNameMap = {};
    if (allUids.isNotEmpty) {
      final snapshots = await Future.wait(allUids.map((uid) =>
          FirebaseFirestore.instance.collection('users').doc(uid).get()));

      if (_disposed) return; // Page might have been popped

      for (var doc in snapshots) {
        if (doc.exists) {
          userNameMap[doc.id] = doc.data()?['userName'] ?? doc.id;
        }
      }
    }

    // --- 4) Check if current user already requested to join ------------------
    final joinRq = await _membersService.groupsCollection
        .doc(groupId)
        .collection('joinRequests')
        .where('userId', isEqualTo: currentUserId)
        .where('status', isEqualTo: 'pending')
        .get();

    if (_disposed) return;

    hasRequested = joinRq.docs.isNotEmpty;

    // --- 5) Done -------------------------------------------------------------
    isLoading = false;
    safeNotify();
  }

  /// Sends a join-request for the current user.
  Future<void> sendJoinRequest() async {
    await _membersService.sendJoinRequest(groupId, currentUserId);
    if (_disposed) return;

    hasRequested = true;
    safeNotify();
  }

  /// Returns a display-name for the given uid, falling back to the uid itself.
  String getUserName(String uid) => userNameMap[uid] ?? uid;

  // ---------------------------------------------------------------------------
  // ChangeNotifier overrides
  // ---------------------------------------------------------------------------

  /// Prevent further notifications after dispose.
  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Calls notifyListeners() only if ViewModel is still alive.
  void safeNotify() {
    if (!_disposed) {
      notifyListeners();
    }
  }
}
