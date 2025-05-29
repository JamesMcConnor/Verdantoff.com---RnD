import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:verdantoff/services/auth_service.dart';
import '../home/Navigation_management/home_screen.dart'; // 引入 HomeScreen

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

      print('Logged in: ${userCredential.user?.email}');

      // After successful login, jump to `HomeScreen` and no longer pass `userName'
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
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
            builder: (context) => HomeScreen(),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Add Verdantoff title
            Text(
              'Verdantoff',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24.0), // The spacing between the title and the input box

            // Email 输入框
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),

            SizedBox(height: 16.0), // Spacing between Email and Password

            // Password 输入框
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),

            SizedBox(height: 24.0), // Spacing between input box and button

            //Login Button
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),

            SizedBox(height: 16.0), // spacing

            // Google 登录按钮
            ElevatedButton.icon(
              onPressed: _loginWithGoogle,
              icon: Icon(Icons.login),
              label: Text('Login with Google'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Button Color
                foregroundColor: Colors.white, // Font Color
              ),
            ),

            SizedBox(height: 16.0),

            // Register Button
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/auth/register');
              },
              child: Text('Don’t have an account? Register here!'),
            ),

            // Forgot password button
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/auth/forgot-password');
              },
              child: Text('Forgot Password?'),
            ),
          ],
        ),
      ),
    );
  }
}
