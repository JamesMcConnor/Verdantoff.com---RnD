// lib/services/calls/call/call_session_controller.dart
//
// ViewModel connecting UI ⬌ service layer:
// • Creates / joins / hangs-up calls via CallService
// • Owns PeerConnection + lifecycle handler
// • Exposes Stream<Duration> and Stream<MediaStream> for UI widgets

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../call/call_service.dart';
import '../call/call_timer.dart';
import '../connection/peer_connection_lifecycle_handler.dart';
import '../connection/peer_connection_manager.dart';
import '../connection/remote_stream_tracker.dart';
import '../media/media_repository.dart';
import '../models/call_media_preset.dart';
import '../models/call_model.dart.dart';
import '../models/call_status.dart';
import '../signaling/signaling_listener.dart';
import '../signaling/signaling_event.dart';
import '../signaling/signaling_service.dart';

class CallSessionController {
  // ------------------------------------------------------------------ ctor --

  CallSessionController({required this.localUid});

  final String localUid;

  // ---------------------------------------------------------------- services --

  final CallService _callService = CallService();
  final CallTimer _callTimer = CallTimer();
  final MediaRepository _mediaRepo = MediaRepository();
  final SignalingService _signaling = SignalingService();

  // ---------------------------------------------------------------- state ----

  CallModel? currentCall;
  bool get isHost => currentCall?.hostId == localUid;

  MediaStream? localStream;
  MediaStream? remoteStream;

  bool _isScreenSharing = false;
  bool get isScreenSharing => _isScreenSharing;

  // ---------------------------------------------------------------- streams --

  final _durationCtr = StreamController<Duration>.broadcast();
  Stream<Duration> get durationStream => _durationCtr.stream;

  final _remoteCtr = StreamController<MediaStream>.broadcast();
  Stream<MediaStream> get remoteStreamStream => _remoteCtr.stream;

  final _connStateCtr = StreamController<RTCPeerConnectionState>.broadcast();
  Stream<RTCPeerConnectionState> get connectionStateStream =>
      _connStateCtr.stream;

  // (if UI needs raw signaling events)
  final _sigCtr = StreamController<SignalingEvent>.broadcast();
  Stream<SignalingEvent> get signalingStream => _sigCtr.stream;

  // ---------------------------------------------------------------- peers ----

  PeerConnectionManager? _peerMgr;
  PeerConnectionLifecycleHandler? _pcHandler;
  RemoteStreamTracker? _remoteTracker;

  StreamSubscription? _signalingSub;

  // =========================================================== public API ====

  // ------------------------ Call creation / answer --------------------------

  /// Host starts a ringing call and returns generated callId.
  Future<String> createCall({
    required List<String> invitees,
    required String type,
  }) async {
    print('[CallSessionController] createCall: host=$localUid, invitees=$invitees, type=$type');
    final id = await _callService.createCall(
      hostId: localUid,
      invitedUids: invitees,
      type: type,
    );

    print('[CallSessionController] Call created with id=$id');
    currentCall = CallModel(
      id: id,
      hostId: localUid,
      type: type,
      status: CallStatus.ringing,
      createdAt: Timestamp.now(),
      invitedUids: invitees,
    );
    await initLocalMedia(CallMediaPreset.audioOnly);
    await startConnection(isCaller: true);

    _callTimer.startTimeoutTimer(const Duration(seconds: 60));
    _callTimer.onTimeout = endCall;

    return id;
  }

  /// Join an existing ringing call as participant.
  Future<void> answerCall(String callId) async {
    print('[CallSessionController] answerCall: callId=$callId, uid=$localUid');

    await _callService.answerCall(callId: callId, uid: localUid);

    final snap = await FirebaseFirestore.instance
        .collection('calls')
        .doc(callId)
        .get();
    if (!snap.exists) throw Exception('call not found');

    currentCall = CallModel.fromMap(snap.id, snap.data()!);


    if (localStream == null) {
      await initLocalMedia(CallMediaPreset.audioOnly);
    }

    if (_peerMgr == null) {
      await startConnection(isCaller: false);
    }

    _startCallTimer();
  }



  /// Hang-up (local) – will mark call ended if you're the host.
  Future<void> endCall() async {
    if (currentCall != null) {
      await _callService.endCall(callId: currentCall!.id, uid: localUid);
    }
    _disposeInternal();
  }

  // ----------------------------- Media --------------------------------------
  String? get otherUid {
    if (currentCall == null) return null;
    // You are the caller
    if (currentCall!.hostId == localUid && currentCall!.invitedUids.isNotEmpty) {
      return currentCall!.invitedUids.first;
    }
    // You are called
    if (currentCall!.hostId != localUid) {
      return currentCall!.hostId;
    }
    // fallback
    return null;
  }

// ----------------------------- Media --------------------------------------

