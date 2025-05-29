import 'package:cloud_firestore/cloud_firestore.dart';

class ShowUserInfoToPeopleServices {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetches user information from Firestore.
  ///
  /// - [userId]: The ID of the user whose information is being retrieved.
  /// - Returns: A `Future<Map<String, dynamic>>` containing user details.
  static Future<Map<String, dynamic>> getUserInfo(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) {
        throw Exception('[ERROR] User not found.');
      }
      return userDoc.data() ?? {};
    } catch (e) {
      print('[ERROR] Failed to fetch user info: $e');
      return {};
    }
  }
}
