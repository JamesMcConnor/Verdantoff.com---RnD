import 'package:flutter/material.dart';
import '../../../../../services/models/p2p_chat/p2p_message_model.dart';

class ChatAreaMessageBubble extends StatelessWidget {
  final P2PMessage message; // The message data model
  final bool isMe; // Indicates if the message is sent by the current user
  final String friendName; // The friend's display name

  const ChatAreaMessageBubble({
    Key? key,
    required this.message,
    required this.isMe,
    required this.friendName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isRecalled = message.isRecalled; // Check if the message was recalled
    final isEdited = message.isEdited; // Check if the message was edited

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

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Display friend's avatar if the message is from them
          if (!isMe)
            CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text(
                avatarText,
                style: const TextStyle(color: Colors.white),
              ),
            ),

          // Wrap message bubble inside IntrinsicWidth to fit content dynamically
          IntrinsicWidth(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75, // Limit message bubble width
              ),
              margin: const EdgeInsets.symmetric(
                vertical: 4.0,
                horizontal: 8.0,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display the message text
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end, // Align text and "Edited" label properly
                    mainAxisSize: MainAxisSize.min, // Ensure Row only takes as much space as needed
                    children: [
                      Flexible(
                        child: Text(
                          isRecalled
                              ? 'This message has been recalled'
                              : (message.content ?? 'No content available'),
                          style: isRecalled ? recalledStyle : textStyle,
                          softWrap: true, // Allow text to wrap
                          overflow: TextOverflow.visible, // Ensure text is fully visible
                        ),
                      ),
                      if (isEdited) // Show "Edited" label if the message has been edited
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Text(
                            'Edited',
                            style: editedStyle,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Display the user's avatar if the message is from them
          if (isMe)
            CircleAvatar(
              backgroundColor: Colors.green,
              child: const Icon(Icons.person, color: Colors.white),
            ),
        ],
      ),
    );
  }
}
