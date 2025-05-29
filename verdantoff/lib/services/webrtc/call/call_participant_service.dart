import 'package:cloud_firestore/cloud_firestore.dart';

/// Service helper for **/calls/{id}/participants/{uid}** documents.
/// Encapsulates Firestore CRUD so CallService stays focused on business logic.
class CallParticipantService {
  final _db = FirebaseFirestore.instance;

  /// Create the very first participant and mark them as **host**.
  Future<void> createHost(String callId, String uid) => _doc(callId, uid).set({
    'joinedAt': FieldValue.serverTimestamp(), // Server-side join time
    'muted': false,
    'videoOn': true,
    'role': 'host',
  });

  /// Join an ongoing call as a normal **participant**.
  Future<void> join(String callId, String uid) => _doc(callId, uid).set({
    'joinedAt': FieldValue.serverTimestamp(),
    'muted': false,
    'videoOn': true,
    'role': 'participant',
  });

  /// Mark participant as having left the call.
  Future<void> leave(String callId, String uid) =>
      _doc(callId, uid).update({'leftAt': FieldValue.serverTimestamp()});

  /// Update mute / camera state from in-call toggles.
  Future<void> updateState(String callId, String uid,
      {required bool muted, required bool videoOn}) =>
      _doc(callId, uid).update({'muted': muted, 'videoOn': videoOn});

  /// Convenience wrapper to obtain the participant document reference.
  DocumentReference<Map<String, dynamic>> _doc(String callId, String uid) =>
      _db.collection('calls').doc(callId).collection('participants').doc(uid);
}
