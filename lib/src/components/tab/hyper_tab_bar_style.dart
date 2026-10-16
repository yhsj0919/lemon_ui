import 'package:flutter/material.dart';

import '../card/hyper_card_style.dart';

enum HyperTabBarVariant { segmented, separated, underline }

@immutable
final class HyperTabBarStyle {
  const HyperTabBarStyle({
    this.trackStyle,
    this.itemStyle,
    this.selectedItemStyle,
    this.textStyle,
    this.selectedTextStyle,
    this.foregroundColor,
    this.selectedForegroundColor,
    this.dividerColor,
    this.indicatorColor,
  });
  final HyperCardStyle? trackStyle;
  final HyperCardStyle? itemStyle;
  final HyperCardStyle? selectedItemStyle;
  final TextStyle? textStyle;
  final TextStyle? selectedTextStyle;
  final Color? foregroundColor;
  final Color? selectedForegroundColor;
  final Color? dividerColor;
  final Color? indicatorColor;
  HyperTabBarStyle copyWith({
    HyperCardStyle? trackStyle,
    HyperCardStyle? itemStyle,
    HyperCardStyle? selectedItemStyle,
    TextStyle? textStyle,
    TextStyle? selectedTextStyle,
    Color? foregroundColor,
    Color? selectedForegroundColor,
    Color? dividerColor,
    Color? indicatorColor,
  }) => merge(
    HyperTabBarStyle(
      trackStyle: trackStyle,
      itemStyle: itemStyle,
      selectedItemStyle: selectedItemStyle,
      textStyle: textStyle,
      selectedTextStyle: selectedTextStyle,
      foregroundColor: foregroundColor,
      selectedForegroundColor: selectedForegroundColor,
      dividerColor: dividerColor,
      indicatorColor: indicatorColor,
    ),
  );
  HyperTabBarStyle merge(HyperTabBarStyle? other) => other == null
      ? this
      : HyperTabBarStyle(
          trackStyle: trackStyle?.merge(other.trackStyle) ?? other.trackStyle,
          itemStyle: itemStyle?.merge(other.itemStyle) ?? other.itemStyle,
          selectedItemStyle:
              selectedItemStyle?.merge(other.selectedItemStyle) ??
              other.selectedItemStyle,
          textStyle: textStyle?.merge(other.textStyle) ?? other.textStyle,
          selectedTextStyle:
              selectedTextStyle?.merge(other.selectedTextStyle) ??
              other.selectedTextStyle,
          foregroundColor: other.foregroundColor ?? foregroundColor,
          selectedForegroundColor:
              other.selectedForegroundColor ?? selectedForegroundColor,
          dividerColor: other.dividerColor ?? dividerColor,
          indicatorColor: other.indicatorColor ?? indicatorColor,
        );
  static HyperTabBarStyle lerp(
    HyperTabBarStyle a,
    HyperTabBarStyle b,
    double t,
  ) => HyperTabBarStyle(
    trackStyle: a.trackStyle == null || b.trackStyle == null
        ? (t < .5 ? a.trackStyle : b.trackStyle)
        : HyperCardStyle.lerp(a.trackStyle!, b.trackStyle!, t),
    itemStyle: a.itemStyle == null || b.itemStyle == null
        ? (t < .5 ? a.itemStyle : b.itemStyle)
        : HyperCardStyle.lerp(a.itemStyle!, b.itemStyle!, t),
    selectedItemStyle:
        a.selectedItemStyle == null || b.selectedItemStyle == null
        ? (t < .5 ? a.selectedItemStyle : b.selectedItemStyle)
        : HyperCardStyle.lerp(a.selectedItemStyle!, b.selectedItemStyle!, t),
    textStyle: TextStyle.lerp(a.textStyle, b.textStyle, t),
    selectedTextStyle: TextStyle.lerp(
      a.selectedTextStyle,
      b.selectedTextStyle,
      t,
    ),
    foregroundColor: Color.lerp(a.foregroundColor, b.foregroundColor, t),
    selectedForegroundColor: Color.lerp(
      a.selectedForegroundColor,
      b.selectedForegroundColor,
      t,
    ),
    dividerColor: Color.lerp(a.dividerColor, b.dividerColor, t),
    indicatorColor: Color.lerp(a.indicatorColor, b.indicatorColor, t),
  );
  @override
  bool operator ==(Object other) =>
      other is HyperTabBarStyle &&
      trackStyle == other.trackStyle &&
      itemStyle == other.itemStyle &&
      selectedItemStyle == other.selectedItemStyle &&
      textStyle == other.textStyle &&
      selectedTextStyle == other.selectedTextStyle &&
      foregroundColor == other.foregroundColor &&
      selectedForegroundColor == other.selectedForegroundColor &&
      dividerColor == other.dividerColor &&
      indicatorColor == other.indicatorColor;
  @override
  int get hashCode => Object.hashAll([
    trackStyle,
    itemStyle,
    selectedItemStyle,
    textStyle,
    selectedTextStyle,
    foregroundColor,
    selectedForegroundColor,
    dividerColor,
    indicatorColor,
  ]);
}
