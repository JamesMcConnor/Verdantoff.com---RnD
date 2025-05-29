import 'package:cloud_firestore/cloud_firestore.dart';
import 'signaling_type.dart';

class SignalingMessageModel {
  final String id;
  final String senderUid;
  final SignalingType type;
  final String? sdp;
  final String? candidate;
  final DateTime timestamp;

  const SignalingMessageModel({
    required this.id,
    required this.senderUid,
    required this.type,
    this.sdp,
    this.candidate,
    required this.timestamp,
  });

  factory SignalingMessageModel.fromMap(String id, Map<String, dynamic> map) {
    return SignalingMessageModel(
      id: id,
      senderUid: map['senderUid'],
      type: SignalingTypeX.fromWire(map['type']),
      sdp: map['sdp'],
      candidate: map['candidate'],
      // Fallback to now() if serverTimestamp not resolved yet
      timestamp: (map['ts'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
    'senderUid': senderUid,
    'type': type.wire,
    'sdp': sdp,
    'candidate': candidate,
    'ts': Timestamp.fromDate(timestamp),
  };
}
