import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  final String title; // 标题文字
  final VoidCallback onNotificationTap; // 铃铛按钮点击事件

  const TopBar({
    required this.title,
    required this.onNotificationTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: Colors.green, // 背景颜色
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.black, // 字体颜色
            ),
          ),
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: onNotificationTap, // 铃铛点击事件
          ),
        ],
      ),
    );
  }
}
