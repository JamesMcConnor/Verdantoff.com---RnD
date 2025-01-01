import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // User Registration with Username
  Future<User?> registerWithUserName(String email, String password, String userName) async {
    try {
      // 创建用户
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 存储用户信息到 Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'userName': userName,
        'email': email,
      }).then((_) {
        print('User data saved successfully.');
      }).catchError((error) {
        print('Failed to save user data: $error');
        throw Exception('Failed to save user data to Firestore');
      });

      return userCredential.user;
    } catch (authError) {
      print('Registration failed: $authError');
      return null;
    }
  }



  // Google Sign-in Method (保持不变)
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        // 检查 Firestore 是否已有该用户记录
        final userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (!userDoc.exists) {
          // 如果没有，存储用户信息
          await _firestore.collection('users').doc(user.uid).set({
            'userName': user.displayName ?? 'Google User', // 如果没有显示名，默认 Google User
            'email': user.email,
          });
        }
      }

      return user;
    } catch (e) {
      print('Google Sign-In failed: $e');
      return null;
    }
  }


  // User logout method
  Future<void> logout() async {
    try {
      await _auth.signOut();
      print('User signed out');
    } catch (e) {
      print('Sign-out failed: $e');
    }
  }
  //如果用户未从注册页面直接跳转到主页（例如通过登录进入），你可以从 Firestore 中检索用户名
  Future<String> fetchUserName(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc['userName'] != null) {
        return doc['userName'] as String; // 确保 userName 是 String 类型
      }
      return 'Unknown User'; // 如果 userName 为 null，返回默认值
    } catch (e) {
      print('Failed to fetch userName: $e');
      return 'Unknown User'; // 捕获异常时返回默认值
    }
  }


}
