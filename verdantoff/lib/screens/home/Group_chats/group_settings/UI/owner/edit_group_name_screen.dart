import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../../../services/G2G_chat/G2G_service.dart';

class EditGroupNameScreen extends StatelessWidget {
  final String groupId;
  final TextEditingController controller = TextEditingController();
  final G2GService _g2gService = G2GService();
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;

  EditGroupNameScreen({required this.groupId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Group Name')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(children: [
          TextField(controller: controller),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              await _g2gService.setGroupName(groupId, controller.text, currentUserId);
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ]),
      ),
    );
  }
}
