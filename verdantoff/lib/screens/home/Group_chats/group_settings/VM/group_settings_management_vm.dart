import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupSettingsManagementViewModel extends ChangeNotifier {
  final String groupId;
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String role = 'member';
  bool isLoading = true;

  GroupSettingsManagementViewModel(this.groupId) {
    determineUserRole();
  }

  Future<void> determineUserRole() async {
    isLoading = true;
    notifyListeners();

    final doc = await _firestore.collection('groups').doc(groupId).get();
    final roles = doc.data()?['roles'] as Map<String, dynamic>? ?? {};
    role = roles[currentUserId] ?? 'member';

    isLoading = false;
    notifyListeners();
  }
}
