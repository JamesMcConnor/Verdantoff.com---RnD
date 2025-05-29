import 'dart:async';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:rxdart/rxdart.dart';

import '../view_models/base_call_vm.dart';
import '../view_models/reconnection_mixin.dart';
import '../../../../../services/webrtc/call/call_session_controller.dart';

/// ViewModel for person-to-person voice call pages.
/// Handles call timers, audio levels, status, speaker, and resource cleanup.
class PersonVoiceVm extends BaseCallVm with ReconnectionMixin {
  /// Returns the UID of the other participant.
  String? get otherUid => controller.otherUid;

  PersonVoiceVm(CallSessionController ctrl) : super(ctrl) {
    // Set up reconnection logic (for dropped calls)
    initReconnection(null);

    // Simulated remote audio level (UI feedback ring)
    _levelStream = Stream<double>.periodic(
      const Duration(milliseconds: 200),
          (_) => 0.05 + (0.35 * math.Random().nextDouble()),
    );

    _initDurationStream(); // Key change: Start call timer
  }

  // ===========================================================================
  // Remote audio level for UI ring indicator
  late final Stream<double> _levelStream;
  Stream<double> get remoteAudioLevelStream => _levelStream;

  // ===========================================================================
  // Call duration tracking (local timer, syncs to server when possible)
  /// Expose a read-only stream for UI
  Stream<Duration> get durationStream => _durationSubject.stream;

  // Internal duration state
  final BehaviorSubject<Duration> _durationSubject =
  BehaviorSubject<Duration>.seeded(Duration.zero);

  Timer? _localTimer;
  Timer? _serverTimer;
  StreamSubscription<DocumentSnapshot>? _createdAtSub;

  /// Start the duration timer immediately (local), then switch to server time.
  void _initDurationStream() {
    // 1. Start local stopwatch
    final localStart = DateTime.now();
    _localTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => _durationSubject
            .add(DateTime.now().difference(localStart)));

    // 2. Wait for callId, then listen for server createdAt timestamp
    _waitForCallId().then(_listenServerCreatedAt);
  }

  /// Listen for the call's Firestore createdAt, and update timer to sync.
  Future<void> _listenServerCreatedAt(String callId) async {
    _createdAtSub = FirebaseFirestore.instance
        .collection('calls')
        .doc(callId)
        .snapshots(includeMetadataChanges: true)
        .where((s) =>
    !s.metadata.hasPendingWrites && s.data()?['createdAt'] is Timestamp)
        .take(1) // Only need the first value
        .listen((snap) {
      final serverStart =
      (snap.data()!['createdAt'] as Timestamp).toDate();

      // Switch from local timer to server-based timer
      _localTimer?.cancel();
      _serverTimer?.cancel();
      _serverTimer = Timer.periodic(
          const Duration(seconds: 1),
              (_) => _durationSubject
              .add(DateTime.now().difference(serverStart)));
    });
  }

  /// Wait for the callId to be available (polling).
  /// Can be improved with a stream if supported by controller.
  Future<String> _waitForCallId() async {
    while (controller.currentCall?.id == null) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
    return controller.currentCall!.id;
  }

  // ===========================================================================
  // Other public state/actions

  /// Tracks whether speakerphone is enabled.
  bool isSpeakerOn = false;

  /// Returns the host (caller) name or UID.
  String? get callerName => controller.currentCall?.hostId;

  /// Stream for call status ("ringing", "active", "ended").
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

  // ===========================================================================
  // UI Action overrides

  /// Toggle mic state and update UI
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

  /// Toggle speaker (earpiece <-> loudspeaker)
  Future<void> toggleSpeaker() async {
    try {
      isSpeakerOn = !isSpeakerOn;
      await Helper.setSpeakerphoneOn(isSpeakerOn);
      notifyListeners();
    } catch (e) {
      print('toggleSpeaker failed: $e');
    }
  }

  /// Camera toggling is no-op in voice calls
  @override
  Future<void> toggleCam() async {
    // Voice call – No operation
  }

  /// Camera switching is no-op in voice calls
  @override
  Future<void> switchCamera() async {
    // Voice call – No operation
  }

  /// Hang up the call, handle errors gracefully
  @override
  Future<void> hangUp() async {
    try {
      await controller.endCall();
    } catch (e) {
      print('hangUp failed or already ended: $e');
    }
  }

  /// Accept an incoming call
  Future<void> accept() async {
    try {
      await controller.answerCall(controller.currentCall!.id);
    } catch (e) {
      print('accept call failed: $e');
    }
  }

  /// Reject an incoming call
  Future<void> reject() async {
    try {
      await controller.endCall();
    } catch (e) {
      print('reject call failed or already ended: $e');
    }
  }

  // ===========================================================================
  // Resource cleanup

  @override
  void dispose() {
    _localTimer?.cancel();
    _serverTimer?.cancel();
    _createdAtSub?.cancel();
    _durationSubject.close();
    disposeReconnection();
    super.dispose();
  }
}
