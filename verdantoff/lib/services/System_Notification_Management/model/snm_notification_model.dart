import 'dart:convert';

/// Unified notification DTO used everywhere in SNM.
///
///  • `type`            → high-level category (chat_message, incoming_call …)
///  • The call-related fields are **null** for non-call payloads.
class SNMNotificationModel {
  final String id;
  final String type;               // chat_message | incoming_call | …
  final String title;
  final String body;
  final Map<String, dynamic> data; // raw payload (used for routing)
  final DateTime timestamp;

  // call-specific
  final String? callId;
  final String? callType; // voice | video | screen
  final String? hostId;

  SNMNotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.data,
    required this.timestamp,
    this.callId,
    this.callType,
    this.hostId,
  });

  /* ───────────────────────────── JSON helpers ─────────────────────────── */

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'title': title,
    'body': body,
    'data': data,
    'timestamp': timestamp.toIso8601String(),
    'callId': callId,
    'callType': callType,
    'hostId': hostId,
  };

  factory SNMNotificationModel.fromJson(Map<String, dynamic> json) =>
      SNMNotificationModel(
        id: json['id'],
        type: json['type'],
        title: json['title'] ?? '',
        body: json['body'] ?? '',
        data: Map<String, dynamic>.from(json['data'] ?? {}),
        timestamp: DateTime.parse(json['timestamp']),
        callId: json['callId'],
        callType: json['callType'],
        hostId: json['hostId'],
      );

  /// Build directly from an **FCM data payload**.
  factory SNMNotificationModel.fromRemote(Map<String, dynamic> p) =>
      SNMNotificationModel(
        id: p['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
        type: p['type'] ?? 'unknown',
        title: p['title'] ?? '',
        body: p['body'] ?? '',
        data: p,
        timestamp: DateTime.now(),
        callId: p['callId'],
        callType: p['callType'],
        hostId: p['hostId'],
      );

  @override
  String toString() => jsonEncode(toJson());
}
