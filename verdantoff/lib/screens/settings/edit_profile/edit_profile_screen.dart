import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'edit_profile_controller.dart';
import 'edit_profile_view.dart';

/// Entry point for editing a user profile.
///
/// The screen itself is only a thin wrapper that:
///   • fetches Firestore user-data through [EditProfileController]
///   • hands that Future to [EditProfileView]
///   • refreshes after any field / photo update
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);   // ← const ctor!

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final EditProfileController _controller = EditProfileController();

  /// Holds the latest user-document future. Re-created on every refresh.
  late Future<DocumentSnapshot> _userDocFuture;

  @override
  void initState() {
    super.initState();
    _reloadUserData();
  }

  /// (Re)fetch current user-document from Firestore.
  void _reloadUserData() {
    _userDocFuture = _controller.loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return EditProfileView(
      userDataFuture: _userDocFuture,

      /// When the avatar is changed:
      onProfilePhotoUpdate: () async {
        await _controller.uploadProfilePhoto(context);
        setState(_reloadUserData);               // refresh + rebuild
      },

      /// When any text field is edited:
      onFieldUpdated: () {
        setState(_reloadUserData);               // refresh + rebuild
      },
    );
  }
}
