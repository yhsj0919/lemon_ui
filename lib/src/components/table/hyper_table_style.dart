import '../text_field/hyper_text_field_style.dart';

import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../foundation/hyper_surface_material.dart';

/// Explicit table overrides; omitted fields inherit the resolved theme.
@immutable
final class HyperTableStyle {
  const HyperTableStyle({
    this.hoverLift,
    this.striped,
    this.showColumnResizeHandles,
    this.editorStyle,
    this.footerPadding,
    this.scrollbarTheme,
    this.treeIndent,
    this.rowHeight,
    this.headerHeight,
    this.columnWidth,
    this.minimumColumnWidth,
    this.controlColumnWidth,
    this.horizontalPadding,
    this.verticalPadding,
    this.iconSize,
    this.borderWidth,
    this.radius,
    this.textStyle,
    this.headerTextStyle,
    this.background,
    this.headerBackground,
    this.stripeBackground,
    this.hoverBackground,
    this.selectedBackground,
    this.editingBackground,
    this.borderColor,
    this.focusColor,
    this.material,
    this.materialQuality,
    this.reduceTransparency,
    this.boxShadow,
    this.rowBoxShadow,
    this.liftBackground,
    this.liftRadius,
    this.liftBorder,
    this.duration,
    this.liftDuration,
    this.curve,
  });
  final HyperTextFieldStyle? editorStyle;
  final bool? hoverLift, striped, showColumnResizeHandles;
  final EdgeInsetsGeometry? footerPadding;
  final ScrollbarThemeData? scrollbarTheme;
  final double? treeIndent;
  final double? rowHeight;
  final double? headerHeight;
  final double? columnWidth;
  final double? minimumColumnWidth;
  final double? controlColumnWidth;
  final double? horizontalPadding;
  final double? verticalPadding;
  final double? iconSize;
  final double? borderWidth;
  final double? radius;
  final TextStyle? textStyle;
  final TextStyle? headerTextStyle;
  final Color? background;
  final Color? headerBackground;
  final Color? stripeBackground;
  final Color? hoverBackground;
  final Color? selectedBackground;
  final Color? editingBackground;
  final Color? borderColor;
  final Color? focusColor;
  final HyperSurfaceMaterial? material;
  final HyperMaterialQuality? materialQuality;
  final bool? reduceTransparency;
  final List<BoxShadow>? boxShadow;

  /// Shared shadow for lifted rows and drag feedback; empty disables it.
  final List<BoxShadow>? rowBoxShadow;
  final Color? liftBackground;
  final double? liftRadius;
  final BorderSide? liftBorder;
  final Duration? duration;

