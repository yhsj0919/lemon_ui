import 'package:flutter/material.dart';

import '../card/hyper_card_style.dart';
import '../icon_button/hyper_icon_button_style.dart';
import '../dialog/hyper_dialog_style.dart';
import 'hyper_image_style.dart';

/// Explicit appearance and motion overrides for the image editor.
@immutable
final class HyperImageEditorStyle {
  const HyperImageEditorStyle({
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
    this.dialogStyle,
    this.cropPadding,
    this.handleSize,
    this.cropColor,
    this.cropLineColor,
    this.cropLineWidth,
    this.maskColor,
    this.handleHitSize,
    this.exportText,
    this.exportErrorText,
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
  final HyperDialogStyle? dialogStyle;
  final EdgeInsets? cropPadding;
  final Size? handleSize;
  final Color? cropColor;
  final Color? cropLineColor;
  final double? cropLineWidth;
  final Color? maskColor;
  final double? handleHitSize;
  final String? exportText;
  final String? exportErrorText;
  HyperImageEditorStyle copyWith({
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
    HyperDialogStyle? dialogStyle,
    EdgeInsets? cropPadding,
    Size? handleSize,
    Color? cropColor,
    Color? cropLineColor,
    double? cropLineWidth,
    Color? maskColor,
    double? handleHitSize,
    String? exportText,
    String? exportErrorText,
  }) => HyperImageEditorStyle(
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
    dialogStyle: dialogStyle == null
        ? this.dialogStyle
        : (this.dialogStyle ?? const HyperDialogStyle()).merge(dialogStyle),
    cropPadding: cropPadding ?? this.cropPadding,
    handleSize: handleSize ?? this.handleSize,
    cropColor: cropColor ?? this.cropColor,
    cropLineColor: cropLineColor ?? this.cropLineColor,
    cropLineWidth: cropLineWidth ?? this.cropLineWidth,
    maskColor: maskColor ?? this.maskColor,
    handleHitSize: handleHitSize ?? this.handleHitSize,
    exportText: exportText ?? this.exportText,
    exportErrorText: exportErrorText ?? this.exportErrorText,
  );
  HyperImageEditorStyle merge(HyperImageEditorStyle? other) => other == null
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
          dialogStyle: other.dialogStyle,
          cropPadding: other.cropPadding,
          handleSize: other.handleSize,
          cropColor: other.cropColor,
          cropLineColor: other.cropLineColor,
          cropLineWidth: other.cropLineWidth,
          maskColor: other.maskColor,
          handleHitSize: other.handleHitSize,
          exportText: other.exportText,
          exportErrorText: other.exportErrorText,
        );
  static HyperImageEditorStyle lerp(
    HyperImageEditorStyle a,
    HyperImageEditorStyle b,
    double t,
  ) {
    T? discrete<T>(T? a, T? b) => t < .5 ? a : b;
    double? number(double? a, double? b) =>
        a == null || b == null ? discrete(a, b) : a + (b - a) * t;
    return HyperImageEditorStyle(
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
      dialogStyle: a.dialogStyle == null || b.dialogStyle == null
          ? discrete(a.dialogStyle, b.dialogStyle)
          : HyperDialogStyle.lerp(a.dialogStyle!, b.dialogStyle!, t),
      cropPadding: EdgeInsets.lerp(a.cropPadding, b.cropPadding, t),
      handleSize: Size.lerp(a.handleSize, b.handleSize, t),
      cropColor: Color.lerp(a.cropColor, b.cropColor, t),
      cropLineColor: Color.lerp(a.cropLineColor, b.cropLineColor, t),
      cropLineWidth: number(a.cropLineWidth, b.cropLineWidth),
      maskColor: Color.lerp(a.maskColor, b.maskColor, t),
      handleHitSize: number(a.handleHitSize, b.handleHitSize),
      exportText: discrete(a.exportText, b.exportText),
      exportErrorText: discrete(a.exportErrorText, b.exportErrorText),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is HyperImageEditorStyle &&
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
      dialogStyle == other.dialogStyle &&
      cropPadding == other.cropPadding &&
      handleSize == other.handleSize &&
      cropColor == other.cropColor &&
      cropLineColor == other.cropLineColor &&
      cropLineWidth == other.cropLineWidth &&
      maskColor == other.maskColor &&
      handleHitSize == other.handleHitSize &&
      exportText == other.exportText &&
      exportErrorText == other.exportErrorText;
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
    dialogStyle,
    cropPadding,
    handleSize,
    cropColor,
    cropLineColor,
    cropLineWidth,
    maskColor,
    handleHitSize,
    exportText,
    exportErrorText,
  ]);
}
