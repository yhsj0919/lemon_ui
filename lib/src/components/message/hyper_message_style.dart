import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../foundation/hyper_fill.dart';
import '../../foundation/hyper_surface_material.dart';
import '../button/hyper_button_theme.dart';

/// Toast 和 Snackbar 共用的视觉模板；各自主题独立配置。
@immutable
final class HyperMessageStyle {
  const HyperMessageStyle({
    this.background,
    this.material,
    this.materialQuality,
    this.reduceTransparency,
    this.border,
    this.borderRadius,
    this.boxShadow,
    this.maxWidth,
    this.padding,
    this.textStyle,
    this.iconColor,
    this.iconSize,
    this.spacing,
    this.animationStyle,
    this.entryOffset,
    this.buttonTheme,
  });
  final HyperFill? background;
  final HyperSurfaceMaterial? material;
  final HyperMaterialQuality? materialQuality;
  final bool? reduceTransparency;
  final BoxBorder? border;
  final BorderRadiusGeometry? borderRadius;
  final List<BoxShadow>? boxShadow;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final Color? iconColor;
  final double? iconSize;
  final double? spacing;
  final AnimationStyle? animationStyle;
  final Offset? entryOffset;
  final HyperButtonThemeData? buttonTheme;
  HyperMessageStyle copyWith({
    HyperFill? background,
    HyperSurfaceMaterial? material,
    HyperMaterialQuality? materialQuality,
    bool? reduceTransparency,
    BoxBorder? border,
    BorderRadiusGeometry? borderRadius,
    List<BoxShadow>? boxShadow,
    double? maxWidth,
    EdgeInsetsGeometry? padding,
    TextStyle? textStyle,
    Color? iconColor,
    double? iconSize,
    double? spacing,
    AnimationStyle? animationStyle,
    Offset? entryOffset,
    HyperButtonThemeData? buttonTheme,
  }) => HyperMessageStyle(
    background: background ?? this.background,
    material: material ?? this.material,
    materialQuality: materialQuality ?? this.materialQuality,
    reduceTransparency: reduceTransparency ?? this.reduceTransparency,
    border: border ?? this.border,
    borderRadius: borderRadius ?? this.borderRadius,
    boxShadow: boxShadow ?? this.boxShadow,
    maxWidth: maxWidth ?? this.maxWidth,
    padding: padding ?? this.padding,
    textStyle: textStyle ?? this.textStyle,
    iconColor: iconColor ?? this.iconColor,
    iconSize: iconSize ?? this.iconSize,
    spacing: spacing ?? this.spacing,
    animationStyle: animationStyle ?? this.animationStyle,
    entryOffset: entryOffset ?? this.entryOffset,
    buttonTheme: buttonTheme ?? this.buttonTheme,
  );
  HyperMessageStyle merge(HyperMessageStyle? other) => other == null
      ? this
      : copyWith(
          background: other.background,
          material: other.material,
          materialQuality: other.materialQuality,
          reduceTransparency: other.reduceTransparency,
          border: other.border,
          borderRadius: other.borderRadius,
          boxShadow: other.boxShadow,
          maxWidth: other.maxWidth,
          padding: other.padding,
          textStyle: textStyle?.merge(other.textStyle) ?? other.textStyle,
          iconColor: other.iconColor,
          iconSize: other.iconSize,
          spacing: other.spacing,
          animationStyle: animationStyle == null
              ? other.animationStyle
              : other.animationStyle == null
              ? animationStyle
              : animationStyle!.copyWith(
                  duration: other.animationStyle!.duration,
                  reverseDuration: other.animationStyle!.reverseDuration,
                  curve: other.animationStyle!.curve,
                  reverseCurve: other.animationStyle!.reverseCurve,
                ),
          entryOffset: other.entryOffset,
          buttonTheme:
              buttonTheme?.merge(other.buttonTheme) ?? other.buttonTheme,
        );
  static HyperMessageStyle lerp(
    HyperMessageStyle a,
    HyperMessageStyle b,
    double t,
  ) {
    if (t == 0 || a == b) return a;
    if (t == 1) return b;
    return HyperMessageStyle(
      materialQuality: t < .5 ? a.materialQuality : b.materialQuality,
      reduceTransparency: t < .5 ? a.reduceTransparency : b.reduceTransparency,
      background: a.background == null || b.background == null
          ? (t < .5 ? a.background : b.background)
          : HyperFill.lerp(a.background!, b.background!, t),
      material: a.material == null || b.material == null
          ? (t < .5 ? a.material : b.material)
          : HyperSurfaceMaterial.lerp(a.material!, b.material!, t),
      border: a.border == null || b.border == null
          ? (t < .5 ? a.border : b.border)
          : BoxBorder.lerp(a.border!, b.border!, t),
      borderRadius: a.borderRadius == null || b.borderRadius == null
          ? (t < .5 ? a.borderRadius : b.borderRadius)
          : BorderRadiusGeometry.lerp(a.borderRadius!, b.borderRadius!, t),
      boxShadow: a.boxShadow == null || b.boxShadow == null
          ? (t < .5 ? a.boxShadow : b.boxShadow)
          : BoxShadow.lerpList(a.boxShadow, b.boxShadow, t),
      maxWidth: a.maxWidth == null || b.maxWidth == null
          ? (t < .5 ? a.maxWidth : b.maxWidth)
          : a.maxWidth! + (b.maxWidth! - a.maxWidth!) * t,
      padding: a.padding == null || b.padding == null
          ? (t < .5 ? a.padding : b.padding)
          : EdgeInsetsGeometry.lerp(a.padding!, b.padding!, t),
      textStyle: a.textStyle == null || b.textStyle == null
          ? (t < .5 ? a.textStyle : b.textStyle)
          : TextStyle.lerp(a.textStyle!, b.textStyle!, t),
      iconColor: a.iconColor == null || b.iconColor == null
          ? (t < .5 ? a.iconColor : b.iconColor)
          : Color.lerp(a.iconColor!, b.iconColor!, t),
      iconSize: a.iconSize == null || b.iconSize == null
          ? (t < .5 ? a.iconSize : b.iconSize)
          : a.iconSize! + (b.iconSize! - a.iconSize!) * t,
      spacing: a.spacing == null || b.spacing == null
          ? (t < .5 ? a.spacing : b.spacing)
          : a.spacing! + (b.spacing! - a.spacing!) * t,
      animationStyle: a.animationStyle == null || b.animationStyle == null
          ? (t < .5 ? a.animationStyle : b.animationStyle)
          : AnimationStyle.lerp(a.animationStyle!, b.animationStyle!, t),
      entryOffset: a.entryOffset == null || b.entryOffset == null
          ? (t < .5 ? a.entryOffset : b.entryOffset)
          : Offset.lerp(a.entryOffset!, b.entryOffset!, t),
      buttonTheme: a.buttonTheme == null || b.buttonTheme == null
          ? (t < .5 ? a.buttonTheme : b.buttonTheme)
          : HyperButtonThemeData.lerp(a.buttonTheme!, b.buttonTheme!, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is HyperMessageStyle &&
      background == other.background &&
      material == other.material &&
      materialQuality == other.materialQuality &&
      reduceTransparency == other.reduceTransparency &&
      border == other.border &&
      borderRadius == other.borderRadius &&
      listEquals(boxShadow, other.boxShadow) &&
      maxWidth == other.maxWidth &&
      padding == other.padding &&
      textStyle == other.textStyle &&
      iconColor == other.iconColor &&
      iconSize == other.iconSize &&
      spacing == other.spacing &&
      animationStyle == other.animationStyle &&
      entryOffset == other.entryOffset &&
      buttonTheme == other.buttonTheme;
  @override
  int get hashCode => Object.hashAll([
    background,
    material,
    materialQuality,
    reduceTransparency,
    border,
    borderRadius,
    boxShadow == null ? null : Object.hashAll(boxShadow!),
    maxWidth,
    padding,
    textStyle,
    iconColor,
    iconSize,
    spacing,
    animationStyle,
    entryOffset,
    buttonTheme,
  ]);
}
