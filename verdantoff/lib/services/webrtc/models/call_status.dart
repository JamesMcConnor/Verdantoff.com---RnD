/// Possible lifecycle states for a call document.
enum CallStatus {
  /// The call is ringing – at least one callee has not answered yet.
  ringing,

  /// At least two participants have joined and media is flowing.
  active,

  /// Call finished (hang-up or timeout).
  ended,
}
