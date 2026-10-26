import '../checkbox/hyper_checkbox_style.dart';

import 'package:flutter/material.dart';

import '../text_field/hyper_text_field_style.dart';
import '../button/hyper_button_style.dart';
import '../list_tile/hyper_list_tile_style.dart';
import '../card/hyper_card_style.dart';

/// Explicit visual overrides. Unspecified geometry inherits current semantic sizes.
@immutable
final class HyperTransferStyle {
  const HyperTransferStyle({
    this.panelHeight,
    this.panelWidth,
    this.gap,
    this.searchStyle,
    this.actionStyle,
    this.itemStyle,
    this.surfaceStyle,
    this.titleStyle,
    this.emptyStyle,
    this.checkboxStyle,
    this.itemRadius,
    this.itemSpacing,
    this.selectedItemColor,
  });
  final HyperCheckboxStyle? checkboxStyle;
  final double? itemRadius;
  final double? itemSpacing;
  final Color? selectedItemColor;
  final double? panelHeight;
  final double? panelWidth;
  final double? gap;
  final HyperTextFieldStyle? searchStyle;
  final HyperButtonStyle? actionStyle;
  final HyperListTileStyle? itemStyle;
  final HyperCardStyle? surfaceStyle;
  final TextStyle? titleStyle;
  final TextStyle? emptyStyle;
  HyperTransferStyle copyWith({
    double? panelHeight,
    double? panelWidth,
    double? gap,
    HyperTextFieldStyle? searchStyle,
    HyperButtonStyle? actionStyle,
    HyperListTileStyle? itemStyle,
    HyperCardStyle? surfaceStyle,
    TextStyle? titleStyle,
    TextStyle? emptyStyle,
    HyperCheckboxStyle? checkboxStyle,
    double? itemRadius,
    double? itemSpacing,
    Color? selectedItemColor,
  }) => merge(
    HyperTransferStyle(
      panelHeight: panelHeight,
      panelWidth: panelWidth,
      gap: gap,
      searchStyle: searchStyle,
      actionStyle: actionStyle,
      itemStyle: itemStyle,
      surfaceStyle: surfaceStyle,
      titleStyle: titleStyle,
      emptyStyle: emptyStyle,
      checkboxStyle: checkboxStyle,
      itemRadius: itemRadius,
      itemSpacing: itemSpacing,
      selectedItemColor: selectedItemColor,
    ),
  );
  HyperTransferStyle merge(HyperTransferStyle? other) => other == null
      ? this
      : HyperTransferStyle(
          checkboxStyle:
              checkboxStyle?.merge(other.checkboxStyle) ?? other.checkboxStyle,
          itemRadius: other.itemRadius ?? itemRadius,
          itemSpacing: other.itemSpacing ?? itemSpacing,
          selectedItemColor: other.selectedItemColor ?? selectedItemColor,
          panelHeight: other.panelHeight ?? panelHeight,
          panelWidth: other.panelWidth ?? panelWidth,
          gap: other.gap ?? gap,
          searchStyle:
              searchStyle?.merge(other.searchStyle) ?? other.searchStyle,
          actionStyle:
              actionStyle?.merge(other.actionStyle) ?? other.actionStyle,
          itemStyle: itemStyle?.merge(other.itemStyle) ?? other.itemStyle,
          surfaceStyle:
              surfaceStyle?.merge(other.surfaceStyle) ?? other.surfaceStyle,
          titleStyle: titleStyle?.merge(other.titleStyle) ?? other.titleStyle,
          emptyStyle: emptyStyle?.merge(other.emptyStyle) ?? other.emptyStyle,
        );
  static HyperTransferStyle lerp(
    HyperTransferStyle a,
    HyperTransferStyle b,
    double t,
  ) => HyperTransferStyle(
    checkboxStyle: a.checkboxStyle == null || b.checkboxStyle == null
        ? (t < .5 ? a.checkboxStyle : b.checkboxStyle)
        : HyperCheckboxStyle.lerp(a.checkboxStyle!, b.checkboxStyle!, t),
    itemSpacing: a.itemSpacing == null || b.itemSpacing == null
        ? (t < .5 ? a.itemSpacing : b.itemSpacing)
        : a.itemSpacing! + (b.itemSpacing! - a.itemSpacing!) * t,
    itemRadius: a.itemRadius == null || b.itemRadius == null
        ? (t < .5 ? a.itemRadius : b.itemRadius)
        : a.itemRadius! + (b.itemRadius! - a.itemRadius!) * t,
    selectedItemColor: Color.lerp(a.selectedItemColor, b.selectedItemColor, t),
    panelHeight: a.panelHeight == null || b.panelHeight == null
        ? (t < .5 ? a.panelHeight : b.panelHeight)
        : a.panelHeight! + (b.panelHeight! - a.panelHeight!) * t,
    panelWidth: a.panelWidth == null || b.panelWidth == null
        ? (t < .5 ? a.panelWidth : b.panelWidth)
        : a.panelWidth! + (b.panelWidth! - a.panelWidth!) * t,
    gap: a.gap == null || b.gap == null
        ? (t < .5 ? a.gap : b.gap)
        : a.gap! + (b.gap! - a.gap!) * t,
    searchStyle: a.searchStyle == null || b.searchStyle == null
        ? (t < .5 ? a.searchStyle : b.searchStyle)
        : HyperTextFieldStyle.lerp(a.searchStyle!, b.searchStyle!, t),
    actionStyle: a.actionStyle == null || b.actionStyle == null
        ? (t < .5 ? a.actionStyle : b.actionStyle)
        : HyperButtonStyle.lerp(a.actionStyle!, b.actionStyle!, t),
    itemStyle: a.itemStyle == null || b.itemStyle == null
        ? (t < .5 ? a.itemStyle : b.itemStyle)
        : HyperListTileStyle.lerp(a.itemStyle!, b.itemStyle!, t),
    surfaceStyle: a.surfaceStyle == null || b.surfaceStyle == null
        ? (t < .5 ? a.surfaceStyle : b.surfaceStyle)
        : HyperCardStyle.lerp(a.surfaceStyle!, b.surfaceStyle!, t),
    titleStyle: TextStyle.lerp(a.titleStyle, b.titleStyle, t),
    emptyStyle: TextStyle.lerp(a.emptyStyle, b.emptyStyle, t),
  );
  @override
  bool operator ==(Object other) =>
      other is HyperTransferStyle &&
      other.checkboxStyle == checkboxStyle &&
      other.itemRadius == itemRadius &&
      other.itemSpacing == itemSpacing &&
      other.selectedItemColor == selectedItemColor &&
      other.panelHeight == panelHeight &&
      other.panelWidth == panelWidth &&
      other.gap == gap &&
      other.searchStyle == searchStyle &&
      other.actionStyle == actionStyle &&
      other.itemStyle == itemStyle &&
      other.surfaceStyle == surfaceStyle &&
      other.titleStyle == titleStyle &&
      other.emptyStyle == emptyStyle;
  @override
  int get hashCode => Object.hashAll([
    checkboxStyle,
    itemRadius,
    itemSpacing,
    selectedItemColor,
    panelHeight,
    panelWidth,
    gap,
    searchStyle,
    actionStyle,
    itemStyle,
    surfaceStyle,
    titleStyle,
    emptyStyle,
  ]);
}
