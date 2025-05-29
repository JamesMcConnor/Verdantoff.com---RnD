import 'dart:developer' as dev;
import 'dart:io' show Platform;
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'media_constraints.dart';

/// Handles local media acquisition and management for calls
class MediaRepository {
  MediaStream? _localStream;
  MediaStreamTrack? _cameraTrack;
  MediaStream? _screenStream;
  bool _isScreenSharing = false;

  bool get isScreenSharing => _isScreenSharing;
  bool get isCameraActive => _localStream?.getVideoTracks().any((t) => t.enabled) ?? false;
  bool get isMicActive => _localStream?.getAudioTracks().any((t) => t.enabled) ?? false;
  MediaStream? get localStream => _localStream;

  // ========================================================================
  // Core Media Acquisition
  // ========================================================================

  Future<MediaStream> getCallMedia({
    required bool isVideoCall,
    bool isScreenShare = false,
  }) async {
    if (_localStream != null) return _localStream!;

    final constraints = MediaConstraints.callConstraints(
      isVideoCall: isVideoCall,
      isScreenShare: isScreenShare,
    );

    try {
      _localStream = await navigator.mediaDevices.getUserMedia(constraints);
      _handleNewStream(isVideoCall: isVideoCall, isScreenShare: isScreenShare);
      return _localStream!;
    } catch (e) {
      dev.log('Media acquisition failed: $e');
      rethrow;
    }
  }

  // ========================================================================
  // Track Management
  // ========================================================================

  void _handleNewStream({required bool isVideoCall, bool isScreenShare = false}) {
    if (isVideoCall && !isScreenShare) {
      _cameraTrack = _localStream?.getVideoTracks().firstWhere(
            (t) => t.kind == 'video',
        orElse: () => throw 'No video track found',
      );
    }

    if (!isVideoCall) {
      _localStream?.getVideoTracks().forEach((t) => t.enabled = false);
    }
  }

  void setMicEnabled(bool enabled) {
    _localStream?.getAudioTracks().forEach((t) => t.enabled = enabled);
    dev.log('Microphone ${enabled ? 'enabled' : 'disabled'}');
  }

  void setCameraEnabled(bool enabled) {
    if (_cameraTrack == null) {
      dev.log('Camera track unavailable – probably an audio-only call');
      return;
    }
    _cameraTrack!.enabled = enabled;
    dev.log('Camera ${enabled ? 'enabled' : 'disabled'}');
  }


  // ========================================================================
  // Device Operations
  // ========================================================================

  Future<void> switchCamera() async {
    if (!Platform.isAndroid && !Platform.isIOS) return;

    final videoTrack = _localStream?.getVideoTracks().firstWhere(
          (t) => t.kind == 'video',
      orElse: () => throw 'No video track available',
    );

    if (videoTrack != null) {
      try {
        await Helper.switchCamera(videoTrack);
        dev.log('Camera switched successfully');
      } catch (e) {
        dev.log('Camera switch failed: $e');
        rethrow;
      }
    }
  }

  // ========================================================================
  // Screen Sharing (Android only)
  // ========================================================================

  Future<void> startScreenShare(RTCPeerConnection pc) async {
    if (_isScreenSharing) return;
    if (!Platform.isAndroid) throw 'Screen share unavailable';

    try {
      _screenStream = await navigator.mediaDevices.getDisplayMedia(
        MediaConstraints.callConstraints(isVideoCall: true, isScreenShare: true),
      );

      final screenTrack = _screenStream!.getVideoTracks().first;
      final sender = await _firstVideoSender(pc);
      await sender.replaceTrack(screenTrack);

      _isScreenSharing = true;
      dev.log('Screen sharing started');
    } catch (e) {
      await _cleanupFailedScreenShare();
      rethrow;
    }
  }

  Future<void> stopScreenShare(RTCPeerConnection pc) async {
    if (!_isScreenSharing) return;

    try {
      final sender = await _firstVideoSender(pc);
      if (_cameraTrack != null) {
        await sender.replaceTrack(_cameraTrack!);
      }

      await _disposeScreenResources();
      _isScreenSharing = false;
      dev.log('Screen sharing stopped');
    } catch (e) {
      dev.log('Error stopping screen share: $e');
    }
  }

  // ========================================================================
  // Resource Management
  // ========================================================================

  Future<void> disposeLocalStream() async {
    await _disposeMainStream();
    await _disposeScreenResources();
    _resetState();
  }

  Future<void> _disposeMainStream() async {
    final tracks = _localStream?.getTracks() ?? [];
    for (final track in tracks) {
      try { await track.stop();    } catch (_) {}
      try { await track.dispose(); } catch (_) {}
    }
    await _localStream?.dispose();
    _localStream = null;
    _cameraTrack = null;
  }


  Future<void> _disposeScreenResources() async {
    final tracks = _screenStream?.getTracks() ?? [];
    for (final track in tracks) {
      try { await track.stop();    } catch (_) {}
      try { await track.dispose(); } catch (_) {}
    }
    await _screenStream?.dispose();
    _screenStream = null;
  }


  void _resetState() {
    _localStream = null;
    _cameraTrack = null;
    _screenStream = null;
    _isScreenSharing = false;
  }

  // ========================================================================
  // Internal Helpers
  // ========================================================================

  Future<RTCRtpSender> _firstVideoSender(RTCPeerConnection pc) async {
    final senders = await pc.getSenders();
    return senders.firstWhere(
          (s) => s.track?.kind == 'video',
      orElse: () => throw 'No video sender found',
    );
  }

  Future<void> _cleanupFailedScreenShare() async {
    final tracks = _screenStream?.getTracks() ?? [];
    for (final track in tracks) {
      await track.stop();
    }
    await _screenStream?.dispose();
    _screenStream = null;
    _isScreenSharing = false;
  }

  bool get isVideoCallActive =>
      _localStream?.getVideoTracks().any((t) => t.enabled) ?? false;
}
