import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../foundation/hyper_fill.dart';
import '../../foundation/hyper_surface_material.dart';
import '../progress/hyper_progress_style.dart';
import '../button/hyper_button_theme.dart';

typedef HyperLoadingOverlayTransitionBuilder = Widget Function(
  BuildContext context,
  double value,
  Widget child,
);

@immutable
final class HyperLoadingOverlayStyle {
  const HyperLoadingOverlayStyle({
    this.background,
    this.material,
    this.materialQuality,
    this.reduceTransparency,
    this.borderRadius,
    this.contentBackground,
    this.contentBorder,
    this.contentBorderRadius,
    this.boxShadow,
    this.padding,
    this.maxContentWidth,
    this.spacing,
    this.textStyle,
    this.alignment,
    this.progressStyle,
    this.buttonTheme,
    this.showDelay,
    this.minimumVisibleDuration,
    this.duration,
    this.curve,
    this.transitionBuilder,
  });
  final HyperFill? background;
  final HyperSurfaceMaterial? material;
  final HyperMaterialQuality? materialQuality;
  final bool? reduceTransparency;
  final BorderRadiusGeometry? borderRadius;
  final HyperFill? contentBackground;
  final BoxBorder? contentBorder;
  final BorderRadiusGeometry? contentBorderRadius;
  final List<BoxShadow>? boxShadow;
  final EdgeInsetsGeometry? padding;
  final double? maxContentWidth;
  final double? spacing;
  final TextStyle? textStyle;
  final AlignmentGeometry? alignment;
  final HyperProgressStyle? progressStyle;
  final HyperButtonThemeData? buttonTheme;
  final Duration? showDelay;
  final Duration? minimumVisibleDuration;
  final Duration? duration;
  final Curve? curve;
  final HyperLoadingOverlayTransitionBuilder? transitionBuilder;
  HyperLoadingOverlayStyle copyWith({
    HyperFill? background,
    HyperSurfaceMaterial? material,
    HyperMaterialQuality? materialQuality,
    bool? reduceTransparency,
    BorderRadiusGeometry? borderRadius,
    HyperFill? contentBackground,
    BoxBorder? contentBorder,
    BorderRadiusGeometry? contentBorderRadius,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    double? maxContentWidth,
    double? spacing,
    TextStyle? textStyle,
    AlignmentGeometry? alignment,
    HyperProgressStyle? progressStyle,
    HyperButtonThemeData? buttonTheme,
    Duration? showDelay,
    Duration? minimumVisibleDuration,
    Duration? duration,
    Curve? curve,
    HyperLoadingOverlayTransitionBuilder? transitionBuilder,
  }) => HyperLoadingOverlayStyle(
    background: background ?? this.background,
    material: material ?? this.material,
    materialQuality: materialQuality ?? this.materialQuality,
    reduceTransparency: reduceTransparency ?? this.reduceTransparency,
    borderRadius: borderRadius ?? this.borderRadius,
    contentBackground: contentBackground ?? this.contentBackground,
    contentBorder: contentBorder ?? this.contentBorder,
    contentBorderRadius: contentBorderRadius ?? this.contentBorderRadius,
    boxShadow: boxShadow ?? this.boxShadow,
    padding: padding ?? this.padding,
    maxContentWidth: maxContentWidth ?? this.maxContentWidth,
    spacing: spacing ?? this.spacing,
    textStyle: textStyle ?? this.textStyle,
    alignment: alignment ?? this.alignment,
    progressStyle: progressStyle ?? this.progressStyle,
    buttonTheme: buttonTheme ?? this.buttonTheme,
    showDelay: showDelay ?? this.showDelay,
    minimumVisibleDuration:
        minimumVisibleDuration ?? this.minimumVisibleDuration,
    duration: duration ?? this.duration,
    curve: curve ?? this.curve,
    transitionBuilder: transitionBuilder ?? this.transitionBuilder,
  );
  HyperLoadingOverlayStyle merge(HyperLoadingOverlayStyle? other) =>
      other == null
      ? this
      : copyWith(
          background: other.background,
          material: other.material,
          materialQuality: other.materialQuality,
          reduceTransparency: other.reduceTransparency,
          borderRadius: other.borderRadius,
          contentBackground: other.contentBackground,
          contentBorder: other.contentBorder,
          contentBorderRadius: other.contentBorderRadius,
          boxShadow: other.boxShadow,
          padding: other.padding,
          maxContentWidth: other.maxContentWidth,
          spacing: other.spacing,
          textStyle: textStyle?.merge(other.textStyle) ?? other.textStyle,
          alignment: other.alignment,
          progressStyle:
              progressStyle?.merge(other.progressStyle) ?? other.progressStyle,
          buttonTheme:
              buttonTheme?.merge(other.buttonTheme) ?? other.buttonTheme,
          showDelay: other.showDelay,
          minimumVisibleDuration: other.minimumVisibleDuration,
          duration: other.duration,
          curve: other.curve,
          transitionBuilder: other.transitionBuilder,
        );
  static HyperLoadingOverlayStyle lerp(
    HyperLoadingOverlayStyle a,
    HyperLoadingOverlayStyle b,
    double t,
  ) {
    if (t == 0 || a == b) return a;
    if (t == 1) return b;
    return HyperLoadingOverlayStyle(
      background: a.background == null || b.background == null
          ? (t < .5 ? a.background : b.background)
          : HyperFill.lerp(a.background!, b.background!, t),
      material: a.material == null || b.material == null
          ? (t < .5 ? a.material : b.material)
          : HyperSurfaceMaterial.lerp(a.material!, b.material!, t),
      materialQuality: t < .5 ? a.materialQuality : b.materialQuality,
      reduceTransparency: t < .5 ? a.reduceTransparency : b.reduceTransparency,
      borderRadius: a.borderRadius == null || b.borderRadius == null
          ? (t < .5 ? a.borderRadius : b.borderRadius)
          : BorderRadiusGeometry.lerp(a.borderRadius!, b.borderRadius!, t),
      contentBackground:
          a.contentBackground == null || b.contentBackground == null
          ? (t < .5 ? a.contentBackground : b.contentBackground)
          : HyperFill.lerp(a.contentBackground!, b.contentBackground!, t),
      contentBorder: a.contentBorder == null || b.contentBorder == null
          ? (t < .5 ? a.contentBorder : b.contentBorder)
          : BoxBorder.lerp(a.contentBorder!, b.contentBorder!, t),
      contentBorderRadius:
          a.contentBorderRadius == null || b.contentBorderRadius == null
          ? (t < .5 ? a.contentBorderRadius : b.contentBorderRadius)
          : BorderRadiusGeometry.lerp(
              a.contentBorderRadius!,
              b.contentBorderRadius!,
              t,
            ),
      boxShadow: a.boxShadow == null || b.boxShadow == null
          ? (t < .5 ? a.boxShadow : b.boxShadow)
          : BoxShadow.lerpList(a.boxShadow, b.boxShadow, t),
      padding: a.padding == null || b.padding == null
          ? (t < .5 ? a.padding : b.padding)
          : EdgeInsetsGeometry.lerp(a.padding!, b.padding!, t),
      maxContentWidth: a.maxContentWidth == null || b.maxContentWidth == null
          ? (t < .5 ? a.maxContentWidth : b.maxContentWidth)
          : a.maxContentWidth! + (b.maxContentWidth! - a.maxContentWidth!) * t,
      spacing: a.spacing == null || b.spacing == null
          ? (t < .5 ? a.spacing : b.spacing)
          : a.spacing! + (b.spacing! - a.spacing!) * t,
      textStyle: a.textStyle == null || b.textStyle == null
          ? (t < .5 ? a.textStyle : b.textStyle)
          : TextStyle.lerp(a.textStyle!, b.textStyle!, t),
      alignment: a.alignment == null || b.alignment == null
          ? (t < .5 ? a.alignment : b.alignment)
          : AlignmentGeometry.lerp(a.alignment!, b.alignment!, t),
      progressStyle: a.progressStyle == null || b.progressStyle == null
          ? (t < .5 ? a.progressStyle : b.progressStyle)
          : HyperProgressStyle.lerp(a.progressStyle!, b.progressStyle!, t),
      buttonTheme: a.buttonTheme == null || b.buttonTheme == null
          ? (t < .5 ? a.buttonTheme : b.buttonTheme)
          : HyperButtonThemeData.lerp(a.buttonTheme!, b.buttonTheme!, t),
      showDelay: a.showDelay == null || b.showDelay == null
          ? (t < .5 ? a.showDelay : b.showDelay)
          : Duration(
              microseconds:
                  (a.showDelay!.inMicroseconds +
                          (b.showDelay!.inMicroseconds -
                                  a.showDelay!.inMicroseconds) *
                              t)
                      .round(),
            ),
      minimumVisibleDuration:
          a.minimumVisibleDuration == null || b.minimumVisibleDuration == null
          ? (t < .5 ? a.minimumVisibleDuration : b.minimumVisibleDuration)
          : Duration(
              microseconds:
                  (a.minimumVisibleDuration!.inMicroseconds +
                          (b.minimumVisibleDuration!.inMicroseconds -
                                  a.minimumVisibleDuration!.inMicroseconds) *
                              t)
                      .round(),
            ),
      duration: a.duration == null || b.duration == null
          ? (t < .5 ? a.duration : b.duration)
          : Duration(
              microseconds:
                  (a.duration!.inMicroseconds +
                          (b.duration!.inMicroseconds -
                                  a.duration!.inMicroseconds) *
                              t)
                      .round(),
            ),
      curve: t < .5 ? a.curve : b.curve,
      transitionBuilder: t < .5 ? a.transitionBuilder : b.transitionBuilder,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is HyperLoadingOverlayStyle &&
      background == other.background &&
      material == other.material &&
      materialQuality == other.materialQuality &&
      reduceTransparency == other.reduceTransparency &&
      borderRadius == other.borderRadius &&
      contentBackground == other.contentBackground &&
      contentBorder == other.contentBorder &&
      contentBorderRadius == other.contentBorderRadius &&
      listEquals(boxShadow, other.boxShadow) &&
      padding == other.padding &&
      maxContentWidth == other.maxContentWidth &&
      spacing == other.spacing &&
      textStyle == other.textStyle &&
      alignment == other.alignment &&
      progressStyle == other.progressStyle &&
      buttonTheme == other.buttonTheme &&
      showDelay == other.showDelay &&
      minimumVisibleDuration == other.minimumVisibleDuration &&
      duration == other.duration &&
      curve == other.curve &&
      transitionBuilder == other.transitionBuilder;
  @override
  int get hashCode => Object.hashAll([
    background,
    material,
    materialQuality,
    reduceTransparency,
    borderRadius,
    contentBackground,
    contentBorder,
    contentBorderRadius,
    boxShadow == null ? null : Object.hashAll(boxShadow!),
    padding,
    maxContentWidth,
    spacing,
    textStyle,
    alignment,
    progressStyle,
    buttonTheme,
    showDelay,
    minimumVisibleDuration,
    duration,
    curve,
    transitionBuilder,
  ]);
}
