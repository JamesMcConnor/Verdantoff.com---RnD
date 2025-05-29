import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:verdantoff/screens/calls/person_video/person_video_vm.dart';
import '../widgets/display_name_avatar.dart';
import 'Person_video_active_page.dart';

/// Waiting screen for outgoing one-on-one video calls.
/// Plays ringtone and waits for the other party to answer.
/// Shows avatar, status, and hang up button.
class PersonVideoWaitingPage extends StatefulWidget {
  const PersonVideoWaitingPage({super.key});

  @override
  State<PersonVideoWaitingPage> createState() => _PersonVideoWaitingPageState();
}

class _PersonVideoWaitingPageState extends State<PersonVideoWaitingPage> {
  late final AudioPlayer _player; // Ringtone player
  bool _navigated = false;        // Prevents duplicate navigation

  @override
  void initState() {
    super.initState();
    // Start ringtone playback in loop mode
    _player = AudioPlayer()..setReleaseMode(ReleaseMode.loop);
    _player.play(AssetSource('audio/ringtone.mp3'));
  }

  @override
  void dispose() {
    // Stop and dispose ringtone player
    _player.stop();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PersonVideoVm>();
    final otherUid = vm.otherUid;

    // Listen for call status: navigate on answer/hangup
    return StreamBuilder<String>(
      stream: vm.callStatusStream,
      builder: (context, snapshot) {
        final status = snapshot.data ?? 'ringing';
        // Navigate to active call screen on answer
        if (status == 'active' && !_navigated) {
          _navigated = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => ChangeNotifierProvider.value(
                  value: vm,
                  child: const PersonVideoActivePage(),
                ),
              ),
            );
          });
        }
        // Auto-close if call is ended
        else if (status == 'ended' && !_navigated) {
          _navigated = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && Navigator.canPop(context)) Navigator.pop(context);
          });
        }

        // Waiting UI
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(backgroundColor: Colors.transparent),
          body: SafeArea(
            child: Column(
              children: [
                const Spacer(),
                // Show peer's avatar or fallback
                if (otherUid != null && otherUid.isNotEmpty)
                  DisplayNameAvatar(uid: otherUid, radius: 48)
                else
                  const _AvatarPlaceholder(),
                const SizedBox(height: 24),
                const Text(
                    'Waiting for video call...',
                    style: TextStyle(color: Colors.white70, fontSize: 20)
                ),
                const Spacer(),
                // Only hang up button shown
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _circleButton(
                      icon: Icons.call_end,
                      color: Colors.redAccent,
                      onTap: () async {
                        await vm.hangUp();
                        if (mounted && Navigator.canPop(context)) Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Helper: circular icon button for call controls.
  Widget _circleButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.black38,
      shape: const CircleBorder(),
      child: IconButton(
        icon: Icon(icon, color: color, size: 30),
        splashRadius: 30,
        onPressed: onTap,
      ),
    );
  }
}

/// Fallback avatar if peer info is missing.
class _AvatarPlaceholder extends StatelessWidget {
  const _AvatarPlaceholder();

  @override
  Widget build(BuildContext context) => CircleAvatar(
    radius: 48,
    backgroundColor: Colors.grey.shade800,
    child: const Icon(Icons.person, size: 48, color: Colors.white30),
  );
}
