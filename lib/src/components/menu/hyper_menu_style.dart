import 'package:flutter/material.dart';

import '../card/hyper_card_style.dart';
import '../overlay/hyper_anchored_overlay.dart';

/// 菜单实例或主题中的明确覆盖；null 字段继续继承。
@immutable
final class HyperMenuStyle {
  const HyperMenuStyle({
    this.width,
    this.maxHeight,
    this.itemHeight,
    this.padding,
    this.surfacePadding,
    this.groupSpacing,
    this.itemRadius,
    this.surfaceRadius,
    this.iconSize,
    this.iconSpacing,
    this.foregroundColor,
    this.disabledColor,
    this.selectedBackgroundColor,
    this.selectedForegroundColor,
    this.activeBackgroundColor,
    this.itemTextStyle,
    this.groupTitleStyle,
    this.surfaceStyle,
    this.submenuTransitionBuilder,
  });

  final double? width;
  final double? maxHeight;
  final double? itemHeight;
  final double? padding;

  /// 菜单表面到菜单项的内边距，独立于菜单项文字内边距。
  final double? surfacePadding;
  final double? groupSpacing;
  final double? itemRadius;
  final double? surfaceRadius;
  final double? iconSize;
  final double? iconSpacing;
  final Color? foregroundColor;
  final Color? disabledColor;
  final Color? selectedBackgroundColor;
  final Color? selectedForegroundColor;
  final Color? activeBackgroundColor;
  final TextStyle? itemTextStyle;
  final TextStyle? groupTitleStyle;
  final HyperCardStyle? surfaceStyle;
  final HyperOverlayTransitionBuilder? submenuTransitionBuilder;

  HyperMenuStyle copyWith({
    double? width,
    double? maxHeight,
    double? itemHeight,
    double? padding,
    double? surfacePadding,
    double? groupSpacing,
    double? itemRadius,
    double? surfaceRadius,
    double? iconSize,
    double? iconSpacing,
    Color? foregroundColor,
    Color? disabledColor,
    Color? selectedBackgroundColor,
    Color? selectedForegroundColor,
    Color? activeBackgroundColor,
    TextStyle? itemTextStyle,
    TextStyle? groupTitleStyle,
    HyperCardStyle? surfaceStyle,
    HyperOverlayTransitionBuilder? submenuTransitionBuilder,
  }) => HyperMenuStyle(
    width: width ?? this.width,
    maxHeight: maxHeight ?? this.maxHeight,
    itemHeight: itemHeight ?? this.itemHeight,
    padding: padding ?? this.padding,
    surfacePadding: surfacePadding ?? this.surfacePadding,
    groupSpacing: groupSpacing ?? this.groupSpacing,
    itemRadius: itemRadius ?? this.itemRadius,
    surfaceRadius: surfaceRadius ?? this.surfaceRadius,
    iconSize: iconSize ?? this.iconSize,
    iconSpacing: iconSpacing ?? this.iconSpacing,
    foregroundColor: foregroundColor ?? this.foregroundColor,
    disabledColor: disabledColor ?? this.disabledColor,
    selectedBackgroundColor:
        selectedBackgroundColor ?? this.selectedBackgroundColor,
    selectedForegroundColor:
        selectedForegroundColor ?? this.selectedForegroundColor,
    activeBackgroundColor: activeBackgroundColor ?? this.activeBackgroundColor,
    itemTextStyle: itemTextStyle ?? this.itemTextStyle,
    groupTitleStyle: groupTitleStyle ?? this.groupTitleStyle,
    surfaceStyle: surfaceStyle ?? this.surfaceStyle,
    submenuTransitionBuilder:
        submenuTransitionBuilder ?? this.submenuTransitionBuilder,
  );

