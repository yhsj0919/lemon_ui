// Copyright 2014 The Flutter Authors. All rights reserved.
// Checkbox mark path and animation adapted from Flutter under BSD-3-Clause.
// See docs/flutter-license.txt for the retained license.
import 'package:flutter/material.dart';

class HyperAnimatedCheckmark extends StatefulWidget {
  static const defaultDuration = Duration(milliseconds: 200);
  static const defaultCurve = Curves.easeIn;

  const HyperAnimatedCheckmark({
    super.key,
    this.animateOnMount = false,
    this.glyphScale = 1.15,
    required this.state,
    required this.color,
    required this.strokeWidth,
    required this.duration,
    required this.curve,
  });

  final bool? state;
  final bool animateOnMount;
  final double glyphScale;
  final Color color;
  final double strokeWidth;
  final Duration duration;
  final Curve curve;

  @override
  State<HyperAnimatedCheckmark> createState() => _HyperAnimatedCheckmarkState();
}

class _HyperAnimatedCheckmarkState extends State<HyperAnimatedCheckmark>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late bool? _fromState;

  @override
  void initState() {
    super.initState();
    _fromState = widget.animateOnMount ? false : widget.state;
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..value = 1;
    if (widget.animateOnMount && widget.duration != Duration.zero) {
      _controller.forward(from: 0);
    }
  }

  @override
  void didUpdateWidget(HyperAnimatedCheckmark oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.duration = widget.duration;
    if (oldWidget.state == widget.state) return;
    _fromState = oldWidget.state;
    if (widget.duration == Duration.zero) {
      _controller.value = 1;
    } else {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => CustomPaint(
        painter: _CheckboxMarkPainter(
          fromState: _fromState,
          toState: widget.state,
          progress: widget.curve.transform(_controller.value),
          color: widget.color,
          strokeWidth: widget.strokeWidth,
          glyphScale: widget.glyphScale,
        ),
      ),
    );
  }
}

class _CheckboxMarkPainter extends CustomPainter {
  const _CheckboxMarkPainter({
    required this.fromState,
    required this.toState,
    required this.progress,
    required this.color,
    required this.strokeWidth,
    required this.glyphScale,
  });

  final bool? fromState;
  final bool? toState;
  final double progress;
  final Color color;
  final double strokeWidth;
  final double glyphScale;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..isAntiAlias = true
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    // Adapted from Flutter's _CheckboxPainter (BSD-3-Clause).
    // Use two straight 45-degree strokes and its two-phase mark animation.
    final edge = size.shortestSide * glyphScale / 2;
    final origin = size.center(Offset.zero) - Offset(edge / 2, edge / 2);
    void check(double t) {
      if (t <= 0) return;
      canvas.drawPath(hyperCheckboxCheckPath(origin, edge, t), paint);
    }

    void dash(double t) {
      if (t <= 0) return;
      final start = origin + Offset(edge * .2, edge * .5);
      final mid = origin + Offset(edge * .5, edge * .5);
      final end = origin + Offset(edge * .8, edge * .5);
      canvas.drawLine(
        Offset.lerp(start, mid, 1 - t)!,
        Offset.lerp(mid, end, t)!,
        paint,
      );
    }

    void mark(bool? state, double t) {
      if (state == true) {
        check(t);
      }
      if (state == null) {
        dash(t);
      }
    }

    if (fromState == toState) {
      mark(toState, toState == false ? 0 : 1);
    } else if (fromState == false || toState == false) {
      final t = toState == false ? 1 - progress : progress;
      mark(toState == false ? fromState : toState, ((t - .5) * 2).clamp(0, 1));
    } else if (progress <= .5) {
      mark(fromState, 1 - progress * 2);
    } else {
      mark(toState, (progress - .5) * 2);
    }
  }

  @override
  bool shouldRepaint(_CheckboxMarkPainter oldDelegate) =>
      fromState != oldDelegate.fromState ||
      toState != oldDelegate.toState ||
      progress != oldDelegate.progress ||
      color != oldDelegate.color ||
      strokeWidth != oldDelegate.strokeWidth ||
      glyphScale != oldDelegate.glyphScale;
}

// Flutter Checkbox geometry shared by checkmark-bearing controls.
Path hyperCheckboxCheckPath(Offset origin, double edge, double progress) {
  final start = origin + Offset(edge * .15, edge * .45);
  final mid = origin + Offset(edge * .4, edge * .7);
  final end = origin + Offset(edge * .85, edge * .25);
  final path = Path()..moveTo(start.dx, start.dy);
  if (progress < .5) {
    final point = Offset.lerp(start, mid, progress * 2)!;
    path.lineTo(point.dx, point.dy);
  } else {
    final point = Offset.lerp(mid, end, (progress - .5) * 2)!;
    path.lineTo(mid.dx, mid.dy);
    path.lineTo(point.dx, point.dy);
  }
  return path;
}
