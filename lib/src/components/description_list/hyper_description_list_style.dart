import 'package:flutter/material.dart';

import '../../foundation/hyper_fill.dart';
import '../../foundation/hyper_surface_material.dart';

enum HyperDescriptionContentHeightMode { auto, maximum, fixed }

@immutable
final class HyperDescriptionListStyle {
  const HyperDescriptionListStyle({
    this.background,
    this.labelBackground,
    this.valueBackground,
    this.material,
    this.materialQuality,
    this.reduceTransparency,
    this.borderColor,
    this.borderThickness,
    this.borderRadius,
    this.cellPadding,
    this.columnSpacing,
    this.rowSpacing,
    this.labelValueSpacing,
    this.labelAlign,
    this.valueAlign,
    this.contentHeight,
    this.contentHeightMode,
    this.minimumColumnWidth,
    this.labelWidth,
    this.labelFlex,
    this.valueFlex,
    this.labelStyle,
    this.valueStyle,
    this.placeholder,
    this.duration,
    this.curve,
    this.transitionBuilder,
  });
  final HyperFill? background;
  final HyperFill? labelBackground;
  final HyperFill? valueBackground;
  final HyperSurfaceMaterial? material;
  final HyperMaterialQuality? materialQuality;
  final bool? reduceTransparency;
  final Color? borderColor;
  final double? borderThickness;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? cellPadding;
  final double? columnSpacing;
  final double? rowSpacing;
  final double? labelValueSpacing;
  final TextAlign? labelAlign;
  final TextAlign? valueAlign;
  final double? contentHeight;
  final HyperDescriptionContentHeightMode? contentHeightMode;
  final double? minimumColumnWidth;
  final double? labelWidth;
  final int? labelFlex;
  final int? valueFlex;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  final String? placeholder;
  final Duration? duration;
  final Curve? curve;
  final AnimatedSwitcherTransitionBuilder? transitionBuilder;
  HyperDescriptionListStyle copyWith({
    HyperFill? background,
    HyperFill? labelBackground,
    HyperFill? valueBackground,
    HyperSurfaceMaterial? material,
    HyperMaterialQuality? materialQuality,
    bool? reduceTransparency,
    Color? borderColor,
    double? borderThickness,
    BorderRadiusGeometry? borderRadius,
    EdgeInsetsGeometry? cellPadding,
    double? columnSpacing,
    double? rowSpacing,
    double? labelValueSpacing,
    TextAlign? labelAlign,
    TextAlign? valueAlign,
    double? contentHeight,
    HyperDescriptionContentHeightMode? contentHeightMode,
    double? minimumColumnWidth,
    double? labelWidth,
    int? labelFlex,
    int? valueFlex,
    TextStyle? labelStyle,
    TextStyle? valueStyle,
    String? placeholder,
    Duration? duration,
    Curve? curve,
    AnimatedSwitcherTransitionBuilder? transitionBuilder,
  }) => HyperDescriptionListStyle(
    background: background ?? this.background,
    labelBackground: labelBackground ?? this.labelBackground,
    valueBackground: valueBackground ?? this.valueBackground,
    material: material ?? this.material,
    materialQuality: materialQuality ?? this.materialQuality,
    reduceTransparency: reduceTransparency ?? this.reduceTransparency,
    borderColor: borderColor ?? this.borderColor,
    borderThickness: borderThickness ?? this.borderThickness,
    borderRadius: borderRadius ?? this.borderRadius,
    cellPadding: cellPadding ?? this.cellPadding,
    columnSpacing: columnSpacing ?? this.columnSpacing,
    rowSpacing: rowSpacing ?? this.rowSpacing,
    labelValueSpacing: labelValueSpacing ?? this.labelValueSpacing,
    labelAlign: labelAlign ?? this.labelAlign,
    valueAlign: valueAlign ?? this.valueAlign,
    contentHeight: contentHeight ?? this.contentHeight,
    contentHeightMode: contentHeightMode ?? this.contentHeightMode,
    minimumColumnWidth: minimumColumnWidth ?? this.minimumColumnWidth,
    labelWidth: labelWidth ?? this.labelWidth,
    labelFlex: labelFlex ?? this.labelFlex,
    valueFlex: valueFlex ?? this.valueFlex,
    labelStyle: labelStyle ?? this.labelStyle,
    valueStyle: valueStyle ?? this.valueStyle,
    placeholder: placeholder ?? this.placeholder,
    duration: duration ?? this.duration,
    curve: curve ?? this.curve,
    transitionBuilder: transitionBuilder ?? this.transitionBuilder,
  );
  HyperDescriptionListStyle merge(HyperDescriptionListStyle? other) =>
      other == null
      ? this
      : HyperDescriptionListStyle(
          background: other.background ?? background,
          labelBackground: other.labelBackground ?? labelBackground,
          valueBackground: other.valueBackground ?? valueBackground,
          material: other.material ?? material,
          materialQuality: other.materialQuality ?? materialQuality,
          reduceTransparency: other.reduceTransparency ?? reduceTransparency,
          borderColor: other.borderColor ?? borderColor,
          borderThickness: other.borderThickness ?? borderThickness,
          borderRadius: other.borderRadius ?? borderRadius,
          cellPadding: other.cellPadding ?? cellPadding,
          columnSpacing: other.columnSpacing ?? columnSpacing,
          rowSpacing: other.rowSpacing ?? rowSpacing,
          labelValueSpacing: other.labelValueSpacing ?? labelValueSpacing,
          labelAlign: other.labelAlign ?? labelAlign,
          valueAlign: other.valueAlign ?? valueAlign,
          contentHeight: other.contentHeight ?? contentHeight,
          contentHeightMode: other.contentHeightMode ?? contentHeightMode,
          minimumColumnWidth: other.minimumColumnWidth ?? minimumColumnWidth,
          labelWidth: other.labelWidth ?? labelWidth,
          labelFlex: other.labelFlex ?? labelFlex,
          valueFlex: other.valueFlex ?? valueFlex,
          labelStyle: labelStyle?.merge(other.labelStyle) ?? other.labelStyle,
          valueStyle: valueStyle?.merge(other.valueStyle) ?? other.valueStyle,
          placeholder: other.placeholder ?? placeholder,
          duration: other.duration ?? duration,
          curve: other.curve ?? curve,
          transitionBuilder: other.transitionBuilder ?? transitionBuilder,
        );
  static HyperDescriptionListStyle lerp(
    HyperDescriptionListStyle a,
    HyperDescriptionListStyle b,
    double t,
  ) {
    if (t == 0) {
      return a;
    }
    if (t == 1) {
      return b;
    }
    return HyperDescriptionListStyle(
      background: a.background == null || b.background == null
          ? (t < .5 ? a.background : b.background)
          : HyperFill.lerp(a.background!, b.background!, t),
      labelBackground: a.labelBackground == null || b.labelBackground == null
          ? (t < .5 ? a.labelBackground : b.labelBackground)
          : HyperFill.lerp(a.labelBackground!, b.labelBackground!, t),
      valueBackground: a.valueBackground == null || b.valueBackground == null
          ? (t < .5 ? a.valueBackground : b.valueBackground)
          : HyperFill.lerp(a.valueBackground!, b.valueBackground!, t),
      material: a.material == null || b.material == null
          ? (t < .5 ? a.material : b.material)
          : HyperSurfaceMaterial.lerp(a.material!, b.material!, t),
      materialQuality: t < .5 ? a.materialQuality : b.materialQuality,
      reduceTransparency: t < .5 ? a.reduceTransparency : b.reduceTransparency,
      borderColor: Color.lerp(a.borderColor, b.borderColor, t),
      borderThickness: a.borderThickness == null || b.borderThickness == null
          ? (t < .5 ? a.borderThickness : b.borderThickness)
          : a.borderThickness! + (b.borderThickness! - a.borderThickness!) * t,
      borderRadius: BorderRadiusGeometry.lerp(
        a.borderRadius,
        b.borderRadius,
        t,
      ),
      cellPadding: EdgeInsetsGeometry.lerp(a.cellPadding, b.cellPadding, t),
      columnSpacing: a.columnSpacing == null || b.columnSpacing == null
          ? (t < .5 ? a.columnSpacing : b.columnSpacing)
          : a.columnSpacing! + (b.columnSpacing! - a.columnSpacing!) * t,
      rowSpacing: a.rowSpacing == null || b.rowSpacing == null
          ? (t < .5 ? a.rowSpacing : b.rowSpacing)
          : a.rowSpacing! + (b.rowSpacing! - a.rowSpacing!) * t,
      labelValueSpacing:
          a.labelValueSpacing == null || b.labelValueSpacing == null
          ? (t < .5 ? a.labelValueSpacing : b.labelValueSpacing)
          : a.labelValueSpacing! +
                (b.labelValueSpacing! - a.labelValueSpacing!) * t,
      labelAlign: t < .5 ? a.labelAlign : b.labelAlign,
      valueAlign: t < .5 ? a.valueAlign : b.valueAlign,
      contentHeight: a.contentHeight == null || b.contentHeight == null
          ? (t < .5 ? a.contentHeight : b.contentHeight)
          : a.contentHeight! + (b.contentHeight! - a.contentHeight!) * t,
      contentHeightMode: t < .5 ? a.contentHeightMode : b.contentHeightMode,
      minimumColumnWidth:
          a.minimumColumnWidth == null || b.minimumColumnWidth == null
          ? (t < .5 ? a.minimumColumnWidth : b.minimumColumnWidth)
          : a.minimumColumnWidth! +
                (b.minimumColumnWidth! - a.minimumColumnWidth!) * t,
      labelWidth: a.labelWidth == null || b.labelWidth == null
          ? (t < .5 ? a.labelWidth : b.labelWidth)
          : a.labelWidth! + (b.labelWidth! - a.labelWidth!) * t,
      labelFlex: t < .5 ? a.labelFlex : b.labelFlex,
      valueFlex: t < .5 ? a.valueFlex : b.valueFlex,
      labelStyle: TextStyle.lerp(a.labelStyle, b.labelStyle, t),
      valueStyle: TextStyle.lerp(a.valueStyle, b.valueStyle, t),
      placeholder: t < .5 ? a.placeholder : b.placeholder,
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
      other is HyperDescriptionListStyle &&
      background == other.background &&
      labelBackground == other.labelBackground &&
      valueBackground == other.valueBackground &&
      material == other.material &&
      materialQuality == other.materialQuality &&
      reduceTransparency == other.reduceTransparency &&
      borderColor == other.borderColor &&
      borderThickness == other.borderThickness &&
      borderRadius == other.borderRadius &&
      cellPadding == other.cellPadding &&
      columnSpacing == other.columnSpacing &&
      rowSpacing == other.rowSpacing &&
      labelValueSpacing == other.labelValueSpacing &&
      labelAlign == other.labelAlign &&
      valueAlign == other.valueAlign &&
      contentHeight == other.contentHeight &&
      contentHeightMode == other.contentHeightMode &&
      minimumColumnWidth == other.minimumColumnWidth &&
      labelWidth == other.labelWidth &&
      labelFlex == other.labelFlex &&
      valueFlex == other.valueFlex &&
      labelStyle == other.labelStyle &&
      valueStyle == other.valueStyle &&
      placeholder == other.placeholder &&
      duration == other.duration &&
      curve == other.curve &&
      transitionBuilder == other.transitionBuilder;
  @override
  int get hashCode => Object.hashAll([
    background,
    labelBackground,
    valueBackground,
    material,
    materialQuality,
    reduceTransparency,
    borderColor,
    borderThickness,
    borderRadius,
    cellPadding,
    columnSpacing,
    rowSpacing,
    labelValueSpacing,
    labelAlign,
    valueAlign,
    contentHeight,
    contentHeightMode,
    minimumColumnWidth,
    labelWidth,
    labelFlex,
    valueFlex,
    labelStyle,
    valueStyle,
    placeholder,
    duration,
    curve,
    transitionBuilder,
  ]);
}
