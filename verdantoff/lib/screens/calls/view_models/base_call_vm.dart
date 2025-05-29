import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../../../services/webrtc/call/call_session_controller.dart';

/// Base ViewModel for call screens (voice, video, screen share).
/// Provides unified interface to call state and common actions.
/// Notifies listeners for UI updates when toggling mic/cam/sharing.
class BaseCallVm extends ChangeNotifier {
  /// Initialize and connect to CallSessionController streams.
  BaseCallVm(this._ctrl) {
    durationStream = _ctrl.durationStream;
    remoteStream = _ctrl.remoteStreamStream;
    connectionStateStream = _ctrl.connectionStateStream;
  }

  /// Controller managing the underlying call session and WebRTC logic.
  final CallSessionController _ctrl;

  /// Protected accessor for subclasses.
  @protected
  CallSessionController get controller => _ctrl;

  /// Elapsed call duration (updates every second).
  late final Stream<Duration> durationStream;

  /// Remote media stream (audio/video from peer).
  late final Stream<MediaStream> remoteStream;

  /// Peer connection state updates.
  late final Stream<RTCPeerConnectionState>? connectionStateStream;

  // ---------------------------------------------------------------------------
  // Local call state
  // ---------------------------------------------------------------------------
  bool _micOn = true;
  bool _camOn = true;
  bool _sharing = false;

  /// Returns true if microphone is muted.
  bool get isMuted => !_micOn;

  /// Returns true if camera is off.
  bool get isCamOff => !_camOn;

  /// Returns true if currently screen sharing.
  bool get isScreenShare => _sharing;

  // ---------------------------------------------------------------------------
  // User action methods
  // ---------------------------------------------------------------------------

  /// Toggle microphone state and notify listeners.
  Future<void> toggleMic() async {
    _micOn = !_micOn;
    await _ctrl.toggleMic(_micOn);
    notifyListeners();
  }

  /// Toggle camera state and notify listeners.
  Future<void> toggleCam() async {
    _camOn = !_camOn;
    await _ctrl.toggleCamera(_camOn);
    notifyListeners();
  }

  /// Switch between front/rear camera.
  Future<void> switchCamera() async => _ctrl.switchCamera();

  /// Hang up and end the current call.
  Future<void> hangUp() async {
    await _ctrl.endCall();
  }

  /// Update screen sharing state and notify listeners (protected).
  @protected
  void _setSharing(bool v) {
    _sharing = v;
    notifyListeners();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }
}
