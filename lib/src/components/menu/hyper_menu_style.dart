import 'package:flutter/material.dart';

import '../card/hyper_card_style.dart';
import '../overlay/hyper_anchored_overlay.dart';

enum HyperMenuCheckPlacement { leading, trailing }

/// 菜单实例或主题中的明确覆盖；null 字段继续继承。
@immutable
final class HyperMenuStyle {
  const HyperMenuStyle({
    this.width,
    this.maxHeight,
    this.itemHeight,
    this.padding,
    this.surfacePadding,
    this.itemSpacing,
    this.groupSpacing,
    this.itemRadius,
    this.surfaceRadius,
    this.checkPlacement,
    this.checkColor,
    this.checkSize,
    this.checkSpacing,
    this.checkIcon,
    this.showCheckmark,
    this.iconSize,
    this.iconSpacing,
    this.foregroundColor,
    this.disabledColor,
    this.selectedBackgroundColor,
    this.selectedForegroundColor,
    this.activeBackgroundColor,
    this.itemTextStyle,
    this.descriptionStyle,
    this.descriptionGap,
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

  /// 同组相邻菜单项之间的间距。
  final double? itemSpacing;
  final double? groupSpacing;
  final double? itemRadius;
  final double? surfaceRadius;

  /// 选中项的标记图标。
  final HyperMenuCheckPlacement? checkPlacement;
  final Color? checkColor;
  final double? checkSize;
  final double? checkSpacing;
  final IconData? checkIcon;

  /// 是否显示选中对勾；false 保留选中配色但不占标记空间。
  final bool? showCheckmark;
  final double? iconSize;
  final double? iconSpacing;
  final Color? foregroundColor;
  final Color? disabledColor;
  final Color? selectedBackgroundColor;
  final Color? selectedForegroundColor;
  final Color? activeBackgroundColor;
  final TextStyle? itemTextStyle;

  /// 菜单描述的文字样式。
  final TextStyle? descriptionStyle;

  /// 菜单描述的标题间距，单位为逻辑像素。
  final double? descriptionGap;
  final TextStyle? groupTitleStyle;
  final HyperCardStyle? surfaceStyle;
  final HyperOverlayTransitionBuilder? submenuTransitionBuilder;

  HyperMenuStyle copyWith({
    double? width,
    double? maxHeight,
    double? itemHeight,
    double? padding,
    double? surfacePadding,
    double? itemSpacing,
    double? groupSpacing,
    double? itemRadius,
    double? surfaceRadius,
    HyperMenuCheckPlacement? checkPlacement,
    Color? checkColor,
    double? checkSize,
    double? checkSpacing,
    IconData? checkIcon,
    bool? showCheckmark,
    double? iconSize,
    double? iconSpacing,
    Color? foregroundColor,
    Color? disabledColor,
    Color? selectedBackgroundColor,
    Color? selectedForegroundColor,
    Color? activeBackgroundColor,
    TextStyle? itemTextStyle,
    TextStyle? descriptionStyle,
    double? descriptionGap,
    TextStyle? groupTitleStyle,
    HyperCardStyle? surfaceStyle,
    HyperOverlayTransitionBuilder? submenuTransitionBuilder,
  }) => HyperMenuStyle(
    width: width ?? this.width,
    maxHeight: maxHeight ?? this.maxHeight,
    itemHeight: itemHeight ?? this.itemHeight,
    padding: padding ?? this.padding,
    surfacePadding: surfacePadding ?? this.surfacePadding,
    itemSpacing: itemSpacing ?? this.itemSpacing,
    groupSpacing: groupSpacing ?? this.groupSpacing,
    itemRadius: itemRadius ?? this.itemRadius,
    surfaceRadius: surfaceRadius ?? this.surfaceRadius,
    checkPlacement: checkPlacement ?? this.checkPlacement,
    checkColor: checkColor ?? this.checkColor,
    checkSize: checkSize ?? this.checkSize,
    checkSpacing: checkSpacing ?? this.checkSpacing,
    checkIcon: checkIcon ?? this.checkIcon,
    showCheckmark: showCheckmark ?? this.showCheckmark,
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
    descriptionStyle: descriptionStyle ?? this.descriptionStyle,
    descriptionGap: descriptionGap ?? this.descriptionGap,
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
      itemSpacing: other.itemSpacing ?? itemSpacing,
      groupSpacing: other.groupSpacing ?? groupSpacing,
      itemRadius: other.itemRadius ?? itemRadius,
      surfaceRadius: other.surfaceRadius ?? surfaceRadius,
      checkPlacement: other.checkPlacement ?? checkPlacement,
      checkColor: other.checkColor ?? checkColor,
      checkSize: other.checkSize ?? checkSize,
      checkSpacing: other.checkSpacing ?? checkSpacing,
      checkIcon: other.checkIcon ?? checkIcon,
      showCheckmark: other.showCheckmark ?? showCheckmark,
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
      descriptionStyle:
          descriptionStyle?.merge(other.descriptionStyle) ??
          other.descriptionStyle,
      descriptionGap: other.descriptionGap ?? descriptionGap,
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
      itemSpacing: number(a.itemSpacing, b.itemSpacing),
      groupSpacing: number(a.groupSpacing, b.groupSpacing),
      itemRadius: number(a.itemRadius, b.itemRadius),
      surfaceRadius: number(a.surfaceRadius, b.surfaceRadius),
      checkPlacement: discrete(a.checkPlacement, b.checkPlacement),
      checkColor: Color.lerp(a.checkColor, b.checkColor, t),
      checkSize: number(a.checkSize, b.checkSize),
      checkSpacing: number(a.checkSpacing, b.checkSpacing),
      checkIcon: discrete(a.checkIcon, b.checkIcon),
      showCheckmark: discrete(a.showCheckmark, b.showCheckmark),
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
      descriptionStyle: TextStyle.lerp(
        a.descriptionStyle,
        b.descriptionStyle,
        t,
      ),
      descriptionGap: number(a.descriptionGap, b.descriptionGap),
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
      other.itemSpacing == itemSpacing &&
      other.groupSpacing == groupSpacing &&
      other.itemRadius == itemRadius &&
      other.surfaceRadius == surfaceRadius &&
      other.checkPlacement == checkPlacement &&
      other.checkColor == checkColor &&
      other.checkSize == checkSize &&
      other.checkSpacing == checkSpacing &&
      other.checkIcon == checkIcon &&
      other.showCheckmark == showCheckmark &&
      other.iconSize == iconSize &&
      other.iconSpacing == iconSpacing &&
      other.foregroundColor == foregroundColor &&
      other.disabledColor == disabledColor &&
      other.selectedBackgroundColor == selectedBackgroundColor &&
      other.selectedForegroundColor == selectedForegroundColor &&
      other.activeBackgroundColor == activeBackgroundColor &&
      other.itemTextStyle == itemTextStyle &&
      other.descriptionStyle == descriptionStyle &&
      other.descriptionGap == descriptionGap &&
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
    itemSpacing,
    groupSpacing,
    itemRadius,
    surfaceRadius,
    checkPlacement,
    checkColor,
    checkSize,
    checkSpacing,
    checkIcon,
    showCheckmark,
    iconSize,
    iconSpacing,
    foregroundColor,
    disabledColor,
    selectedBackgroundColor,
    selectedForegroundColor,
    activeBackgroundColor,
    itemTextStyle,
    descriptionStyle,
    descriptionGap,
    groupTitleStyle,
    surfaceStyle,
    submenuTransitionBuilder,
  ]);
}
