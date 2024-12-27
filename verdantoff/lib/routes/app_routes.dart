// 应用路由表，集中管理所有页面路由地址。
// 每个页面可以通过命名路由方式进行导航。
import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/home_screen.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(child: Text('Login Screen')),
    );
  }
}
// 路由注册
final Map<String, WidgetBuilder> routes = {
  '/login': (context) => LoginScreen(),
  '/register': (context) => RegisterScreen(), // 注册页面
  '/home': (context) => HomeScreen(),
};