import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Chat_logic/chat_state_manager.dart';

class BottomInput extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSendMessage;
  final Future<void> Function() onStartVoiceCall;
  final Future<void> Function()? onStartVideoCall;
  final VoidCallback onSendImage;
  final VoidCallback onSendFile;

  const BottomInput({
    Key? key,
    required this.controller,
    required this.onSendMessage,
    required this.onStartVoiceCall,
    this.onStartVideoCall,
    required this.onSendImage,
    required this.onSendFile,
  }) : super(key: key);

  @override
  _BottomInputState createState() => _BottomInputState();
}

class _BottomInputState extends State<BottomInput> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() => _hasText = widget.controller.text.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    final chatStateManager = Provider.of<ChatStateManager>(context, listen: true);

    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Column(
        children: [
          ValueListenableBuilder<double?>(
            valueListenable: chatStateManager.uploadProgress,
            builder: (context, progress, _) {
              return progress != null
                  ? LinearProgressIndicator(value: progress)
                  : const SizedBox();
            },
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  decoration: const InputDecoration(
                    hintText: 'Type a message...',
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(_hasText ? Icons.send : Icons.add, color: Colors.green),
                onPressed: _hasText
                    ? () {
                  widget.onSendMessage();
                  widget.controller.clear();
                }
                    : () => _showExtraOptions(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showExtraOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 250,
          padding: const EdgeInsets.all(16),
          child: GridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: [
              _buildExtraOption(Icons.image, 'Gallery', onTap: widget.onSendImage),
              _buildExtraOption(Icons.attach_file, 'File', onTap: widget.onSendFile),
              _buildExtraOption(Icons.videocam, 'Video Call', onTap: () async {
                Navigator.pop(context);
                if (widget.onStartVideoCall != null) {
                  await widget.onStartVideoCall!();
                }
              }),
              _buildExtraOption(Icons.phone, 'Voice Call', onTap: () async {
                Navigator.pop(context);
                await widget.onStartVoiceCall();
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildExtraOption(IconData icon, String label, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.green,
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
