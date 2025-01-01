// The chat page displays the chat message list and the send message input box.
import 'package:flutter/material.dart';
import 'top_bar.dart'; // 引入顶部栏组件

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 搜索框
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search by name...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
        // 占位聊天内容
        Expanded(
          child: ListView.builder(
            itemCount: 10, // 示例条目数量
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: Text('User $index'),
                subtitle: Text('Last message...'),
                onTap: () {
                  // 跳转到聊天详情页面（未来实现）
                },
              );
            },
          ),
        ),
      ],
    );
  }
}