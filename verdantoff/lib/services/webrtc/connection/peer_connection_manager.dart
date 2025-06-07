import 'package:flutter_webrtc/flutter_webrtc.dart';

/// Wrapper around RTCPeerConnection – keeps transport code out of ViewModel.
class PeerConnectionManager {
  /// Indicates if this client is the call initiator (caller).
  PeerConnectionManager({required this.isCaller});

  /// True if this side starts the connection (initiates offer).
  final bool isCaller;

  /// Underlying RTCPeerConnection instance.
  RTCPeerConnection? _pc;

  /// Local and remote media streams.
  MediaStream? localStream;
  MediaStream? remoteStream;

  // ---------------------------------------------------------------- Callbacks

  /// Triggered when a new ICE candidate is found (to send via signaling).
  Function(RTCIceCandidate)? onLocalIceCandidate;

  /// Triggered when a remote MediaStream is received.
  Function(MediaStream)? onRemoteStream;

  /// Triggered on peer connection state changes.
  Function(RTCPeerConnectionState state)? onConnectionStateChange;

  /// Triggered when a new offer is needed (for ICE restart or renegotiation).
  Function(String sdp)? onNeedOffer;

  // ========== Key Additions ==========

  /// Stores ICE candidates received before remoteDescription is set.
  final List<RTCIceCandidate> _pendingCandidates = [];

  /// True after setRemoteDescription has succeeded.
  bool _remoteDescriptionSet = false;
  // ===================================

  // TURN / STUN configuration
  static const Map<String, dynamic> _iceConfig = {
    'iceServers': [
      // 0) First put a UDP 443 TURN (many operators allow 443/udp)
      {
        'urls': ['turn:markusxu.uk:443?transport=udp'],
        'username': 'verdant',
        'credential': 'off123',
      },

      // 1) STUN is the backup, if a hole can be found, just go to P2P
      { 'urls': ['stun:stun.l.google.com:19302'] },

      // 2) TCP 443 TURN — Mobile networks can definitely pass
      {
        'urls': ['turn:markusxu.uk:443?transport=tcp'],
        'username': 'verdant',
        'credential': 'off123',
      },

      // 3) Traditional 3478/udp + 5349/tcp, put last
      {
        'urls': [
          'turn:markusxu.uk:3478?transport=udp',
          'turn:markusxu.uk:5349?transport=tcp',
        ],
        'username': 'verdant',
        'credential': 'off123',
      },
    ],


    'iceTransportPolicy': 'all',
  };



  // Constraints for offer/answer SDP creation.
  static const _sdpConstraints = {
    'mandatory': {
      'OfferToReceiveAudio': true,
      'OfferToReceiveVideo': true,
    },
    'optional': [],
  };

  // ------------------------------------------------------------------ init --

  /// Initializes the peer connection, adds local tracks, and binds all events.
  Future<void> initConnection(MediaStream local) async {
    localStream = local;
    remoteStream = await createLocalMediaStream('remote');

    print('[PeerConnectionManager] Creating PeerConnection');
    _pc = await createPeerConnection(_iceConfig, _sdpConstraints);

    // Publish all tracks from local stream.
    for (final t in local.getTracks()) {
      await _pc!.addTrack(t, local);
      print('[PeerConnectionManager] addTrack: ${t.kind}');
    }

    // Event: remote track received (usually first remote stream)
    _pc!.onTrack = (e) {
      print('[PeerConnectionManager] onTrack: kind=${e.track.kind}');
      if (e.streams.isNotEmpty) {
        remoteStream = e.streams.first;
        onRemoteStream?.call(remoteStream!);
      }
    };

    // Event: local ICE candidate found
    _pc!.onIceCandidate = (c) {
      print('[PeerConnectionManager] onIceCandidate: ${c.candidate}');
      onLocalIceCandidate?.call(c);
    };

    // Event: connection state changed
    _pc!.onConnectionState = (s) {
      print('[PeerConnectionManager] onConnectionState: $s');
      onConnectionStateChange?.call(s);
    };

    // Event: ICE connection state (e.g., for ICE restart)
    _pc!.onIceConnectionState = (s) async {
      print('[PeerConnectionManager] onIceConnectionState: $s');
      if (s == RTCIceConnectionState.RTCIceConnectionStateFailed) {
        print('[PeerConnectionManager] ICE failed, do ICE-restart');
        final offer = await _pc!.createOffer({'iceRestart': true});
        await _pc!.setLocalDescription(offer);
        onNeedOffer?.call(offer.sdp!);
      }
    };

    // Event: negotiation needed (e.g., add track or ICE restart)
    _pc!.onRenegotiationNeeded = () async {
      // Only create offer if caller, or after remoteDescription is set.
      if (isCaller) {
        final off = await _pc!.createOffer();
        await _pc!.setLocalDescription(off);
        onNeedOffer?.call(off.sdp!);
        print('[PeerConnectionManager] onRenegotiationNeeded -> new offer');
      }
    };
  }

