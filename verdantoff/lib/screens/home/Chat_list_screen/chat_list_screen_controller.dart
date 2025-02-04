import 'dart:async';
import '../../../services/models/p2p_chat/p2p_chat_model.dart';
import 'chat_list_screen_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatListScreenController {
  final ChatListScreenService _service = ChatListScreenService();
  final StreamController<List<P2PChat>> _chatsController =
  StreamController<List<P2PChat>>.broadcast();
  List<P2PChat> _allChats = [];
  StreamSubscription? _chatSubscription;

  /// ✅ **Use `_service.chatsStream` as data source**
  Stream<List<P2PChat>> get chatsStream => _service.chatsStream;

  /// **Load chats for the current user**
  void loadChats() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    // ✅ **Start listening to chats**
    _service.listenForChats(userId);

    // ✅ **Subscribe to `chatsStream` to auto-update UI**
    _chatSubscription = _service.chatsStream.listen((chats) {
      _allChats = chats;
      if (!_chatsController.isClosed) {
        _chatsController.add(chats);
      }
    });
  }

  /// **Search chats by query**
  void searchChats(String query) {
    if (query.isEmpty) {
      if (!_chatsController.isClosed) {
        _chatsController.add(_allChats);
      }
    } else {
      List<P2PChat> filteredChats = _allChats
          .where((chat) => chat.alias!.toLowerCase().contains(query.toLowerCase()))
          .toList();
      if (!_chatsController.isClosed) {
        _chatsController.add(filteredChats);
      }
    }
  }

  /// **Dispose all subscriptions**
  void dispose() {
    _chatSubscription?.cancel();
    _chatsController.close();
    _service.dispose();
  }
}
