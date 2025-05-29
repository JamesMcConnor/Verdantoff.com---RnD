// lib/services/calls/participant/participant_listener.dart
//
// Listens to /calls/{callId}/participants/ and produces a
// Stream<List<ParticipantModel>> for the UI layer.

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/participant_model.dart';

class ParticipantListener {
  ParticipantListener({required this.callId});

  final String callId;
  final _db = FirebaseFirestore.instance;

  /// Continuous stream of all participant documents for a given call.
  /// Emits on **add / update / delete**.
  Stream<List<ParticipantModel>> listen() {
    return _db
        .collection('calls')
        .doc(callId)
        .collection('participants')
    // optional: keep UI order stable by join time
        .orderBy('joinedAt')
        .snapshots()
        .map(_mapSnapshot)
    // optional: suppress duplicate identical lists
        .distinct(_listEquals);
  }

  List<ParticipantModel> _mapSnapshot(QuerySnapshot<Map<String, dynamic>> snap) {
    return snap.docs
        .map((d) => ParticipantModel.fromMap(d.id, d.data()))
        .toList();
  }

  /// Compare by uid + fields to avoid emitting identical lists.
  bool _listEquals(List<ParticipantModel> a, List<ParticipantModel> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
