import 'package:flutter/material.dart';

class BottomInput extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSendMessage;

  const BottomInput({
    Key? key,
    required this.controller,
    required this.onSendMessage,
  }) : super(key: key);

  @override
  _BottomInputState createState() => _BottomInputState();
}

class _BottomInputState extends State<BottomInput> {
  bool _hasText = false; // Determine if input has text

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
    setState(() {
      _hasText = widget.controller.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.mic, color: Colors.green),
            onPressed: () {
              // Placeholder for voice message
              print('Voice message button clicked');
            },
          ),
          Expanded(
            child: TextField(
              controller: widget.controller,
              decoration: const InputDecoration(
                hintText: 'Type a message...',
                border: InputBorder.none,
              ),
              onTap: () {
                // Show the keyboard
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.emoji_emotions, color: Colors.green),
            onPressed: () {
              // Placeholder for emoji picker
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
              widget.onSendMessage();
              widget.controller.clear();
            }
                : () {
              _showExtraOptions(context);
            },
          ),
        ],
      ),
    );
  }

  /// Shows extra options like camera, image, file, and location.
  void _showExtraOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
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
        );
      },
    );
  }

  /// Builds individual extra option icons.
  Widget _buildExtraOption(IconData icon, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 30.0,
          child: Icon(icon, size: 24.0, color: Colors.white),
          backgroundColor: Colors.green,
        ),
        const SizedBox(height: 8.0),
        Text(label, style: const TextStyle(fontSize: 14.0)),
      ],
    );
  }
}
