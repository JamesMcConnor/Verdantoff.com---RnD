import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../settings/edit_profile/edit_profile_screen.dart';
import 'me_view_model.dart';

/// UI for the profile (“Me”) tab – now **stateless**,
/// all business logic lives in MeViewModel.
class MeScreen extends StatelessWidget {
  const MeScreen({Key? key}) : super(key: key);

  // ────────────────────────────────────────────────────────────────────────────
  // Helpers – small private widgets
  // ────────────────────────────────────────────────────────────────────────────
  Widget _avatar(Map<String, dynamic> data) {
    final avatarUrl = data['avatar'] as String?;
    return CircleAvatar(
      radius: 50,
      backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
          ? NetworkImage(avatarUrl)
          : null,
      child: avatarUrl == null || avatarUrl.isEmpty
          ? const Icon(Icons.person, size: 50)
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MeViewModel()..load(),
      child: Consumer<MeViewModel>(
        builder: (context, vm, _) {
          final data = vm.userDoc?.data() as Map<String, dynamic>?;

          return Scaffold(
            appBar: AppBar(title: const Text('My profile')),
            body: vm.isBusy
                ? const Center(child: CircularProgressIndicator())
                : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (data != null) ...[
                    _avatar(data),
                    const SizedBox(height: 16),
                    Text(
                      data['userName'] ?? 'Username',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      data['email'] ?? '',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ] else
                    const Text('Unable to load user data'),

                  const SizedBox(height: 32),

                  // ───── menu items ─────
                  ListTile(
                    leading:
                    const Icon(Icons.edit, color: Colors.blueAccent),
                    title: const Text('Edit profile'),
                    onTap: () async {
                      final updated = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const EditProfileScreen()),
                      );
                      if (updated == true) vm.load();
                    },
                  ),
                  ListTile(
                    leading:
                    const Icon(Icons.logout, color: Colors.orange),
                    title: const Text('Sign-out'),
                    onTap: () async {
                      await vm.signOut();
                      if (!context.mounted) return;
                      Navigator.pushReplacementNamed(
                          context, '/auth/login');
                    },
                  ),
                  ListTile(
                    leading:
                    const Icon(Icons.delete, color: Colors.redAccent),
                    title: const Text('Delete account'),
                    onTap: () async {
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Delete account'),
                          content: const Text(
                              'This action is irreversible. Continue?'),
                          actions: [
                            TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, false),
                                child: const Text('Cancel')),
                            TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, true),
                                child: const Text('Delete',
                                    style:
                                    TextStyle(color: Colors.red))),
                          ],
                        ),
                      );

                      if (ok != true) return;
                      final success = await vm.deleteAccount();
                      if (!context.mounted) return;

                      Navigator.pushReplacementNamed(
                          context, '/auth/login');

                      if (!success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Couldn’t delete account – please sign in again and retry.')),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