  /// Exposes underlying RTCPeerConnection if needed.
  RTCPeerConnection? get peerConnection => _pc;

  // ----------------------------------------------------------- SDP helpers --

  /// Create and set local offer SDP; returns the SDP.
  Future<RTCSessionDescription> createOffer() async {
    final offer = await _pc!.createOffer();
    await _pc!.setLocalDescription(offer);
    print('[PeerConnectionManager] Local offer SDP:\n${offer.sdp}');
    return offer;
  }

  /// Create and set local answer SDP; returns the SDP.
  Future<RTCSessionDescription> createAnswer() async {
    final ans = await _pc!.createAnswer();
    await _pc!.setLocalDescription(ans);
    print('[PeerConnectionManager] Local answer SDP:\n${ans.sdp}');
    return ans;
  }

  /// Set the remote description and process any buffered ICE candidates.
  Future<void> setRemoteDescription(String sdp, String type) async {
    print('[PeerConnectionManager] setRemoteDescription(type=$type)…');
    await _pc!.setRemoteDescription(RTCSessionDescription(sdp, type));
    _remoteDescriptionSet = true;

    if (_pendingCandidates.isNotEmpty) {
      print('[PeerConnectionManager] Flushing ${_pendingCandidates.length} pending candidates');
      for (final c in _pendingCandidates) {
        await _pc!.addCandidate(c);
      }
      _pendingCandidates.clear();
    }
  }

  /// Add an ICE candidate (buffer if remote SDP not yet set).
  Future<void> addIceCandidate(RTCIceCandidate c) async {
    final safeMid = (c.sdpMid?.isNotEmpty ?? false) ? c.sdpMid! : '0';
    final safeIndex = c.sdpMLineIndex ?? (safeMid == '0' ? 0 : 1);
    final safe = RTCIceCandidate(c.candidate, safeMid, safeIndex);

    if (!_remoteDescriptionSet) {
      _pendingCandidates.add(safe);
      print('[PeerConnectionManager] Candidate queued (waiting for remote SDP)');
    } else {
      await _pc!.addCandidate(safe);
    }
  }

  // ------------------------------------------------------- track helpers ----

  /// Replace the outgoing video track (e.g., for camera switching).
  Future<void> replaceVideoTrack(MediaStreamTrack newTrack) async {
    final sender = (await _pc!.getSenders())
        .firstWhere((s) => s.track?.kind == 'video',
        orElse: () => throw 'No video sender');
    await sender.replaceTrack(newTrack);
  }

  /// Add a new media track to the connection.
  Future<void> addTrack(MediaStreamTrack t, MediaStream s) =>
      _pc!.addTrack(t, s);

  // ---------------------------------------------------------------- dispose -

  /// Cleanup: stop all tracks, close connection, release resources.
  Future<void> close() async {
    print('[PeerConnectionManager] Closing…');

    onLocalIceCandidate = null;
    onRemoteStream = null;
    onConnectionStateChange = null;
    onNeedOffer = null;

    // Stop all local and remote tracks.
    for (final t in localStream?.getTracks() ?? []) t.stop();
    for (final t in remoteStream?.getTracks() ?? []) t.stop();

    // Close the RTCPeerConnection.
    await _pc?.close();
    _pc = null;

    // Dispose media streams.
    await localStream?.dispose();
    await remoteStream?.dispose();

    _remoteDescriptionSet = false;
    _pendingCandidates.clear();
    print('[PeerConnectionManager] Closed.');
  }
}
