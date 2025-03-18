import 'dart:convert';

class SNMNotificationModel {
  final String id;
  final String title;
  final String body;
  final String type;
  final Map<String, dynamic> data;
  final DateTime timestamp;

  SNMNotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.data,
    required this.timestamp,
  });

  // Convert notification object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'type': type,
      'data': data,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Create a notification object from JSON
  factory SNMNotificationModel.fromJson(Map<String, dynamic> json) {
    return SNMNotificationModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      type: json['type'],
      data: json['data'] ?? {},
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  // Convert object to String (for debugging)
  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
