import 'package:flutter/foundation.dart';

/// 当前设备的尺寸；可选字段为空时保留组件已有的几何推导。
@immutable
final class HyperRadioSize {
  const HyperRadioSize({
    required this.size,
    this.minimumTapTargetSize,
    this.indicatorSize,
    this.markSize,
    this.strokeWidth,
    this.radius,
    this.spacing = 8,
  });
  final double size;
  final double spacing;
  final double? minimumTapTargetSize;
  final double? indicatorSize;
  final double? markSize;
  final double? strokeWidth;
  final double? radius;
  HyperRadioSize copyWith({
    double? size,
    double? spacing,
    double? minimumTapTargetSize,
    double? indicatorSize,
    double? markSize,
    double? strokeWidth,
    double? radius,
  }) => HyperRadioSize(
    size: size ?? this.size,
    spacing: spacing ?? this.spacing,
    minimumTapTargetSize: minimumTapTargetSize ?? this.minimumTapTargetSize,
    indicatorSize: indicatorSize ?? this.indicatorSize,
    markSize: markSize ?? this.markSize,
    strokeWidth: strokeWidth ?? this.strokeWidth,
    radius: radius ?? this.radius,
  );
  static HyperRadioSize lerp(HyperRadioSize a, HyperRadioSize b, double t) {
    double? optional(double? x, double? y) =>
        x == null || y == null ? (t < .5 ? x : y) : x + (y - x) * t;
    return HyperRadioSize(
      spacing: a.spacing + (b.spacing - a.spacing) * t,
      size: a.size + (b.size - a.size) * t,
      minimumTapTargetSize: optional(
        a.minimumTapTargetSize,
        b.minimumTapTargetSize,
      ),
      indicatorSize: optional(a.indicatorSize, b.indicatorSize),
      markSize: optional(a.markSize, b.markSize),
      strokeWidth: optional(a.strokeWidth, b.strokeWidth),
      radius: optional(a.radius, b.radius),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is HyperRadioSize &&
      other.size == size &&
      other.spacing == spacing &&
      other.minimumTapTargetSize == minimumTapTargetSize &&
      other.indicatorSize == indicatorSize &&
      other.markSize == markSize &&
      other.strokeWidth == strokeWidth &&
      other.radius == radius;
  @override
  int get hashCode => Object.hashAll([
    size,
    spacing,
    minimumTapTargetSize,
    indicatorSize,
    markSize,
    strokeWidth,
    radius,
  ]);
}
