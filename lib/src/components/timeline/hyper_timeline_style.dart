import 'package:flutter/material.dart';

import '../../foundation/hyper_fill.dart';
import '../../foundation/hyper_surface_material.dart';

@immutable
final class HyperTimelineStyle {
  const HyperTimelineStyle({
    this.nodeFill,
    this.material,
    this.materialQuality,
    this.reduceTransparency,
    this.nodeBorder,
    this.nodeBorderRadius,
    this.nodeSize,
    this.iconSize,
    this.nodeForeground,
    this.lineColor,
    this.lineThickness,
    this.spacing,
    this.itemSpacing,
    this.textSpacing,
    this.timeStyle,
    this.titleStyle,
    this.contentStyle,
    this.duration,
    this.curve,
    this.transitionBuilder,
  });
  final HyperFill? nodeFill;
  final HyperSurfaceMaterial? material;
  final HyperMaterialQuality? materialQuality;
  final bool? reduceTransparency;
  final BorderSide? nodeBorder;
  final BorderRadiusGeometry? nodeBorderRadius;
  final double? nodeSize;
  final double? iconSize;
  final Color? nodeForeground;
  final Color? lineColor;
  final double? lineThickness;
  final double? spacing;
  final double? itemSpacing;
  final double? textSpacing;
  final TextStyle? timeStyle;
  final TextStyle? titleStyle;
  final TextStyle? contentStyle;
  final Duration? duration;
  final Curve? curve;
  final AnimatedSwitcherTransitionBuilder? transitionBuilder;
  HyperTimelineStyle copyWith({
    HyperFill? nodeFill,
    HyperSurfaceMaterial? material,
    HyperMaterialQuality? materialQuality,
    bool? reduceTransparency,
    BorderSide? nodeBorder,
    BorderRadiusGeometry? nodeBorderRadius,
    double? nodeSize,
    double? iconSize,
    Color? nodeForeground,
    Color? lineColor,
    double? lineThickness,
    double? spacing,
    double? itemSpacing,
    double? textSpacing,
    TextStyle? timeStyle,
    TextStyle? titleStyle,
    TextStyle? contentStyle,
    Duration? duration,
    Curve? curve,
    AnimatedSwitcherTransitionBuilder? transitionBuilder,
  }) => HyperTimelineStyle(
    nodeFill: nodeFill ?? this.nodeFill,
    material: material ?? this.material,
    materialQuality: materialQuality ?? this.materialQuality,
    reduceTransparency: reduceTransparency ?? this.reduceTransparency,
    nodeBorder: nodeBorder ?? this.nodeBorder,
    nodeBorderRadius: nodeBorderRadius ?? this.nodeBorderRadius,
    nodeSize: nodeSize ?? this.nodeSize,
    iconSize: iconSize ?? this.iconSize,
    nodeForeground: nodeForeground ?? this.nodeForeground,
    lineColor: lineColor ?? this.lineColor,
    lineThickness: lineThickness ?? this.lineThickness,
    spacing: spacing ?? this.spacing,
    itemSpacing: itemSpacing ?? this.itemSpacing,
    textSpacing: textSpacing ?? this.textSpacing,
    timeStyle: timeStyle ?? this.timeStyle,
    titleStyle: titleStyle ?? this.titleStyle,
    contentStyle: contentStyle ?? this.contentStyle,
    duration: duration ?? this.duration,
    curve: curve ?? this.curve,
    transitionBuilder: transitionBuilder ?? this.transitionBuilder,
  );
  HyperTimelineStyle merge(HyperTimelineStyle? other) => other == null
      ? this
      : HyperTimelineStyle(
          nodeFill: other.nodeFill ?? nodeFill,
          material: other.material ?? material,
          materialQuality: other.materialQuality ?? materialQuality,
          reduceTransparency: other.reduceTransparency ?? reduceTransparency,
          nodeBorder: other.nodeBorder ?? nodeBorder,
          nodeBorderRadius: other.nodeBorderRadius ?? nodeBorderRadius,
          nodeSize: other.nodeSize ?? nodeSize,
          iconSize: other.iconSize ?? iconSize,
          nodeForeground: other.nodeForeground ?? nodeForeground,
          lineColor: other.lineColor ?? lineColor,
          lineThickness: other.lineThickness ?? lineThickness,
          spacing: other.spacing ?? spacing,
          itemSpacing: other.itemSpacing ?? itemSpacing,
          textSpacing: other.textSpacing ?? textSpacing,
          timeStyle: timeStyle?.merge(other.timeStyle) ?? other.timeStyle,
          titleStyle: titleStyle?.merge(other.titleStyle) ?? other.titleStyle,
          contentStyle:
              contentStyle?.merge(other.contentStyle) ?? other.contentStyle,
          duration: other.duration ?? duration,
          curve: other.curve ?? curve,
          transitionBuilder: other.transitionBuilder ?? transitionBuilder,
        );
  static HyperTimelineStyle lerp(
    HyperTimelineStyle a,
    HyperTimelineStyle b,
    double t,
  ) {
    if (t == 0) {
      return a;
    }
    if (t == 1) {
      return b;
    }
    return HyperTimelineStyle(
      nodeFill: a.nodeFill == null || b.nodeFill == null
          ? (t < .5 ? a.nodeFill : b.nodeFill)
          : HyperFill.lerp(a.nodeFill!, b.nodeFill!, t),
      material: a.material == null || b.material == null
          ? (t < .5 ? a.material : b.material)
          : HyperSurfaceMaterial.lerp(a.material!, b.material!, t),
      materialQuality: t < .5 ? a.materialQuality : b.materialQuality,
      reduceTransparency: t < .5 ? a.reduceTransparency : b.reduceTransparency,
      nodeBorder: a.nodeBorder == null || b.nodeBorder == null
          ? (t < .5 ? a.nodeBorder : b.nodeBorder)
          : BorderSide.lerp(a.nodeBorder!, b.nodeBorder!, t),
      nodeBorderRadius: BorderRadiusGeometry.lerp(
        a.nodeBorderRadius,
        b.nodeBorderRadius,
        t,
      ),
      nodeSize: a.nodeSize == null || b.nodeSize == null
          ? (t < .5 ? a.nodeSize : b.nodeSize)
          : a.nodeSize! + (b.nodeSize! - a.nodeSize!) * t,
      iconSize: a.iconSize == null || b.iconSize == null
          ? (t < .5 ? a.iconSize : b.iconSize)
          : a.iconSize! + (b.iconSize! - a.iconSize!) * t,
      nodeForeground: Color.lerp(a.nodeForeground, b.nodeForeground, t),
      lineColor: Color.lerp(a.lineColor, b.lineColor, t),
      lineThickness: a.lineThickness == null || b.lineThickness == null
          ? (t < .5 ? a.lineThickness : b.lineThickness)
          : a.lineThickness! + (b.lineThickness! - a.lineThickness!) * t,
      spacing: a.spacing == null || b.spacing == null
          ? (t < .5 ? a.spacing : b.spacing)
          : a.spacing! + (b.spacing! - a.spacing!) * t,
      itemSpacing: a.itemSpacing == null || b.itemSpacing == null
          ? (t < .5 ? a.itemSpacing : b.itemSpacing)
          : a.itemSpacing! + (b.itemSpacing! - a.itemSpacing!) * t,
      textSpacing: a.textSpacing == null || b.textSpacing == null
          ? (t < .5 ? a.textSpacing : b.textSpacing)
          : a.textSpacing! + (b.textSpacing! - a.textSpacing!) * t,
      timeStyle: TextStyle.lerp(a.timeStyle, b.timeStyle, t),
      titleStyle: TextStyle.lerp(a.titleStyle, b.titleStyle, t),
      contentStyle: TextStyle.lerp(a.contentStyle, b.contentStyle, t),
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
      other is HyperTimelineStyle &&
      nodeFill == other.nodeFill &&
      material == other.material &&
      materialQuality == other.materialQuality &&
      reduceTransparency == other.reduceTransparency &&
      nodeBorder == other.nodeBorder &&
      nodeBorderRadius == other.nodeBorderRadius &&
      nodeSize == other.nodeSize &&
      iconSize == other.iconSize &&
      nodeForeground == other.nodeForeground &&
      lineColor == other.lineColor &&
      lineThickness == other.lineThickness &&
      spacing == other.spacing &&
      itemSpacing == other.itemSpacing &&
      textSpacing == other.textSpacing &&
      timeStyle == other.timeStyle &&
      titleStyle == other.titleStyle &&
      contentStyle == other.contentStyle &&
      duration == other.duration &&
      curve == other.curve &&
      transitionBuilder == other.transitionBuilder;
  @override
  int get hashCode => Object.hashAll([
    nodeFill,
    material,
    materialQuality,
    reduceTransparency,
    nodeBorder,
    nodeBorderRadius,
    nodeSize,
    iconSize,
    nodeForeground,
    lineColor,
    lineThickness,
    spacing,
    itemSpacing,
    textSpacing,
    timeStyle,
    titleStyle,
    contentStyle,
    duration,
    curve,
    transitionBuilder,
  ]);
}
