import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  final String friendName;
  final VoidCallback onBack;

  const TopBar({
    Key? key,
    required this.friendName,
    required this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      color: Colors.green,
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: onBack,
            ),
            Expanded(
              child: Center(
                child: Text(
                  friendName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.info_outline, color: Colors.white),
              onPressed: () {
                // Placeholder: Add logic to view chat info.
                print('Chat info clicked');
              },
            ),
          ],
        ),
      ),
    );
  }
}
