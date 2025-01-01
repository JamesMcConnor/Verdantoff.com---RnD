import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // 用于 Firestore
import '../../services/auth_service.dart';
import '../home/home_screen.dart'; // 导入 HomeScreen

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _userNameController = TextEditingController(); // 用户名控制器
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>(); // 用于表单验证

  void _register() async {
    if (_formKey.currentState!.validate()) {
      final userName = _userNameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      print('Attempting to register: $email with username: $userName');
      final user = await _authService.registerWithUserName(email, password, userName);

      if (user != null) {
        print('Registration successful for: ${user.email}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Welcome, $userName')),
        );

        // 注册成功后直接跳转到主页面，并传递用户名
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(userName: userName), // 直接传递 userName
          ),
        );


      } else {
        print('Registration failed. Check logs for details.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration Failed. Please try again.')),
        );
      }
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 用户名输入框
                TextFormField(
                  controller: _userNameController,
                  decoration: const InputDecoration(labelText: 'User Name'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a user name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // 邮箱输入框
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter an email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // 密码输入框
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // 确认密码输入框
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(labelText: 'Confirm Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // 注册按钮
                ElevatedButton(
                  onPressed: _register,
                  child: const Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
