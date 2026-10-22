import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'hyper_pie_chart.dart';

/// 外部引导线标签。按左右两侧分别避让，容纳不下时隐藏多余标签。
class HyperPieLeaderLabels extends StatelessWidget {
  const HyperPieLeaderLabels({
    super.key,
    required this.sections,
    required this.hidden,
    required this.total,
    required this.radius,
    required this.style,
    required this.strokeWidth,
    required this.gap,
    required this.scaler,
    required this.direction,
    this.formatter,
  });
  final List<HyperPieSection> sections;
  final Set<int> hidden;
  final double total, radius, strokeWidth, gap;
  final TextStyle style;
  final TextScaler scaler;
  final TextDirection direction;
  final String Function(HyperPieChartHit hit, double percent)? formatter;
  @override
  Widget build(BuildContext context) => CustomPaint(painter: _Leaders(this));
}

class _Label {
  _Label(this.anchor, this.elbow, this.right, this.text);
  final Offset anchor;
  final Offset elbow;
  final bool right;
  final TextPainter text;
}

class _Leaders extends CustomPainter {
  _Leaders(this.data);
  final HyperPieLeaderLabels data;
  @override
  void paint(Canvas canvas, Size size) {
    if (data.total <= 0 || size.isEmpty) return;
    final center = size.center(Offset.zero);
    final labels = <_Label>[];
    var angle = -math.pi / 2;
    for (var i = 0; i < data.sections.length; i++) {
      final section = data.sections[i];
      if (data.hidden.contains(i) || section.value <= 0) continue;
      final sweep = section.value / data.total * math.pi * 2;
      final mid = angle + sweep / 2;
      angle += sweep;
      final right = math.cos(mid) >= 0;
      final labelWidth = math.max(
        0.0,
        (size.width / 2 - data.radius - data.gap * 2.5),
      );
      if (labelWidth <= 0) continue;
      final text = TextPainter(
        text: TextSpan(
          style: data.style,
          text:
              data.formatter?.call(
                HyperPieChartHit(index: i, section: section),
                section.value / data.total * 100,
              ) ??
              '${section.label} ${section.value} (${(section.value / data.total * 100).toStringAsFixed(1)}%)',
        ),
        textScaler: data.scaler,
        textDirection: data.direction,
        maxLines: 2,
        ellipsis: '…',
      )..layout(maxWidth: labelWidth);
      labels.add(
        _Label(
          center + Offset(math.cos(mid), math.sin(mid)) * data.radius,
          center +
              Offset(math.cos(mid), math.sin(mid)) * (data.radius + data.gap),
          right,
          text,
        ),
      );
    }
    final paint = Paint()
      ..color = data.style.color ?? Colors.grey
      ..strokeWidth = data.strokeWidth
      ..style = PaintingStyle.stroke;
    for (final right in [false, true]) {
      final side = labels.where((label) => label.right == right).toList()
        ..sort((a, b) => a.anchor.dy.compareTo(b.anchor.dy));
      var bottom = 0.0;
      for (final label in side) {
        final y = math
            .max(bottom, label.elbow.dy - label.text.height / 2)
            .clamp(0.0, math.max(0.0, size.height - label.text.height))
            .toDouble();
        if (y < bottom || label.text.height > size.height) {
          label.text.dispose();
          continue;
        }
        final lineX =
            center.dx + (right ? 1 : -1) * (data.radius + data.gap * 2);
        final x = right
            ? lineX + data.gap / 2
            : lineX - data.gap / 2 - label.text.width;
        final end = Offset(lineX, y + label.text.height / 2);
        canvas.drawPath(
          Path()
            ..moveTo(label.anchor.dx, label.anchor.dy)
            ..lineTo(label.elbow.dx, end.dy)
            ..lineTo(end.dx, end.dy),
          paint,
        );
        label.text.paint(canvas, Offset(x, y));
        bottom = y + label.text.height + data.gap / 2;
        label.text.dispose();
      }
    }
  }

  @override
  bool shouldRepaint(_Leaders oldDelegate) => true;
}
