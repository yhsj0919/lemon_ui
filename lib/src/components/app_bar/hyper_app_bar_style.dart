import 'package:flutter/material.dart';

import '../../foundation/hyper_surface_material.dart';

/// 固定与滚动顶栏共用的视觉覆盖。
@immutable
final class HyperAppBarStyle {
  const HyperAppBarStyle({
    this.backgroundColor,
    this.foregroundColor,
    this.titleTextStyle,
    this.expandedTitleTextStyle,
    this.material,
    this.centerTitle,
    this.elevation,
  });

  final Color? backgroundColor;
  final Color? foregroundColor;
  final TextStyle? titleTextStyle;
  final TextStyle? expandedTitleTextStyle;
  final HyperSurfaceMaterial? material;

  /// 收起标题默认居中；设为 false 时按阅读方向在起始侧对齐。
  final bool? centerTitle;
  final double? elevation;

  HyperAppBarStyle merge(HyperAppBarStyle? other) => other == null
      ? this
      : HyperAppBarStyle(
          backgroundColor: other.backgroundColor ?? backgroundColor,
          foregroundColor: other.foregroundColor ?? foregroundColor,
          titleTextStyle:
              titleTextStyle?.merge(other.titleTextStyle) ??
              other.titleTextStyle,
          expandedTitleTextStyle:
              expandedTitleTextStyle?.merge(other.expandedTitleTextStyle) ??
              other.expandedTitleTextStyle,
          material: other.material ?? material,
          centerTitle: other.centerTitle ?? centerTitle,
          elevation: other.elevation ?? elevation,
        );

  HyperAppBarStyle copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    TextStyle? titleTextStyle,
    TextStyle? expandedTitleTextStyle,
    HyperSurfaceMaterial? material,
    bool? centerTitle,
    double? elevation,
  }) => merge(
    HyperAppBarStyle(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      titleTextStyle: titleTextStyle,
      expandedTitleTextStyle: expandedTitleTextStyle,
      material: material,
      centerTitle: centerTitle,
      elevation: elevation,
    ),
  );

  static HyperAppBarStyle lerp(
    HyperAppBarStyle a,
    HyperAppBarStyle b,
    double t,
  ) => HyperAppBarStyle(
    backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
    foregroundColor: Color.lerp(a.foregroundColor, b.foregroundColor, t),
    titleTextStyle: TextStyle.lerp(a.titleTextStyle, b.titleTextStyle, t),
    expandedTitleTextStyle: TextStyle.lerp(
      a.expandedTitleTextStyle,
      b.expandedTitleTextStyle,
      t,
    ),
    material: a.material == null || b.material == null
        ? (t < .5 ? a.material : b.material)
        : HyperSurfaceMaterial.lerp(a.material!, b.material!, t),
    centerTitle: t < .5 ? a.centerTitle : b.centerTitle,
    elevation: a.elevation == null || b.elevation == null
        ? (t < .5 ? a.elevation : b.elevation)
        : a.elevation! + (b.elevation! - a.elevation!) * t,
  );

  @override
  bool operator ==(Object other) =>
      other is HyperAppBarStyle &&
      other.backgroundColor == backgroundColor &&
      other.foregroundColor == foregroundColor &&
      other.titleTextStyle == titleTextStyle &&
      other.expandedTitleTextStyle == expandedTitleTextStyle &&
      other.material == material &&
      other.centerTitle == centerTitle &&
      other.elevation == elevation;

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    foregroundColor,
    titleTextStyle,
    expandedTitleTextStyle,
    material,
    centerTitle,
    elevation,
  );
}
