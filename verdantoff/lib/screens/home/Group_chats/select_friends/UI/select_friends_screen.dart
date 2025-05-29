import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Get_Friend_List_Service.dart';
import '../VM/select_friends_vm.dart';

class SelectFriendsScreen extends StatelessWidget {
  final List<Friend> initialSelected;

  SelectFriendsScreen({required this.initialSelected});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SelectFriendsViewModel(initialSelected),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Select Friends'),
        ),
        body: Consumer<SelectFriendsViewModel>(
          builder: (context, vm, child) {
            if (vm.isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: vm.friends.length,
                    itemBuilder: (context, index) {
                      final friend = vm.friends[index];
                      final isSelected = vm.isSelected(friend);
                      return CheckboxListTile(
                        title: Text(friend.alias),
                        value: isSelected,
                        onChanged: (selected) {
                          vm.toggleFriendSelection(friend);
                        },
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  child: Text('Confirm'),
                  onPressed: () {
                    Navigator.pop(context, vm.selectedFriends);
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