  /// Duration of hover elevation and drag shadow transitions.
  final Duration? liftDuration;
  final Curve? curve;
  HyperTableStyle copyWith({
    bool? hoverLift,
    bool? striped,
    bool? showColumnResizeHandles,
    HyperTextFieldStyle? editorStyle,
    EdgeInsetsGeometry? footerPadding,
    ScrollbarThemeData? scrollbarTheme,
    double? treeIndent,
    double? rowHeight,
    double? headerHeight,
    double? columnWidth,
    double? minimumColumnWidth,
    double? controlColumnWidth,
    double? horizontalPadding,
    double? verticalPadding,
    double? iconSize,
    double? borderWidth,
    double? radius,
    TextStyle? textStyle,
    TextStyle? headerTextStyle,
    Color? background,
    Color? headerBackground,
    Color? stripeBackground,
    Color? hoverBackground,
    Color? selectedBackground,
    Color? editingBackground,
    Color? borderColor,
    Color? focusColor,
    HyperSurfaceMaterial? material,
    HyperMaterialQuality? materialQuality,
    bool? reduceTransparency,
    List<BoxShadow>? boxShadow,
    List<BoxShadow>? rowBoxShadow,
    Color? liftBackground,
    double? liftRadius,
    BorderSide? liftBorder,
    Duration? duration,
    Duration? liftDuration,
    Curve? curve,
  }) => HyperTableStyle(
    hoverLift: hoverLift ?? this.hoverLift,
    striped: striped ?? this.striped,
    showColumnResizeHandles:
        showColumnResizeHandles ?? this.showColumnResizeHandles,
    editorStyle: editorStyle ?? this.editorStyle,
    footerPadding: footerPadding ?? this.footerPadding,
    scrollbarTheme: scrollbarTheme ?? this.scrollbarTheme,
    treeIndent: treeIndent ?? this.treeIndent,
    rowHeight: rowHeight ?? this.rowHeight,
    headerHeight: headerHeight ?? this.headerHeight,
    columnWidth: columnWidth ?? this.columnWidth,
    minimumColumnWidth: minimumColumnWidth ?? this.minimumColumnWidth,
    controlColumnWidth: controlColumnWidth ?? this.controlColumnWidth,
    horizontalPadding: horizontalPadding ?? this.horizontalPadding,
    verticalPadding: verticalPadding ?? this.verticalPadding,
    iconSize: iconSize ?? this.iconSize,
    borderWidth: borderWidth ?? this.borderWidth,
    radius: radius ?? this.radius,
    textStyle: textStyle ?? this.textStyle,
    headerTextStyle: headerTextStyle ?? this.headerTextStyle,
    background: background ?? this.background,
    headerBackground: headerBackground ?? this.headerBackground,
    stripeBackground: stripeBackground ?? this.stripeBackground,
    hoverBackground: hoverBackground ?? this.hoverBackground,
    selectedBackground: selectedBackground ?? this.selectedBackground,
    editingBackground: editingBackground ?? this.editingBackground,
    borderColor: borderColor ?? this.borderColor,
    focusColor: focusColor ?? this.focusColor,
    material: material ?? this.material,
    materialQuality: materialQuality ?? this.materialQuality,
    reduceTransparency: reduceTransparency ?? this.reduceTransparency,
    boxShadow: boxShadow ?? this.boxShadow,
    rowBoxShadow: rowBoxShadow ?? this.rowBoxShadow,
    liftBackground: liftBackground ?? this.liftBackground,
    liftRadius: liftRadius ?? this.liftRadius,
    liftBorder: liftBorder ?? this.liftBorder,
    duration: duration ?? this.duration,
    liftDuration: liftDuration ?? this.liftDuration,
    curve: curve ?? this.curve,
  );
  HyperTableStyle merge(HyperTableStyle? other) => other == null
      ? this
      : HyperTableStyle(
          hoverLift: other.hoverLift ?? hoverLift,
          striped: other.striped ?? striped,
          showColumnResizeHandles:
              other.showColumnResizeHandles ?? showColumnResizeHandles,
          footerPadding: other.footerPadding ?? footerPadding,
          editorStyle:
              editorStyle?.merge(other.editorStyle) ?? other.editorStyle,
          scrollbarTheme: other.scrollbarTheme ?? scrollbarTheme,
          treeIndent: other.treeIndent ?? treeIndent,
          rowHeight: other.rowHeight ?? rowHeight,
          headerHeight: other.headerHeight ?? headerHeight,
          columnWidth: other.columnWidth ?? columnWidth,
          minimumColumnWidth: other.minimumColumnWidth ?? minimumColumnWidth,
          controlColumnWidth: other.controlColumnWidth ?? controlColumnWidth,
          horizontalPadding: other.horizontalPadding ?? horizontalPadding,
          verticalPadding: other.verticalPadding ?? verticalPadding,
          iconSize: other.iconSize ?? iconSize,
          borderWidth: other.borderWidth ?? borderWidth,
          radius: other.radius ?? radius,
          textStyle: textStyle?.merge(other.textStyle) ?? other.textStyle,
          headerTextStyle:
              headerTextStyle?.merge(other.headerTextStyle) ??
              other.headerTextStyle,
          background: other.background ?? background,
          headerBackground: other.headerBackground ?? headerBackground,
          stripeBackground: other.stripeBackground ?? stripeBackground,
          hoverBackground: other.hoverBackground ?? hoverBackground,
          selectedBackground: other.selectedBackground ?? selectedBackground,
          editingBackground: other.editingBackground ?? editingBackground,
          borderColor: other.borderColor ?? borderColor,
          focusColor: other.focusColor ?? focusColor,
          material: other.material ?? material,
          materialQuality: other.materialQuality ?? materialQuality,
          reduceTransparency: other.reduceTransparency ?? reduceTransparency,
          boxShadow: other.boxShadow ?? boxShadow,
          rowBoxShadow: other.rowBoxShadow ?? rowBoxShadow,
          liftBackground: other.liftBackground ?? liftBackground,
          liftRadius: other.liftRadius ?? liftRadius,
          liftBorder: other.liftBorder ?? liftBorder,
          duration: other.duration ?? duration,
          liftDuration: other.liftDuration ?? liftDuration,
          curve: other.curve ?? curve,
        );
  static HyperTableStyle lerp(HyperTableStyle a, HyperTableStyle b, double t) =>
      t == 0
      ? a
      : t == 1
      ? b
      : HyperTableStyle(
          hoverLift: t < .5 ? a.hoverLift : b.hoverLift,
          striped: t < .5 ? a.striped : b.striped,
          showColumnResizeHandles: t < .5
              ? a.showColumnResizeHandles
              : b.showColumnResizeHandles,
          editorStyle: a.editorStyle == null || b.editorStyle == null
              ? (t < .5 ? a.editorStyle : b.editorStyle)
              : HyperTextFieldStyle.lerp(a.editorStyle!, b.editorStyle!, t),
          scrollbarTheme: a.scrollbarTheme == null || b.scrollbarTheme == null
              ? (t < .5 ? a.scrollbarTheme : b.scrollbarTheme)
              : ScrollbarThemeData.lerp(
                  a.scrollbarTheme!,
                  b.scrollbarTheme!,
                  t,
                ),
          treeIndent: lerpDouble(a.treeIndent, b.treeIndent, t),
          rowHeight: lerpDouble(a.rowHeight, b.rowHeight, t),
          headerHeight: lerpDouble(a.headerHeight, b.headerHeight, t),
          columnWidth: lerpDouble(a.columnWidth, b.columnWidth, t),
          minimumColumnWidth: lerpDouble(
            a.minimumColumnWidth,
            b.minimumColumnWidth,
            t,
          ),
          controlColumnWidth: lerpDouble(
            a.controlColumnWidth,
            b.controlColumnWidth,
            t,
          ),
          horizontalPadding: lerpDouble(
            a.horizontalPadding,
            b.horizontalPadding,
            t,
          ),
          verticalPadding: lerpDouble(a.verticalPadding, b.verticalPadding, t),
          iconSize: lerpDouble(a.iconSize, b.iconSize, t),
          borderWidth: lerpDouble(a.borderWidth, b.borderWidth, t),
          radius: lerpDouble(a.radius, b.radius, t),
          textStyle: TextStyle.lerp(a.textStyle, b.textStyle, t),
          headerTextStyle: TextStyle.lerp(
            a.headerTextStyle,
            b.headerTextStyle,
            t,
          ),
          background: Color.lerp(a.background, b.background, t),
          headerBackground: Color.lerp(
            a.headerBackground,
            b.headerBackground,
            t,
          ),
          stripeBackground: Color.lerp(
            a.stripeBackground,
            b.stripeBackground,
            t,
          ),
          hoverBackground: Color.lerp(a.hoverBackground, b.hoverBackground, t),
          selectedBackground: Color.lerp(
            a.selectedBackground,
            b.selectedBackground,
            t,
          ),
          editingBackground: Color.lerp(
            a.editingBackground,
            b.editingBackground,
            t,
          ),
          borderColor: Color.lerp(a.borderColor, b.borderColor, t),
          focusColor: Color.lerp(a.focusColor, b.focusColor, t),
          material: a.material == null || b.material == null
              ? (t < .5 ? a.material : b.material)
              : HyperSurfaceMaterial.lerp(a.material!, b.material!, t),
          materialQuality: t < .5 ? a.materialQuality : b.materialQuality,
          reduceTransparency: t < .5
              ? a.reduceTransparency
              : b.reduceTransparency,
          boxShadow: BoxShadow.lerpList(a.boxShadow, b.boxShadow, t),
          rowBoxShadow: BoxShadow.lerpList(a.rowBoxShadow, b.rowBoxShadow, t),
          footerPadding: EdgeInsetsGeometry.lerp(
            a.footerPadding,
            b.footerPadding,
            t,
          ),
          liftBackground: Color.lerp(a.liftBackground, b.liftBackground, t),
          liftRadius: lerpDouble(a.liftRadius, b.liftRadius, t),
          liftBorder: BorderSide.lerp(
            a.liftBorder ?? BorderSide.none,
            b.liftBorder ?? BorderSide.none,
            t,
          ),
          liftDuration: a.liftDuration == null || b.liftDuration == null
              ? (t < .5 ? a.liftDuration : b.liftDuration)
              : Duration(
                  microseconds:
                      (a.liftDuration!.inMicroseconds +
                              (b.liftDuration!.inMicroseconds -
                                      a.liftDuration!.inMicroseconds) *
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
        );
  @override
  bool operator ==(Object other) =>
      other is HyperTableStyle &&
      hoverLift == other.hoverLift &&
      striped == other.striped &&
      showColumnResizeHandles == other.showColumnResizeHandles &&
      footerPadding == other.footerPadding &&
      editorStyle == other.editorStyle &&
      scrollbarTheme == other.scrollbarTheme &&
      treeIndent == other.treeIndent &&
      rowHeight == other.rowHeight &&
      headerHeight == other.headerHeight &&
      columnWidth == other.columnWidth &&
      minimumColumnWidth == other.minimumColumnWidth &&
      controlColumnWidth == other.controlColumnWidth &&
      horizontalPadding == other.horizontalPadding &&
      verticalPadding == other.verticalPadding &&
      iconSize == other.iconSize &&
      borderWidth == other.borderWidth &&
      radius == other.radius &&
      textStyle == other.textStyle &&
      headerTextStyle == other.headerTextStyle &&
      background == other.background &&
      headerBackground == other.headerBackground &&
      stripeBackground == other.stripeBackground &&
      hoverBackground == other.hoverBackground &&
      selectedBackground == other.selectedBackground &&
      editingBackground == other.editingBackground &&
      borderColor == other.borderColor &&
      focusColor == other.focusColor &&
      material == other.material &&
      materialQuality == other.materialQuality &&
      reduceTransparency == other.reduceTransparency &&
      listEquals(boxShadow, other.boxShadow) &&
      listEquals(rowBoxShadow, other.rowBoxShadow) &&
      liftBackground == other.liftBackground &&
      liftRadius == other.liftRadius &&
      liftBorder == other.liftBorder &&
      duration == other.duration &&
      liftDuration == other.liftDuration &&
      curve == other.curve;
  @override
  int get hashCode => Object.hashAll([
    hoverLift,
    striped,
    showColumnResizeHandles,
    footerPadding,
    editorStyle,
    scrollbarTheme,
    treeIndent,
    rowHeight,
    headerHeight,
    columnWidth,
    minimumColumnWidth,
    controlColumnWidth,
    horizontalPadding,
    verticalPadding,
    iconSize,
    borderWidth,
    radius,
    textStyle,
    headerTextStyle,
    background,
    headerBackground,
    stripeBackground,
    hoverBackground,
    selectedBackground,
    editingBackground,
    borderColor,
    focusColor,
    material,
    materialQuality,
    reduceTransparency,
    boxShadow == null ? null : Object.hashAll(boxShadow!),
    rowBoxShadow == null ? null : Object.hashAll(rowBoxShadow!),
    liftBackground,
    liftRadius,
    liftBorder,
    duration,
    liftDuration,
    curve,
  ]);
}
