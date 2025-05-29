import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

/// Controller class for handling profile update logic.
/// This includes loading user data and updating profile pictures.
class EditProfileController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Loads user data from Firestore.
  Future<DocumentSnapshot> loadUserData() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser?.uid)
        .get();
  }

  /// Handles profile photo upload and updates Firestore.
  Future<void> uploadProfilePhoto(BuildContext context) async {
    try {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
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

          // Upload image to Firebase Storage
          final storageRef =
          FirebaseStorage.instance.ref().child('profile_photos/$uid.jpg');
          final uploadTask = await storageRef.putFile(File(croppedImage.path));
          final downloadUrl = await uploadTask.ref.getDownloadURL();

          // Update Firestore with new profile picture URL
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .update({'avatar': downloadUrl});

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile photo updated successfully!')),
          );
        }
      }
    } catch (e) {
      print('Error uploading profile photo: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile photo.')),
      );
    }
  }
}
