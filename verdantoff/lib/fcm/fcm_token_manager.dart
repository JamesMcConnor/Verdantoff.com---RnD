/// services/fcm_token_manager.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FcmTokenManager {
  /// Call once from `main()`.
  static Future<void> initialise() async {
    // Update immediately if someone is already logged-in.
    await _updateTokenIfLoggedIn();

    //login / logout.
    FirebaseAuth.instance.authStateChanges().listen((_) {
      _updateTokenIfLoggedIn();
    });

    // React to token refreshes pushed by FCM (about once a month,
    //     or when the user clears data / reinstalls).
    FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _storeToken(user.uid, token);
      }
    });
  }

  /* --------------------------------------------------------------------- */

  static Future<void> _updateTokenIfLoggedIn() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) await _storeToken(user.uid, token);
  }

  static Future<void> _storeToken(String uid, String token) async {

    //SINGLE‐TOKEN FIELD
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set({'fcmToken': token}, SetOptions(merge: true));

  }
}
