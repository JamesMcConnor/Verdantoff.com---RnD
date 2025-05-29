class GroupJoinRequestModel {
  String requestId;
  String userId;
  DateTime requestedAt;
  String status; // pending, approved, rejected
  String? reviewedBy;
  DateTime? reviewedAt;

  GroupJoinRequestModel({
    required this.requestId,
    required this.userId,
    required this.requestedAt,
    required this.status,
    this.reviewedBy,
    this.reviewedAt,
  });

  factory GroupJoinRequestModel.fromFirestore(String id, Map<String, dynamic> data) {
    return GroupJoinRequestModel(
      requestId: id,
      userId: data['userId'],
      requestedAt: data['requestedAt'].toDate(),
      status: data['status'],
      reviewedBy: data['reviewedBy'],
      reviewedAt: data['reviewedAt']?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'requestedAt': requestedAt,
      'status': status,
      'reviewedBy': reviewedBy,
      'reviewedAt': reviewedAt,
    };
  }
}
