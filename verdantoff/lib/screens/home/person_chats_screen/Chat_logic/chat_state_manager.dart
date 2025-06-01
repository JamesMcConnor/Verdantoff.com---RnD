import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../services/models/p2p_chat/p2p_message_model.dart';
import '../../../../services/p2p_chat/p2p_message_funtions/file_upload_service.dart';
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
  final FileUploadService _fileUploadService = FileUploadService();

  final ValueNotifier<List<P2PMessage>> messages = ValueNotifier([]);
  final ValueNotifier<double?> uploadProgress = ValueNotifier<double?>(null);
  final ValueNotifier<String?> uploadError = ValueNotifier<String?>(null);
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

  /// Sends an image message
  Future<void> sendImage() async {
    try {
      uploadError.value = null;
      final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      // Compress image before upload
      final compressedImage = await _compressImage(File(image.path));
      if (compressedImage == null) {
        throw Exception('Image compression failed');
      }

      // Check file size
      final fileSize = await compressedImage.length();
      if (fileSize > 5 * 1024 * 1024) {
        throw Exception('Image size exceeds 5MB limit');
      }

      uploadProgress.value = 0;
      final fileMeta = await _fileUploadService.uploadFile(
        compressedImage,
        chatId,
        onProgress: (progress) => uploadProgress.value = progress,
      );

      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      final newMsg = P2PMessage(
        id: '',
        senderId: uid,
        type: 'image',
        content: '[Image]',
        attachments: [],
        timestamp: DateTime.now(),
        editableUntil: DateTime.now().add(const Duration(minutes: 1)),
        isRecalled: false,
        isReadBy: [],
        isEdited: false,
        fileMeta: fileMeta,
      );

      await _p2pServices.messageService.addMessage(chatId, newMsg);
    } catch (e) {
      uploadError.value = 'Failed to send image: $e';
    } finally {
      uploadProgress.value = null;
    }
  }

  /// Sends a file message
  Future<void> sendFile() async {
    try {
      uploadError.value = null;
      final result = await FilePicker.platform.pickFiles();
      if (result == null || result.files.isEmpty) return;

      final file = File(result.files.single.path!);
      final fileName = result.files.single.name;
      final fileExtension = fileName.split('.').last.toLowerCase();

      // Validate file type
      if (!_isSupportedFileType(fileExtension)) {
        throw Exception('File type not supported');
      }

      // Check file size
      final fileSize = await file.length();
      if (fileSize > 5 * 1024 * 1024) {
        throw Exception('File size exceeds 5MB limit');
      }

      uploadProgress.value = 0;
      final fileMeta = await _fileUploadService.uploadFile(
        file,
        chatId,
        onProgress: (progress) => uploadProgress.value = progress,
      );

      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      final newMsg = P2PMessage(
        id: '',
        senderId: uid,
        type: 'file',
        content: fileName,
        attachments: [],
        timestamp: DateTime.now(),
        editableUntil: DateTime.now().add(const Duration(minutes: 1)),
        isRecalled: false,
        isReadBy: [],
        isEdited: false,
        fileMeta: fileMeta,
      );

      await _p2pServices.messageService.addMessage(chatId, newMsg);
    } catch (e) {
      uploadError.value = 'Failed to send file: $e';
    } finally {
      uploadProgress.value = null;
    }
  }

  /// Compresses an image file to reduce size
  Future<File?> _compressImage(File file) async {
    try {
      final result = await FlutterImageCompress.compressAndGetFile(
        file.path,
        '${file.path}_compressed.jpg',
        quality: 70,
        minWidth: 1024,
        minHeight: 1024,
      );
      return result != null ? File(result.path) : null;
    } catch (e) {
      print('[ERROR] Image compression failed: $e');
      return null;
    }
  }

  /// Checks if a file type is supported
  bool _isSupportedFileType(String extension) {
    const supportedTypes = ['jpg', 'jpeg', 'png', 'gif', 'pdf', 'doc', 'docx', 'xls', 'xlsx', 'txt'];
    return supportedTypes.contains(extension.toLowerCase());
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

  void dispose() {
    _messageSubscription?.cancel();
    messageController.dispose();
    uploadProgress.dispose();
    uploadError.dispose();
  }
}
