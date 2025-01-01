// Apply the routing table to centrally manage all page routing addresses.
// Each page can be navigated by named routing.
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
// Route Registration
final Map<String, WidgetBuilder> routes = {
  '/login': (context) => LoginScreen(),
  '/register': (context) => RegisterScreen(), // Registration Page
};