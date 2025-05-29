import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import '../../../services/models/p2p_chat/p2p_chat_model.dart';
import '../../../services/models/G2G_chat/GroupChats_DisplayOnChatsList.dart';

class ChatListScreenService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // --- P2P Chat Stream ---
  final StreamController<List<P2PChat>> _chatsController = StreamController<List<P2PChat>>.broadcast();
  Stream<List<P2PChat>> get chatsStream => _chatsController.stream;
  StreamSubscription? _chatsSubscription;
  List<P2PChat> _latestChats = [];
  Map<String, String> _aliasCache = {};

  // --- Group Chat Stream ---
  final StreamController<List<GroupChatDisplayModel>> _groupChatsController = StreamController<List<GroupChatDisplayModel>>.broadcast();
  Stream<List<GroupChatDisplayModel>> get groupChatsStream => _groupChatsController.stream;
  StreamSubscription? _groupChatsSubscription;
  List<GroupChatDisplayModel> _latestGroupChats = [];

  /// ------------------ P2P CHATS ------------------
  void listenForChats(String userId) {
    if (_chatsSubscription != null) return;

    _chatsSubscription = _firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .listen((querySnapshot) async {
      _latestChats = await Future.wait(querySnapshot.docs.map((doc) async {
        P2PChat chat = P2PChat.fromMap(doc.id, doc.data());
        bool isRecalled = chat.lastMessage['isRecalled'] ?? false;
        String lastMessageContent = isRecalled
            ? 'This message has been recalled.'
            : chat.lastMessage['content'] ?? 'No messages yet';

        String friendId = chat.participants.firstWhere((id) => id != userId, orElse: () => '');
        String alias = await _fetchAlias(userId, friendId);

        return chat.copyWith(
          alias: alias,
          lastMessage: {'content': lastMessageContent},
        );
      }).toList());

      _updateChatList();
    });
  }

  Future<String> _fetchAlias(String userId, String friendId) async {
    if (_aliasCache.containsKey(friendId)) return _aliasCache[friendId]!;

    try {
      final friendDoc = await _firestore.collection('friends').doc(userId).get();
      final data = friendDoc.data() as Map<String, dynamic>?;
      final list = data?['friends'] as List?;
      if (list != null) {
        final friend = list.firstWhere((f) => f['friendId'] == friendId, orElse: () => null);
        if (friend != null) {
          final alias = friend['alias'] ?? 'Unknown';
          _aliasCache[friendId] = alias;
          return alias;
        }
      }
    } catch (e) {
      print('[ERROR] fetchAlias failed: $e');
    }
    return 'Unknown';
  }

  void _updateChatList() {
    if (!_chatsController.isClosed) {
      _chatsController.add(List.from(_latestChats));
    }
  }

  /// ------------------ GROUP CHATS ------------------
  void listenForGroupChats(String userId) {
    if (_groupChatsSubscription != null) return;

    _groupChatsSubscription = _firestore
        .collection('groups')
        .where('roles.$userId', isNotEqualTo: null)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .listen((querySnapshot) async {
      _latestGroupChats = await Future.wait(querySnapshot.docs.map((doc) async {
        final data = doc.data();
        final lastMsg = data['lastMessage'] ?? {};
        final groupName = data['name'] ?? 'Unnamed Group';
        final unread = await _getUnreadCount(doc.id, userId);

        return GroupChatDisplayModel(
          groupId: doc.id,
          groupName: groupName,
          lastMessageContent: lastMsg['isRecalled'] == true ? 'Message recalled' : lastMsg['content'] ?? '',
          lastMessageSenderName: lastMsg['senderName'] ?? '',
          updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
          unreadCount: unread,
          isLastMessageRecalled: lastMsg['isRecalled'] == true,
        );

      }).toList());

      _updateGroupChatList();
    });
  }

  Future<int> _getUnreadCount(String groupId, String userId) async {
    final doc = await _firestore.collection('groups').doc(groupId).collection('members').doc(userId).get();
    return doc['unreadCount'] ?? 0;
  }

  void _updateGroupChatList() {
    if (!_groupChatsController.isClosed) {
      _groupChatsController.add(List.from(_latestGroupChats));
    }
  }

  void dispose() {
    _chatsSubscription?.cancel();
    _chatsController.close();
    _groupChatsSubscription?.cancel();
    _groupChatsController.close();
  }
}
