import 'package:flutter/material.dart';

import '../button/hyper_button_style.dart';
import '../menu/hyper_menu_style.dart';
import '../overlay/hyper_anchored_overlay.dart';

/// 顶部导航覆盖；null 继续继承，按钮与菜单字段保持原有职责。
@immutable
final class HyperTopNavigationStyle {
  const HyperTopNavigationStyle({
    this.itemStyle,
    this.selectedItemStyle,
    this.menuStyle,
    this.descriptionStyle,
    this.dropdownIcon,
    this.itemSpacing,
    this.descriptionGap,
    this.transitionBuilder,
  });

  /// 顶层按钮通用外观、尺寸与交互状态配置。
  final HyperButtonStyle? itemStyle;

  /// 选中项或选中后代的顶层按钮覆盖。
  final HyperButtonStyle? selectedItemStyle;

  /// 全部层级的子菜单样式覆盖。
  final HyperMenuStyle? menuStyle;

  /// 顶层描述文字；子菜单描述由 menuStyle 管理。
  final TextStyle? descriptionStyle;

  /// 具有子菜单时显示的展开图标。
  final IconData? dropdownIcon;

  /// 顶层按钮之间的逻辑像素间距。
  final double? itemSpacing;

  /// 顶层标题与描述之间的逻辑像素间距。
  final double? descriptionGap;

  /// 替换子菜单进出场视觉；默认沿用 Motion。
  final HyperOverlayTransitionBuilder? transitionBuilder;
  HyperTopNavigationStyle copyWith({
    HyperButtonStyle? itemStyle,
    HyperButtonStyle? selectedItemStyle,
    HyperMenuStyle? menuStyle,
    TextStyle? descriptionStyle,
    IconData? dropdownIcon,
    double? itemSpacing,
    double? descriptionGap,
    HyperOverlayTransitionBuilder? transitionBuilder,
  }) => merge(
    HyperTopNavigationStyle(
      itemStyle: itemStyle,
      selectedItemStyle: selectedItemStyle,
      menuStyle: menuStyle,
      descriptionStyle: descriptionStyle,
      dropdownIcon: dropdownIcon,
      itemSpacing: itemSpacing,
      descriptionGap: descriptionGap,
      transitionBuilder: transitionBuilder,
    ),
  );
  HyperTopNavigationStyle merge(HyperTopNavigationStyle? other) {
    if (other == null) return this;
    return HyperTopNavigationStyle(
      itemStyle: itemStyle?.merge(other.itemStyle) ?? other.itemStyle,
      selectedItemStyle:
          selectedItemStyle?.merge(other.selectedItemStyle) ??
          other.selectedItemStyle,
      menuStyle: menuStyle?.merge(other.menuStyle) ?? other.menuStyle,
      descriptionStyle:
          descriptionStyle?.merge(other.descriptionStyle) ??
          other.descriptionStyle,
      dropdownIcon: other.dropdownIcon ?? dropdownIcon,
      itemSpacing: other.itemSpacing ?? itemSpacing,
      descriptionGap: other.descriptionGap ?? descriptionGap,
      transitionBuilder: other.transitionBuilder ?? transitionBuilder,
    );
  }

  static HyperTopNavigationStyle lerp(
    HyperTopNavigationStyle a,
    HyperTopNavigationStyle b,
    double t,
  ) {
    T? discrete<T>(T? x, T? y) => t < .5 ? x : y;
    return HyperTopNavigationStyle(
      itemStyle: a.itemStyle == null || b.itemStyle == null
          ? discrete(a.itemStyle, b.itemStyle)
          : HyperButtonStyle.lerp(a.itemStyle!, b.itemStyle!, t),
      selectedItemStyle:
          a.selectedItemStyle == null || b.selectedItemStyle == null
          ? discrete(a.selectedItemStyle, b.selectedItemStyle)
          : HyperButtonStyle.lerp(
              a.selectedItemStyle!,
              b.selectedItemStyle!,
              t,
            ),
      menuStyle: a.menuStyle == null || b.menuStyle == null
          ? discrete(a.menuStyle, b.menuStyle)
          : HyperMenuStyle.lerp(a.menuStyle!, b.menuStyle!, t),
      descriptionStyle: TextStyle.lerp(
        a.descriptionStyle,
        b.descriptionStyle,
        t,
      ),
      dropdownIcon: discrete(a.dropdownIcon, b.dropdownIcon),
      itemSpacing: a.itemSpacing == null || b.itemSpacing == null
          ? discrete(a.itemSpacing, b.itemSpacing)
          : a.itemSpacing! + (b.itemSpacing! - a.itemSpacing!) * t,
      descriptionGap: a.descriptionGap == null || b.descriptionGap == null
          ? discrete(a.descriptionGap, b.descriptionGap)
          : a.descriptionGap! + (b.descriptionGap! - a.descriptionGap!) * t,
      transitionBuilder: discrete(a.transitionBuilder, b.transitionBuilder),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is HyperTopNavigationStyle &&
      other.itemStyle == itemStyle &&
      other.selectedItemStyle == selectedItemStyle &&
      other.menuStyle == menuStyle &&
      other.descriptionStyle == descriptionStyle &&
      other.dropdownIcon == dropdownIcon &&
      other.itemSpacing == itemSpacing &&
      other.descriptionGap == descriptionGap &&
      other.transitionBuilder == transitionBuilder;
  @override
  int get hashCode => Object.hashAll([
    itemStyle,
    selectedItemStyle,
    menuStyle,
    descriptionStyle,
    dropdownIcon,
    itemSpacing,
    descriptionGap,
    transitionBuilder,
  ]);
}
