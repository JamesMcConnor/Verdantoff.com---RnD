import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../../../services/webrtc/call/call_session_controller.dart';

/// Plug-in that watches the peer-connection state and triggers
/// an ICE-restart *if the browser/engine did not already succeed*.
///
/// * Back-off sequence: 1 s → 2 s → 4 s → 8 s → 16 s (max 5 attempts).
/// * `isReconnecting` is exposed so pages can show a spinner / banner.
mixin ReconnectionMixin {
  // The host VM must expose controller + notifyListeners().
  CallSessionController get controller;
  void notifyListeners();

  // ---------------------------------------------------------------- state --
  final _attempts = <Duration>[
    const Duration(seconds: 1),
    const Duration(seconds: 2),
    const Duration(seconds: 4),
    const Duration(seconds: 8),
    const Duration(seconds: 16),
  ];
  int _index = 0;

  bool _reconnecting = false;
  bool get isReconnecting => _reconnecting;

  StreamSubscription? _sub;

  void initReconnection(Stream<RTCPeerConnectionState>? stream) {
    if (stream == null) return; // controller not wired yet

    _sub = stream.listen((state) async {
      if (state == RTCPeerConnectionState.RTCPeerConnectionStateConnected) {
        _reset();
      } else if (state ==
          RTCPeerConnectionState.RTCPeerConnectionStateFailed &&
          _index < _attempts.length) {
        await _scheduleRestart();
      }
    });
  }

  Future<void> _scheduleRestart() async {
    _reconnecting = true;
    notifyListeners();

    final wait = _attempts[_index++];
    await Future.delayed(wait);

    // Ask service layer to perform explicit ICE-restart offer.
    // (PeerConnectionManager also tries automatically – this is a fallback.)
    final pc = controller.peerConnection;
    if (pc != null &&
        pc.connectionState !=
            RTCPeerConnectionState.RTCPeerConnectionStateClosed) {
      final offer = await pc.createOffer({'iceRestart': true});
      await pc.setLocalDescription(offer);
      await controller.sendOffer(offer.sdp!);
    }
  }

  void _reset() {
    _index = 0;
    if (_reconnecting) {
      _reconnecting = false;
      notifyListeners();
    }
  }

  void disposeReconnection() => _sub?.cancel();
}
