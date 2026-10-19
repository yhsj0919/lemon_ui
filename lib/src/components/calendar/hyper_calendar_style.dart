import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

@immutable
final class HyperCalendarStyle {
  const HyperCalendarStyle({
    this.width,
    this.dayMinHeight,
    this.spacing,
    this.radius,
    this.selectionSize,
    this.backgroundColor,
    this.foregroundColor,
    this.selectedColor,
    this.selectedForegroundColor,
    this.rangeColor,
    this.disabledColor,
    this.weekdayColor,
    this.todayColor,
    this.textStyle,
    this.headerTextStyle,
    this.weekdayTextStyle,
  });
  final double? width;
  final double? dayMinHeight;
  final double? spacing;
  final double? radius;
  final double? selectionSize;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? selectedColor;
  final Color? selectedForegroundColor;
  final Color? rangeColor;
  final Color? disabledColor;
  final Color? weekdayColor;
  final Color? todayColor;
  final TextStyle? textStyle;
  final TextStyle? headerTextStyle;
  final TextStyle? weekdayTextStyle;
  HyperCalendarStyle copyWith({
    double? width,
    double? dayMinHeight,
    double? spacing,
    double? radius,
    double? selectionSize,
    Color? backgroundColor,
    Color? foregroundColor,
    Color? selectedColor,
    Color? selectedForegroundColor,
    Color? rangeColor,
    Color? disabledColor,
    Color? weekdayColor,
    Color? todayColor,
    TextStyle? textStyle,
    TextStyle? headerTextStyle,
    TextStyle? weekdayTextStyle,
  }) => merge(
    HyperCalendarStyle(
      width: width,
      dayMinHeight: dayMinHeight,
      spacing: spacing,
      radius: radius,
      selectionSize: selectionSize,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      selectedColor: selectedColor,
      selectedForegroundColor: selectedForegroundColor,
      rangeColor: rangeColor,
      disabledColor: disabledColor,
      weekdayColor: weekdayColor,
      todayColor: todayColor,
      textStyle: textStyle,
      headerTextStyle: headerTextStyle,
      weekdayTextStyle: weekdayTextStyle,
    ),
  );
  HyperCalendarStyle merge(HyperCalendarStyle? other) => other == null
      ? this
      : HyperCalendarStyle(
          width: other.width ?? width,
          dayMinHeight: other.dayMinHeight ?? dayMinHeight,
          spacing: other.spacing ?? spacing,
          radius: other.radius ?? radius,
          selectionSize: other.selectionSize ?? selectionSize,
          backgroundColor: other.backgroundColor ?? backgroundColor,
          foregroundColor: other.foregroundColor ?? foregroundColor,
          selectedColor: other.selectedColor ?? selectedColor,
          selectedForegroundColor:
              other.selectedForegroundColor ?? selectedForegroundColor,
          rangeColor: other.rangeColor ?? rangeColor,
          disabledColor: other.disabledColor ?? disabledColor,
          weekdayColor: other.weekdayColor ?? weekdayColor,
          todayColor: other.todayColor ?? todayColor,
          textStyle: textStyle?.merge(other.textStyle) ?? other.textStyle,
          headerTextStyle:
              headerTextStyle?.merge(other.headerTextStyle) ??
              other.headerTextStyle,
          weekdayTextStyle:
              weekdayTextStyle?.merge(other.weekdayTextStyle) ??
              other.weekdayTextStyle,
        );
  static HyperCalendarStyle lerp(
    HyperCalendarStyle a,
    HyperCalendarStyle b,
    double t,
  ) => HyperCalendarStyle(
    width: lerpDouble(a.width, b.width, t),
    dayMinHeight: lerpDouble(a.dayMinHeight, b.dayMinHeight, t),
    spacing: lerpDouble(a.spacing, b.spacing, t),
    radius: lerpDouble(a.radius, b.radius, t),
    selectionSize: lerpDouble(a.selectionSize, b.selectionSize, t),
    backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
    foregroundColor: Color.lerp(a.foregroundColor, b.foregroundColor, t),
    selectedColor: Color.lerp(a.selectedColor, b.selectedColor, t),
    selectedForegroundColor: Color.lerp(
      a.selectedForegroundColor,
      b.selectedForegroundColor,
      t,
    ),
    rangeColor: Color.lerp(a.rangeColor, b.rangeColor, t),
    disabledColor: Color.lerp(a.disabledColor, b.disabledColor, t),
    weekdayColor: Color.lerp(a.weekdayColor, b.weekdayColor, t),
    todayColor: Color.lerp(a.todayColor, b.todayColor, t),
    textStyle: TextStyle.lerp(a.textStyle, b.textStyle, t),
    headerTextStyle: TextStyle.lerp(a.headerTextStyle, b.headerTextStyle, t),
    weekdayTextStyle: TextStyle.lerp(a.weekdayTextStyle, b.weekdayTextStyle, t),
  );
  @override
  bool operator ==(Object other) =>
      other is HyperCalendarStyle &&
      other.width == width &&
      other.dayMinHeight == dayMinHeight &&
      other.spacing == spacing &&
      other.radius == radius &&
      other.selectionSize == selectionSize &&
      other.backgroundColor == backgroundColor &&
      other.foregroundColor == foregroundColor &&
      other.selectedColor == selectedColor &&
      other.selectedForegroundColor == selectedForegroundColor &&
      other.rangeColor == rangeColor &&
      other.disabledColor == disabledColor &&
      other.weekdayColor == weekdayColor &&
      other.todayColor == todayColor &&
      other.textStyle == textStyle &&
      other.headerTextStyle == headerTextStyle &&
      other.weekdayTextStyle == weekdayTextStyle;
  @override
  int get hashCode => Object.hashAll([
    width,
    dayMinHeight,
    spacing,
    radius,
    selectionSize,
    backgroundColor,
    foregroundColor,
    selectedColor,
    selectedForegroundColor,
    rangeColor,
    disabledColor,
    weekdayColor,
    todayColor,
    textStyle,
    headerTextStyle,
    weekdayTextStyle,
  ]);
}
