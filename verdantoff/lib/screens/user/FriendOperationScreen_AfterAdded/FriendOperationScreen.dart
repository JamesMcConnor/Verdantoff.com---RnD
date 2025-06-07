import 'package:flutter/material.dart';
import '../../../services/friend_requests/friend_manager_Delete.dart';
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

  /// 显示确认对话框并执行删除
  Future<void> _confirmAndDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Friend'),
        content: Text('Are you sure you want to delete "$friendName" from your friend list?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      try {
        await FriendManager().deleteFriend(friendId);
        // 删除成功后弹窗
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Success'),
              content: const Text('Friend deleted successfully.'),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop(); // 关闭成功弹窗
                    Navigator.of(context).pop(true); // 返回上一页，并可触发刷新
                  },
                ),
              ],
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Error'),
              content: Text('Failed to delete friend: $e'),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          );
        }
      }
    }
  }

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
            title: const Text('Delete Friend'),
            onTap: () => _confirmAndDelete(context),
          ),
        ],
      ),
    );
  }
}
