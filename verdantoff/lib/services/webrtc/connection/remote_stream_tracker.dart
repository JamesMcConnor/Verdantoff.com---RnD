import 'package:flutter_webrtc/flutter_webrtc.dart';

/// Keeps a reference to the inbound remote stream so we can
/// stop() tracks when the call ends.
class RemoteStreamTracker {
  MediaStream? _remote;
  Function(MediaStream)? onReady;

  void handleNewRemoteStream(MediaStream s) {
    _remote = s;
    onReady?.call(s);
  }

  void dispose() {
    _remote?.getTracks().forEach((t) => t.stop());
    _remote = null;
  }
}
