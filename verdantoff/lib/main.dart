import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart'; // login
import 'screens/auth/register_screen.dart'; // register
import 'screens/home/home_screen.dart'; // main page
import 'screens/auth/forgot_password.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
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
      initialRoute: '/auth/login', // The initial route is set to the login interface
      routes: {
        '/auth/login': (context) => LoginScreen(),
        '/auth/register': (context) => RegisterScreen(), // Adding a registration page route
        '/auth/forgot-password': (context) => ForgotPasswordScreen(), // Forgot Password Routing
        '/home': (context) => HomeScreen(),
      },
    );
  }
}
