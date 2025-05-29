import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore document model for **calls/{callId}/participants/{uid}**.
class ParticipantModel {
  /// UID of the participant (also the document id).
  final String uid;

  /// Timestamp when the user joined.
  final Timestamp joinedAt;

  /// Timestamp when user left (nullable while in the call).
  final Timestamp? leftAt;

  /// Microphone muted?
  final bool muted;

  /// Camera or screen video track active?
  final bool videoOn;

  /// “host” | “participant”.
  final String role;

  const ParticipantModel({
    required this.uid,
    required this.joinedAt,
    this.leftAt,
    required this.muted,
    required this.videoOn,
    required this.role,
  });

  factory ParticipantModel.fromMap(String uid, Map<String, dynamic> data) =>
      ParticipantModel(
        uid: uid,
        joinedAt: data['joinedAt'],
        leftAt: data['leftAt'],
        muted: data['muted'] ?? false,
        videoOn: data['videoOn'] ?? false,
        role: data['role'] ?? 'participant',
      );

  Map<String, dynamic> toMap() => {
    'joinedAt': joinedAt,
    'leftAt': leftAt,
    'muted': muted,
    'videoOn': videoOn,
    'role': role,
  };

  ParticipantModel copyWith({
    bool? muted,
    bool? videoOn,
    Timestamp? leftAt,
  }) =>
      ParticipantModel(
        uid: uid,
        joinedAt: joinedAt,
        leftAt: leftAt ?? this.leftAt,
        muted: muted ?? this.muted,
        videoOn: videoOn ?? this.videoOn,
        role: role,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ParticipantModel &&
              runtimeType == other.runtimeType &&
              other.uid == uid;

  @override
  int get hashCode => uid.hashCode;
}
