import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../group_profile/UI/group_profile_screen.dart';
import '../VM/group_search_vm.dart';

class GroupSearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GroupSearchViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Search Groups'),
        ),
        body: Consumer<GroupSearchViewModel>(
          builder: (context, vm, child) => Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: vm.searchController,
                  decoration: InputDecoration(
                    hintText: 'Enter group name or group code',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: vm.searchGroups,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: vm.isLoading
                    ? Center(child: CircularProgressIndicator())
                    : vm.searchResults.isEmpty
                    ? Center(child: Text('No groups found.'))
                    : ListView.builder(
                  itemCount: vm.searchResults.length,
                  itemBuilder: (context, index) {
                    final group = vm.searchResults[index];
                    return ListTile(
                      leading: Icon(Icons.group),
                      title: Text(group.name),
                      subtitle: Text('Code: ${group.groupCode}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => GroupProfileScreen(groupId: group.groupId),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
