import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:rxdart/rxdart.dart';

import '../view_models/base_call_vm.dart';
import '../view_models/reconnection_mixin.dart';
import '../../../../../services/webrtc/call/call_session_controller.dart';

/// ViewModel for one-on-one video call UI and state management.
/// Handles call timer, local/remote stream updates, speaker/camera state, and resource cleanup.
class PersonVideoVm extends BaseCallVm with ReconnectionMixin {
  /// Returns UID of the other participant.
  String? get otherUid => controller.otherUid;

  PersonVideoVm(CallSessionController ctrl) : super(ctrl) {
    // Setup reconnection logic
    initReconnection(null);

    // Initialize call duration and video streams
    _initDurationStream();
    _initLocalRemoteStreams();

    // Listen for call status changes to trigger cleanup when ended
    _statusSub = callStatusStream.listen((s) {
      if (s == 'ended') _forceDispose();
    });
  }

  // ===========================================================================
  // Call timer (syncs to server time if possible)

  /// Stream for elapsed call duration (UI display)
  Stream<Duration> get durationStream => _durationSubject.stream;
  final BehaviorSubject<Duration> _durationSubject =
  BehaviorSubject<Duration>.seeded(Duration.zero);

  Timer? _localTimer;
  Timer? _serverTimer;
  StreamSubscription<DocumentSnapshot>? _createdAtSub;

  /// Start local timer and try to sync to server createdAt timestamp
  void _initDurationStream() {
    final localStart = DateTime.now();
    _localTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => _durationSubject.add(DateTime.now().difference(localStart)));
    _waitForCallId().then(_listenServerCreatedAt);
  }

  /// Listen to server 'createdAt' for more accurate duration, switch from local.
  Future<void> _listenServerCreatedAt(String callId) async {
    _createdAtSub = FirebaseFirestore.instance
        .collection('calls')
        .doc(callId)
        .snapshots(includeMetadataChanges: true)
        .where((s) =>
    !s.metadata.hasPendingWrites && s.data()?['createdAt'] is Timestamp)
        .take(1)
        .listen((snap) {
      final serverStart = (snap.data()!['createdAt'] as Timestamp).toDate();
      _localTimer?.cancel();
      _serverTimer?.cancel();
      _serverTimer = Timer.periodic(
        const Duration(seconds: 1),
            (_) => _durationSubject.add(DateTime.now().difference(serverStart)),
      );
    });
  }

  /// Wait for a callId to be available before subscribing to Firestore.
  Future<String> _waitForCallId() async {
    while (controller.currentCall?.id == null) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
    return controller.currentCall!.id;
  }

  // ===========================================================================
  // Local and remote media stream management

  /// Latest local and remote MediaStream objects (for UI binding)
  MediaStream? get currentLocalStream => controller.localStream;
  MediaStream? get currentRemoteStream => controller.remoteStream;

  /// Notifies listeners when the local/remote MediaStream changes
  final BehaviorSubject<MediaStream?> _localStreamSubject =
  BehaviorSubject<MediaStream?>();
  final BehaviorSubject<MediaStream?> _remoteStreamSubject =
  BehaviorSubject<MediaStream?>();
  Stream<MediaStream?> get localStreamStream => _localStreamSubject.stream;
  Stream<MediaStream?> get remoteStreamStream => _remoteStreamSubject.stream;

  /// Initialize stream listeners for local and remote video.
  void _initLocalRemoteStreams() {
    _localStreamSubject.add(controller.localStream);
    _remoteStreamSubject.add(controller.remoteStream);
    controller.remoteStreamStream.listen(_remoteStreamSubject.add);
  }

  // ===========================================================================
  // State

  /// True if speakerphone is enabled.
  bool isSpeakerOn = false;

  /// True if camera is currently enabled.
  bool isCamOn = true;

  /// Returns host/caller ID (could also map to a name).
  String? get callerName => controller.currentCall?.hostId;

  /// Stream of call status ("ringing", "active", "ended").
  Stream<String> get callStatusStream {
    final id = controller.currentCall?.id;
    if (id == null) return const Stream.empty();

    return FirebaseFirestore.instance
        .collection('calls')
        .doc(id)
        .snapshots()
        .map((snap) =>
    snap.exists ? (snap.data()?['status'] as String? ?? 'ended') : 'ended');
  }

  StreamSubscription<String>? _statusSub; // For auto-dispose on call end

  // ===========================================================================
  // Video call specific actions

  /// Toggle microphone state and notify UI.
  @override
  Future<void> toggleMic() async {
    try {
      await controller.toggleMic(super.isMuted);
      super.toggleMic();
      notifyListeners();
    } catch (e) {
      print('toggleMic failed: $e');
    }
  }

  /// Toggle camera on/off and update local video stream.
  @override
  Future<void> toggleCam() async {
    try {
      isCamOn = !isCamOn;
      await controller.toggleCamera(isCamOn);
      notifyListeners();
      _localStreamSubject.add(controller.localStream);
    } catch (e) {
      print('toggleCam failed: $e');
    }
  }

  /// Switch between front and back cameras.
  @override
  Future<void> switchCamera() async {
    try {
      await controller.switchCamera();
      _localStreamSubject.add(controller.localStream);
    } catch (e) {
      print('switchCamera failed: $e');
    }
  }

  /// Toggle speaker (loudspeaker/earpiece)
  Future<void> toggleSpeaker() async {
    try {
      isSpeakerOn = !isSpeakerOn;
      await Helper.setSpeakerphoneOn(isSpeakerOn);
      notifyListeners();
    } catch (e) {
      print('toggleSpeaker failed: $e');
    }
  }

  /// Hang up and end call (for both parties).
  @override
  Future<void> hangUp() async {
    try {
      await controller.endCall(); // User-initiated hang up
    } catch (e) {
      print('hangUp failed or already ended: $e');
    }
  }

  /// Accept incoming call.
  Future<void> accept() async {
    try {
      await controller.answerCall(controller.currentCall!.id);
    } catch (e) {
      print('accept call failed: $e');
    }
  }

  /// Reject incoming call (decline).
  Future<void> reject() async {
    try {
      await controller.endCall();
    } catch (e) {
      print('reject call failed or already ended: $e');
    }
  }

  // ===========================================================================
  // Cleanup: Immediately release camera/mic when call ends

  /// Called when remote/own hang up triggers resource release.
  void _forceDispose() {
    controller.dispose();      // Immediately release cam/mic resources
    notifyListeners();         // Allow UI to react to state change
  }

  // ===========================================================================
  // Dispose resources, timers, streams, listeners

  @override
  void dispose() {
    _statusSub?.cancel();
    _localTimer?.cancel();
    _serverTimer?.cancel();
    _createdAtSub?.cancel();
    _durationSubject.close();
    _localStreamSubject.close();
    _remoteStreamSubject.close();
    disposeReconnection();
    super.dispose();
  }
}
