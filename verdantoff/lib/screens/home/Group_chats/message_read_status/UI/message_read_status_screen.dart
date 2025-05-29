import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../VM/message_read_status_vm.dart';

class MessageReadStatusScreen extends StatelessWidget {
  final String groupId;
  final String messageId;

  MessageReadStatusScreen({required this.groupId, required this.messageId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MessageReadStatusViewModel(groupId, messageId),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Read by'),
        ),
        body: Consumer<MessageReadStatusViewModel>(
          builder: (context, vm, child) {
            if (vm.isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (vm.readMembers.isEmpty) {
              return Center(child: Text('No one has read this message yet.'));
            }

            return ListView.builder(
              itemCount: vm.readMembers.length,
              itemBuilder: (context, index) {
                final member = vm.readMembers[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(member.avatarUrl),
                  ),
                  title: Text(member.nickname),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
