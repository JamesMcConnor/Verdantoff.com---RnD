import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import 'package:verdantoff/screens/calls/person_video/person_video_vm.dart';
import '../widgets/call_buttons.dart';
import '../widgets/display_name_avatar.dart';

/// Main page for one-on-one video call session.
/// Shows remote/local video, call controls, connection status, and timer.
class PersonVideoActivePage extends StatefulWidget {
  const PersonVideoActivePage({super.key});

  @override
  State<PersonVideoActivePage> createState() => _PersonVideoActivePageState();
}

class _PersonVideoActivePageState extends State<PersonVideoActivePage> {
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();

  bool _initialized = false;             // Tracks video renderer setup
  bool _connectionEstablished = false;   // True when remote stream detected
  bool _showConnectionMessage = true;    // Controls connection status overlay

  @override
  void initState() {
    super.initState();
    _initRenderers();
  }

  /// Initialize video renderers for local and remote video.
  Future<void> _initRenderers() async {
    await Future.wait([
      _remoteRenderer.initialize(),
      _localRenderer.initialize(),
    ]);
    if (mounted) setState(() => _initialized = true);
  }

  @override
  void dispose() {
    // Clean up video renderers
    _remoteRenderer.srcObject = null;
    _localRenderer.srcObject = null;
    Future.delayed(const Duration(milliseconds: 300), _remoteRenderer.dispose);
    _localRenderer.dispose();
    super.dispose();
  }

  /// Check if remote video stream is received, then show success message.
  void _checkConnectionState(MediaStream? remote) {
    if (!_connectionEstablished && remote != null && remote.getTracks().any((t) => t.enabled)) {
      setState(() {
        _connectionEstablished = true;
      });
      // Show "Successful connection" for 2 seconds, then hide
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _showConnectionMessage = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      // Show loading indicator until renderers are ready
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final vm = context.watch<PersonVideoVm>();
    final otherUid = vm.otherUid;

    final remote = vm.currentRemoteStream;
    final local = vm.currentLocalStream;

    // Set video renderers' sources
    if (remote != null && _remoteRenderer.srcObject != remote) {
      _remoteRenderer.srcObject = remote;
    }
    if (local != null && _localRenderer.srcObject != local) {
      _localRenderer.srcObject = local;
    }

    _checkConnectionState(remote);

    // Listen for call status (to handle hang up navigation)
    return StreamBuilder<String>(
      stream: vm.callStatusStream,
      builder: (context, snap) {
        if (snap.data == 'ended') {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (Navigator.canPop(context)) Navigator.pop(context);
          });
        }

        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(backgroundColor: Colors.transparent),
          body: SafeArea(
            child: Stack(
              children: [
                // Main remote video background (or avatar if no video)
                Positioned.fill(
                  child: remote != null && remote.getVideoTracks().isNotEmpty
                      ? RTCVideoView(_remoteRenderer,
                      objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover)
                      : Center(
                    child: (otherUid?.isNotEmpty ?? false)
                        ? DisplayNameAvatar(uid: otherUid!, radius: 60)
                        : const _AvatarPlaceholder(),
                  ),
                ),

                // Local self video preview (small window at top-right)
                Positioned(
                  top: 16,
                  right: 16,
                  width: 110,
                  height: 160,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: local != null && local.getVideoTracks().isNotEmpty
                        ? RTCVideoView(_localRenderer,
                        mirror: true,
                        objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover)
                        : Container(
                      color: Colors.grey.shade700,
                      child: const Icon(Icons.videocam, color: Colors.white24, size: 32),
                    ),
                  ),
                ),

                // Call duration timer (top-left corner)
                Positioned(
                  top: 20,
                  left: 20,
                  child: StreamBuilder<Duration>(
                    stream: vm.durationStream,
                    builder: (_, dSnap) {
                      final d = dSnap.data ?? Duration.zero;
                      final mm = d.inMinutes.remainder(60).toString().padLeft(2, '0');
                      final ss = d.inSeconds.remainder(60).toString().padLeft(2, '0');
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text('$mm:$ss',
                            style: const TextStyle(color: Colors.white, fontSize: 14)),
                      );
                    },
                  ),
                ),

                // Connection status overlay (centered)
                if (_showConnectionMessage)
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _connectionEstablished ? 'Successful connection' : 'Establishing connection...',
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),

                // Bottom row of call control buttons
                Positioned(
                  bottom: 24,
                  left: 0,
                  right: 0,
                  child: CallButtons(
                    isMicOn: !vm.isMuted,
                    isCamOn: !vm.isCamOff,
                    onToggleMic: vm.toggleMic,
                    onToggleCam: vm.toggleCam,
                    onSwitchCamera: vm.switchCamera,
                    onHangUp: vm.hangUp,
                    isSpeakerOn: vm.isSpeakerOn,
                    onToggleSpeaker: vm.toggleSpeaker,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Placeholder avatar for when user info or video is missing
class _AvatarPlaceholder extends StatelessWidget {
  const _AvatarPlaceholder();

  @override
  Widget build(BuildContext context) => CircleAvatar(
    radius: 48,
    backgroundColor: Colors.grey.shade800,
    child: const Icon(Icons.person, size: 48, color: Colors.white30),
  );
}
