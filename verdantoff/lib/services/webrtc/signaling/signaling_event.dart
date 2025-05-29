import 'signaling_message_model.dart';
import 'signaling_type.dart';

/// Event object bubbled up to `CallSessionController` & UI.
class SignalingEvent {
  final SignalingType type;
  final String senderUid;
  final String? sdp;
  final String? candidate;

  const SignalingEvent({
    required this.type,
    required this.senderUid,
    this.sdp,
    this.candidate,
  });

  factory SignalingEvent.fromModel(SignalingMessageModel m) => SignalingEvent(
    type: m.type,
    senderUid: m.senderUid,
    sdp: m.sdp,
    candidate: m.candidate,
  );
}
