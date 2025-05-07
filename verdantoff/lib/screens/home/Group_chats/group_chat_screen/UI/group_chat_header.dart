import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../group_settings/UI/group_settings_screen_mangement.dart';
import '../VM/group_chat_vm.dart';

class GroupChatHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<GroupChatViewModel>(context);
    return Container(
      color: Colors.blueAccent,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              vm.groupName,
              style: TextStyle(fontSize: 20, color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => GroupSettingsScreenManagement(
                groupId:vm.groupId,



              ),
              ),
              );
            },
          ),
        ],
      ),
    );
  }
}
