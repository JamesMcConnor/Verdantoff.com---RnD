import 'package:cloud_firestore/cloud_firestore.dart';
import 'signaling_event.dart';
import 'signaling_message_model.dart';

class SignalingListener {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String callId;
  final String localUid;

  SignalingListener({required this.callId, required this.localUid});

  /// Stream of remote signaling events (already mapped).
  Stream<SignalingEvent> listen() {
    print('[SignalingListener] Start listening to signaling for callId=$callId, localUid=$localUid');
    return _firestore
        .collection('calls')
        .doc(callId)
        .collection('signalling')
        .orderBy('ts')
        .snapshots()
        .expand((q) => q.docChanges) // flatten list
        .where((c) =>
    c.type == DocumentChangeType.added &&
        c.doc.data()?['senderUid'] != localUid)
        .map((c) {
      final m = SignalingMessageModel.fromMap(c.doc.id, c.doc.data() as Map<String, dynamic>);
      print('[SignalingListener] Signaling event received: type=${m.type}, sender=${m.senderUid}, sdp=${m.sdp}, candidate=${m.candidate}');
      return SignalingEvent.fromModel(m);
    });
  }
}
