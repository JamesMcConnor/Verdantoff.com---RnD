import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:verdantoff/services/auth_service.dart';
import '../home/home_screen.dart'; // 引入 HomeScreen

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final uid = userCredential.user?.uid;
      if (uid != null) {
        String? userName = await AuthService().fetchUserName(uid);
        print('Logged in: ${userCredential.user?.email} with userName: $userName');

        // 登录成功后跳转到主页面并传递用户名
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(userName: userName),
          ),
        );
      } else {
        throw Exception('User ID is null');
      }
    } catch (e) {
      print('Login failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login failed. Please try again.')),
      );
    }
  }

  Future<void> _loginWithGoogle() async {
    try {
      final user = await AuthService().signInWithGoogle();
      if (user != null) {
        print('Google Login successful: ${user.email}');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(userName: user.displayName ?? 'Google User'),
          ),
        );
      } else {
        print('Google Login cancelled');
      }
    } catch (e) {
      print('Google Login failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Google Login failed. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            SizedBox(height: 16.0), // 增加间距
            ElevatedButton.icon(
              onPressed: _loginWithGoogle,
              icon: Icon(Icons.login),
              label: Text('Login with Google'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // 按钮颜色
                foregroundColor: Colors.white, // 字体颜色
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/auth/register'); // 跳转到注册页面
              },
              child: Text('Don’t have an account? Register here!'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/auth/forgot-password'); // 跳转到忘记密码页面
              },
              child: Text('Forgot Password?'),
            ),
          ],
        ),
      ),
    );
  }
}
