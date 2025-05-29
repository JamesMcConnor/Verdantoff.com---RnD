import 'dart:math' as math;
import 'dart:async';
import 'package:flutter/material.dart';

/// Simple radial meter that animates smoothly between
/// 0.0 (silence) and 1.0 (maximum).
/// *Feed it a `Stream<double>` with linear volume values.*
class AudioLevelIndicator extends StatefulWidget {
  const AudioLevelIndicator({
    super.key,
    required this.levelStream,
    this.size = 90,
    this.ringWidth = 6,
  });

  final Stream<double> levelStream;
  final double size;
  final double ringWidth;

  @override
  State<AudioLevelIndicator> createState() => _AudioLevelIndicatorState();
}

class _AudioLevelIndicatorState extends State<AudioLevelIndicator> {
  double _level = 0; // last value
  StreamSubscription<double>? _sub;

  @override
  void initState() {
    super.initState();
    _sub = widget.levelStream.listen((v) {
      if (!mounted) return;
      setState(() => _level = v.clamp(0.0, 1.0));
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: _level),
        duration: const Duration(milliseconds: 200),
        builder: (_, value, __) => CustomPaint(
          painter: _RingPainter(
            value,
            ringWidth: widget.ringWidth,
            color: Colors.greenAccent,
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.level, {required this.ringWidth, required this.color});

  final double level; // 0..1
  final double ringWidth;
  final Color color;

  @override
  void paint(Canvas c, Size s) {
    final rect = Offset.zero & s;
    final center = rect.center;
    final radius = s.width / 2 - ringWidth / 2;

    final bg = Paint()
      ..color = Colors.grey.shade700
      ..style = PaintingStyle.stroke
      ..strokeWidth = ringWidth;
    c.drawCircle(center, radius, bg);

    final fg = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = ringWidth
      ..strokeCap = StrokeCap.round;

    final sweep = 2 * math.pi * level;
    c.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweep,
      false,
      fg,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) => old.level != level;
}
