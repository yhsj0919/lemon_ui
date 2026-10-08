import 'package:flutter/material.dart';

import '../../foundation/hyper_fill.dart';
import '../../foundation/hyper_surface_material.dart';

typedef HyperCollapsibleTransitionBuilder = Widget Function(
  BuildContext context,
  double value,
  Axis axis,
  Widget child,
);

@immutable
final class HyperCollapsibleStyle {
  const HyperCollapsibleStyle({
    this.background,
    this.material,
    this.materialQuality,
    this.reduceTransparency,
    this.border,
    this.borderRadius,
    this.headerPadding,
    this.contentPadding,
    this.headerMinHeight,
    this.spacing,
    this.headerStyle,
    this.iconColor,
    this.indicatorIcon,
    this.iconSize,
    this.overlayColor,
    this.hoverOpacity,
    this.focusOpacity,
    this.pressedOpacity,
    this.disabledOpacity,
    this.duration,
    this.curve,
    this.transitionBuilder,
  });
  final HyperFill? background;
  final HyperSurfaceMaterial? material;
  final HyperMaterialQuality? materialQuality;
  final bool? reduceTransparency;
  final BoxBorder? border;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? headerPadding;
  final EdgeInsetsGeometry? contentPadding;
  final double? headerMinHeight;
  final double? spacing;
  final TextStyle? headerStyle;
  final Color? iconColor;
  final IconData? indicatorIcon;
  final double? iconSize;
  final Color? overlayColor;
  final double? hoverOpacity;
  final double? focusOpacity;
  final double? pressedOpacity;
  final double? disabledOpacity;
  final Duration? duration;
  final Curve? curve;
  final HyperCollapsibleTransitionBuilder? transitionBuilder;
  HyperCollapsibleStyle copyWith({
    HyperFill? background,
    HyperSurfaceMaterial? material,
    HyperMaterialQuality? materialQuality,
    bool? reduceTransparency,
    BoxBorder? border,
    BorderRadiusGeometry? borderRadius,
    EdgeInsetsGeometry? headerPadding,
    EdgeInsetsGeometry? contentPadding,
    double? headerMinHeight,
    double? spacing,
    TextStyle? headerStyle,
    Color? iconColor,
    IconData? indicatorIcon,
    double? iconSize,
    Color? overlayColor,
    double? hoverOpacity,
    double? focusOpacity,
    double? pressedOpacity,
    double? disabledOpacity,
    Duration? duration,
    Curve? curve,
    HyperCollapsibleTransitionBuilder? transitionBuilder,
  }) => HyperCollapsibleStyle(
    background: background ?? this.background,
    material: material ?? this.material,
    materialQuality: materialQuality ?? this.materialQuality,
    reduceTransparency: reduceTransparency ?? this.reduceTransparency,
    border: border ?? this.border,
    borderRadius: borderRadius ?? this.borderRadius,
    headerPadding: headerPadding ?? this.headerPadding,
    contentPadding: contentPadding ?? this.contentPadding,
    headerMinHeight: headerMinHeight ?? this.headerMinHeight,
    spacing: spacing ?? this.spacing,
    headerStyle: headerStyle ?? this.headerStyle,
    iconColor: iconColor ?? this.iconColor,
    indicatorIcon: indicatorIcon ?? this.indicatorIcon,
    iconSize: iconSize ?? this.iconSize,
    overlayColor: overlayColor ?? this.overlayColor,
    hoverOpacity: hoverOpacity ?? this.hoverOpacity,
    focusOpacity: focusOpacity ?? this.focusOpacity,
    pressedOpacity: pressedOpacity ?? this.pressedOpacity,
    disabledOpacity: disabledOpacity ?? this.disabledOpacity,
    duration: duration ?? this.duration,
    curve: curve ?? this.curve,
    transitionBuilder: transitionBuilder ?? this.transitionBuilder,
  );
  HyperCollapsibleStyle merge(HyperCollapsibleStyle? other) => other == null
      ? this
      : HyperCollapsibleStyle(
          background: other.background ?? background,
          material: other.material ?? material,
          materialQuality: other.materialQuality ?? materialQuality,
          reduceTransparency: other.reduceTransparency ?? reduceTransparency,
          border: other.border ?? border,
          borderRadius: other.borderRadius ?? borderRadius,
          headerPadding: other.headerPadding ?? headerPadding,
          contentPadding: other.contentPadding ?? contentPadding,
          headerMinHeight: other.headerMinHeight ?? headerMinHeight,
          spacing: other.spacing ?? spacing,
          headerStyle:
              headerStyle?.merge(other.headerStyle) ?? other.headerStyle,
          iconColor: other.iconColor ?? iconColor,
          indicatorIcon: other.indicatorIcon ?? indicatorIcon,
          iconSize: other.iconSize ?? iconSize,
          overlayColor: other.overlayColor ?? overlayColor,
          hoverOpacity: other.hoverOpacity ?? hoverOpacity,
          focusOpacity: other.focusOpacity ?? focusOpacity,
          pressedOpacity: other.pressedOpacity ?? pressedOpacity,
          disabledOpacity: other.disabledOpacity ?? disabledOpacity,
          duration: other.duration ?? duration,
          curve: other.curve ?? curve,
          transitionBuilder: other.transitionBuilder ?? transitionBuilder,
        );
  static HyperCollapsibleStyle lerp(
    HyperCollapsibleStyle a,
    HyperCollapsibleStyle b,
    double t,
  ) {
    if (t == 0) {
      return a;
    }
    if (t == 1) {
      return b;
    }
    return HyperCollapsibleStyle(
      background: a.background == null || b.background == null
          ? (t < .5 ? a.background : b.background)
          : HyperFill.lerp(a.background!, b.background!, t),
      material: a.material == null || b.material == null
          ? (t < .5 ? a.material : b.material)
          : HyperSurfaceMaterial.lerp(a.material!, b.material!, t),
      materialQuality: t < .5 ? a.materialQuality : b.materialQuality,
      reduceTransparency: t < .5 ? a.reduceTransparency : b.reduceTransparency,
      border: BoxBorder.lerp(a.border, b.border, t),
      borderRadius: BorderRadiusGeometry.lerp(
        a.borderRadius,
        b.borderRadius,
        t,
      ),
      headerPadding: EdgeInsetsGeometry.lerp(
        a.headerPadding,
        b.headerPadding,
        t,
      ),
      contentPadding: EdgeInsetsGeometry.lerp(
        a.contentPadding,
        b.contentPadding,
        t,
      ),
      headerMinHeight: a.headerMinHeight == null || b.headerMinHeight == null
          ? (t < .5 ? a.headerMinHeight : b.headerMinHeight)
          : a.headerMinHeight! + (b.headerMinHeight! - a.headerMinHeight!) * t,
      spacing: a.spacing == null || b.spacing == null
          ? (t < .5 ? a.spacing : b.spacing)
          : a.spacing! + (b.spacing! - a.spacing!) * t,
      headerStyle: TextStyle.lerp(a.headerStyle, b.headerStyle, t),
      iconColor: Color.lerp(a.iconColor, b.iconColor, t),
      indicatorIcon: t < .5 ? a.indicatorIcon : b.indicatorIcon,
      iconSize: a.iconSize == null || b.iconSize == null
          ? (t < .5 ? a.iconSize : b.iconSize)
          : a.iconSize! + (b.iconSize! - a.iconSize!) * t,
      overlayColor: Color.lerp(a.overlayColor, b.overlayColor, t),
      hoverOpacity: a.hoverOpacity == null || b.hoverOpacity == null
          ? (t < .5 ? a.hoverOpacity : b.hoverOpacity)
          : a.hoverOpacity! + (b.hoverOpacity! - a.hoverOpacity!) * t,
      focusOpacity: a.focusOpacity == null || b.focusOpacity == null
          ? (t < .5 ? a.focusOpacity : b.focusOpacity)
          : a.focusOpacity! + (b.focusOpacity! - a.focusOpacity!) * t,
      pressedOpacity: a.pressedOpacity == null || b.pressedOpacity == null
          ? (t < .5 ? a.pressedOpacity : b.pressedOpacity)
          : a.pressedOpacity! + (b.pressedOpacity! - a.pressedOpacity!) * t,
      disabledOpacity: a.disabledOpacity == null || b.disabledOpacity == null
          ? (t < .5 ? a.disabledOpacity : b.disabledOpacity)
          : a.disabledOpacity! + (b.disabledOpacity! - a.disabledOpacity!) * t,
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
      other is HyperCollapsibleStyle &&
      background == other.background &&
      material == other.material &&
      materialQuality == other.materialQuality &&
      reduceTransparency == other.reduceTransparency &&
      border == other.border &&
      borderRadius == other.borderRadius &&
      headerPadding == other.headerPadding &&
      contentPadding == other.contentPadding &&
      headerMinHeight == other.headerMinHeight &&
      spacing == other.spacing &&
      headerStyle == other.headerStyle &&
      iconColor == other.iconColor &&
      indicatorIcon == other.indicatorIcon &&
      iconSize == other.iconSize &&
      overlayColor == other.overlayColor &&
      hoverOpacity == other.hoverOpacity &&
      focusOpacity == other.focusOpacity &&
      pressedOpacity == other.pressedOpacity &&
      disabledOpacity == other.disabledOpacity &&
      duration == other.duration &&
      curve == other.curve &&
      transitionBuilder == other.transitionBuilder;
  @override
  int get hashCode => Object.hashAll([
    background,
    material,
    materialQuality,
    reduceTransparency,
    border,
    borderRadius,
    headerPadding,
    contentPadding,
    headerMinHeight,
    spacing,
    headerStyle,
    iconColor,
    indicatorIcon,
    iconSize,
    overlayColor,
    hoverOpacity,
    focusOpacity,
    pressedOpacity,
    disabledOpacity,
    duration,
    curve,
    transitionBuilder,
  ]);
}
