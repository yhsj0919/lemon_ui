import '../card/hyper_card_style.dart';

import 'package:flutter/material.dart';

/// 通用抽屉的实例或主题视觉覆盖；null 表示继承。
@immutable
final class HyperDrawerStyle {
  const HyperDrawerStyle({
    this.width,
    this.backgroundColor,
    this.surfaceStyle,
    this.elevation,
    this.shape,
  });

  final double? width;
  final Color? backgroundColor;
  final HyperCardStyle? surfaceStyle;
  final double? elevation;
  final ShapeBorder? shape;

  HyperDrawerStyle copyWith({
    double? width,
    Color? backgroundColor,
    HyperCardStyle? surfaceStyle,
    double? elevation,
    ShapeBorder? shape,
  }) => HyperDrawerStyle(
    width: width ?? this.width,
    backgroundColor: backgroundColor ?? this.backgroundColor,
    surfaceStyle: surfaceStyle ?? this.surfaceStyle,
    elevation: elevation ?? this.elevation,
    shape: shape ?? this.shape,
  );

  HyperDrawerStyle merge(HyperDrawerStyle? other) => other == null
      ? this
      : copyWith(
          width: other.width,
          backgroundColor: other.backgroundColor,
          surfaceStyle:surfaceStyle?.merge(other.surfaceStyle)??other.surfaceStyle,
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
    surfaceStyle: a.surfaceStyle == null || b.surfaceStyle == null
        ? (t < .5 ? a.surfaceStyle : b.surfaceStyle)
        : HyperCardStyle.lerp(a.surfaceStyle!, b.surfaceStyle!, t),
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
