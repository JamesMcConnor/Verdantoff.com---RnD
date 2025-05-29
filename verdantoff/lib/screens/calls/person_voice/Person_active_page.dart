import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:verdantoff/screens/calls/person_voice/person_voice_vm.dart';
import '../widgets/audio_level_indicator.dart';
import '../widgets/call_buttons.dart';
import '../widgets/display_name_avatar.dart'; // For peer's avatar/nickname

/// In-call screen for active one-to-one voice calls.
/// Shows peer's avatar, call duration, and control buttons.
class PersonVoiceActivePage extends StatelessWidget {
  const PersonVoiceActivePage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PersonVoiceVm>();
    final otherUid = vm.otherUid;

    // Listen to call status for auto-navigation on call end
    return StreamBuilder<String>(
      stream: vm.callStatusStream,
      builder: (context, snapshot) {
        if (snapshot.data == 'ended') {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (Navigator.canPop(context)) Navigator.pop(context);
          });
        }

        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(backgroundColor: Colors.transparent),
          body: SafeArea(
            child: Column(
              children: [
                const Spacer(),
                // Show peer's avatar and nickname (if loaded)
                if (otherUid != null && otherUid.isNotEmpty)
                  DisplayNameAvatar(uid: otherUid, radius: 48)
                else
                  const _AvatarPlaceholder(),
                const SizedBox(height: 8),
                // Display call duration in mm:ss format
                StreamBuilder<Duration>(
                  stream: vm.durationStream,
                  builder: (_, snap) {
                    final d = snap.data ?? Duration.zero;
                    final mm = d.inMinutes.remainder(60).toString().padLeft(2, '0');
                    final ss = d.inSeconds.remainder(60).toString().padLeft(2, '0');
                    return Text(
                      '$mm:$ss',
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                    );
                  },
                ),
                const Spacer(),
                // Call control buttons (mic, hang up, speaker)
                CallButtons(
                  isMicOn: !vm.isMuted,
                  onToggleMic: vm.toggleMic,
                  onHangUp: vm.hangUp,
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

/// Fallback avatar if user info is missing/unavailable
class _AvatarPlaceholder extends StatelessWidget {
  const _AvatarPlaceholder();

  @override
  Widget build(BuildContext context) => CircleAvatar(
    radius: 48,
    backgroundColor: Colors.grey.shade800,
    child: const Icon(Icons.person, size: 48, color: Colors.white30),
  );
}
