import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart'; // 确保这行导入存在
import 'Chat_logic/chat_state_manager.dart'; // 确保这行导入存在

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
    // 获取 ChatStateManager 实例
    final chatStateManager = Provider.of<ChatStateManager>(context, listen: true);

    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Column(
        children: [
          // Upload progress indicator - 使用从 provider 获取的实例
          ValueListenableBuilder<double?>(
            valueListenable: chatStateManager.uploadProgress, // 使用获取的实例
            builder: (context, progress, _) {
              return progress != null
                  ? LinearProgressIndicator(value: progress)
                  : const SizedBox();
            },
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.mic, color: Colors.green),
                onPressed: () => print('Voice message button clicked'),
              ),
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
                icon: const Icon(Icons.emoji_emotions, color: Colors.green),
                onPressed: () => print('Emoji picker button clicked'),
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
              _buildExtraOption(Icons.camera_alt, 'Camera', onTap: _takePhoto),
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
              _buildExtraOption(Icons.location_on, 'Location'),
            ],
          ),
        );
      },
    );
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await ImagePicker().pickImage(source: ImageSource.camera);
      if (photo != null) {
        // 这里应该调用发送图片的方法
        // 例如: widget.onSendImage();
      }
    } catch (e) {
      print('[ERROR] Camera error: $e');
    }
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
