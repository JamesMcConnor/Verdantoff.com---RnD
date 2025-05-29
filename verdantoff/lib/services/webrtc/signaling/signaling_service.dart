import 'package:cloud_firestore/cloud_firestore.dart';
import 'signaling_message_model.dart';
import 'signaling_type.dart';

class SignalingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _send({
    required String callId,
    required String senderUid,
    required SignalingType type,
    String? sdp,
    String? candidate,
  }) async {
    print('[SignalingService] Sending signaling: type=$type, sender=$senderUid, callId=$callId, sdp=$sdp, candidate=$candidate');
    final msg = SignalingMessageModel(
      id: '',
      senderUid: senderUid,
      type: type,
      sdp: sdp,
      candidate: candidate,
      timestamp: DateTime.now(),
    );
    await _firestore
        .collection('calls')
        .doc(callId)
        .collection('signalling')
        .add(msg.toMap());
    print('[SignalingService] Signaling message sent: $type');
  }

  // ---------- convenience helpers ---------- //

  Future<void> sendOffer({
    required String callId,
    required String senderUid,
    required String sdp,
  }) =>
      _send(
        callId: callId,
        senderUid: senderUid,
        type: SignalingType.offer,
        sdp: sdp,
      );

  Future<void> sendAnswer({
    required String callId,
    required String senderUid,
    required String sdp,
  }) =>
      _send(
        callId: callId,
        senderUid: senderUid,
        type: SignalingType.answer,
        sdp: sdp,
      );

  Future<void> sendIceCandidate({
    required String callId,
    required String senderUid,
    required String candidate,
  }) =>
      _send(
        callId: callId,
        senderUid: senderUid,
        type: SignalingType.candidate,
        candidate: candidate,
      );
}
