import 'package:cloud_firestore/cloud_firestore.dart';

class FriendService {
  final CollectionReference friendsCollection =
  FirebaseFirestore.instance.collection('friends');


  Future<List<Friend>> getFriendsList(String userId) async {
    final friendDoc = await friendsCollection.doc(userId).get();

    final friendData = friendDoc.data() as Map<String, dynamic>?;
    final friendsData = friendData?['friends'] as List<dynamic>?;

    if (friendsData == null) return [];

    return friendsData
        .map((friendMap) => Friend.fromMap(friendMap as Map<String, dynamic>))
        .toList();
  }
}

class Friend {
  final String friendId;
  final String alias;
  final String status;
  final String addedAt;

  Friend({
    required this.friendId,
    required this.alias,
    required this.status,
    required this.addedAt,
  });

  factory Friend.fromMap(Map<String, dynamic> data) {
    return Friend(
      friendId: data['friendId'],
      alias: data['alias'],
      status: data['status'],
      addedAt: data['addedAt'],
    );
  }
}
