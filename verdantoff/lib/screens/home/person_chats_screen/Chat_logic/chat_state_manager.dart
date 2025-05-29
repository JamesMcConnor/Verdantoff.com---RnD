import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../services/models/p2p_chat/p2p_message_model.dart';
import '../../../../services/p2p_services.dart';
import '../../../../services/webrtc/call/call_session_controller.dart';
import '../../../../services/webrtc/models/call_media_preset.dart';

import '../../../calls/person_voice/person_voice_vm.dart';
import '../../../calls/person_voice/person_waiting_page.dart';

import '../../../calls/person_video/person_video_vm.dart';
import '../../../calls/person_video/person_video_waiting_page.dart';

class ChatStateManager {
  final String chatId;
  final String friendName;
  final String friendId;

  final TextEditingController messageController = TextEditingController();
  final P2PServices _p2pServices = P2PServices();

  final ValueNotifier<List<P2PMessage>> messages = ValueNotifier([]);
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _messageSubscription;

  ChatStateManager({
    required this.chatId,
    required this.friendName,
    required this.friendId,
  });


  void initializeChat() {
    _messageSubscription = FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .listen((snapshot) {
      messages.value = snapshot.docs
          .map((doc) {
        try {
          return P2PMessage.fromMap(doc.id, doc.data());
        } catch (e) {
          print('[ERROR] Failed to parse message: $e');
          return null;
        }
      })
          .whereType<P2PMessage>()
          .toList();
      markMessagesAsRead();
    });
  }

  void markMessagesAsRead() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    for (final m in messages.value) {
      if (!m.isReadBy.contains(uid)) {
        _p2pServices.messageService.markMessageAsRead(chatId, m.id, uid);
      }
    }
  }


  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || text.isEmpty) return;

    final newMsg = P2PMessage(
      id: '',
      senderId: uid,
      type: 'text',
      content: text,
      attachments: [],
      timestamp: DateTime.now(),
      editableUntil: DateTime.now().add(const Duration(minutes: 1)),
      isRecalled: false,
      isReadBy: [],
      isEdited: false,
    );
    try {
      await _p2pServices.messageService.addMessage(chatId, newMsg);
      messageController.clear();
    } catch (e) {
      print('[ERROR] sendMessage: $e');
    }
  }

  Future<void> startVoiceCall(BuildContext context) async {
    final myUid = FirebaseAuth.instance.currentUser!.uid;

    final ctrl = CallSessionController(localUid: myUid);
    final vm   = PersonVoiceVm(ctrl);

    await ctrl.initLocalMedia(CallMediaPreset.audioOnly);
    await ctrl.createCall(invitees: [friendId], type: 'voice');

    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider.value(
            value: vm,
            child: const PersonVoiceWaitingPage(),
          ),
        ),
      );
    }
  }


  Future<void> startVideoCall(BuildContext context) async {
    final myUid = FirebaseAuth.instance.currentUser!.uid;

    final ctrl = CallSessionController(localUid: myUid);
    final vm   = PersonVideoVm(ctrl);

    await ctrl.initLocalMedia(CallMediaPreset.video);
    await ctrl.createCall(invitees: [friendId], type: 'video');

    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider.value(
            value: vm,
            child: const PersonVideoWaitingPage(),
          ),
        ),
      );
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  void dispose() {
    _messageSubscription?.cancel();
    messageController.dispose();
  }
}
