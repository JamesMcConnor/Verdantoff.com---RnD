import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/auth/forgot_password.dart';
import '../screens/home/notifications_screen.dart';
import '../screens/home/user_search_screen.dart';
import '../screens/user/send_friend_request_screen.dart';
import '../screens/user/user_detail_screen.dart';

// 路由表
final Map<String, WidgetBuilder> staticRoutes = {
  '/auth/login': (context) => LoginScreen(),
  '/auth/register': (context) => RegisterScreen(),
  '/auth/forgot-password': (context) => ForgotPasswordScreen(),
  //'/notifications': (context) => NotificationsScreen(),
  '/user-search': (context) => UserSearchScreen(), // 用户搜索页面
};

// 动态路由表
Route<dynamic>? generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/home':
      final args = settings.arguments as String; // 接收传递的 userName
      return MaterialPageRoute(
        builder: (context) => HomeScreen(userName: args),
      );
    case '/user-detail':
      final user = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder: (context) => UserDetailScreen(user: user),
      );
    case '/send-friend-request':
      final user = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder: (context) => SendFriendRequestScreen(user: user),
      );
    default:
      return null; // 未定义的路由返回 null
  }
}

