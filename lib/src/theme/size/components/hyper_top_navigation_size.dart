import 'package:flutter/material.dart';

/// 顶部导航当前设备的布局规格，四端默认值由 HyperSizeScheme 管理。
@immutable
final class HyperTopNavigationSize {
  const HyperTopNavigationSize({
    required this.height,
    required this.radius,
    required this.padding,
    required this.iconSize,
    required this.iconSpacing,
    this.itemSpacing = 4,
    this.descriptionGap = 2,
  });

  /// 当前设备的height规格，单位为逻辑像素。
  final double height;

  /// 当前设备的radius规格，单位为逻辑像素。
  final double radius;

  /// 当前设备的padding规格，单位为逻辑像素。
  final EdgeInsetsGeometry padding;

  /// 当前设备的iconSize规格，单位为逻辑像素。
  final double iconSize;

  /// 当前设备的iconSpacing规格，单位为逻辑像素。
  final double iconSpacing;

  /// 当前设备的itemSpacing规格，单位为逻辑像素。
  final double itemSpacing;

  /// 当前设备的descriptionGap规格，单位为逻辑像素。
  final double descriptionGap;
  HyperTopNavigationSize copyWith({
    double? height,
    double? radius,
    EdgeInsetsGeometry? padding,
    double? iconSize,
    double? iconSpacing,
    double? itemSpacing,
    double? descriptionGap,
  }) => HyperTopNavigationSize(
    height: height ?? this.height,
    radius: radius ?? this.radius,
    padding: padding ?? this.padding,
    iconSize: iconSize ?? this.iconSize,
    iconSpacing: iconSpacing ?? this.iconSpacing,
    itemSpacing: itemSpacing ?? this.itemSpacing,
    descriptionGap: descriptionGap ?? this.descriptionGap,
  );
  static HyperTopNavigationSize lerp(
    HyperTopNavigationSize a,
    HyperTopNavigationSize b,
    double t,
  ) => HyperTopNavigationSize(
    height: a.height + (b.height - a.height) * t,
    radius: a.radius + (b.radius - a.radius) * t,
    padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t)!,
    iconSize: a.iconSize + (b.iconSize - a.iconSize) * t,
    iconSpacing: a.iconSpacing + (b.iconSpacing - a.iconSpacing) * t,
    itemSpacing: a.itemSpacing + (b.itemSpacing - a.itemSpacing) * t,
    descriptionGap:
        a.descriptionGap + (b.descriptionGap - a.descriptionGap) * t,
  );
  @override
  bool operator ==(Object other) =>
      other is HyperTopNavigationSize &&
      other.height == height &&
      other.radius == radius &&
      other.padding == padding &&
      other.iconSize == iconSize &&
      other.iconSpacing == iconSpacing &&
      other.itemSpacing == itemSpacing &&
      other.descriptionGap == descriptionGap;
  @override
  int get hashCode => Object.hashAll([
    height,
    radius,
    padding,
    iconSize,
    iconSpacing,
    itemSpacing,
    descriptionGap,
  ]);
}
