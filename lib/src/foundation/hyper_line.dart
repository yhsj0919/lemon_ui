import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';

import 'hyper_fill.dart';
import '../painting/hyper_pattern_segments.dart';

/// 线条的绘制方式；分割线与边框共用。
enum HyperLinePattern { solid, dashed, dotted }

/// 共用线条样式。null 由使用它的组件表示继承，none 表示明确不绘制。
@immutable
class HyperLine {
  const HyperLine({
    required this.fill,
    required this.thickness,
    this.pattern = HyperLinePattern.solid,
    this.dashLength = 6,
    this.gap = 4,
    this.radius = 0,
  }) : assert(thickness >= 0),
       assert(dashLength >= 0),
       assert(gap >= 0),
       assert(radius >= 0);
  const HyperLine.none() : this(fill: const HyperFill.none(), thickness: 0);
  final HyperFill fill;
  final double thickness;
  final HyperLinePattern pattern;
  final double dashLength, gap, radius;
  bool get isNone => fill.isNone || thickness == 0;
  HyperLine copyWith({
    HyperFill? fill,
    double? thickness,
    HyperLinePattern? pattern,
    double? dashLength,
    double? gap,
    double? radius,
  }) => HyperLine(
    fill: fill ?? this.fill,
    thickness: thickness ?? this.thickness,
    pattern: pattern ?? this.pattern,
    dashLength: dashLength ?? this.dashLength,
    gap: gap ?? this.gap,
    radius: radius ?? this.radius,
  );
  static HyperLine lerp(HyperLine a, HyperLine b, double t) => HyperLine(
    fill: HyperFill.lerp(a.fill, b.fill, t),
    thickness: lerpDouble(a.thickness, b.thickness, t)!,
    pattern: t < .5 ? a.pattern : b.pattern,
    dashLength: lerpDouble(a.dashLength, b.dashLength, t)!,
    gap: lerpDouble(a.gap, b.gap, t)!,
    radius: lerpDouble(a.radius, b.radius, t)!,
  );
  Iterable<({double start, double end})> segments(double extent) => isNone
      ? const []
      : pattern == HyperLinePattern.solid
      ? [(start: 0.0, end: extent)]
      : hyperPatternSegments(
          extent: extent,
          dashLength: dashLength,
          gap: gap,
          dotDiameter: pattern == HyperLinePattern.dotted ? thickness : null,
        );
  @override
  bool operator ==(Object other) =>
      other is HyperLine &&
      other.fill == fill &&
      other.thickness == thickness &&
      other.pattern == pattern &&
      other.dashLength == dashLength &&
      other.gap == gap &&
      other.radius == radius;
  @override
  int get hashCode =>
      Object.hash(fill, thickness, pattern, dashLength, gap, radius);
}
