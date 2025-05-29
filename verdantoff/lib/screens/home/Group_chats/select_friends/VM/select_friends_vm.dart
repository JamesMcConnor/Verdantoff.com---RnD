import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../Get_Friend_List_Service.dart';

class SelectFriendsViewModel extends ChangeNotifier {
  final FriendService _friendService = FriendService();
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  List<Friend> friends = [];
  List<Friend> selectedFriends = [];
  bool isLoading = false;

  SelectFriendsViewModel(List<Friend> initialSelected) {
    selectedFriends = List.from(initialSelected);
    fetchFriends();
  }

  Future<void> fetchFriends() async {
    isLoading = true;
    notifyListeners();

    friends = await _friendService.getFriendsList(currentUserId);

    print("Fetched friends: ${friends.length}");
    for (var friend in friends) {
      print("Friend ID: ${friend.friendId}, Alias: ${friend.alias}");
    }

    isLoading = false;
    notifyListeners();
  }

  void toggleFriendSelection(Friend friend) {
    if (isSelected(friend))
      selectedFriends.removeWhere((f) => f.friendId == friend.friendId);
    else
      selectedFriends.add(friend);

    notifyListeners();
  }

  bool isSelected(Friend friend) {
    return selectedFriends.any((f) => f.friendId == friend.friendId);
  }
}
