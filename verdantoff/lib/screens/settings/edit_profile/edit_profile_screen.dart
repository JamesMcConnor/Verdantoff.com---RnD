import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_profile_controller.dart';
import 'edit_profile_view.dart';

/// Entry point for editing user profile.
/// Manages state and updates user data dynamically after changes.
class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final EditProfileController _controller = EditProfileController();
  late Completer<DocumentSnapshot> _userDataCompleter;

  @override
  void initState() {
    super.initState();
    _refreshUserData();
  }

  /// Fetches user data and stores it in a `Completer` for reusability.
  void _refreshUserData() {
    _userDataCompleter = Completer<DocumentSnapshot>();
    _controller.loadUserData().then((data) {
      if (!_userDataCompleter.isCompleted) {
        _userDataCompleter.complete(data);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return EditProfileView(
      userDataFuture: _userDataCompleter.future,
      onProfilePhotoUpdate: () async {
        await _controller.uploadProfilePhoto(context);
        _refreshUserData(); // Refresh user data after updating profile photo
        setState(() {}); // Trigger UI rebuild
      },
      onFieldUpdated: () {
        _refreshUserData(); // Refresh user data when a field is updated
        setState(() {}); // Trigger UI rebuild
      },
    );
  }
}
