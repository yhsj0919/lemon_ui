import 'package:flutter/foundation.dart';

/// 当前设备的尺寸；可选字段为空时保留组件已有的几何推导。
@immutable
final class HyperDividerSize {
  const HyperDividerSize({
    required this.thickness,
    required this.dashLength,
    required this.contentGap,
    required this.edgeExtent,
    required this.iconSize,
    required this.gap,
    this.length,
    this.indent,
    this.endIndent,
    this.radius,
  });
  final double thickness;
  final double dashLength;
  final double contentGap;
  final double edgeExtent;
  final double iconSize;
  final double gap;
  final double? length;
  final double? indent;
  final double? endIndent;
  final double? radius;
  HyperDividerSize copyWith({
    double? thickness,
    double? dashLength,
    double? contentGap,
    double? edgeExtent,
    double? iconSize,
    double? gap,
    double? length,
    double? indent,
    double? endIndent,
    double? radius,
  }) => HyperDividerSize(
    thickness: thickness ?? this.thickness,
    dashLength: dashLength ?? this.dashLength,
    contentGap: contentGap ?? this.contentGap,
    edgeExtent: edgeExtent ?? this.edgeExtent,
    iconSize: iconSize ?? this.iconSize,
    gap: gap ?? this.gap,
    length: length ?? this.length,
    indent: indent ?? this.indent,
    endIndent: endIndent ?? this.endIndent,
    radius: radius ?? this.radius,
  );
  static HyperDividerSize lerp(
    HyperDividerSize a,
    HyperDividerSize b,
    double t,
  ) {
    double? optional(double? x, double? y) =>
        x == null || y == null ? (t < .5 ? x : y) : x + (y - x) * t;
    return HyperDividerSize(
      thickness: a.thickness + (b.thickness - a.thickness) * t,
      dashLength: a.dashLength + (b.dashLength - a.dashLength) * t,
      contentGap: a.contentGap + (b.contentGap - a.contentGap) * t,
      edgeExtent: a.edgeExtent + (b.edgeExtent - a.edgeExtent) * t,
      iconSize: a.iconSize + (b.iconSize - a.iconSize) * t,
      gap: a.gap + (b.gap - a.gap) * t,
      length: optional(a.length, b.length),
      indent: optional(a.indent, b.indent),
      endIndent: optional(a.endIndent, b.endIndent),
      radius: optional(a.radius, b.radius),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is HyperDividerSize &&
      other.thickness == thickness &&
      other.dashLength == dashLength &&
      other.contentGap == contentGap &&
      other.edgeExtent == edgeExtent &&
      other.iconSize == iconSize &&
      other.gap == gap &&
      other.length == length &&
      other.indent == indent &&
      other.endIndent == endIndent &&
      other.radius == radius;
  @override
  int get hashCode => Object.hashAll([
    thickness,
    dashLength,
    contentGap,
    edgeExtent,
    iconSize,
    gap,
    length,
    indent,
    endIndent,
    radius,
  ]);
}
