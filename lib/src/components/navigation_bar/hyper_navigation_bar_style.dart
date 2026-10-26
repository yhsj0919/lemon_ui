import 'package:flutter/material.dart';

import '../button/hyper_button_style.dart';
import '../card/hyper_card_style.dart';

/// Explicit visual overrides. Unspecified geometry inherits current semantic sizes.
@immutable
final class HyperNavigationBarStyle {
  const HyperNavigationBarStyle({
    this.gap,
    this.iconSize,
    this.itemSpacing,
    this.itemStyle,
    this.selectedItemStyle,
    this.surfaceStyle,
    this.labelStyle,
  });
  final double? gap;
  final double? iconSize;
  final double? itemSpacing;
  final HyperButtonStyle? itemStyle;
  final HyperButtonStyle? selectedItemStyle;
  final HyperCardStyle? surfaceStyle;
  final TextStyle? labelStyle;
  HyperNavigationBarStyle copyWith({
    double? gap,
    double? iconSize,
    double? itemSpacing,
    HyperButtonStyle? itemStyle,
    HyperButtonStyle? selectedItemStyle,
    HyperCardStyle? surfaceStyle,
    TextStyle? labelStyle,
  }) => merge(
    HyperNavigationBarStyle(
      gap: gap,
      iconSize: iconSize,
      itemSpacing: itemSpacing,
      itemStyle: itemStyle,
      selectedItemStyle: selectedItemStyle,
      surfaceStyle: surfaceStyle,
      labelStyle: labelStyle,
    ),
  );
  HyperNavigationBarStyle merge(HyperNavigationBarStyle? other) => other == null
      ? this
      : HyperNavigationBarStyle(
          gap: other.gap ?? gap,
          iconSize: other.iconSize ?? iconSize,
          itemSpacing: other.itemSpacing ?? itemSpacing,
          itemStyle: itemStyle?.merge(other.itemStyle) ?? other.itemStyle,
          selectedItemStyle:
              selectedItemStyle?.merge(other.selectedItemStyle) ??
              other.selectedItemStyle,
          surfaceStyle:
              surfaceStyle?.merge(other.surfaceStyle) ?? other.surfaceStyle,
          labelStyle: labelStyle?.merge(other.labelStyle) ?? other.labelStyle,
        );
  static HyperNavigationBarStyle lerp(
    HyperNavigationBarStyle a,
    HyperNavigationBarStyle b,
    double t,
  ) => HyperNavigationBarStyle(
    gap: a.gap == null || b.gap == null
        ? (t < .5 ? a.gap : b.gap)
        : a.gap! + (b.gap! - a.gap!) * t,
    iconSize: a.iconSize == null || b.iconSize == null
        ? (t < .5 ? a.iconSize : b.iconSize)
        : a.iconSize! + (b.iconSize! - a.iconSize!) * t,
    itemSpacing: a.itemSpacing == null || b.itemSpacing == null
        ? (t < .5 ? a.itemSpacing : b.itemSpacing)
        : a.itemSpacing! + (b.itemSpacing! - a.itemSpacing!) * t,
    itemStyle: a.itemStyle == null || b.itemStyle == null
        ? (t < .5 ? a.itemStyle : b.itemStyle)
        : HyperButtonStyle.lerp(a.itemStyle!, b.itemStyle!, t),
    selectedItemStyle:
        a.selectedItemStyle == null || b.selectedItemStyle == null
        ? (t < .5 ? a.selectedItemStyle : b.selectedItemStyle)
        : HyperButtonStyle.lerp(a.selectedItemStyle!, b.selectedItemStyle!, t),
    surfaceStyle: a.surfaceStyle == null || b.surfaceStyle == null
        ? (t < .5 ? a.surfaceStyle : b.surfaceStyle)
        : HyperCardStyle.lerp(a.surfaceStyle!, b.surfaceStyle!, t),
    labelStyle: TextStyle.lerp(a.labelStyle, b.labelStyle, t),
  );
  @override
  bool operator ==(Object other) =>
      other is HyperNavigationBarStyle &&
      other.gap == gap &&
      other.iconSize == iconSize &&
      other.itemSpacing == itemSpacing &&
      other.itemStyle == itemStyle &&
      other.selectedItemStyle == selectedItemStyle &&
      other.surfaceStyle == surfaceStyle &&
      other.labelStyle == labelStyle;
  @override
  int get hashCode => Object.hashAll([
    gap,
    iconSize,
    itemSpacing,
    itemStyle,
    selectedItemStyle,
    surfaceStyle,
    labelStyle,
  ]);
}
