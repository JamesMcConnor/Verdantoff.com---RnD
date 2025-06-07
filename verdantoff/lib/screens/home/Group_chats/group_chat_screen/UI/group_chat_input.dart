import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../VM/group_chat_vm.dart';

class GroupChatInput extends StatefulWidget {
  @override
  State<GroupChatInput> createState() => _GroupChatInputState();
}

class _GroupChatInputState extends State<GroupChatInput> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    final vm = Provider.of<GroupChatViewModel>(context, listen: false);
    vm.messageController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    final vm = Provider.of<GroupChatViewModel>(context, listen: false);
    vm.messageController.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    final vm = Provider.of<GroupChatViewModel>(context, listen: false);
    setState(() {
      _hasText = vm.messageController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<GroupChatViewModel>(context);

    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: vm.messageController,
              decoration: const InputDecoration(
                hintText: 'Type a message...',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.green),
            onPressed: _hasText
                ? () {
              vm.sendTextMessage();
              vm.messageController.clear();
            }
                : null,
          ),
        ],
      ),
    );
  }
}
