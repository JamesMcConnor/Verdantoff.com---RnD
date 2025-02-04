import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendsTab extends StatefulWidget {
  @override
  _FriendsTabState createState() => _FriendsTabState();
}

class _FriendsTabState extends State<FriendsTab> {
  final ScrollController _scrollController = ScrollController();

  /// Scroll to a specific letter section
  void _scrollToLetter(String letter, List<String> keys) {
    final index = keys.indexOf(letter);
    if (index >= 0) {
      final offset = index * 50.0;
      _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Center(child: Text('You need to log in to view friends.'));
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('friends').doc(currentUser.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.data() == null) {
          return _buildFriendsView({}, false); // No friends data
        }

        final friendsData = snapshot.data!.data() as Map<String, dynamic>;
        final friends = friendsData['friends'] as List<dynamic>? ?? [];
        final groupedFriends = _groupFriendsByLetter(friends);

        return _buildFriendsView(groupedFriends, friends.isNotEmpty);
      },
    );
  }

  Widget _buildFriendsView(Map<String, List<Map<String, dynamic>>> groupedFriends, bool hasFriends) {
    final keys = groupedFriends.keys.toList();
    final itemCount = hasFriends ? groupedFriends.keys.length + 3 : 4;

    return Stack(
      children: [
        ListView.builder(
          controller: _scrollController,
          itemCount: itemCount,
          itemBuilder: (context, index) {
            if (index == 0) {
              return _buildTopButton(
                icon: Icons.person_add,
                text: 'New Friends',
                onTap: () {
                  Navigator.pushNamed(context, '/user-search');
                },
              );
            } else if (index == 1) {
              return _buildTopButton(
                icon: Icons.group_add,
                text: 'New Group',
                onTap: () {},
              );
            } else if (index == 2) {
              return _buildTopButton(
                icon: Icons.settings,
                text: 'Custom Server',
                onTap: () {},
              );
            } else if (!hasFriends && index == 3) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text('No friends yet. Add some new friends!',
                      style: TextStyle(fontSize: 16, color: Colors.grey)),
                ),
              );
            } else {
              final letter = keys[index - 3];
              final friendsList = groupedFriends[letter]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    color: Colors.grey[200],
                    child: Text(
                      letter,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ...friendsList.map((friend) {
                    final friendName = friend['alias'] ?? 'Unknown';
                    final friendId = friend['friendId'] ?? '';

                    return ListTile(
                      title: Text(friendName),
                      leading: CircleAvatar(child: Text(friendName[0])),
                      onTap: () => _navigateToChat(friendId, friendName),
                    );
                  }).toList(),
                ],
              );
            }
          },
        ),
        Positioned(
          right: 0,
          top: 10,
          bottom: 10,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: keys.map((letter) {
              return GestureDetector(
                onTap: () => _scrollToLetter(letter, keys),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(letter,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  /// Navigate to the chat screen, ensuring `chatId` is created or fetched
  Future<void> _navigateToChat(String friendId, String friendName) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || friendId.isEmpty) return;

    try {
      final chatQuery = await FirebaseFirestore.instance
          .collection('chats')
          .where('participants', arrayContains: currentUser.uid)
          .get();

      String? chatId;

      for (var doc in chatQuery.docs) {
        final participants = List<String>.from(doc['participants']);
        if (participants.contains(friendId)) {
          chatId = doc.id;
          break;
        }
      }

      // If `chatId` doesn't exist, create a new chat
      chatId ??= await FirebaseFirestore.instance.collection('chats').add({
        'type': 'direct',
        'participants': [currentUser.uid, friendId],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'lastMessage': {},
        'unreadCounts': {currentUser.uid: 0, friendId: 0},
      }).then((doc) => doc.id);

      // Navigate to chat screen with `chatId`
      Navigator.pushNamed(
        context,
        '/person_chats_screen',
        arguments: {
          'chatId': chatId,
          'friendName': friendName,
          'friendId': friendId,
        },
      );
    } catch (e) {
      print('[ERROR] Failed to navigate to chat: $e');
    }
  }

  /// Groups friends by the first letter of their alias.
  Map<String, List<Map<String, dynamic>>> _groupFriendsByLetter(List<dynamic> friends) {
    final Map<String, List<Map<String, dynamic>>> grouped = {};
    for (var friend in friends) {
      final alias = friend['alias'] ?? 'Unknown';
      final letter = alias[0].toUpperCase();
      if (!grouped.containsKey(letter)) {
        grouped[letter] = [];
      }
      grouped[letter]!.add(friend);
    }
    return grouped;
  }

  Widget _buildTopButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      onTap: onTap,
    );
  }
}
