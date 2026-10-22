import 'package:flutter/widgets.dart';

const _unchanged = Object();

/// 当前设备的通用抽屉尺寸。
@immutable
final class HyperDrawerSize {
  const HyperDrawerSize({
    required this.width,
    this.radius,
    this.margin = EdgeInsets.zero,
    this.borderRadius,
  });

  final double width;
  final double? radius;

  /// 抽屉表面与所在 Scaffold 四边之间的留白，宽度不包含此留白。
  final EdgeInsetsGeometry margin;

  /// 整体四角规格；null 时保留随抽屉起止方向解析的既有圆角。
  final BorderRadiusGeometry? borderRadius;

  HyperDrawerSize copyWith({
    double? width,
    double? radius,
    EdgeInsetsGeometry? margin,
    Object? borderRadius = _unchanged,
  }) => HyperDrawerSize(
    width: width ?? this.width,
    radius: radius ?? this.radius,
    margin: margin ?? this.margin,
    borderRadius: identical(borderRadius, _unchanged)
        ? this.borderRadius
        : borderRadius as BorderRadiusGeometry?,
  );

  static HyperDrawerSize lerp(HyperDrawerSize a, HyperDrawerSize b, double t) =>
      HyperDrawerSize(
        width: a.width + (b.width - a.width) * t,
        margin: EdgeInsetsGeometry.lerp(a.margin, b.margin, t)!,
        borderRadius: a.borderRadius == null || b.borderRadius == null
            ? (t < .5 ? a.borderRadius : b.borderRadius)
            : BorderRadiusGeometry.lerp(a.borderRadius, b.borderRadius, t),
        radius: a.radius == null || b.radius == null
            ? (t < .5 ? a.radius : b.radius)
            : a.radius! + (b.radius! - a.radius!) * t,
      );

  @override
  bool operator ==(Object other) =>
      other is HyperDrawerSize &&
      other.width == width &&
      other.radius == radius &&
      other.margin == margin &&
      other.borderRadius == borderRadius;

  @override
  int get hashCode => Object.hash(width, radius, margin, borderRadius);
}
