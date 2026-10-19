import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

@immutable
final class HyperWheelPickerStyle {
  const HyperWheelPickerStyle({
    this.itemExtent,
    this.width,
    this.horizontalPadding,
    this.selectionRadius,
    this.textStyle,
    this.selectedTextStyle,
    this.foregroundColor,
    this.selectedForegroundColor,
    this.selectionColor,
    this.backgroundColor,
    this.disabledColor,
    this.selectionBorder,
    this.unselectedOpacity,
    this.unselectedScale,
    this.diameterRatio,
    this.perspective,
    this.squeeze,
    this.duration,
    this.curve,
  });
  final double? itemExtent;
  final double? width;
  final double? horizontalPadding;
  final double? selectionRadius;
  final TextStyle? textStyle;
  final TextStyle? selectedTextStyle;
  final Color? foregroundColor;
  final Color? selectedForegroundColor;
  final Color? selectionColor;
  final Color? backgroundColor;
  final Color? disabledColor;
  final Border? selectionBorder;
  final double? unselectedOpacity;
  final double? unselectedScale;
  final double? diameterRatio;
  final double? perspective;
  final double? squeeze;
  final Duration? duration;
  final Curve? curve;
  HyperWheelPickerStyle copyWith({
    double? itemExtent,
    double? width,
    double? horizontalPadding,
    double? selectionRadius,
    TextStyle? textStyle,
    TextStyle? selectedTextStyle,
    Color? foregroundColor,
    Color? selectedForegroundColor,
    Color? selectionColor,
    Color? backgroundColor,
    Color? disabledColor,
    Border? selectionBorder,
    double? unselectedOpacity,
    double? unselectedScale,
    double? diameterRatio,
    double? perspective,
    double? squeeze,
    Duration? duration,
    Curve? curve,
  }) => merge(
    HyperWheelPickerStyle(
      itemExtent: itemExtent,
      width: width,
      horizontalPadding: horizontalPadding,
      selectionRadius: selectionRadius,
      textStyle: textStyle,
      selectedTextStyle: selectedTextStyle,
      foregroundColor: foregroundColor,
      selectedForegroundColor: selectedForegroundColor,
      selectionColor: selectionColor,
      backgroundColor: backgroundColor,
      disabledColor: disabledColor,
      selectionBorder: selectionBorder,
      unselectedOpacity: unselectedOpacity,
      unselectedScale: unselectedScale,
      diameterRatio: diameterRatio,
      perspective: perspective,
      squeeze: squeeze,
      duration: duration,
      curve: curve,
    ),
  );
  HyperWheelPickerStyle merge(HyperWheelPickerStyle? other) => other == null
      ? this
      : HyperWheelPickerStyle(
          itemExtent: other.itemExtent ?? itemExtent,
          width: other.width ?? width,
          horizontalPadding: other.horizontalPadding ?? horizontalPadding,
          selectionRadius: other.selectionRadius ?? selectionRadius,
          textStyle: textStyle?.merge(other.textStyle) ?? other.textStyle,
          selectedTextStyle:
              selectedTextStyle?.merge(other.selectedTextStyle) ??
              other.selectedTextStyle,
          foregroundColor: other.foregroundColor ?? foregroundColor,
          selectedForegroundColor:
              other.selectedForegroundColor ?? selectedForegroundColor,
          selectionColor: other.selectionColor ?? selectionColor,
          backgroundColor: other.backgroundColor ?? backgroundColor,
          disabledColor: other.disabledColor ?? disabledColor,
          selectionBorder: other.selectionBorder ?? selectionBorder,
          unselectedOpacity: other.unselectedOpacity ?? unselectedOpacity,
          unselectedScale: other.unselectedScale ?? unselectedScale,
          diameterRatio: other.diameterRatio ?? diameterRatio,
          perspective: other.perspective ?? perspective,
          squeeze: other.squeeze ?? squeeze,
          duration: other.duration ?? duration,
          curve: other.curve ?? curve,
        );
  static HyperWheelPickerStyle lerp(
    HyperWheelPickerStyle a,
    HyperWheelPickerStyle b,
    double t,
  ) => HyperWheelPickerStyle(
    itemExtent: lerpDouble(a.itemExtent, b.itemExtent, t),
    width: lerpDouble(a.width, b.width, t),
    horizontalPadding: lerpDouble(a.horizontalPadding, b.horizontalPadding, t),
    selectionRadius: lerpDouble(a.selectionRadius, b.selectionRadius, t),
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
    selectionColor: Color.lerp(a.selectionColor, b.selectionColor, t),
    backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
    disabledColor: Color.lerp(a.disabledColor, b.disabledColor, t),
    selectionBorder: Border.lerp(a.selectionBorder, b.selectionBorder, t),
    unselectedOpacity: lerpDouble(a.unselectedOpacity, b.unselectedOpacity, t),
    unselectedScale: lerpDouble(a.unselectedScale, b.unselectedScale, t),
    diameterRatio: lerpDouble(a.diameterRatio, b.diameterRatio, t),
    perspective: lerpDouble(a.perspective, b.perspective, t),
    squeeze: lerpDouble(a.squeeze, b.squeeze, t),
    duration: t < .5 ? a.duration : b.duration,
    curve: t < .5 ? a.curve : b.curve,
  );
  @override
  bool operator ==(Object other) =>
      other is HyperWheelPickerStyle &&
      other.itemExtent == itemExtent &&
      other.width == width &&
      other.horizontalPadding == horizontalPadding &&
      other.selectionRadius == selectionRadius &&
      other.textStyle == textStyle &&
      other.selectedTextStyle == selectedTextStyle &&
      other.foregroundColor == foregroundColor &&
      other.selectedForegroundColor == selectedForegroundColor &&
      other.selectionColor == selectionColor &&
      other.backgroundColor == backgroundColor &&
      other.disabledColor == disabledColor &&
      other.selectionBorder == selectionBorder &&
      other.unselectedOpacity == unselectedOpacity &&
      other.unselectedScale == unselectedScale &&
      other.diameterRatio == diameterRatio &&
      other.perspective == perspective &&
      other.squeeze == squeeze &&
      other.duration == duration &&
      other.curve == curve;
  @override
  int get hashCode => Object.hashAll([
    itemExtent,
    width,
    horizontalPadding,
    selectionRadius,
    textStyle,
    selectedTextStyle,
    foregroundColor,
    selectedForegroundColor,
    selectionColor,
    backgroundColor,
    disabledColor,
    selectionBorder,
    unselectedOpacity,
    unselectedScale,
    diameterRatio,
    perspective,
    squeeze,
    duration,
    curve,
  ]);
}