  HyperMenuStyle merge(HyperMenuStyle? other) {
    if (other == null) return this;
    return HyperMenuStyle(
      width: other.width ?? width,
      maxHeight: other.maxHeight ?? maxHeight,
      itemHeight: other.itemHeight ?? itemHeight,
      padding: other.padding ?? padding,
      surfacePadding: other.surfacePadding ?? surfacePadding,
      groupSpacing: other.groupSpacing ?? groupSpacing,
      itemRadius: other.itemRadius ?? itemRadius,
      surfaceRadius: other.surfaceRadius ?? surfaceRadius,
      iconSize: other.iconSize ?? iconSize,
      iconSpacing: other.iconSpacing ?? iconSpacing,
      foregroundColor: other.foregroundColor ?? foregroundColor,
      disabledColor: other.disabledColor ?? disabledColor,
      selectedBackgroundColor:
          other.selectedBackgroundColor ?? selectedBackgroundColor,
      selectedForegroundColor:
          other.selectedForegroundColor ?? selectedForegroundColor,
      activeBackgroundColor:
          other.activeBackgroundColor ?? activeBackgroundColor,
      itemTextStyle: other.itemTextStyle ?? itemTextStyle,
      groupTitleStyle: other.groupTitleStyle ?? groupTitleStyle,
      surfaceStyle:
          surfaceStyle?.merge(other.surfaceStyle) ?? other.surfaceStyle,
      submenuTransitionBuilder:
          other.submenuTransitionBuilder ?? submenuTransitionBuilder,
    );
  }

  static HyperMenuStyle lerp(HyperMenuStyle a, HyperMenuStyle b, double t) {
    T? discrete<T>(T? x, T? y) => t < .5 ? x : y;
    double? number(double? x, double? y) =>
        x == null || y == null ? discrete(x, y) : x + (y - x) * t;
    return HyperMenuStyle(
      width: number(a.width, b.width),
      maxHeight: number(a.maxHeight, b.maxHeight),
      itemHeight: number(a.itemHeight, b.itemHeight),
      padding: number(a.padding, b.padding),
      surfacePadding: number(a.surfacePadding, b.surfacePadding),
      groupSpacing: number(a.groupSpacing, b.groupSpacing),
      itemRadius: number(a.itemRadius, b.itemRadius),
      surfaceRadius: number(a.surfaceRadius, b.surfaceRadius),
      iconSize: number(a.iconSize, b.iconSize),
      iconSpacing: number(a.iconSpacing, b.iconSpacing),
      foregroundColor: Color.lerp(a.foregroundColor, b.foregroundColor, t),
      disabledColor: Color.lerp(a.disabledColor, b.disabledColor, t),
      selectedBackgroundColor: Color.lerp(
        a.selectedBackgroundColor,
        b.selectedBackgroundColor,
        t,
      ),
      selectedForegroundColor: Color.lerp(
        a.selectedForegroundColor,
        b.selectedForegroundColor,
        t,
      ),
      activeBackgroundColor: Color.lerp(
        a.activeBackgroundColor,
        b.activeBackgroundColor,
        t,
      ),
      itemTextStyle: TextStyle.lerp(a.itemTextStyle, b.itemTextStyle, t),
      groupTitleStyle: TextStyle.lerp(a.groupTitleStyle, b.groupTitleStyle, t),
      surfaceStyle: a.surfaceStyle == null || b.surfaceStyle == null
          ? discrete(a.surfaceStyle, b.surfaceStyle)
          : HyperCardStyle.lerp(a.surfaceStyle!, b.surfaceStyle!, t),
      submenuTransitionBuilder: discrete(
        a.submenuTransitionBuilder,
        b.submenuTransitionBuilder,
      ),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is HyperMenuStyle &&
      other.width == width &&
      other.maxHeight == maxHeight &&
      other.itemHeight == itemHeight &&
      other.padding == padding &&
      other.surfacePadding == surfacePadding &&
      other.groupSpacing == groupSpacing &&
      other.itemRadius == itemRadius &&
      other.surfaceRadius == surfaceRadius &&
      other.iconSize == iconSize &&
      other.iconSpacing == iconSpacing &&
      other.foregroundColor == foregroundColor &&
      other.disabledColor == disabledColor &&
      other.selectedBackgroundColor == selectedBackgroundColor &&
      other.selectedForegroundColor == selectedForegroundColor &&
      other.activeBackgroundColor == activeBackgroundColor &&
      other.itemTextStyle == itemTextStyle &&
      other.groupTitleStyle == groupTitleStyle &&
      other.surfaceStyle == surfaceStyle &&
      other.submenuTransitionBuilder == submenuTransitionBuilder;

  @override
  int get hashCode => Object.hashAll([
    width,
    maxHeight,
    itemHeight,
    padding,
    surfacePadding,
    groupSpacing,
    itemRadius,
    surfaceRadius,
    iconSize,
    iconSpacing,
    foregroundColor,
    disabledColor,
    selectedBackgroundColor,
    selectedForegroundColor,
    activeBackgroundColor,
    itemTextStyle,
    groupTitleStyle,
    surfaceStyle,
    submenuTransitionBuilder,
  ]);
}
