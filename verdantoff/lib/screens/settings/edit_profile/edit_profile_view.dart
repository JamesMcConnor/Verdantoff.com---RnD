import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../edit_field_screen.dart';

///Contains UI elements such as profile photo, editable fields, and the list UI.
/// View component for displaying and editing profile information.
class EditProfileView extends StatelessWidget {
  final Future<DocumentSnapshot> userDataFuture;
  final VoidCallback onProfilePhotoUpdate;
  final VoidCallback onFieldUpdated;

  const EditProfileView({
    required this.userDataFuture,
    required this.onProfilePhotoUpdate,
    required this.onFieldUpdated,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        centerTitle: true,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData && snapshot.data != null) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            return ListView(
              children: [
                _buildProfilePhotoTile(userData['avatar'], onProfilePhotoUpdate),
                Divider(),
                _buildEditableTile(context, 'userName', userData['userName']),
                _buildEditableTile(context, 'fullName', userData['fullName']),
                _buildEditableTile(context, 'email', userData['email']),
                _buildEditableTile(context, 'birthday', userData['birthday']),
                _buildEditableTile(context, 'country', userData['country']),
                _buildEditableTile(context, 'role', userData['role']),
                _buildEditableTile(context, 'industry', userData['industry']),
              ],
            );
          }
          return Center(child: Text('Unable to load profile data'));
        },
      ),
    );
  }

  /// Displays the profile picture and allows users to change it.
  Widget _buildProfilePhotoTile(String? avatarUrl, VoidCallback onTap) {
    return ListTile(
      title: Text('Profile Photo'),
      subtitle: Text('Tap to change your profile photo'),
      leading: CircleAvatar(
        radius: 40,
        backgroundColor: Colors.grey.shade300,
        backgroundImage: avatarUrl != null
            ? CachedNetworkImageProvider(avatarUrl)
            : null,
        child: avatarUrl == null ? Icon(Icons.person, size: 40) : null,
      ),
      onTap: onTap,
    );
  }

  /// Creates an editable field tile that navigates to the `EditFieldScreen`.
  Widget _buildEditableTile(BuildContext context, String label, dynamic value) {
    return ListTile(
      title: Text(_capitalize(label)),
      subtitle: Text(value != null ? value.toString() : 'Not Set'),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditFieldScreen(
              fieldName: label,
              currentValue: value != null ? value.toString() : '',
            ),
          ),
        ).then((isUpdated) {
          if (isUpdated == true) {
            onFieldUpdated(); // Call function to refresh user data
          }
        });
      },
    );
  }

  /// Capitalizes the first letter of a string.
  String _capitalize(String text) {
    return text[0].toUpperCase() + text.substring(1);
  }
}