import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 确保用户已登录
  bool _isUserLoggedIn() {
    return _auth.currentUser != null;
  }

  // 精确邮箱搜索
  Future<Map<String, dynamic>?> searchByEmail(String email) async {
    if (!_isUserLoggedIn()) {
      print('User not logged in. Please log in first.');
      throw Exception('User not logged in');
    }

    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.data() as Map<String, dynamic>;
      }
      return null; // 没有找到用户
    } catch (e) {
      print('Search by email failed: $e');
      return null;
    }
  }

  // 完整匹配用户名搜索
  Future<List<Map<String, dynamic>>> searchByUserName(String userName) async {
    if (!_isUserLoggedIn()) {
      print('User not logged in. Please log in first.');
      throw Exception('User not logged in');
    }

    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('userName', isEqualTo: userName)
          .get();

      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Search by username failed: $e');
      return [];
    }
  }
}
