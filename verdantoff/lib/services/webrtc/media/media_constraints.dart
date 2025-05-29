// media_constraints.dart
import 'dart:io' show Platform;

class MediaConstraints {

  static Map<String, dynamic> callConstraints({
    required bool isVideoCall,
    bool isScreenShare = false,
  }) {
    if (isScreenShare) {
      return _screenShare;
    }

    if (isVideoCall) {
      return  _androidVideo;
    }

    return Map<String, dynamic>.from(_audioOnly);

  }


  static const Map<String, dynamic> _androidVideo = {
    'audio': {
      'noiseSuppression': true,
      'echoCancellation': true,
    },
    'video': {
      'facingMode': 'user',
      'width': {'ideal': 1280},
      'height': {'ideal': 720},
      'frameRate': {'ideal': 30},
    },
  };


  static const Map<String, dynamic> _screenShare = {
    'audio': false,
    'video': {
      'deviceId': 'screen',
      'mandatory': {
        'minWidth': 1280,
        'minHeight': 720,
        'minFrameRate': 15,
      },
    },
  };

  static const Map<String, dynamic> _audioOnly = {
    'audio': {
      'noiseSuppression': true,
      'echoCancellation': true,
      'autoGainControl': true,
    },
    'video': false,
  };
}