  /// Initialize local media stream. Get audio or video according to preset.
  Future<void> initLocalMedia(CallMediaPreset preset) async {
    final isVideo = preset == CallMediaPreset.video;
    // Only audioOnly or video is allowed here, screenShare is used as a follow-up operation
    localStream = await _mediaRepo.getCallMedia(
      isVideoCall: isVideo,
      isScreenShare: false,
    );
  }

  Future<void> switchCamera() => _mediaRepo.switchCamera();

  Future<void> toggleMic(bool on) async {
    if (currentCall == null) return;
    await _callService.updateParticipantState(
      callId: currentCall!.id,
      uid: localUid,
      muted: !on,
      videoOn: currentCall!.type == 'video', // True only for video calls
    );
    _mediaRepo.setMicEnabled(on);
  }

  Future<void> toggleCamera(bool on) async {
    if (currentCall == null) return;
    await _callService.updateParticipantState(
      callId: currentCall!.id,
      uid: localUid,
      muted: false,
      videoOn: on,
    );
    _mediaRepo.setCameraEnabled(on);
  }


  // ----------------------- PeerConnection setup -----------------------------
  Future<void> startConnection({required bool isCaller}) async {
    // Preliminary inspection
    if (currentCall == null) return;
    if (localStream == null) {
      throw StateError('startConnection is called when localStream is still uninitialized');
    }

    // If there is already a connection, skip it to avoid duplicate creation
    if (_peerMgr != null) {
      print('[CallSessionController] startConnection skipped: connection already exists');
      return;
    }

    // Creating a PeerConnectionManager
    _peerMgr = PeerConnectionManager(isCaller: isCaller);
    _remoteTracker = RemoteStreamTracker();

    _peerMgr!.onRemoteStream = (s) {
      remoteStream = s;
      _remoteTracker?.handleNewRemoteStream(s);
      _remoteCtr.add(s);
    };
    _peerMgr!.onConnectionStateChange = (state) => _connStateCtr.add(state);
    _peerMgr!.onNeedOffer = (sdp) {
      _signaling.sendOffer(
        callId: currentCall!.id,
        senderUid: localUid,
        sdp: sdp,
      );
    };

    // Establish the underlying RTCPeerConnection and add the local stream to it
    await _peerMgr!.initConnection(localStream!);

    // Caller: Send initial offer
    if (isCaller) {
      final offer = await _peerMgr!.createOffer(); // LocalDescription is set
      await _signaling.sendOffer(
        callId: currentCall!.id,
        senderUid: localUid,
        sdp: offer.sdp!,
      );
      print('[CallSessionController] Initial Offer sent.');
    }

    // Monitor signaling and drive state machine
    final listener = SignalingListener(
      callId: currentCall!.id,
      localUid: localUid,
    );

    _pcHandler = PeerConnectionLifecycleHandler(
      callId: currentCall!.id,
      localUid: localUid,
      listener: listener,
      signalingService: _signaling,
      peerManager: _peerMgr!,
    );
    await _pcHandler!.start();

    _signalingSub = listener.listen().listen(_sigCtr.add);
  }

  /// Expose the current RTCPeerConnection to mix-ins / higher layers.
  RTCPeerConnection? get peerConnection => _peerMgr?.peerConnection;
  /// Helper the mix-ins can call to push a fresh OFFER (ICE-restart, etc.).
  Future<void> sendOffer(String sdp) async {
    if (currentCall == null) return;
    await _signaling.sendOffer(
      callId: currentCall!.id,
      senderUid: localUid,
      sdp: sdp,
    );
  }

  // -------------------------- Screen share ----------------------------------

  Future<void> startScreenSharing() async {
    if (_peerMgr == null || _isScreenSharing) return;
    await _mediaRepo.startScreenShare(_peerMgr!.peerConnection!);
    _isScreenSharing = true;

    if (currentCall != null) {
      await _callService.updateParticipantState(
        callId: currentCall!.id,
        uid: localUid,
        muted: false,
        videoOn: true,
      );
    }
  }

  Future<void> stopScreenSharing() async {
    if (_peerMgr == null || !_isScreenSharing) return;
    await _mediaRepo.stopScreenShare(_peerMgr!.peerConnection!);
    _isScreenSharing = false;
  }

  // ======================================================== internal utils ==

  void _startCallTimer() {
    _callTimer.startCallTimer();
    _callTimer.onTick = _durationCtr.add;
  }

  void _disposeInternal() {
    _signalingSub?.cancel();

    _callTimer.dispose();
    _pcHandler?.stop();
    _peerMgr?.close();
    _remoteTracker?.dispose();
    _mediaRepo.disposeLocalStream();

    _peerMgr?.peerConnection?.close();

    currentCall = null;
    localStream = null;
    remoteStream = null;
    _isScreenSharing = false;

    // Make sure all event sources are closed before closing the stream controller
    _durationCtr.close();
    _remoteCtr.close();
    _connStateCtr.close();

    // The signaling stream was finally closed.
    _sigCtr.close();
  }


  void dispose() => _disposeInternal();
}
