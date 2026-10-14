import 'package:flutter/foundation.dart';

/// 当前设备的尺寸；可选字段为空时保留组件已有的几何推导。
@immutable
final class HyperCheckboxSize {
  const HyperCheckboxSize({
    required this.size,
    required this.markStrokeWidth,
    required this.roundedRadius,
    this.minimumTapTargetSize,
    this.circleRadius,
    this.markSize,
  });
  final double size;
  final double? markSize;
  final double markStrokeWidth;
  final double roundedRadius;
  final double? minimumTapTargetSize;
  final double? circleRadius;
  HyperCheckboxSize copyWith({
    double? size,
    double? markSize,
    double? markStrokeWidth,
    double? roundedRadius,
    double? minimumTapTargetSize,
    double? circleRadius,
  }) => HyperCheckboxSize(
    size: size ?? this.size,
    markSize: markSize ?? this.markSize,
    markStrokeWidth: markStrokeWidth ?? this.markStrokeWidth,
    roundedRadius: roundedRadius ?? this.roundedRadius,
    minimumTapTargetSize: minimumTapTargetSize ?? this.minimumTapTargetSize,
    circleRadius: circleRadius ?? this.circleRadius,
  );
  static HyperCheckboxSize lerp(
    HyperCheckboxSize a,
    HyperCheckboxSize b,
    double t,
  ) {
    double? optional(double? x, double? y) =>
        x == null || y == null ? (t < .5 ? x : y) : x + (y - x) * t;
    return HyperCheckboxSize(
      markSize: optional(a.markSize, b.markSize),
      size: a.size + (b.size - a.size) * t,
      markStrokeWidth:
          a.markStrokeWidth + (b.markStrokeWidth - a.markStrokeWidth) * t,
      roundedRadius: a.roundedRadius + (b.roundedRadius - a.roundedRadius) * t,
      minimumTapTargetSize: optional(
        a.minimumTapTargetSize,
        b.minimumTapTargetSize,
      ),
      circleRadius: optional(a.circleRadius, b.circleRadius),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is HyperCheckboxSize &&
      other.size == size &&
      other.markSize == markSize &&
      other.markStrokeWidth == markStrokeWidth &&
      other.roundedRadius == roundedRadius &&
      other.minimumTapTargetSize == minimumTapTargetSize &&
      other.circleRadius == circleRadius;
  @override
  int get hashCode => Object.hashAll([
    size,
    markSize,
    markStrokeWidth,
    roundedRadius,
    minimumTapTargetSize,
    circleRadius,
  ]);
}
