/// The only three signaling message types we exchange via Firestore.
enum SignalingType { offer, answer, candidate }

extension SignalingTypeX on SignalingType {
  /// String representation stored in Firestore.
  String get wire => name;

  /// Parse incoming Firestore string → enum (defaults to candidate).
  static SignalingType fromWire(String? value) {
    switch (value) {
      case 'offer':
        return SignalingType.offer;
      case 'answer':
        return SignalingType.answer;
      default:
        return SignalingType.candidate;
    }
  }
}
