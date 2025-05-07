import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../VM/group_chat_vm.dart';
import 'gourp_chat_messages_actions_menu.dart';

class GroupChatMessages extends StatefulWidget {
  @override
  _GroupChatMessagesState createState() => _GroupChatMessagesState();
}

class _GroupChatMessagesState extends State<GroupChatMessages> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<GroupChatViewModel>(context);
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;


    WidgetsBinding.instance.addPostFrameCallback((_) {
      vm.markMessagesAsRead(currentUserId);
      scrollToBottom();
    });

    return ListView.builder(
      controller: _scrollController,
      itemCount: vm.messages.length,
      itemBuilder: (context, index) {
        final msg = vm.messages[index];
        final isMine = msg.senderId == currentUserId;

        return Align(
          alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
          child: GestureDetector(
            onLongPress: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext bottomSheetContext) => ChangeNotifierProvider.value(
                  value: vm,
                  child: GroupChatMessagesActionsMenu(
                    groupId: vm.groupId,
                    message: msg,
                    isMine: isMine,
                  ),
                ),
              );
            },
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isMine ? Colors.blue[200] : Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment:
                isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment:
                    isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: [
                      if (!isMine) ...[
                        CircleAvatar(
                          radius: 15,
                          backgroundImage: NetworkImage(msg.senderAvatar),
                        ),
                        SizedBox(width: 6),
                        Text(
                          msg.senderNickname,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ] else ...[
                        Text(
                          msg.senderNickname,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 6),
                        CircleAvatar(
                          radius: 15,
                          backgroundImage: NetworkImage(msg.senderAvatar),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 6),
                  Text(
                    msg.isRecalled ? 'Message recalled' : msg.content,
                    style: TextStyle(
                      fontSize: 18,
                      fontStyle: msg.isRecalled ? FontStyle.italic : FontStyle.normal,
                      color: msg.isRecalled ? Colors.grey : Colors.black,
                    ),
                  ),
                  if (msg.isEdited && !msg.isRecalled)
                    Text('(Edited)', style: TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
