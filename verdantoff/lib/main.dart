import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:verdantoff/screens/auth/login_screen.dart';
import 'package:verdantoff/screens/home/Navigation_management/home_screen.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Auth',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.blue,
          textTheme: ButtonTextTheme.primary,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
      ),
      home: AuthWrapper(), // Monitor user login status
      routes: staticRoutes,
      onGenerateRoute: generateRoute,
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: const Text('Page Not Found')),
            body: Center(
              child: Text('The page ${settings.name} does not exist.'),
            ),
          ),
        );
      },
    );
  }
}

/// **Listen to Firebase authentication status and decide to jump to `HomeScreen` or `LoginScreen`**
class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          return FutureBuilder<String?>(
            future: _fetchUserName(snapshot.data!),
            builder: (context, userNameSnapshot) {
              if (userNameSnapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              if (userNameSnapshot.hasError || userNameSnapshot.data == null) {
                return LoginScreen(); // Login failed, return to login page
              }

              return HomeScreen(); // Login successful, enter the home page
            },
          );
        }

        return LoginScreen();
      },
    );
  }
}

/// **get `userName`**
Future<String?> _fetchUserName(User user) async {
  try {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    return userDoc['userName'] as String?;
  } catch (e) {
    print('[ERROR] Failed to fetch userName: $e');
    return null;
  }
}
