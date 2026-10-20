import 'package:flutter/material.dart';

import '../button/hyper_button_style.dart';
import '../select/hyper_select_style.dart';
import '../wheel_picker/hyper_wheel_picker_style.dart';

/// Explicit overrides; all geometry otherwise inherits Select/Menu/Button.
@immutable
final class HyperCascaderStyle {
  const HyperCascaderStyle({
    this.selectStyle,
    this.navigationStyle,
    this.branchIcon,
    this.backIcon,
    this.wheelStyle,
    this.clearButtonStyle,
  });

  final HyperSelectStyle? selectStyle;
  final HyperButtonStyle? navigationStyle;
  final IconData? branchIcon, backIcon;
  final HyperWheelPickerStyle? wheelStyle;
  final HyperButtonStyle? clearButtonStyle;

  HyperCascaderStyle copyWith({
    HyperSelectStyle? selectStyle,
    HyperButtonStyle? navigationStyle,
    IconData? branchIcon,
    IconData? backIcon,
    HyperWheelPickerStyle? wheelStyle,
    HyperButtonStyle? clearButtonStyle,
  }) => merge(
    HyperCascaderStyle(
      selectStyle: selectStyle,
      navigationStyle: navigationStyle,
      branchIcon: branchIcon,
      backIcon: backIcon,
      wheelStyle: wheelStyle,
      clearButtonStyle: clearButtonStyle,
    ),
  );

  HyperCascaderStyle merge(HyperCascaderStyle? other) => other == null
      ? this
      : HyperCascaderStyle(
          selectStyle:
              selectStyle?.merge(other.selectStyle) ?? other.selectStyle,
          navigationStyle:
              navigationStyle?.merge(other.navigationStyle) ??
              other.navigationStyle,
          branchIcon: other.branchIcon ?? branchIcon,
          backIcon: other.backIcon ?? backIcon,
          wheelStyle: wheelStyle?.merge(other.wheelStyle) ?? other.wheelStyle,
          clearButtonStyle:
              clearButtonStyle?.merge(other.clearButtonStyle) ??
              other.clearButtonStyle,
        );

  static HyperCascaderStyle lerp(
    HyperCascaderStyle a,
    HyperCascaderStyle b,
    double t,
  ) => HyperCascaderStyle(
    selectStyle: a.selectStyle == null || b.selectStyle == null
        ? (t < .5 ? a.selectStyle : b.selectStyle)
        : HyperSelectStyle.lerp(a.selectStyle!, b.selectStyle!, t),
    navigationStyle: a.navigationStyle == null || b.navigationStyle == null
        ? (t < .5 ? a.navigationStyle : b.navigationStyle)
        : HyperButtonStyle.lerp(a.navigationStyle!, b.navigationStyle!, t),
    branchIcon: t < .5 ? a.branchIcon : b.branchIcon,
    backIcon: t < .5 ? a.backIcon : b.backIcon,
    wheelStyle: a.wheelStyle == null || b.wheelStyle == null
        ? (t < .5 ? a.wheelStyle : b.wheelStyle)
        : HyperWheelPickerStyle.lerp(a.wheelStyle!, b.wheelStyle!, t),
    clearButtonStyle: a.clearButtonStyle == null || b.clearButtonStyle == null
        ? (t < .5 ? a.clearButtonStyle : b.clearButtonStyle)
        : HyperButtonStyle.lerp(a.clearButtonStyle!, b.clearButtonStyle!, t),
  );

  @override
  bool operator ==(Object other) =>
      other is HyperCascaderStyle &&
      other.selectStyle == selectStyle &&
      other.navigationStyle == navigationStyle &&
      other.branchIcon == branchIcon &&
      other.backIcon == backIcon &&
      other.wheelStyle == wheelStyle &&
      other.clearButtonStyle == clearButtonStyle;

  @override
  int get hashCode => Object.hash(
    selectStyle,
    navigationStyle,
    branchIcon,
    backIcon,
    wheelStyle,
    clearButtonStyle,
  );
}
