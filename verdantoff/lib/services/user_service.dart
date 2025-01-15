import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// 确保用户已登录，否则抛出异常
  void _checkUserLoggedIn() {
    if (_auth.currentUser == null) {
      throw Exception('User not logged in');
    }
  }

  /// 按邮箱精确搜索用户
  ///
  /// 返回值包含用户数据和 UID。
  Future<Map<String, dynamic>?> searchByEmail(String email) async {
    _checkUserLoggedIn(); // 确保用户已登录

    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (snapshot.docs.isNotEmpty) {
        var doc = snapshot.docs.first;
        return {
          'uid': doc.id, // 添加 UID
          ...doc.data() as Map<String, dynamic>
        };
      }
      return null; // 未找到用户
    } catch (e) {
      print('Search by email failed: $e');
      rethrow; // 抛出异常供调用方捕获
    }
  }

  /// 按用户名精确搜索用户
  ///
  /// 返回值为用户数据列表，每个用户包含 UID。
  Future<List<Map<String, dynamic>>> searchByUserName(String userName) async {
    _checkUserLoggedIn(); // 确保用户已登录

    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('userName', isEqualTo: userName)
          .get();

      return snapshot.docs.map((doc) {
        return {
          'uid': doc.id, // 添加 UID
          ...doc.data() as Map<String, dynamic>
        };
      }).toList();
    } catch (e) {
      print('Search by username failed: $e');
      rethrow; // 抛出异常供调用方捕获
    }
  }
}
