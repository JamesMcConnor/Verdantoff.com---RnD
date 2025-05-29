// lib/services/calls/call/call_timer.dart

import 'dart:async';

/// Lightweight utility that manages three separate timers:
/// 1. **Call duration** from the moment a call is connected.
/// 2. **Screen-share countdown** (optional, finite).
/// 3. **Timeout** for unanswered/ringing calls.
class CallTimer {
  // ---------------------------------------------------------------------------
  // Public state & callbacks
  // ---------------------------------------------------------------------------

  /// Elapsed duration of the active call.
  Duration elapsed = Duration.zero;
  Timer? _callTimer;

  /// Remaining time for an active screen-share session (nullable).
  Duration? screenShareCountdown;
  Timer? _screenTimer;

  /// Ringing timeout; triggers auto-hang-up if nobody answers.
  Timer? _timeoutTimer;

  /// Fires every second while a call is active.
  void Function(Duration elapsed)? onTick;

  /// Fired once when the ringing timeout elapses.
  void Function()? onTimeout;

  /// Fired once when the screen-share countdown reaches zero.
  void Function()? onScreenShareEnd;

  // ---------------------------------------------------------------------------
  // Timer lifecycle helpers
  // ---------------------------------------------------------------------------

  /// Begin call-duration tracking—usually invoked right after `answerCall`.
  void startCallTimer() {
    _callTimer?.cancel();
    _callTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      elapsed += const Duration(seconds: 1);
      onTick?.call(elapsed);
    });
  }

  /// Start a ringing timeout (e.g., 60 s). Auto-hang-up when reached.
  void startTimeoutTimer(Duration maxRingingDuration) {
    _timeoutTimer?.cancel();
    _timeoutTimer = Timer(maxRingingDuration, () {
      onTimeout?.call();
    });
  }

  /// Start a finite screen-share countdown (e.g., 10 min limit).
  void startScreenShareCountdown(Duration duration) {
    screenShareCountdown = duration;
    _screenTimer?.cancel();
    _screenTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (screenShareCountdown != null) {
        screenShareCountdown =
            screenShareCountdown! - const Duration(seconds: 1);
        if (screenShareCountdown!.inSeconds <= 0) {
          _screenTimer?.cancel();
          onScreenShareEnd?.call();
        }
      }
    });
  }

  /// Cancel **all** timers (use on call end or dispose).
  void stopAll() {
    _callTimer?.cancel();
    _timeoutTimer?.cancel();
    _screenTimer?.cancel();
  }

  /// Dispose references to avoid memory leaks.
  void dispose() {
    stopAll();
    onTick = null;
    onTimeout = null;
    onScreenShareEnd = null;
  }
}
