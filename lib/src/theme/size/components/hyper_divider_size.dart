import 'package:flutter/foundation.dart';

/// 当前设备的 HyperDivider 尺寸规格。
@immutable
final class HyperDividerSize {
  const HyperDividerSize({
    required this.thickness,
    required this.dashLength,
    required this.gap,
  });
  final double thickness;
  final double dashLength;
  final double gap;
  HyperDividerSize copyWith({
    double? thickness,
    double? dashLength,
    double? gap,
  }) => HyperDividerSize(
    thickness: thickness ?? this.thickness,
    dashLength: dashLength ?? this.dashLength,
    gap: gap ?? this.gap,
  );
  static HyperDividerSize lerp(
    HyperDividerSize a,
    HyperDividerSize b,
    double t,
  ) => HyperDividerSize(
    thickness: a.thickness + (b.thickness - a.thickness) * t,
    dashLength: a.dashLength + (b.dashLength - a.dashLength) * t,
    gap: a.gap + (b.gap - a.gap) * t,
  );
  @override
  bool operator ==(Object other) =>
      other is HyperDividerSize &&
      other.thickness == thickness &&
      other.dashLength == dashLength &&
      other.gap == gap;
  @override
  int get hashCode => Object.hash(thickness, dashLength, gap);
}
