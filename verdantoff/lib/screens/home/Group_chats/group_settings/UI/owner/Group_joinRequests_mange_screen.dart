import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../VM/owner/Group_joinRequests_mange_vm.dart';

class GroupJoinRequestsManageScreen extends StatelessWidget {
  final String groupId;

  GroupJoinRequestsManageScreen({required this.groupId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GroupJoinRequestsManageVM(groupId),
      child: Scaffold(
        appBar: AppBar(title: Text('Join Requests')),
        body: Consumer<GroupJoinRequestsManageVM>(
          builder: (context, vm, _) {
            if (vm.isLoading) return Center(child: CircularProgressIndicator());
            return ListView.builder(
              itemCount: vm.requests.length,
              itemBuilder: (context, index) {
                final req = vm.requests[index];
                return ListTile(
                  leading: CircleAvatar(backgroundImage: NetworkImage(req.avatar)),
                  title: Text(req.username),
                  subtitle: Text(req.requestedAt.toLocal().toString()),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: Icon(Icons.check), color: Colors.green, onPressed: () => vm.approve(req.userId)),
                      IconButton(icon: Icon(Icons.close), color: Colors.red, onPressed: () => vm.reject(req.userId)),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
