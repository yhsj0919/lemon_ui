import 'package:flutter/foundation.dart';

/// 当前设备的 HyperCheckbox 尺寸规格。
@immutable
final class HyperCheckboxSize {
  const HyperCheckboxSize({
    required this.size,
    required this.markStrokeWidth,
    required this.roundedRadius,
  });
  final double size;
  final double markStrokeWidth;
  final double roundedRadius;
  HyperCheckboxSize copyWith({
    double? size,
    double? markStrokeWidth,
    double? roundedRadius,
  }) => HyperCheckboxSize(
    size: size ?? this.size,
    markStrokeWidth: markStrokeWidth ?? this.markStrokeWidth,
    roundedRadius: roundedRadius ?? this.roundedRadius,
  );
  static HyperCheckboxSize lerp(
    HyperCheckboxSize a,
    HyperCheckboxSize b,
    double t,
  ) => HyperCheckboxSize(
    size: a.size + (b.size - a.size) * t,
    markStrokeWidth:
        a.markStrokeWidth + (b.markStrokeWidth - a.markStrokeWidth) * t,
    roundedRadius: a.roundedRadius + (b.roundedRadius - a.roundedRadius) * t,
  );
  @override
  bool operator ==(Object other) =>
      other is HyperCheckboxSize &&
      other.size == size &&
      other.markStrokeWidth == markStrokeWidth &&
      other.roundedRadius == roundedRadius;
  @override
  int get hashCode => Object.hash(size, markStrokeWidth, roundedRadius);
}
