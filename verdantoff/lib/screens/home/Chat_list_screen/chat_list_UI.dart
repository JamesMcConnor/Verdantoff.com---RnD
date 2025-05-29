import 'package:flutter/material.dart';
import '../Chat_list_screen/chat_list_screen_controller.dart';
import 'chat_list_item_UI.dart';
import 'group_chat_list_item_UI.dart';
import '../../../services/models/p2p_chat/p2p_chat_model.dart';
import '../../../services/models/G2G_chat/GroupChats_DisplayOnChatsList.dart';

class ChatListUI extends StatelessWidget {
  final ChatListScreenController controller;

  const ChatListUI({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<P2PChat>>(
      stream: controller.chatsStream,
      builder: (context, p2pSnapshot) {
        return StreamBuilder<List<GroupChatDisplayModel>>(
          stream: controller.groupChatsStream,
          builder: (context, groupSnapshot) {
            if (p2pSnapshot.connectionState == ConnectionState.waiting ||
                groupSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final p2pChats = p2pSnapshot.data ?? [];
            final groupChats = groupSnapshot.data ?? [];

            // Merge chats and sort by update time
            final combinedList = [
              ...p2pChats.map((chat) => {'type': 'p2p', 'data': chat}),
              ...groupChats.map((chat) => {'type': 'group', 'data': chat}),
            ];

            combinedList.sort((a, b) {
              final aData = a['data'];
              final bData = b['data'];

              DateTime aTime;
              DateTime bTime;

              if (aData is P2PChat) {
                aTime = aData.updatedAt;
              } else if (aData is GroupChatDisplayModel) {
                aTime = aData.updatedAt;
              } else {
                aTime = DateTime.fromMillisecondsSinceEpoch(0);
              }

              if (bData is P2PChat) {
                bTime = bData.updatedAt;
              } else if (bData is GroupChatDisplayModel) {
                bTime = bData.updatedAt;
              } else {
                bTime = DateTime.fromMillisecondsSinceEpoch(0);
              }

              return bTime.compareTo(aTime); // 按时间降序
            });



            if (combinedList.isEmpty) {
              return const Center(child: Text("No chats available"));
            }

            return ListView.builder(
              itemCount: combinedList.length,
              itemBuilder: (context, index) {
                final item = combinedList[index];
                if (item['type'] == 'p2p') {
                  return ChatListItemUI(chat: item['data'] as P2PChat);
                } else {
                  return GroupChatListItemUI(groupChat: item['data'] as GroupChatDisplayModel);
                }
              },
            );
          },
        );
      },
    );
  }
}
