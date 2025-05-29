// lib/screens/calls/person_voice/person_voice_waiting_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:verdantoff/screens/calls/person_voice/person_voice_vm.dart';
import '../widgets/call_buttons.dart';
import '../widgets/display_name_avatar.dart';
import 'person_active_page.dart';

/// Waiting page shown during outgoing/incoming call setup (before answer).
/// Plays ringtone and displays avatar, status, and call controls.
class PersonVoiceWaitingPage extends StatefulWidget {
  const PersonVoiceWaitingPage({super.key});

  @override
  State<PersonVoiceWaitingPage> createState() => _PersonVoiceWaitingPageState();
}

class _PersonVoiceWaitingPageState extends State<PersonVoiceWaitingPage> {
  late final AudioPlayer _player;  // For ringtone loop
  bool _navigated = false;         // Prevents duplicate navigation

  @override
  void initState() {
    super.initState();
    // Initialize and start playing ringtone in loop mode
    _player = AudioPlayer()..setReleaseMode(ReleaseMode.loop);
    _player.play(AssetSource('audio/ringtone.mp3'));
  }

  @override
  void dispose() {
    // Stop and clean up ringtone
    _player.stop();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PersonVoiceVm>();

    // Listen to call status stream to handle navigation and UI updates
    return StreamBuilder<String>(
      stream: vm.callStatusStream,
      builder: (context, snapshot) {
        final status = snapshot.data ?? 'ringing';

        // ---- Status state machine navigation ----
        if (status == 'active' && !_navigated) {
          _navigated = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => ChangeNotifierProvider.value(
                  value: vm,
                  child: const PersonVoiceActivePage(),
                ),
              ),
            );
          });
        } else if (status == 'ended' && !_navigated) {
          _navigated = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && Navigator.canPop(context)) Navigator.pop(context);
          });
        }

        // ---- Waiting screen UI ----
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(backgroundColor: Colors.transparent),
          body: SafeArea(
            child: Column(
              children: [
                const Spacer(),

                // Show other user's avatar and name (if available)
                if (vm.otherUid != null && vm.otherUid!.isNotEmpty)
                  DisplayNameAvatar(uid: vm.otherUid!, radius: 48)
                else
                  const _AvatarPlaceholder(),

                const SizedBox(height: 24),
                const Text(
                  'Calling…',
                  style: TextStyle(color: Colors.white70, fontSize: 20),
                ),

                const Spacer(),
                // Call control buttons (mic, hang up, speaker)
                CallButtons(
                  isMicOn: !vm.isMuted,
                  onToggleMic: vm.toggleMic,
                  onHangUp: () async {
                    await vm.hangUp();
                    if (mounted && Navigator.canPop(context)) Navigator.pop(context);
                  },
                  isSpeakerOn: vm.isSpeakerOn,
                  onToggleSpeaker: vm.toggleSpeaker,
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Fallback avatar displayed if UID or info is not loaded
class _AvatarPlaceholder extends StatelessWidget {
  const _AvatarPlaceholder();

  @override
  Widget build(BuildContext context) => CircleAvatar(
    radius: 48,
    backgroundColor: Colors.grey.shade800,
    child: const Icon(Icons.person, size: 48, color: Colors.white30),
  );
}
