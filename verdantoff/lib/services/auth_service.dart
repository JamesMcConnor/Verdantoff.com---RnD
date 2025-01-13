import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// **Register a new user with email, password, and username**
  ///
  /// This method creates a new user in Firebase Authentication and stores the
  /// user information in Firestore with optional fields initialized to `null`.
  Future<User?> registerWithUserName(
      String email, String password, String userName) async {
    try {
      // Create user in Firebase Authentication
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store user information in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'userName': userName,
        'email': email,
        'fullName': null, // Optional fields initialized to null
        'birthday': null,
        'country': null,
        'role': null,
        'industry': null,
        'avatar': null,
        'createdAt': FieldValue.serverTimestamp(), // Store registration time
      });

      print('User data saved successfully.');
      return userCredential.user;
    } catch (authError) {
      print('Registration failed: $authError');
      throw Exception('Failed to register user: ${authError.toString()}');
    }
  }

  /// **Sign in with Google**
  ///
  /// This method allows users to sign in using their Google account.
  /// If the user doesn't exist in Firestore, it initializes their information.
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
      await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        // Check if user data exists in Firestore
        final userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (!userDoc.exists) {
          // Initialize user data
          await _firestore.collection('users').doc(user.uid).set({
            'userName': user.displayName ?? 'Google User',
            'email': user.email,
            'fullName': user.displayName,
            'avatar': googleUser.photoUrl ?? null,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      }
      return user;
    } catch (e) {
      print('Google Sign-In failed: $e');
      throw Exception('Google sign-in failed: ${e.toString()}');
    }
  }

  /// **Log out the current user**
  ///
  /// This method logs out the currently authenticated user.
  Future<void> logout() async {
    try {
      await _auth.signOut();
      print('User signed out');
    } catch (e) {
      print('Sign-out failed: $e');
      throw Exception('Failed to sign out: ${e.toString()}');
    }
  }

  /// **Fetch user information by UID**
  ///
  /// This method retrieves the `userName` from Firestore for a given user ID.
  Future<String> fetchUserName(String uid) async {
    try {
      DocumentSnapshot doc =
      await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc['userName'] != null) {
        return doc['userName'] as String; // Ensure the field is of type String
      }
      return 'Unknown User';
    } catch (e) {
      print('Failed to fetch userName: $e');
      return 'Unknown User'; // Default value in case of error
    }
  }

  /// **Update user profile information**
  ///
  /// This method updates specific fields in the user's Firestore document.
  Future<void> updateUserProfile(
      String uid, Map<String, dynamic> updatedFields) async {
    try {
      await _firestore.collection('users').doc(uid).update(updatedFields);
      print('User profile updated successfully.');
    } catch (e) {
      print('Failed to update user profile: $e');
      throw Exception('Failed to update user profile.');
    }
  }
}
