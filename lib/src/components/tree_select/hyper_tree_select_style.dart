import 'package:flutter/material.dart';

import '../button/hyper_button_style.dart';
import '../select/hyper_select_style.dart';
import '../tree/hyper_tree_view_style.dart';

/// Visual overrides for the tree selector; geometry inherits Select and Tree.
@immutable
final class HyperTreeSelectStyle {
  const HyperTreeSelectStyle({
    this.selectStyle,
    this.treeStyle,
    this.clearButtonStyle,
  });

  final HyperSelectStyle? selectStyle;
  final HyperTreeViewStyle? treeStyle;
  final HyperButtonStyle? clearButtonStyle;

  HyperTreeSelectStyle copyWith({
    HyperSelectStyle? selectStyle,
    HyperTreeViewStyle? treeStyle,
    HyperButtonStyle? clearButtonStyle,
  }) => merge(
    HyperTreeSelectStyle(
      selectStyle: selectStyle,
      treeStyle: treeStyle,
      clearButtonStyle: clearButtonStyle,
    ),
  );

  HyperTreeSelectStyle merge(HyperTreeSelectStyle? other) => other == null
      ? this
      : HyperTreeSelectStyle(
          selectStyle:
              selectStyle?.merge(other.selectStyle) ?? other.selectStyle,
          treeStyle: treeStyle?.merge(other.treeStyle) ?? other.treeStyle,
          clearButtonStyle:
              clearButtonStyle?.merge(other.clearButtonStyle) ??
              other.clearButtonStyle,
        );

  static HyperTreeSelectStyle lerp(
    HyperTreeSelectStyle a,
    HyperTreeSelectStyle b,
    double t,
  ) => HyperTreeSelectStyle(
    selectStyle: a.selectStyle == null || b.selectStyle == null
        ? (t < .5 ? a.selectStyle : b.selectStyle)
        : HyperSelectStyle.lerp(a.selectStyle!, b.selectStyle!, t),
    treeStyle: a.treeStyle == null || b.treeStyle == null
        ? (t < .5 ? a.treeStyle : b.treeStyle)
        : HyperTreeViewStyle.lerp(a.treeStyle!, b.treeStyle!, t),
    clearButtonStyle: a.clearButtonStyle == null || b.clearButtonStyle == null
        ? (t < .5 ? a.clearButtonStyle : b.clearButtonStyle)
        : HyperButtonStyle.lerp(a.clearButtonStyle!, b.clearButtonStyle!, t),
  );

  @override
  bool operator ==(Object other) =>
      other is HyperTreeSelectStyle &&
      other.selectStyle == selectStyle &&
      other.treeStyle == treeStyle &&
      other.clearButtonStyle == clearButtonStyle;

  @override
  int get hashCode => Object.hash(selectStyle, treeStyle, clearButtonStyle);
}
