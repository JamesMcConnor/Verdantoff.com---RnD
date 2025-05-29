import 'dart:async';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../signaling/signaling_listener.dart';
import '../signaling/signaling_service.dart';
import '../signaling/signaling_event.dart';
import '../signaling/signaling_type.dart';
import 'peer_connection_manager.dart';

/// Listens to remote signaling messages and drives the peer connection.
/// Also pushes local ICE candidates back to Firestore.
class PeerConnectionLifecycleHandler {
  final String callId;
  final String localUid;

  final SignalingListener _listener;
  final SignalingService _signaling;
  final PeerConnectionManager _peer;

  StreamSubscription? _sub;

  PeerConnectionLifecycleHandler({
    required this.callId,
    required this.localUid,
    required SignalingListener listener,
    required SignalingService signalingService,
    required PeerConnectionManager peerManager,
  })  : _listener = listener,
        _signaling = signalingService,
        _peer = peerManager;

  Future<void> start() async {
    print('[PCLifecycle] Listening signaling...');
    _sub = _listener.listen().listen((SignalingEvent e) async {
      print('[PCLifecycle] SignalingEvent received: type=${e.type} from=${e.senderUid}');
      if (e.senderUid == localUid) return; // ignore self

      switch (e.type) {
        case SignalingType.offer:
          print('[PCLifecycle] Handling offer, creating answer...');
          await _peer.setRemoteDescription(e.sdp!, e.type.wire);

          final answer = await _peer.createAnswer();
          await _signaling.sendAnswer(
            callId: callId,
            senderUid: localUid,
            sdp: answer.sdp!,
          );
          break;

        case SignalingType.answer:
          print('[PCLifecycle] Received answer, setting remote description...');
          await _peer.setRemoteDescription(e.sdp!, e.type.wire);
          break;

        case SignalingType.candidate:
          print('[PCLifecycle] Received ICE candidate, adding...');
          await _peer.addIceCandidate(RTCIceCandidate(e.candidate, null, null));
          break;
      }

    });

    // Local ICE → Firestore
    _peer.onLocalIceCandidate = (c) {
      print('[PCLifecycle] Sending local ICE candidate to signaling: ${c.candidate}');
      _signaling.sendIceCandidate(
        callId: callId,
        senderUid: localUid,
        candidate: c.candidate!,
      );
    };
  }

  Future<void> stop() async {
    print('[PCLifecycle] Stopping...');
    await _sub?.cancel();
    print('[PCLifecycle] Stopped.');
  }
}
