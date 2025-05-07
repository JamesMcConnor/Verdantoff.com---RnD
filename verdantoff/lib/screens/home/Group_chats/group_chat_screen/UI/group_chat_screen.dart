import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../VM/group_chat_vm.dart';
import 'group_chat_header.dart';
import 'group_chat_messages.dart';
import 'group_chat_input.dart';

class GroupChatScreen extends StatelessWidget {
  final String groupId;
  final String groupName;

  GroupChatScreen({required this.groupId, required this.groupName});


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GroupChatViewModel(groupId),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              GroupChatHeader(),
              Expanded(child: GroupChatMessages()),
              GroupChatInput(),
            ],
          ),
        ),
      ),
    );
  }
}
