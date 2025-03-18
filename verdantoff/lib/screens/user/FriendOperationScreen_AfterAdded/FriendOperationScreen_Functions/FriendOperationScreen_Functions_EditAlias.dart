import 'package:flutter/material.dart';
import '../../../../services/friend_requests/edit_friend_alias_service.dart';

/// Displays a dialog for editing the friend's alias.
/// [context]: BuildContext for the dialog.
/// [friendId]: The unique identifier of the friend.
/// [currentAlias]: The current alias (nickname) of the friend.
Future<void> showEditAliasDialog(BuildContext context, String friendId, String currentAlias) async {
  final TextEditingController aliasController = TextEditingController(text: currentAlias);

  return showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Edit Friend Alias'),
        content: TextField(
          controller: aliasController,
          decoration: const InputDecoration(
            labelText: 'Current Alias',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newAlias = aliasController.text.trim();
              if (newAlias.isEmpty) {
                // Show error if the alias is empty
                await showDialog(
                  context: context,
                  builder: (alertContext) {
                    return AlertDialog(
                      title: const Text('Error'),
                      content: const Text('Alias cannot be empty.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(alertContext),
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
                return;
              }
              // Debug print to verify the new alias value
              print('New alias to update: $newAlias');
              try {
                await EditFriendAliasService.updateFriendAlias(friendId, newAlias);
                Navigator.pop(dialogContext); // Close the edit dialog
                // Show success alert dialog
                await showDialog(
                  context: context,
                  builder: (alertContext) {
                    return AlertDialog(
                      title: const Text('Success'),
                      content: const Text('Alias updated successfully. Please refresh the page to see new alias.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(alertContext),
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              } catch (e) {
                Navigator.pop(dialogContext); // Close the edit dialog
                // Show error alert dialog
                await showDialog(
                  context: context,
                  builder: (alertContext) {
                    return AlertDialog(
                      title: const Text('Error'),
                      content: const Text('Failed to update alias. Please check your network connection.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(alertContext),
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}