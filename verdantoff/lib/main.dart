import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart'; // 登录界面
import 'screens/auth/register_screen.dart'; // 注册界面
import 'screens/home/home_screen.dart'; // 主界面
import 'screens/auth/forgot_password.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // 初始化 Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Auth',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/auth/login', // 初始路由设置为登录界面
      routes: {
        '/auth/login': (context) => LoginScreen(),
        '/auth/register': (context) => RegisterScreen(), // 添加注册页面路由
        '/auth/forgot-password': (context) => ForgotPasswordScreen(), // 忘记密码路由
        '/home': (context) => HomeScreen(),
      },
    );
  }
}
