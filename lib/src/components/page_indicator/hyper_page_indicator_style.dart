import '../../painting/hyper_box_decoration.dart';

import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../../foundation/hyper_fill.dart';
import '../../foundation/hyper_surface_material.dart';

@immutable
final class HyperPageIndicatorStyle {
  const HyperPageIndicatorStyle({
    this.background,
    this.dotFill,
    this.selectedDotFill,
    this.material,
    this.materialQuality,
    this.reduceTransparency,
    this.border,
    this.borderRadius,
    this.boxShadow,
    this.padding,
    this.dotSize,
    this.selectedWidth,
    this.spacing,
    this.minimumTapTargetSize,
    this.dotBorder,
    this.dotRadius,
    this.focusColor,
    this.disabledOpacity,
    this.counterStyle,
    this.duration,
    this.curve,
    this.transitionBuilder,
  });
  final HyperFill? background;
  final HyperFill? dotFill;
  final HyperFill? selectedDotFill;
  final HyperSurfaceMaterial? material;
  final HyperMaterialQuality? materialQuality;
  final bool? reduceTransparency;
  final BoxBorder? border;
  final BorderRadiusGeometry? borderRadius;
  final List<BoxShadow>? boxShadow;
  final EdgeInsetsGeometry? padding;
  final double? dotSize;
  final double? selectedWidth;
  final double? spacing;
  final Size? minimumTapTargetSize;
  final BorderSide? dotBorder;
  final BorderRadiusGeometry? dotRadius;
  final Color? focusColor;
  final double? disabledOpacity;
  final TextStyle? counterStyle;
  final Duration? duration;
  final Curve? curve;
  final AnimatedSwitcherTransitionBuilder? transitionBuilder;
  HyperPageIndicatorStyle copyWith({
    HyperFill? background,
    HyperFill? dotFill,
    HyperFill? selectedDotFill,
    HyperSurfaceMaterial? material,
    HyperMaterialQuality? materialQuality,
    bool? reduceTransparency,
    BoxBorder? border,
    BorderRadiusGeometry? borderRadius,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    double? dotSize,
    double? selectedWidth,
    double? spacing,
    Size? minimumTapTargetSize,
    BorderSide? dotBorder,
    BorderRadiusGeometry? dotRadius,
    Color? focusColor,
    double? disabledOpacity,
    TextStyle? counterStyle,
    Duration? duration,
    Curve? curve,
    AnimatedSwitcherTransitionBuilder? transitionBuilder,
  }) => HyperPageIndicatorStyle(
    background: background ?? this.background,
    dotFill: dotFill ?? this.dotFill,
    selectedDotFill: selectedDotFill ?? this.selectedDotFill,
    material: material ?? this.material,
    materialQuality: materialQuality ?? this.materialQuality,
    reduceTransparency: reduceTransparency ?? this.reduceTransparency,
    border: border ?? this.border,
    borderRadius: borderRadius ?? this.borderRadius,
    boxShadow: boxShadow ?? this.boxShadow,
    padding: padding ?? this.padding,
    dotSize: dotSize ?? this.dotSize,
    selectedWidth: selectedWidth ?? this.selectedWidth,
    spacing: spacing ?? this.spacing,
    minimumTapTargetSize: minimumTapTargetSize ?? this.minimumTapTargetSize,
    dotBorder: dotBorder ?? this.dotBorder,
    dotRadius: dotRadius ?? this.dotRadius,
    focusColor: focusColor ?? this.focusColor,
    disabledOpacity: disabledOpacity ?? this.disabledOpacity,
    counterStyle: counterStyle ?? this.counterStyle,
    duration: duration ?? this.duration,
    curve: curve ?? this.curve,
    transitionBuilder: transitionBuilder ?? this.transitionBuilder,
  );
  HyperPageIndicatorStyle merge(HyperPageIndicatorStyle? other) => other == null
      ? this
      : HyperPageIndicatorStyle(
          background: other.background ?? background,
          dotFill: other.dotFill ?? dotFill,
          selectedDotFill: other.selectedDotFill ?? selectedDotFill,
          material: other.material ?? material,
          materialQuality: other.materialQuality ?? materialQuality,
          reduceTransparency: other.reduceTransparency ?? reduceTransparency,
          border: other.border ?? border,
          borderRadius: other.borderRadius ?? borderRadius,
          boxShadow: other.boxShadow ?? boxShadow,
          padding: other.padding ?? padding,
          dotSize: other.dotSize ?? dotSize,
          selectedWidth: other.selectedWidth ?? selectedWidth,
          spacing: other.spacing ?? spacing,
          minimumTapTargetSize:
              other.minimumTapTargetSize ?? minimumTapTargetSize,
          dotBorder: other.dotBorder ?? dotBorder,
          dotRadius: other.dotRadius ?? dotRadius,
          focusColor: other.focusColor ?? focusColor,
          disabledOpacity: other.disabledOpacity ?? disabledOpacity,
          counterStyle:
              counterStyle?.merge(other.counterStyle) ?? other.counterStyle,
          duration: other.duration ?? duration,
          curve: other.curve ?? curve,
          transitionBuilder: other.transitionBuilder ?? transitionBuilder,
        );
  static HyperPageIndicatorStyle lerp(
    HyperPageIndicatorStyle a,
    HyperPageIndicatorStyle b,
    double t,
  ) => t == 0
      ? a
      : t == 1
      ? b
      : HyperPageIndicatorStyle(
          background: a.background == null || b.background == null
              ? (t < .5 ? a.background : b.background)
              : HyperFill.lerp(a.background!, b.background!, t),
          dotFill: a.dotFill == null || b.dotFill == null
              ? (t < .5 ? a.dotFill : b.dotFill)
              : HyperFill.lerp(a.dotFill!, b.dotFill!, t),
          selectedDotFill:
              a.selectedDotFill == null || b.selectedDotFill == null
              ? (t < .5 ? a.selectedDotFill : b.selectedDotFill)
              : HyperFill.lerp(a.selectedDotFill!, b.selectedDotFill!, t),
          material: a.material == null || b.material == null
              ? (t < .5 ? a.material : b.material)
              : HyperSurfaceMaterial.lerp(a.material!, b.material!, t),
          materialQuality: t < .5 ? a.materialQuality : b.materialQuality,
          reduceTransparency: t < .5
              ? a.reduceTransparency
              : b.reduceTransparency,
          border: lerpHyperBoxBorder(a.border, b.border, t),
          borderRadius: BorderRadiusGeometry.lerp(
            a.borderRadius,
            b.borderRadius,
            t,
          ),
          boxShadow: BoxShadow.lerpList(a.boxShadow, b.boxShadow, t),
          padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
          dotSize: lerpDouble(a.dotSize, b.dotSize, t),
          selectedWidth: lerpDouble(a.selectedWidth, b.selectedWidth, t),
          spacing: lerpDouble(a.spacing, b.spacing, t),
          minimumTapTargetSize: Size.lerp(
            a.minimumTapTargetSize,
            b.minimumTapTargetSize,
            t,
          ),
          dotBorder: a.dotBorder == null || b.dotBorder == null
              ? (t < .5 ? a.dotBorder : b.dotBorder)
              : BorderSide.lerp(a.dotBorder!, b.dotBorder!, t),
          dotRadius: BorderRadiusGeometry.lerp(a.dotRadius, b.dotRadius, t),
          focusColor: Color.lerp(a.focusColor, b.focusColor, t),
          disabledOpacity: lerpDouble(a.disabledOpacity, b.disabledOpacity, t),
          counterStyle: TextStyle.lerp(a.counterStyle, b.counterStyle, t),
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
  @override
  bool operator ==(Object other) =>
      other is HyperPageIndicatorStyle &&
      background == other.background &&
      dotFill == other.dotFill &&
      selectedDotFill == other.selectedDotFill &&
      material == other.material &&
      materialQuality == other.materialQuality &&
      reduceTransparency == other.reduceTransparency &&
      border == other.border &&
      borderRadius == other.borderRadius &&
      listEquals(boxShadow, other.boxShadow) &&
      padding == other.padding &&
      dotSize == other.dotSize &&
      selectedWidth == other.selectedWidth &&
      spacing == other.spacing &&
      minimumTapTargetSize == other.minimumTapTargetSize &&
      dotBorder == other.dotBorder &&
      dotRadius == other.dotRadius &&
      focusColor == other.focusColor &&
      disabledOpacity == other.disabledOpacity &&
      counterStyle == other.counterStyle &&
      duration == other.duration &&
      curve == other.curve &&
      transitionBuilder == other.transitionBuilder;
  @override
  int get hashCode => Object.hashAll([
    background,
    dotFill,
    selectedDotFill,
    material,
    materialQuality,
    reduceTransparency,
    border,
    borderRadius,
    boxShadow == null ? null : Object.hashAll(boxShadow!),
    padding,
    dotSize,
    selectedWidth,
    spacing,
    minimumTapTargetSize,
    dotBorder,
    dotRadius,
    focusColor,
    disabledOpacity,
    counterStyle,
    duration,
    curve,
    transitionBuilder,
  ]);
}
