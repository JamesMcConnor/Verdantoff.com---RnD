import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// View-model for the “Me” tab.
/// Keeps all Firebase calls away from the UI.
class MeViewModel extends ChangeNotifier {
  // ---------------------------------------------------------------------------
  // Dependencies
  // ---------------------------------------------------------------------------
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ---------------------------------------------------------------------------
  // Exposed, listenable state
  // ---------------------------------------------------------------------------
  DocumentSnapshot? userDoc;
  bool isBusy = false;

  // ---------------------------------------------------------------------------
  // Load current user profile from Firestore
  // ---------------------------------------------------------------------------
  Future<void> load() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    isBusy = true;
    notifyListeners();

    userDoc = await _db.collection('users').doc(uid).get();

    isBusy = false;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Sign-out
  // ---------------------------------------------------------------------------
  Future<void> signOut() async => _auth.signOut();

  // ---------------------------------------------------------------------------
  // Delete account completely:
  //   ① Remove Firestore entry
  //   ② Delete the Auth user (might require re-auth)
  //   ③ Sign-out
  // Returns true on success.
  // ---------------------------------------------------------------------------
  Future<bool> deleteAccount() async {
    final user = _auth.currentUser;
    if (user == null) return false;

    isBusy = true;
    notifyListeners();

    try {
      await _db.collection('users').doc(user.uid).delete();
      await user.delete();               // <— removes from Authentication
      await _auth.signOut();             // leave no session behind
      return true;
    } on FirebaseAuthException catch (e) {
      // If deletion requires recent login we silently sign-out
      // and let the user log in again.
      if (e.code == 'requires-recent-login') {
        await _auth.signOut();
      }
      return false;
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }
}
