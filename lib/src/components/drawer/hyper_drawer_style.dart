import 'package:flutter/material.dart';

/// 通用抽屉的实例或主题视觉覆盖；null 表示继承。
@immutable
final class HyperDrawerStyle {
  const HyperDrawerStyle({
    this.width,
    this.backgroundColor,
    this.elevation,
    this.shape,
  });

  final double? width;
  final Color? backgroundColor;
  final double? elevation;
  final ShapeBorder? shape;

  HyperDrawerStyle copyWith({
    double? width,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
  }) => HyperDrawerStyle(
    width: width ?? this.width,
    backgroundColor: backgroundColor ?? this.backgroundColor,
    elevation: elevation ?? this.elevation,
    shape: shape ?? this.shape,
  );

  HyperDrawerStyle merge(HyperDrawerStyle? other) => other == null
      ? this
      : copyWith(
          width: other.width,
          backgroundColor: other.backgroundColor,
          elevation: other.elevation,
          shape: other.shape,
        );

  static HyperDrawerStyle lerp(
    HyperDrawerStyle a,
    HyperDrawerStyle b,
    double t,
  ) => HyperDrawerStyle(
    width: a.width == null || b.width == null
        ? (t < .5 ? a.width : b.width)
        : a.width! + (b.width! - a.width!) * t,
    backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
    elevation: a.elevation == null || b.elevation == null
        ? (t < .5 ? a.elevation : b.elevation)
        : a.elevation! + (b.elevation! - a.elevation!) * t,
    shape: ShapeBorder.lerp(a.shape, b.shape, t),
  );

  @override
  bool operator ==(Object other) =>
      other is HyperDrawerStyle &&
      other.width == width &&
      other.backgroundColor == backgroundColor &&
      other.elevation == elevation &&
      other.shape == shape;

  @override
  int get hashCode => Object.hash(width, backgroundColor, elevation, shape);
}
