// lib/services/calls/call/call_service.dart
//
// Firestore-only service: create, answer, hang-up calls.
// Media and signaling are handled by their own repos/services.

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/call_status.dart';
import 'call_participant_service.dart';

class CallService {
  final _db = FirebaseFirestore.instance;
  final _ps = CallParticipantService();

  /// Create a call document and add host as first participant.
  /// Returns the generated callId.
  Future<String> createCall({
    required String hostId,
    required List<String> invitedUids,
    required String type,
  }) async {
    final ref = await _db.collection('calls').add({
      'hostId': hostId,
      'type': type,
      'status': CallStatus.ringing.name,
      'createdAt': FieldValue.serverTimestamp(),
      'invitedUids': invitedUids,
    });

    await _ps.createHost(ref.id, hostId);
    return ref.id;
  }

  /// Join as participant and mark call ACTIVE.
  Future<void> answerCall({
    required String callId,
    required String uid,
  }) async {
    await _ps.join(callId, uid);
    await _db
        .collection('calls')
        .doc(callId)
        .update({'status': CallStatus.active.name});
  }

  /// Leave call. Any participant can mark call ENDED.
  Future<void> endCall({
    required String callId,
    required String uid,
  }) async {
    await _ps.leave(callId, uid);

    final doc = await _db.collection('calls').doc(callId).get();
    if (doc.exists) {
      await _db.collection('calls').doc(callId).update({
        'status': CallStatus.ended.name,
        'endedAt': FieldValue.serverTimestamp(),
      });
    }
  }


  /// Update local participant mute/camera flags.
  Future<void> updateParticipantState({
    required String callId,
    required String uid,
    required bool muted,
    required bool videoOn,
  }) =>
      _ps.updateState(callId, uid, muted: muted, videoOn: videoOn);
}
