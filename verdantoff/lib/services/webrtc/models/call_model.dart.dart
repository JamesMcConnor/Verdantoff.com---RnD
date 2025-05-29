import 'package:cloud_firestore/cloud_firestore.dart';
import 'call_status.dart';

/// Firestore document model for **calls/{callId}**.
class CallModel {
  /// Firestore document id.
  final String id;

  /// “voice”, “video” or “screen”.
  final String type;

  /// Ringing / active / ended.
  final CallStatus status;

  /// UID of the user who created the call.
  final String hostId;

  /// Server timestamp when the call document was created.
  final Timestamp createdAt;

  /// Server timestamp when the call ended (nullable).
  final Timestamp? endedAt;

  /// Optional: mediasoup / SFU room id.
  final String? sfuRoomId;

  /// Initial invitee list (may be empty after everyone joins).
  final List<String> invitedUids;

  const CallModel({
    required this.id,
    required this.type,
    required this.status,
    required this.hostId,
    required this.createdAt,
    this.endedAt,
    this.sfuRoomId,
    required this.invitedUids,
  });

  // ---------- Factory & serialization ---------- //

  factory CallModel.fromMap(String id, Map<String, dynamic> data) => CallModel(
    id: id,
    type: data['type'] ?? 'video',
    status: CallStatus.values.firstWhere(
          (e) => e.name == data['status'],
      orElse: () => CallStatus.ringing,
    ),
    hostId: data['hostId'],
    createdAt: data['createdAt'],
    endedAt: data['endedAt'],
    sfuRoomId: data['sfuRoomId'],
    invitedUids: List<String>.from(data['invitedUids'] ?? []),
  );

  Map<String, dynamic> toMap() => {
    'type': type,
    'status': status.name,
    'hostId': hostId,
    'createdAt': createdAt,
    'endedAt': endedAt,
    'sfuRoomId': sfuRoomId,
    'invitedUids': invitedUids,
  };

  // ---------- Helpers ---------- //

  CallModel copyWith({
    CallStatus? status,
    Timestamp? endedAt,
    List<String>? invitedUids,
  }) =>
      CallModel(
        id: id,
        type: type,
        status: status ?? this.status,
        hostId: hostId,
        createdAt: createdAt,
        endedAt: endedAt ?? this.endedAt,
        sfuRoomId: sfuRoomId,
        invitedUids: invitedUids ?? this.invitedUids,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CallModel && runtimeType == other.runtimeType && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
