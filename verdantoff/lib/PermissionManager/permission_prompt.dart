import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'permission_manager.dart';

/// Check whether all required permissions are agreed to. If any permissions are not agreed to, a prompt dialog box will pop up to guide the user to enter the system settings.
Future<void> promptPermissionsIfNeeded(BuildContext context) async {
  PermissionManager permissionManager = PermissionManager();
  bool allGranted = await permissionManager.checkAllPermissions();

  if (!allGranted) {
    // A dialog box pops up, prompting the user to open the settings page
    showDialog(
      context: context,
      barrierDismissible: false, // Do not allow click outside close
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Permissions Required"),
          content: Text("Some required permissions are not granted. Please enable them in app settings to ensure full functionality."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Open the system settings page
                openAppSettings();
              },
              child: Text("Open Settings"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Dismiss"),
            ),
          ],
        );
      },
    );
  }
}
