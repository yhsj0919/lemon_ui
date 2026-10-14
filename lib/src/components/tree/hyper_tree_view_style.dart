import '../../painting/hyper_box_decoration.dart';

import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import '../../foundation/hyper_fill.dart';
import '../../foundation/hyper_surface_material.dart';

typedef HyperTreeExpansionTransitionBuilder = Widget Function(
  BuildContext context,
  Widget child,
  Duration duration,
  Curve curve,
);

@immutable
final class HyperTreeViewStyle {
  const HyperTreeViewStyle({
    this.background,
    this.material,
    this.materialQuality,
    this.reduceTransparency,
    this.border,
    this.borderRadius,
    this.padding,
    this.rowBackground,
    this.selectedBackground,
    this.hoverBackground,
    this.pressedBackground,
    this.foregroundColor,
    this.selectedForegroundColor,
    this.disabledColor,
    this.focusColor,
    this.errorColor,
    this.textStyle,
    this.rowHeight,
    this.rowSpacing,
    this.indent,
    this.iconSize,
    this.contentSpacing,
    this.rowPadding,
    this.rowRadius,
    this.expandIcon,
    this.errorIcon,
    this.loadingLabel,
    this.retryLabel,
    this.emptyLabel,
    this.duration,
    this.curve,
    this.expansionTransitionBuilder,
    this.transitionBuilder,
  });
  final HyperFill? background;
  final HyperSurfaceMaterial? material;
  final HyperMaterialQuality? materialQuality;
  final bool? reduceTransparency;
  final BoxBorder? border;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? padding;
  final HyperFill? rowBackground;
  final HyperFill? selectedBackground;
  final HyperFill? hoverBackground;
  final HyperFill? pressedBackground;
  final Color? foregroundColor;
  final Color? selectedForegroundColor;
  final Color? disabledColor;
  final Color? focusColor;
  final Color? errorColor;
  final TextStyle? textStyle;
  final double? rowHeight;
  final double? rowSpacing;
  final double? indent;
  final double? iconSize;
  final double? contentSpacing;
  final EdgeInsetsGeometry? rowPadding;
  final BorderRadiusGeometry? rowRadius;
  final IconData? expandIcon;
  final IconData? errorIcon;
  final String? loadingLabel;
  final String? retryLabel;
  final String? emptyLabel;
  final Duration? duration;
  final Curve? curve;
  final HyperTreeExpansionTransitionBuilder? expansionTransitionBuilder;
  final AnimatedSwitcherTransitionBuilder? transitionBuilder;
  HyperTreeViewStyle copyWith({
    HyperFill? background,
    HyperSurfaceMaterial? material,
    HyperMaterialQuality? materialQuality,
    bool? reduceTransparency,
    BoxBorder? border,
    BorderRadiusGeometry? borderRadius,
    EdgeInsetsGeometry? padding,
    HyperFill? rowBackground,
    HyperFill? selectedBackground,
    HyperFill? hoverBackground,
    HyperFill? pressedBackground,
    Color? foregroundColor,
    Color? selectedForegroundColor,
    Color? disabledColor,
    Color? focusColor,
    Color? errorColor,
    TextStyle? textStyle,
    double? rowHeight,
    double? rowSpacing,
    double? indent,
    double? iconSize,
    double? contentSpacing,
    EdgeInsetsGeometry? rowPadding,
    BorderRadiusGeometry? rowRadius,
    IconData? expandIcon,
    IconData? errorIcon,
    String? loadingLabel,
    String? retryLabel,
    String? emptyLabel,
    Duration? duration,
    Curve? curve,
    HyperTreeExpansionTransitionBuilder? expansionTransitionBuilder,
    AnimatedSwitcherTransitionBuilder? transitionBuilder,
  }) => HyperTreeViewStyle(
    background: background ?? this.background,
    material: material ?? this.material,
    materialQuality: materialQuality ?? this.materialQuality,
    reduceTransparency: reduceTransparency ?? this.reduceTransparency,
    border: border ?? this.border,
    borderRadius: borderRadius ?? this.borderRadius,
    padding: padding ?? this.padding,
    rowBackground: rowBackground ?? this.rowBackground,
    selectedBackground: selectedBackground ?? this.selectedBackground,
    hoverBackground: hoverBackground ?? this.hoverBackground,
    pressedBackground: pressedBackground ?? this.pressedBackground,
    foregroundColor: foregroundColor ?? this.foregroundColor,
    selectedForegroundColor:
        selectedForegroundColor ?? this.selectedForegroundColor,
    disabledColor: disabledColor ?? this.disabledColor,
    focusColor: focusColor ?? this.focusColor,
    errorColor: errorColor ?? this.errorColor,
    textStyle: textStyle ?? this.textStyle,
    rowHeight: rowHeight ?? this.rowHeight,
    rowSpacing: rowSpacing ?? this.rowSpacing,
    indent: indent ?? this.indent,
    iconSize: iconSize ?? this.iconSize,
    contentSpacing: contentSpacing ?? this.contentSpacing,
    rowPadding: rowPadding ?? this.rowPadding,
    rowRadius: rowRadius ?? this.rowRadius,
    expandIcon: expandIcon ?? this.expandIcon,
    errorIcon: errorIcon ?? this.errorIcon,
    loadingLabel: loadingLabel ?? this.loadingLabel,
    retryLabel: retryLabel ?? this.retryLabel,
    emptyLabel: emptyLabel ?? this.emptyLabel,
    duration: duration ?? this.duration,
    curve: curve ?? this.curve,
    expansionTransitionBuilder:
        expansionTransitionBuilder ?? this.expansionTransitionBuilder,
    transitionBuilder: transitionBuilder ?? this.transitionBuilder,
  );
  HyperTreeViewStyle merge(HyperTreeViewStyle? other) => other == null
      ? this
      : HyperTreeViewStyle(
          background: other.background ?? background,
          material: other.material ?? material,
          materialQuality: other.materialQuality ?? materialQuality,
          reduceTransparency: other.reduceTransparency ?? reduceTransparency,
          border: other.border ?? border,
          borderRadius: other.borderRadius ?? borderRadius,
          padding: other.padding ?? padding,
          rowBackground: other.rowBackground ?? rowBackground,
          selectedBackground: other.selectedBackground ?? selectedBackground,
          hoverBackground: other.hoverBackground ?? hoverBackground,
          pressedBackground: other.pressedBackground ?? pressedBackground,
          foregroundColor: other.foregroundColor ?? foregroundColor,
          selectedForegroundColor:
              other.selectedForegroundColor ?? selectedForegroundColor,
          disabledColor: other.disabledColor ?? disabledColor,
          focusColor: other.focusColor ?? focusColor,
          errorColor: other.errorColor ?? errorColor,
          textStyle: textStyle?.merge(other.textStyle) ?? other.textStyle,
          rowHeight: other.rowHeight ?? rowHeight,
          rowSpacing: other.rowSpacing ?? rowSpacing,
          indent: other.indent ?? indent,
          iconSize: other.iconSize ?? iconSize,
          contentSpacing: other.contentSpacing ?? contentSpacing,
          rowPadding: other.rowPadding ?? rowPadding,
          rowRadius: other.rowRadius ?? rowRadius,
          expandIcon: other.expandIcon ?? expandIcon,
          errorIcon: other.errorIcon ?? errorIcon,
          loadingLabel: other.loadingLabel ?? loadingLabel,
          retryLabel: other.retryLabel ?? retryLabel,
          emptyLabel: other.emptyLabel ?? emptyLabel,
          duration: other.duration ?? duration,
          curve: other.curve ?? curve,
          expansionTransitionBuilder:
              other.expansionTransitionBuilder ?? expansionTransitionBuilder,
          transitionBuilder: other.transitionBuilder ?? transitionBuilder,
        );
  static HyperTreeViewStyle lerp(
    HyperTreeViewStyle a,
    HyperTreeViewStyle b,
    double t,
  ) => t == 0
      ? a
      : t == 1
      ? b
      : HyperTreeViewStyle(
          background: a.background == null || b.background == null
              ? (t < .5 ? a.background : b.background)
              : HyperFill.lerp(a.background!, b.background!, t),
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
          padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
          rowBackground: a.rowBackground == null || b.rowBackground == null
              ? (t < .5 ? a.rowBackground : b.rowBackground)
              : HyperFill.lerp(a.rowBackground!, b.rowBackground!, t),
          selectedBackground:
              a.selectedBackground == null || b.selectedBackground == null
              ? (t < .5 ? a.selectedBackground : b.selectedBackground)
              : HyperFill.lerp(a.selectedBackground!, b.selectedBackground!, t),
          hoverBackground:
              a.hoverBackground == null || b.hoverBackground == null
              ? (t < .5 ? a.hoverBackground : b.hoverBackground)
              : HyperFill.lerp(a.hoverBackground!, b.hoverBackground!, t),
          pressedBackground:
              a.pressedBackground == null || b.pressedBackground == null
              ? (t < .5 ? a.pressedBackground : b.pressedBackground)
              : HyperFill.lerp(a.pressedBackground!, b.pressedBackground!, t),
          foregroundColor: Color.lerp(a.foregroundColor, b.foregroundColor, t),
          selectedForegroundColor: Color.lerp(
            a.selectedForegroundColor,
            b.selectedForegroundColor,
            t,
          ),
          disabledColor: Color.lerp(a.disabledColor, b.disabledColor, t),
          focusColor: Color.lerp(a.focusColor, b.focusColor, t),
          errorColor: Color.lerp(a.errorColor, b.errorColor, t),
          textStyle: TextStyle.lerp(a.textStyle, b.textStyle, t),
          rowHeight: lerpDouble(a.rowHeight, b.rowHeight, t),
          rowSpacing: lerpDouble(a.rowSpacing, b.rowSpacing, t),
          indent: lerpDouble(a.indent, b.indent, t),
          iconSize: lerpDouble(a.iconSize, b.iconSize, t),
          contentSpacing: lerpDouble(a.contentSpacing, b.contentSpacing, t),
          rowPadding: EdgeInsetsGeometry.lerp(a.rowPadding, b.rowPadding, t),
          rowRadius: BorderRadiusGeometry.lerp(a.rowRadius, b.rowRadius, t),
          expandIcon: t < .5 ? a.expandIcon : b.expandIcon,
          errorIcon: t < .5 ? a.errorIcon : b.errorIcon,
          loadingLabel: t < .5 ? a.loadingLabel : b.loadingLabel,
          retryLabel: t < .5 ? a.retryLabel : b.retryLabel,
          emptyLabel: t < .5 ? a.emptyLabel : b.emptyLabel,
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
          expansionTransitionBuilder: t < .5
              ? a.expansionTransitionBuilder
              : b.expansionTransitionBuilder,
          transitionBuilder: t < .5 ? a.transitionBuilder : b.transitionBuilder,
        );
  @override
  bool operator ==(Object other) =>
      other is HyperTreeViewStyle &&
      background == other.background &&
      material == other.material &&
      materialQuality == other.materialQuality &&
      reduceTransparency == other.reduceTransparency &&
      border == other.border &&
      borderRadius == other.borderRadius &&
      padding == other.padding &&
      rowBackground == other.rowBackground &&
      selectedBackground == other.selectedBackground &&
      hoverBackground == other.hoverBackground &&
      pressedBackground == other.pressedBackground &&
      foregroundColor == other.foregroundColor &&
      selectedForegroundColor == other.selectedForegroundColor &&
      disabledColor == other.disabledColor &&
      focusColor == other.focusColor &&
      errorColor == other.errorColor &&
      textStyle == other.textStyle &&
      rowHeight == other.rowHeight &&
      rowSpacing == other.rowSpacing &&
      indent == other.indent &&
      iconSize == other.iconSize &&
      contentSpacing == other.contentSpacing &&
      rowPadding == other.rowPadding &&
      rowRadius == other.rowRadius &&
      expandIcon == other.expandIcon &&
      errorIcon == other.errorIcon &&
      loadingLabel == other.loadingLabel &&
      retryLabel == other.retryLabel &&
      emptyLabel == other.emptyLabel &&
      duration == other.duration &&
      curve == other.curve &&
      expansionTransitionBuilder == other.expansionTransitionBuilder &&
      transitionBuilder == other.transitionBuilder;
  @override
  int get hashCode => Object.hashAll([
    background,
    material,
    materialQuality,
    reduceTransparency,
    border,
    borderRadius,
    padding,
    rowBackground,
    selectedBackground,
    hoverBackground,
    pressedBackground,
    foregroundColor,
    selectedForegroundColor,
    disabledColor,
    focusColor,
    errorColor,
    textStyle,
    rowHeight,
    rowSpacing,
    indent,
    iconSize,
    contentSpacing,
    rowPadding,
    rowRadius,
    expandIcon,
    errorIcon,
    loadingLabel,
    retryLabel,
    emptyLabel,
    duration,
    curve,
    expansionTransitionBuilder,
    transitionBuilder,
  ]);
}
