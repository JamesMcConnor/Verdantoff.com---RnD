import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/auth/login_screen.dart'; // login
import 'screens/auth/register_screen.dart'; // register
import 'screens/home/home_screen.dart'; // main page
import 'screens/auth/forgot_password.dart';
import 'screens/home/notifications_screen.dart';

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
      initialRoute: '/auth/login',
      routes: {
        '/auth/login': (context) => LoginScreen(),
        '/auth/register': (context) => RegisterScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/home') {
          final args = settings.arguments as String; // 接收传递的 userName
          return MaterialPageRoute(
            builder: (context) => HomeScreen(userName: args),
          );
        }
        return null;
      },
    );
  }
}