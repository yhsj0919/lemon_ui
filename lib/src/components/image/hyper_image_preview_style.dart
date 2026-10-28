import 'package:flutter/material.dart';

import '../card/hyper_card_style.dart';
import '../icon_button/hyper_icon_button_style.dart';
import '../dialog/hyper_dialog_style.dart';
import 'hyper_image_style.dart';

/// Explicit appearance and motion overrides for the image preview.
@immutable
final class HyperImagePreviewStyle {
  const HyperImagePreviewStyle({
    this.surfaceStyle,
    this.imageStyle,
    this.toolbarBackground,
    this.foregroundColor,
    this.textStyle,
    this.buttonStyle,
    this.padding,
    this.spacing,
    this.iconSize,
    this.animationDuration,
    this.animationCurve,
    this.dialogStyle,
  });
  final HyperCardStyle? surfaceStyle;
  final HyperImageStyle? imageStyle;
  final Color? toolbarBackground;
  final Color? foregroundColor;
  final TextStyle? textStyle;
  final HyperIconButtonStyle? buttonStyle;
  final EdgeInsetsGeometry? padding;
  final double? spacing;
  final double? iconSize;
  final Duration? animationDuration;
  final Curve? animationCurve;
  final HyperDialogStyle? dialogStyle;
  HyperImagePreviewStyle copyWith({
    HyperCardStyle? surfaceStyle,
    HyperImageStyle? imageStyle,
    Color? toolbarBackground,
    Color? foregroundColor,
    TextStyle? textStyle,
    HyperIconButtonStyle? buttonStyle,
    EdgeInsetsGeometry? padding,
    double? spacing,
    double? iconSize,
    Duration? animationDuration,
    Curve? animationCurve,
    HyperDialogStyle? dialogStyle,
  }) => HyperImagePreviewStyle(
    surfaceStyle: surfaceStyle == null
        ? this.surfaceStyle
        : (this.surfaceStyle ?? HyperCardStyle()).merge(surfaceStyle),
    imageStyle: imageStyle == null
        ? this.imageStyle
        : (this.imageStyle ?? const HyperImageStyle()).merge(imageStyle),
    toolbarBackground: toolbarBackground ?? this.toolbarBackground,
    foregroundColor: foregroundColor ?? this.foregroundColor,
    textStyle: this.textStyle?.merge(textStyle) ?? textStyle,
    buttonStyle: buttonStyle == null
        ? this.buttonStyle
        : (this.buttonStyle ?? HyperIconButtonStyle()).merge(buttonStyle),
    padding: padding ?? this.padding,
    spacing: spacing ?? this.spacing,
    iconSize: iconSize ?? this.iconSize,
    animationDuration: animationDuration ?? this.animationDuration,
    animationCurve: animationCurve ?? this.animationCurve,
    dialogStyle: dialogStyle == null
        ? this.dialogStyle
        : (this.dialogStyle ?? const HyperDialogStyle()).merge(dialogStyle),
  );
  HyperImagePreviewStyle merge(HyperImagePreviewStyle? other) => other == null
      ? this
      : copyWith(
          surfaceStyle: other.surfaceStyle,
          imageStyle: other.imageStyle,
          toolbarBackground: other.toolbarBackground,
          foregroundColor: other.foregroundColor,
          textStyle: other.textStyle,
          buttonStyle: other.buttonStyle,
          padding: other.padding,
          spacing: other.spacing,
          iconSize: other.iconSize,
          animationDuration: other.animationDuration,
          animationCurve: other.animationCurve,
          dialogStyle: other.dialogStyle,
        );
  static HyperImagePreviewStyle lerp(
    HyperImagePreviewStyle a,
    HyperImagePreviewStyle b,
    double t,
  ) {
    T? discrete<T>(T? a, T? b) => t < .5 ? a : b;
    double? number(double? a, double? b) =>
        a == null || b == null ? discrete(a, b) : a + (b - a) * t;
    return HyperImagePreviewStyle(
      surfaceStyle: a.surfaceStyle == null || b.surfaceStyle == null
          ? discrete(a.surfaceStyle, b.surfaceStyle)
          : HyperCardStyle.lerp(a.surfaceStyle!, b.surfaceStyle!, t),
      imageStyle: a.imageStyle == null || b.imageStyle == null
          ? discrete(a.imageStyle, b.imageStyle)
          : HyperImageStyle.lerp(a.imageStyle!, b.imageStyle!, t),
      toolbarBackground: Color.lerp(
        a.toolbarBackground,
        b.toolbarBackground,
        t,
      ),
      foregroundColor: Color.lerp(a.foregroundColor, b.foregroundColor, t),
      textStyle: TextStyle.lerp(a.textStyle, b.textStyle, t),
      buttonStyle: a.buttonStyle == null || b.buttonStyle == null
          ? discrete(a.buttonStyle, b.buttonStyle)
          : HyperIconButtonStyle.lerp(a.buttonStyle!, b.buttonStyle!, t),
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
      spacing: number(a.spacing, b.spacing),
      iconSize: number(a.iconSize, b.iconSize),
      animationDuration: discrete(a.animationDuration, b.animationDuration),
      animationCurve: discrete(a.animationCurve, b.animationCurve),
      dialogStyle: a.dialogStyle == null || b.dialogStyle == null
          ? discrete(a.dialogStyle, b.dialogStyle)
          : HyperDialogStyle.lerp(a.dialogStyle!, b.dialogStyle!, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is HyperImagePreviewStyle &&
      surfaceStyle == other.surfaceStyle &&
      imageStyle == other.imageStyle &&
      toolbarBackground == other.toolbarBackground &&
      foregroundColor == other.foregroundColor &&
      textStyle == other.textStyle &&
      buttonStyle == other.buttonStyle &&
      padding == other.padding &&
      spacing == other.spacing &&
      iconSize == other.iconSize &&
      animationDuration == other.animationDuration &&
      animationCurve == other.animationCurve &&
      dialogStyle == other.dialogStyle;
  @override
  int get hashCode => Object.hashAll([
    surfaceStyle,
    imageStyle,
    toolbarBackground,
    foregroundColor,
    textStyle,
    buttonStyle,
    padding,
    spacing,
    iconSize,
    animationDuration,
    animationCurve,
    dialogStyle,
  ]);
}
