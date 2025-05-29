import 'dart:async';
import '../../../services/models/p2p_chat/p2p_chat_model.dart';
import '../../../services/models/G2G_chat/GroupChats_DisplayOnChatsList.dart';
import 'chat_list_screen_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatListScreenController {
  final ChatListScreenService _service = ChatListScreenService();

  // P2P chat control
  final StreamController<List<P2PChat>> _chatsController = StreamController<List<P2PChat>>.broadcast();
  List<P2PChat> _allChats = [];
  StreamSubscription? _chatSubscription;

  // Group chat control
  final StreamController<List<GroupChatDisplayModel>> _groupChatsController = StreamController<List<GroupChatDisplayModel>>.broadcast();
  List<GroupChatDisplayModel> _allGroupChats = [];
  StreamSubscription? _groupChatSubscription;

  Stream<List<P2PChat>> get chatsStream => _service.chatsStream;
  Stream<List<GroupChatDisplayModel>> get groupChatsStream => _service.groupChatsStream;

  void loadChats() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    _service.listenForChats(userId);
    _chatSubscription = _service.chatsStream.listen((chats) {
      _allChats = chats;
      if (!_chatsController.isClosed) _chatsController.add(chats);
    });
  }

  void loadGroupChats() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    _service.listenForGroupChats(userId);
    _groupChatSubscription = _service.groupChatsStream.listen((groupChats) {
      _allGroupChats = groupChats;
      if (!_groupChatsController.isClosed) _groupChatsController.add(groupChats);
    });
  }

  void searchChats(String query) {
    if (query.isEmpty) {
      if (!_chatsController.isClosed) _chatsController.add(_allChats);
    } else {
      final filtered = _allChats
          .where((chat) => chat.alias!.toLowerCase().contains(query.toLowerCase()))
          .toList();
      if (!_chatsController.isClosed) _chatsController.add(filtered);
    }
  }

  void searchGroupChats(String query) {
    if (query.isEmpty) {
      if (!_groupChatsController.isClosed) _groupChatsController.add(_allGroupChats);
    } else {
      final filtered = _allGroupChats
          .where((group) => group.groupName.toLowerCase().contains(query.toLowerCase()))
          .toList();
      if (!_groupChatsController.isClosed) _groupChatsController.add(filtered);
    }
  }

  void dispose() {
    _chatSubscription?.cancel();
    _chatsController.close();
    _groupChatSubscription?.cancel();
    _groupChatsController.close();
    _service.dispose();
  }
}
