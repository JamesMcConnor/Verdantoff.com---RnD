import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:verdantoff/services/G2G_chat/G2G_service.dart';

class EditGroupAnnouncementScreen extends StatelessWidget {
final String groupId;
final TextEditingController controller = TextEditingController();
final G2GService _g2gService = G2GService();
final currentUserId = FirebaseAuth.instance.currentUser!.uid;

EditGroupAnnouncementScreen({required this.groupId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Group Announcement')),
      body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(children: [
            TextField(controller: controller),
            SizedBox(height: 20),
          ElevatedButton(
              onPressed: ()async{
                await _g2gService.updateGroupAnnouncement(groupId, controller.text, currentUserId);
                Navigator.pop(context);

          },
            child: Text('Save'),
          ),
        ]),
      ),
    );
  }
}