import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:verdantoff/screens/calls/person_video/person_video_vm.dart';
import '../widgets/display_name_avatar.dart';
import 'Person_video_active_page.dart';

/// Incoming call screen for one-on-one video calls.
/// Plays ringtone, shows caller's avatar/info, and lets user accept or reject.
class PersonVideoIncomingPage extends StatefulWidget {
  final String callId;
  final String callType;
  final String hostId;

  const PersonVideoIncomingPage({
    super.key,
    required this.callId,
    required this.callType,
    required this.hostId,
  });

  @override
  State<PersonVideoIncomingPage> createState() =>
      _PersonVideoIncomingPageState();
}

class _PersonVideoIncomingPageState extends State<PersonVideoIncomingPage> {
  late final AudioPlayer _player; // Ringtone player

  @override
  void initState() {
    super.initState();
    // Start playing ringtone in a loop
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

    // Listen for call status changes (auto-close on call end)
    return StreamBuilder<String>(
      stream: vm.callStatusStream,
      builder: (context, snapshot) {
        final status = snapshot.data ?? 'ringing';
        if (status == 'ended') {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && Navigator.canPop(context)) Navigator.pop(context);
          });
        }

        // Main incoming call UI
        return Scaffold(
          backgroundColor: Colors.black87,
          appBar: AppBar(backgroundColor: Colors.transparent),
          body: SafeArea(
            child: Column(
              children: [
                const Spacer(),

                // Display caller's avatar (or placeholder)
                if (otherUid != null && otherUid.isNotEmpty)
                  DisplayNameAvatar(uid: otherUid, radius: 48)
                else
                  const _AvatarPlaceholder(),

                const SizedBox(height: 16),
                const Text(
                  'Incoming video call…',
                  style: TextStyle(color: Colors.white70, fontSize: 20),
                ),
                const Spacer(),

                // Accept and reject call buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Reject call button
                    _circleButton(
                      icon: Icons.call_end,
                      color: Colors.redAccent,
                      onTap: () async {
                        await vm.reject();
                        if (mounted && Navigator.canPop(context)) Navigator.pop(context);
                      },
                    ),
                    // Accept call button
                    _circleButton(
                        icon: Icons.call,
                        color: Colors.green,
                        onTap: () async {
                          await vm.accept();
                          if (mounted) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (_) => ChangeNotifierProvider.value(
                                    value: vm,
                                    child: const PersonVideoActivePage(),
                                  )),
                            );
                          }
                        }),
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

/// Placeholder avatar widget if no user info is loaded.
class _AvatarPlaceholder extends StatelessWidget {
  const _AvatarPlaceholder();

  @override
  Widget build(BuildContext context) => CircleAvatar(
    radius: 48,
    backgroundColor: Colors.grey.shade800,
    child: const Icon(Icons.person, size: 48, color: Colors.white30),
  );
}
