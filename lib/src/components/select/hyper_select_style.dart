import '../button/hyper_button_style.dart';
import '../select/hyper_selection_style.dart';

import 'package:flutter/material.dart';

/// 下拉选择器自身的尺寸和视觉覆盖；空字段继续继承。
@immutable
final class HyperSelectStyle {
  const HyperSelectStyle({
    this.buttonStyle,
    this.selectionStyle,
    this.width,
    this.arrowSize,
    this.arrowSpacing,
    this.popupSpacing,
    this.foregroundColor,
    this.arrowColor,
    this.disabledArrowColor,
    this.selectedBackgroundColor,
  });

  /// 下拉触发按钮的视觉覆盖；实例 buttonStyle 最后覆盖。
  final HyperButtonStyle? buttonStyle;
  final HyperSelectionStyle? selectionStyle;
  final double? width;
  final double? arrowSize;
  final double? arrowSpacing;
  final double? popupSpacing;
  final Color? foregroundColor;
  final Color? arrowColor;
  final Color? disabledArrowColor;
  final Color? selectedBackgroundColor;

  HyperSelectStyle copyWith({
    HyperButtonStyle? buttonStyle,
    HyperSelectionStyle? selectionStyle,
    double? width,
    double? arrowSize,
    double? arrowSpacing,
    double? popupSpacing,
    Color? foregroundColor,
    Color? arrowColor,
    Color? disabledArrowColor,
    Color? selectedBackgroundColor,
  }) => merge(
    HyperSelectStyle(
      buttonStyle: buttonStyle,
      selectionStyle: selectionStyle,
      width: width,
      arrowSize: arrowSize,
      arrowSpacing: arrowSpacing,
      popupSpacing: popupSpacing,
      foregroundColor: foregroundColor,
      arrowColor: arrowColor,
      disabledArrowColor: disabledArrowColor,
      selectedBackgroundColor: selectedBackgroundColor,
    ),
  );

  HyperSelectStyle merge(HyperSelectStyle? other) => other == null
      ? this
      : HyperSelectStyle(
          buttonStyle:
              buttonStyle?.merge(other.buttonStyle) ?? other.buttonStyle,
          selectionStyle:
              selectionStyle?.merge(other.selectionStyle) ??
              other.selectionStyle,
          width: other.width ?? width,
          arrowSize: other.arrowSize ?? arrowSize,
          arrowSpacing: other.arrowSpacing ?? arrowSpacing,
          popupSpacing: other.popupSpacing ?? popupSpacing,
          foregroundColor: other.foregroundColor ?? foregroundColor,
          arrowColor: other.arrowColor ?? arrowColor,
          disabledArrowColor: other.disabledArrowColor ?? disabledArrowColor,
          selectedBackgroundColor:
              other.selectedBackgroundColor ?? selectedBackgroundColor,
        );

  static HyperSelectStyle lerp(
    HyperSelectStyle a,
    HyperSelectStyle b,
    double t,
  ) {
    double? number(double? x, double? y) =>
        x == null || y == null ? (t < .5 ? x : y) : x + (y - x) * t;
    return HyperSelectStyle(
      buttonStyle: a.buttonStyle == null || b.buttonStyle == null
          ? (t < .5 ? a.buttonStyle : b.buttonStyle)
          : HyperButtonStyle.lerp(a.buttonStyle!, b.buttonStyle!, t),
      selectionStyle: a.selectionStyle == null || b.selectionStyle == null
          ? (t < .5 ? a.selectionStyle : b.selectionStyle)
          : HyperSelectionStyle.lerp(a.selectionStyle!, b.selectionStyle!, t),
      width: number(a.width, b.width),
      arrowSize: number(a.arrowSize, b.arrowSize),
      arrowSpacing: number(a.arrowSpacing, b.arrowSpacing),
      popupSpacing: number(a.popupSpacing, b.popupSpacing),
      foregroundColor: Color.lerp(a.foregroundColor, b.foregroundColor, t),
      arrowColor: Color.lerp(a.arrowColor, b.arrowColor, t),
      disabledArrowColor: Color.lerp(
        a.disabledArrowColor,
        b.disabledArrowColor,
        t,
      ),
      selectedBackgroundColor: Color.lerp(
        a.selectedBackgroundColor,
        b.selectedBackgroundColor,
        t,
      ),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is HyperSelectStyle &&
      other.buttonStyle == buttonStyle &&
      other.selectionStyle == selectionStyle &&
      other.width == width &&
      other.arrowSize == arrowSize &&
      other.arrowSpacing == arrowSpacing &&
      other.popupSpacing == popupSpacing &&
      other.foregroundColor == foregroundColor &&
      other.arrowColor == arrowColor &&
      other.disabledArrowColor == disabledArrowColor &&
      other.selectedBackgroundColor == selectedBackgroundColor;

  @override
  int get hashCode => Object.hash(
    buttonStyle,
    selectionStyle,
    width,
    arrowSize,
    arrowSpacing,
    popupSpacing,
    foregroundColor,
    arrowColor,
    disabledArrowColor,
    selectedBackgroundColor,
  );
}
