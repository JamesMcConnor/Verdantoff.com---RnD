import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Make sure the user is logged in, otherwise throw an exception
  void _checkUserLoggedIn() {
    if (_auth.currentUser == null) {
      throw Exception('User not logged in');
    }
  }

  /// Search for users by email address
  ///
  /// The return value contains the user data and the UID.
  Future<Map<String, dynamic>?> searchByEmail(String email) async {
    _checkUserLoggedIn(); // Make sure the user is logged in

    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (snapshot.docs.isNotEmpty) {
        var doc = snapshot.docs.first;
        return {
          'uid': doc.id, // Add UID
          ...doc.data() as Map<String, dynamic>
        };
      }
      return null; // not find user
    } catch (e) {
      print('Search by email failed: $e');
      rethrow; // Throw an exception for the caller to catch
    }
  }

  /// Search for users by username
  ///
  /// The return value is a user data list, each user contains the UID.
  Future<List<Map<String, dynamic>>> searchByUserName(String userName) async {
    _checkUserLoggedIn(); // Make sure the user is logged in

    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('userName', isEqualTo: userName)
          .get();

      return snapshot.docs.map((doc) {
        return {
          'uid': doc.id, // add UID
          ...doc.data() as Map<String, dynamic>
        };
      }).toList();
    } catch (e) {
      print('Search by username failed: $e');
      rethrow; // Throw an exception for the caller to catch
    }
  }
}
