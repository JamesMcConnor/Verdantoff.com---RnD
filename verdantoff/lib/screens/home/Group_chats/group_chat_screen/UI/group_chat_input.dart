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
          IconButton(
            icon: const Icon(Icons.mic, color: Colors.green),
            onPressed: () {
              print('Voice message button clicked');
            },
          ),
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
            icon: const Icon(Icons.emoji_emotions, color: Colors.green),
            onPressed: () {
              print('Emoji picker button clicked');
            },
          ),
          IconButton(
            icon: Icon(
              _hasText ? Icons.send : Icons.add,
              color: Colors.green,
            ),
            onPressed: _hasText
                ? () {
              vm.sendTextMessage();
              vm.messageController.clear();
            }
                : () => _showExtraOptions(context),
          ),
        ],
      ),
    );
  }

  void _showExtraOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        height: 250.0,
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          children: [
            _buildExtraOption(Icons.camera_alt, 'CameraTD'),
            _buildExtraOption(Icons.image, 'ImageTD'),
            _buildExtraOption(Icons.attach_file, 'FileTD'),
            _buildExtraOption(Icons.videocam, 'Video CallTD'),
            _buildExtraOption(Icons.phone, 'Voice CallTD'),
            _buildExtraOption(Icons.location_on, 'LocationTD'),
          ],
        ),
      ),
    );
  }

  Widget _buildExtraOption(IconData icon, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 30.0,
          backgroundColor: Colors.green,
          child: Icon(icon, size: 24.0, color: Colors.white),
        ),
        const SizedBox(height: 8.0),
        Text(label, style: const TextStyle(fontSize: 14.0)),
      ],
    );
  }
}
