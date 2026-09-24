import 'package:flutter/foundation.dart';

/// 当前设备的弹出菜单尺寸，由主题统一提供。
@immutable
final class HyperMenuSize {
  const HyperMenuSize({
    required this.width,
    required this.itemHeight,
    required this.padding,
    required this.groupSpacing,
    required this.iconSize,
    required this.iconSpacing,
    required this.itemRadius,
    required this.surfaceRadius,
  });

  final double width;
  final double itemHeight;
  final double padding;
  final double groupSpacing;
  final double iconSize;
  final double iconSpacing;
  final double itemRadius;

  /// 菜单表面圆角，与内层菜单项的圆角分别管理。
  final double surfaceRadius;

  HyperMenuSize copyWith({
    double? width,
    double? itemHeight,
    double? padding,
    double? groupSpacing,
    double? iconSize,
    double? iconSpacing,
    double? itemRadius,
    double? surfaceRadius,
  }) => HyperMenuSize(
    width: width ?? this.width,
    itemHeight: itemHeight ?? this.itemHeight,
    padding: padding ?? this.padding,
    groupSpacing: groupSpacing ?? this.groupSpacing,
    iconSize: iconSize ?? this.iconSize,
    iconSpacing: iconSpacing ?? this.iconSpacing,
    itemRadius: itemRadius ?? this.itemRadius,
    surfaceRadius: surfaceRadius ?? this.surfaceRadius,
  );

  static HyperMenuSize lerp(HyperMenuSize a, HyperMenuSize b, double t) {
    double value(double x, double y) => x + (y - x) * t;
    return HyperMenuSize(
      width: value(a.width, b.width),
      itemHeight: value(a.itemHeight, b.itemHeight),
      padding: value(a.padding, b.padding),
      groupSpacing: value(a.groupSpacing, b.groupSpacing),
      iconSize: value(a.iconSize, b.iconSize),
      iconSpacing: value(a.iconSpacing, b.iconSpacing),
      itemRadius: value(a.itemRadius, b.itemRadius),
      surfaceRadius: value(a.surfaceRadius, b.surfaceRadius),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is HyperMenuSize &&
      other.width == width &&
      other.itemHeight == itemHeight &&
      other.padding == padding &&
      other.groupSpacing == groupSpacing &&
      other.iconSize == iconSize &&
      other.iconSpacing == iconSpacing &&
      other.itemRadius == itemRadius &&
      other.surfaceRadius == surfaceRadius;

  @override
  int get hashCode => Object.hash(
    width,
    itemHeight,
    padding,
    groupSpacing,
    iconSize,
    iconSpacing,
    itemRadius,
    surfaceRadius,
  );
}
