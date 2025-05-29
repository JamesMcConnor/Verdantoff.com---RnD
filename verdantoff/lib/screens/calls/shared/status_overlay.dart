import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../view_models/base_call_vm.dart';

/// Sticky banner that floats at the top-center of every call page
/// and informs the user about network / connection issues.
///
/// Usage:
/// ```dart
/// Stack(
///   children: [
///     /* call UI ... */,
///     StatusOverlay(vm: context.watch<PersonVoiceVm>()),
///   ],
/// )
/// ```
class StatusOverlay extends StatelessWidget {
  const StatusOverlay({super.key, required this.vm});

  final BaseCallVm vm;

  @override
  Widget build(BuildContext context) {
    // If the service layer does not expose a connection-state stream yet,
    // simply render nothing.
    if (vm.connectionStateStream == null) return const SizedBox.shrink();

    return Positioned(
      top: 24,
      left: 0,
      right: 0,
      child: StreamBuilder<RTCPeerConnectionState>(
        stream: vm.connectionStateStream,
        initialData: RTCPeerConnectionState.RTCPeerConnectionStateConnecting,
        builder: (_, snap) {
          final state = snap.data!;
          final label = _labelFor(state);
          if (label == null) return const SizedBox.shrink();

          return Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: _Banner(key: ValueKey(label), text: label),
            ),
          );
        },
      ),
    );
  }

  /// Map WebRTC states to a short user-facing message.
  /// `null` → overlay hidden.
  String? _labelFor(RTCPeerConnectionState s) {
    switch (s) {
      case RTCPeerConnectionState.RTCPeerConnectionStateNew:
      case RTCPeerConnectionState.RTCPeerConnectionStateConnecting:
        return 'Connecting…';
      case RTCPeerConnectionState.RTCPeerConnectionStateDisconnected:
        return 'Reconnecting…';
      case RTCPeerConnectionState.RTCPeerConnectionStateFailed:
        return 'Network unstable';
      default:
        return null; // connected / closed → hide
    }
  }
}

/// simple pill-shaped banner
class _Banner extends StatelessWidget {
  const _Banner({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.orangeAccent.shade700.withOpacity(0.9),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
