import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/calls/person_video/Person_video_active_page.dart';
import '../screens/calls/person_video/Person_video_incoming_page.dart';
import '../screens/calls/person_video/Person_video_waiting_page.dart';
import '../screens/calls/person_video/person_video_vm.dart';
import '../screens/calls/person_voice/Person_active_page.dart';
import '../screens/calls/person_voice/Person_incoming_page.dart';
import '../screens/calls/person_voice/person_voice_vm.dart';
import '../screens/calls/person_voice/Person_waiting_page.dart';
import '../screens/home/Group_chats/group_chat_screen/UI/group_chat_screen.dart';
import '../screens/home/Navigation_management/home_screen.dart';
import '../screens/auth/forgot_password.dart';
import '../screens/home/Notification_screen/notifications_screen.dart';
import '../screens/home/Contacts/user_search_screen.dart';
import '../screens/home/person_chats_screen/person_chats_screen.dart';
import '../screens/user/send_friend_request_screen.dart';
import '../screens/user/user_detail_screen.dart';
import '../services/webrtc/call/call_session_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/webrtc/models/call_media_preset.dart';
import '../services/webrtc/models/call_model.dart.dart';

// Static Routes
final Map<String, WidgetBuilder> staticRoutes = {
  '/auth/login': (context) => LoginScreen(),
  '/auth/register': (context) => RegisterScreen(),
  '/auth/forgot-password': (context) => ForgotPasswordScreen(),
  '/notifications': (context) => NotificationScreen(),
  '/user-search': (context) => UserSearchScreen(),
  '/call/voice/waiting': (_) => const PersonVoiceWaitingPage(),
  '/call/video/waiting' : (_) => const PersonVideoWaitingPage(),
};

// Get the `userName` of the currently logged in user
Future<String?> _getUserName() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return null;

  try {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    return userDoc['userName'] as String?;
  } catch (e) {
    print('[ERROR] Failed to fetch user name: $e');
    return null;
  }
}

// Dynamic Routes
Route<dynamic>? generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/home':
      return MaterialPageRoute(
        builder: (context) => FutureBuilder<String?>(
          future: _getUserName(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.hasError || snapshot.data == null) {
              return LoginScreen();
            }
            return HomeScreen();
          },
        ),
      );

    case '/user-detail':
      if (settings.arguments is Map<String, dynamic>) {
        final user = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => UserDetailScreen(user: user),
        );
      }
      return _errorRoute('Invalid arguments for /user-detail');

    case '/send-friend-request':
      if (settings.arguments is Map<String, dynamic>) {
        final user = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => SendFriendRequestScreen(user: user),
        );
      }
      return _errorRoute('Invalid arguments for /send-friend-request');

    case '/person_chats_screen':
      if (settings.arguments is Map<String, dynamic>) {
        final chatArgs = settings.arguments as Map<String, dynamic>;
        if (chatArgs.containsKey('chatId') &&
            chatArgs.containsKey('friendName') &&
            chatArgs.containsKey('friendId')) {
          return MaterialPageRoute(
            builder: (context) => PersonChatsScreen(
              chatId: chatArgs['chatId'] as String,
              friendName: chatArgs['friendName'] as String,
              friendId: chatArgs['friendId'] as String,
            ),
          );
        }
      }
      return _errorRoute('Invalid arguments for /person_chats_screen');

    case '/group_chat_screen':
      if (settings.arguments is Map<String, dynamic>) {
        final args = settings.arguments as Map<String, dynamic>;
        if (args.containsKey('groupId') && args.containsKey('groupName')) {
          return MaterialPageRoute(
            builder: (context) => GroupChatScreen(
              groupId: args['groupId'],
              groupName: args['groupName'],
            ),
          );
        }
      }
      return _errorRoute('Invalid arguments for /group_chat_screen');

    case '/call/voice/active':
      if (settings.arguments is PersonVoiceVm) {
        final vm = settings.arguments as PersonVoiceVm;
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider.value(
            value: vm,
            child: const PersonVoiceActivePage(),
          ),
        );
      }
      return _errorRoute('Missing PersonVoiceVm for /call/voice/active');
    case '/call/video/active':
      if (settings.arguments is PersonVideoVm) {
        final vm = settings.arguments as PersonVideoVm;
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider.value(
            value: vm,
            child: const PersonVideoActivePage(),
          ),
        );
      }
      return _errorRoute('Missing PersonVideoVm for /call/video/active');

    case '/call/incoming':
      final args = settings.arguments as Map<String, dynamic>;
      final callId  = args['callId']  as String;
      final callType= args['callType']as String;
      final hostId  = args['hostId']  as String;

      return MaterialPageRoute(
        builder: (_) => FutureBuilder<CallSessionController>(
          future: _initIncomingCallSession(callId),
          builder: (ctx, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }
            if (snap.hasError || !snap.hasData) {
              return const Scaffold(body: Center(child: Text('Failed to init call')));
            }

            if (callType == 'voice') {
              final vm = PersonVoiceVm(snap.data!);
              return ChangeNotifierProvider.value(
                value: vm,
                child: PersonVoiceIncomingPage(
                  callId : callId,
                  callType: callType,
                  hostId : hostId,
                ),
              );
            } else { // 'video'
              final vm = PersonVideoVm(snap.data!);
              return ChangeNotifierProvider.value(
                value: vm,
                child: PersonVideoIncomingPage(
                  callId : callId,
                  callType: callType,
                  hostId : hostId,
                ),
              );
            }
          },
        ),
      );


    default:
      return _errorRoute('Route not defined: ${settings.name}');
  }
}

/// Helper method to initialize the call session
Future<CallSessionController> _initIncomingCallSession(String callId) async {
  final uid = FirebaseAuth.instance.currentUser!.uid;

  final snap = await FirebaseFirestore.instance.collection('calls').doc(callId).get();
  if (!snap.exists) {
    throw Exception('Call not found.');
  }

  final callModel = CallModel.fromMap(snap.id, snap.data()!);
  final controller = CallSessionController(localUid: uid);
  controller.currentCall = callModel;
  final callType = callModel.type;
  final preset = callType == 'voice'
      ? CallMediaPreset.audioOnly
      : CallMediaPreset.video;

  await controller.initLocalMedia(preset);
  await controller.startConnection(isCaller: false);

  return controller;
}



/// Default Error Route
Route<dynamic> _errorRoute(String message) {
  return MaterialPageRoute(
    builder: (context) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(child: Text(message)),
    ),
  );
}
