import 'package:flutter/material.dart';
import '../Show_User_Info_To_People/Show_User_Info_To_People_Screen.dart';
import 'FriendOperationScreen_Functions/FriendOperationScreen_Functions_EditAlias.dart';

class FriendOperationScreen extends StatelessWidget {
  final String friendName;
  final String friendId;

  const FriendOperationScreen({
    Key? key,
    required this.friendName,
    required this.friendId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friend Operations'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('View Friend Info'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShowUserInfoToPeopleScreen(userId: friendId),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit Friend Alias'),
            onTap: () {
              showEditAliasDialog(context, friendId, friendName);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Delete Friend(todo)'),
            onTap: () {
              print('Delete Friend');
            },
          ),
          ListTile(
            leading: const Icon(Icons.archive),
            title: const Text('Export Chat History(todo)'),
            onTap: () {
              print('Export Chat History');
            },
          ),
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text('Search Chat History(todo)'),
            onTap: () {
              print('Search Chat History');
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications_active),
            title: const Text('Set Force Notification(todo)'),
            onTap: () {
              print('Set Force Notification');
            },
          ),
        ],
      ),
    );
  }
}
