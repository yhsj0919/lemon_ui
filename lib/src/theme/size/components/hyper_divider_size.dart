import 'package:flutter/foundation.dart';

/// 当前设备的 HyperDivider 尺寸规格。
@immutable
final class HyperDividerSize {
  const HyperDividerSize({
    required this.thickness,
    required this.dashLength,
    required this.contentGap,
    required this.edgeExtent,
    required this.iconSize,
    required this.gap,
  });
  final double thickness;
  final double dashLength;
  final double contentGap;
  final double edgeExtent;
  final double iconSize;
  final double gap;
  HyperDividerSize copyWith({
    double? thickness,
    double? dashLength,
    double? contentGap,
    double? edgeExtent,
    double? iconSize,
    double? gap,
  }) => HyperDividerSize(
    thickness: thickness ?? this.thickness,
    dashLength: dashLength ?? this.dashLength,
    contentGap: contentGap ?? this.contentGap,
    edgeExtent: edgeExtent ?? this.edgeExtent,
    iconSize: iconSize ?? this.iconSize,
    gap: gap ?? this.gap,
  );
  static HyperDividerSize lerp(
    HyperDividerSize a,
    HyperDividerSize b,
    double t,
  ) => HyperDividerSize(
    thickness: a.thickness + (b.thickness - a.thickness) * t,
    dashLength: a.dashLength + (b.dashLength - a.dashLength) * t,
    contentGap: a.contentGap + (b.contentGap - a.contentGap) * t,
    edgeExtent: a.edgeExtent + (b.edgeExtent - a.edgeExtent) * t,
    iconSize: a.iconSize + (b.iconSize - a.iconSize) * t,
    gap: a.gap + (b.gap - a.gap) * t,
  );
  @override
  bool operator ==(Object other) =>
      other is HyperDividerSize &&
      other.thickness == thickness &&
      other.dashLength == dashLength &&
      other.contentGap == contentGap &&
      other.edgeExtent == edgeExtent &&
      other.iconSize == iconSize &&
      other.gap == gap;
  @override
  int get hashCode =>
      Object.hash(thickness, dashLength, gap, contentGap, edgeExtent, iconSize);
}
