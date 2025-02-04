import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import '../../../services/models/p2p_chat/p2p_chat_model.dart';

class ChatListScreenService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, String> _aliasCache = {}; // Cache to avoid redundant queries

  /// ✅ **StreamController for UI updates**
  final StreamController<List<P2PChat>> _chatsController =
  StreamController<List<P2PChat>>.broadcast();

  Stream<List<P2PChat>> get chatsStream => _chatsController.stream;

  StreamSubscription<QuerySnapshot>? _chatsSubscription;
  List<P2PChat> _latestChats = [];

  /// **Listen for chat updates from Firestore**
  void listenForChats(String userId) {
    if (_chatsSubscription != null) {
      return; // **Prevent duplicate listeners**
    }

    _chatsSubscription = _firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .listen((querySnapshot) async {
      _latestChats = await Future.wait(querySnapshot.docs.map((doc) async {
        P2PChat chat = P2PChat.fromMap(doc.id, doc.data());

        // Check if lastMessage is withdrawn
        bool isRecalled = chat.lastMessage['isRecalled'] ?? false;
        String lastMessageContent =
        isRecalled ? 'This message has been recalled.' : chat.lastMessage['content'] ?? 'No messages yet';

        // Get a friend's ID
        String friendId = chat.participants.firstWhere(
              (id) => id != userId,
          orElse: () => '',
        );

        // Get a friend's alias
        String alias = await _fetchAlias(userId, friendId);

        return chat.copyWith(
          alias: alias,
          lastMessage: {'content': lastMessageContent},
        );
      }).toList());

      _updateChatList();
    });
  }

  /// Get a friend's alias
  Future<String> _fetchAlias(String userId, String friendId) async {
    if (_aliasCache.containsKey(friendId)) {
      return _aliasCache[friendId]!; //Using Cache
    }

    try {
      DocumentSnapshot friendDoc = await _firestore.collection('friends').doc(userId).get();
      Map<String, dynamic>? friendData = friendDoc.data() as Map<String, dynamic>?;

      if (friendData != null && friendData['friends'] is List) {
        var friend = friendData['friends'].firstWhere(
              (f) => f['friendId'] == friendId,
          orElse: () => null,
        );
        if (friend != null) {
          String alias = friend['alias'] ?? 'Unknown';
          _aliasCache[friendId] = alias; // **缓存 alias**
          return alias;
        }
      }
    } catch (e) {
      print('[ERROR] Failed to fetch alias: $e');
    }
    return 'Unknown';
  }

  /// Update chat list
  void _updateChatList() {
    if (!_chatsController.isClosed) {
      _chatsController.add(List.from(_latestChats));
    }
  }

  /// Release resources
  void dispose() {
    _chatsSubscription?.cancel();
    _chatsController.close();
  }
}
