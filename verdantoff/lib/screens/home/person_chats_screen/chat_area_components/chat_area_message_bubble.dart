import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../services/models/p2p_chat/p2p_message_model.dart';

class ChatAreaMessageBubble extends StatelessWidget {
  final P2PMessage message;
  final bool isMe;
  final String friendName;

  const ChatAreaMessageBubble({
    Key? key,
    required this.message,
    required this.isMe,
    required this.friendName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isRecalled = message.isRecalled;
    final isEdited = message.isEdited;

    // Extract initials from the friend's name for the avatar
    final avatarText = friendName.isNotEmpty
        ? friendName.trim().split(' ').map((e) => e[0]).take(2).join().toUpperCase()
        : '?';

    // Define colors for the message bubble
    final bubbleColor = isMe ? Colors.green[200] : Colors.grey[300];
    final textStyle = TextStyle(
      fontSize: 16.0,
      color: isMe ? Colors.black : Colors.blueGrey,
    );
    final recalledStyle = const TextStyle(
      fontSize: 16.0,
      fontStyle: FontStyle.italic,
      color: Colors.red,
    );
    final editedStyle = const TextStyle(
      fontSize: 12.0,
      color: Colors.grey,
      fontStyle: FontStyle.italic,
    );

    // Handle different message types
    Widget contentWidget;
    if (isRecalled) {
      contentWidget = Text(
        'This message has been recalled',
        style: recalledStyle,
      );
    } else if (message.fileMeta != null) {
      // File or image message
      contentWidget = _buildFilePreview(context, message);
    } else {
      // Text message
      contentWidget = Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              message.content,
              style: textStyle,
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ),
          if (isEdited)
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Text(
                'Edited',
                style: editedStyle,
              ),
            ),
        ],
      );
    }

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (!isMe)
              CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text(
                  avatarText,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: contentWidget,
            ),
            if (isMe)
              CircleAvatar(
                backgroundColor: Colors.green,
                child: const Icon(Icons.person, color: Colors.white),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilePreview(BuildContext context, P2PMessage message) {
    final fileMeta = message.fileMeta!;
    final url = fileMeta['url'] as String?;
    final fileType = fileMeta['fileType'] as String?;
    final fileName = fileMeta['fileName'] as String?;
    final fileSize = fileMeta['size'] as int?;

    if (url == null) return const SizedBox();

    // Image preview
    if (message.type == 'image') {
      return GestureDetector(
        onTap: () => _showFullImage(context, url),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 200, maxWidth: 200),
          margin: const EdgeInsets.only(bottom: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: url,
              placeholder: (context, url) => Container(
                color: Colors.grey[200],
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }

    // File preview
    return GestureDetector(
      onTap: () => _openFile(context, url),
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(_getFileIcon(fileType)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fileName ?? 'Unknown file',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (fileSize != null)
                    Text(
                      _formatFileSize(fileSize),
                      style: const TextStyle(fontSize: 12),
                    ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: () => _downloadFile(context, url, fileName),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getFileIcon(String? fileType) {
    if (fileType == null) return Icons.insert_drive_file;

    switch (fileType) {
      case 'pdf': return Icons.picture_as_pdf;
      case 'document': return Icons.description;
      case 'video': return Icons.videocam;
      default: return Icons.insert_drive_file;
    }
  }

  String _formatFileSize(int size) {
    if (size < 1024) return '$size B';
    if (size < 1048576) return '${(size / 1024).toStringAsFixed(1)} KB';
    return '${(size / 1048576).toStringAsFixed(1)} MB';
  }

  void _showFullImage(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 0.5,
          maxScale: 4.0,
          child: CachedNetworkImage(imageUrl: url),
        ),
      ),
    );
  }

  Future<void> _openFile(BuildContext context, String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open file')),
      );
    }
  }

  Future<void> _downloadFile(BuildContext context, String url, String? fileName) async {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(content: Text('Downloading ${fileName ?? 'file'}')),
    );

    // Actual download implementation would go here
    // For now, just open the file
    _openFile(context, url);
  }
}
