import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:verdantoff/screens/calls/person_voice/person_voice_vm.dart';
import '../widgets/display_name_avatar.dart';
import 'Person_active_page.dart'; // to push after accept

/// Incoming ringing screen; user may accept or reject.
class PersonVoiceIncomingPage extends StatefulWidget {
  final String callId;
  final String callType;
  final String hostId;
  const PersonVoiceIncomingPage({
    super.key,
    required this.callId,
    required this.callType,
    required this.hostId,
  });

  @override
  State<PersonVoiceIncomingPage> createState() =>
      _PersonVoiceIncomingPageState();
}

class _PersonVoiceIncomingPageState extends State<PersonVoiceIncomingPage> {
  late final AudioPlayer _player;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer()..setReleaseMode(ReleaseMode.loop);
    // ignore: unawaited_futures
    _player.play(AssetSource('audio/ringtone.mp3'));
  }

  @override
  void dispose() {
    _player.stop();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PersonVoiceVm>();
    final otherUid = vm.otherUid;

    return StreamBuilder<String>(
      stream: vm.callStatusStream,
      builder: (context, snapshot) {
        final status = snapshot.data ?? 'ringing';
        if (status == 'ended') {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && Navigator.canPop(context)) Navigator.pop(context);
          });
        }

        return Scaffold(
          backgroundColor: Colors.black87,
          appBar: AppBar(backgroundColor: Colors.transparent),
          body: SafeArea(
            child: Column(
              children: [
                const Spacer(),

                // ==== 新增头像和昵称显示 ====
                if (otherUid != null && otherUid.isNotEmpty)
                  DisplayNameAvatar(uid: otherUid, radius: 48)
                else
                  const _AvatarPlaceholder(),
                const SizedBox(height: 16),
                // ===========================

                const Text(
                  'Incoming voice call…',
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _circleButton(
                      icon: Icons.call_end,
                      color: Colors.redAccent,
                      onTap: () async {
                        await vm.reject();
                        if (mounted && Navigator.canPop(context)) Navigator.pop(context);
                      },
                    ),
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
                                    child: const PersonVoiceActivePage(),
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

class _AvatarPlaceholder extends StatelessWidget {
  const _AvatarPlaceholder();

  @override
  Widget build(BuildContext context) => CircleAvatar(
    radius: 48,
    backgroundColor: Colors.grey.shade800,
    child: const Icon(Icons.person, size: 48, color: Colors.white30),
  );
}
