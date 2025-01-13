import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'edit_field_screen.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Future<DocumentSnapshot> _userDataFuture;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    _userDataFuture = FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser?.uid)
        .get();
  }

  Future<void> _uploadProfilePhoto() async {
    try {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        // 裁剪图片
        final croppedImage = await ImageCropper().cropImage(
          sourcePath: pickedImage.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 100,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              toolbarColor: Colors.blue,
              toolbarWidgetColor: Colors.white,
              hideBottomControls: true,
              lockAspectRatio: true,
            ),
            IOSUiSettings(
              title: 'Crop Image',
            ),
          ],
        );

        if (croppedImage != null) {
          final uid = _auth.currentUser?.uid;
          if (uid == null) return;

          // 上传图片到 Firebase Storage
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('profile_photos/$uid.jpg');
          final uploadTask = await storageRef.putFile(File(croppedImage.path));
          final downloadUrl = await uploadTask.ref.getDownloadURL();

          // 更新 Firestore 用户信息
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .update({'avatar': downloadUrl});

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile photo updated successfully!')),
          );

          setState(() {
            _loadUserData(); // 刷新用户数据
          });
        }
      }
    } catch (e) {
      print('Error uploading profile photo: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile photo.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        centerTitle: true,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData && snapshot.data != null) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            return ListView(
              children: [
                ListTile(
                  title: Text('Profile Photo'),
                  subtitle: Text('Tap to change your profile photo'),
                  leading: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: userData['avatar'] != null
                        ? CachedNetworkImageProvider(userData['avatar'])
                        : null,
                    child: userData['avatar'] == null
                        ? Icon(Icons.person, size: 40)
                        : null,
                  ),
                  onTap: _uploadProfilePhoto, // 点击修改头像
                ),
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
            setState(() {
              _loadUserData(); // 刷新用户数据
            });
          }
        });
      },
    );
  }

  String _capitalize(String text) {
    return text[0].toUpperCase() + text.substring(1);
  }
}
