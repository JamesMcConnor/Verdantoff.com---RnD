import 'package:flutter/material.dart';

/// Call control buttons bar for voice/video/screen-share calls.
class CallButtons extends StatelessWidget {
  const CallButtons({
    super.key,
    required this.isMicOn,
    required this.onToggleMic,
    required this.onHangUp,
    this.isCamOn,
    this.isSharing,
    this.onToggleCam,
    this.onShareScreen,
    this.onSwitchCamera,
    this.isSpeakerOn,
    this.onToggleSpeaker,
  });

  // Required controls
  final bool isMicOn;
  final VoidCallback onToggleMic;
  final VoidCallback onHangUp;

  // Optional: video and screen share controls
  final bool? isCamOn;
  final bool? isSharing;
  final VoidCallback? onToggleCam;
  final VoidCallback? onShareScreen;
  final VoidCallback? onSwitchCamera;

  // Optional: speaker control
  final bool? isSpeakerOn;
  final VoidCallback? onToggleSpeaker;

  @override
  Widget build(BuildContext context) {
    final iconColor = Colors.white;

    // Layout: horizontal row of buttons, evenly spaced
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Microphone button (toggle mute)
          _circleButton(
            icon: isMicOn ? Icons.mic : Icons.mic_off,
            color: iconColor,
            onTap: onToggleMic,
          ),

          // Show camera button only if relevant (video call)
          if (isCamOn != null && onToggleCam != null)
            _circleButton(
              icon: isCamOn! ? Icons.videocam : Icons.videocam_off,
              color: iconColor,
              onTap: onToggleCam!,
            ),

          // Screen share button (toggle share/stop)
          if (isSharing != null && onShareScreen != null)
            _circleButton(
              icon: isSharing! ? Icons.stop_screen_share : Icons.screen_share,
              color: iconColor,
              onTap: onShareScreen!,
            ),

          // Camera flip button
          if (onSwitchCamera != null)
            _circleButton(
              icon: Icons.cameraswitch,
              color: iconColor,
              onTap: onSwitchCamera!,
            ),

          // Speaker toggle button
          if (isSpeakerOn != null && onToggleSpeaker != null)
            _circleButton(
              icon: isSpeakerOn! ? Icons.volume_up : Icons.hearing,
              color: iconColor,
              onTap: onToggleSpeaker!,
            ),

          // Hang up button (end call)
          _circleButton(
            icon: Icons.call_end,
            color: Colors.redAccent,
            onTap: onHangUp,
          ),
        ],
      ),
    );
  }

  /// Helper widget: one circular call-control button.
  Widget _circleButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.black45,
      shape: const CircleBorder(),
      child: IconButton(
        icon: Icon(icon, color: color),
        onPressed: onTap,
        splashRadius: 26,
      ),
    );
  }
}
