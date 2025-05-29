import 'dart:io';
import 'package:flutter/services.dart';

/// NavigationService is a singleton that handles custom navigation operations.
/// It provides a method to **move the app to the background** instead of completely exiting.
class NavigationService {
  // Singleton instance of NavigationService
  static final NavigationService _instance = NavigationService._internal();

  // Factory constructor to return the same instance
  factory NavigationService() => _instance;

  // Private constructor to ensure only one instance exists
  NavigationService._internal();

  /// Moves the app to the background instead of fully exiting.
  /// This prevents unintended app closures when the back button is pressed.
  ///
  /// Returns `false` if the action is successfully executed (prevents default back behavior).
  /// Returns `true` if an error occurs (allows normal back button behavior).
  Future<bool> handleBackPressed() async {
    try {
      // This functionality is only applicable to Android devices
      if (Platform.isAndroid) {
        print('[INFO] Moving app to background');

        // Calls the system method to minimize the app
        await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        return Future.value(false); // Prevents further back navigation
      }
    } catch (e) {
      print('[ERROR] Failed to move app to background: $e');
    }

    return Future.value(true); // If an error occurs, allow default behavior
  }
}
