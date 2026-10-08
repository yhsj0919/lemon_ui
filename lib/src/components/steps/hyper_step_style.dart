import 'package:flutter/material.dart';

import '../../foundation/hyper_fill.dart';
import '../../foundation/hyper_surface_material.dart';

@immutable
final class HyperStepStyle {
  const HyperStepStyle({
    this.nodeFill,
    this.material,
    this.materialQuality,
    this.reduceTransparency,
    this.nodeBorder,
    this.nodeBorderRadius,
    this.foregroundColor,
    this.titleStyle,
    this.descriptionStyle,
    this.indexStyle,
    this.connectorColor,
    this.connectorThickness,
    this.nodeSize,
    this.iconSize,
    this.spacing,
    this.titleSpacing,
    this.itemSpacing,
    this.statusLabel,
    this.completedIcon,
    this.errorIcon,
    this.overlayColor,
    this.hoverOpacity,
    this.focusOpacity,
    this.pressedOpacity,
    this.interactionRadius,
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
  final Color? foregroundColor;
  final TextStyle? titleStyle;
  final TextStyle? descriptionStyle;
  final TextStyle? indexStyle;
  final Color? connectorColor;
  final double? connectorThickness;
  final double? nodeSize;
  final double? iconSize;
  final double? spacing;
  final double? titleSpacing;
  final double? itemSpacing;
  final String? statusLabel;
  final IconData? completedIcon;
  final IconData? errorIcon;
  final Color? overlayColor;
  final double? hoverOpacity;
  final double? focusOpacity;
  final double? pressedOpacity;
  final BorderRadiusGeometry? interactionRadius;
  final Duration? duration;
  final Curve? curve;
  final AnimatedSwitcherTransitionBuilder? transitionBuilder;
  HyperStepStyle copyWith({
    HyperFill? nodeFill,
    HyperSurfaceMaterial? material,
    HyperMaterialQuality? materialQuality,
    bool? reduceTransparency,
    BorderSide? nodeBorder,
    BorderRadiusGeometry? nodeBorderRadius,
    Color? foregroundColor,
    TextStyle? titleStyle,
    TextStyle? descriptionStyle,
    TextStyle? indexStyle,
    Color? connectorColor,
    double? connectorThickness,
    double? nodeSize,
    double? iconSize,
    double? spacing,
    double? titleSpacing,
    double? itemSpacing,
    String? statusLabel,
    IconData? completedIcon,
    IconData? errorIcon,
    Color? overlayColor,
    double? hoverOpacity,
    double? focusOpacity,
    double? pressedOpacity,
    BorderRadiusGeometry? interactionRadius,
    Duration? duration,
    Curve? curve,
    AnimatedSwitcherTransitionBuilder? transitionBuilder,
  }) => HyperStepStyle(
    nodeFill: nodeFill ?? this.nodeFill,
    material: material ?? this.material,
    materialQuality: materialQuality ?? this.materialQuality,
    reduceTransparency: reduceTransparency ?? this.reduceTransparency,
    nodeBorder: nodeBorder ?? this.nodeBorder,
    nodeBorderRadius: nodeBorderRadius ?? this.nodeBorderRadius,
    foregroundColor: foregroundColor ?? this.foregroundColor,
    titleStyle: titleStyle ?? this.titleStyle,
    descriptionStyle: descriptionStyle ?? this.descriptionStyle,
    indexStyle: indexStyle ?? this.indexStyle,
    connectorColor: connectorColor ?? this.connectorColor,
    connectorThickness: connectorThickness ?? this.connectorThickness,
    nodeSize: nodeSize ?? this.nodeSize,
    iconSize: iconSize ?? this.iconSize,
    spacing: spacing ?? this.spacing,
    titleSpacing: titleSpacing ?? this.titleSpacing,
    itemSpacing: itemSpacing ?? this.itemSpacing,
    statusLabel: statusLabel ?? this.statusLabel,
    completedIcon: completedIcon ?? this.completedIcon,
    errorIcon: errorIcon ?? this.errorIcon,
    overlayColor: overlayColor ?? this.overlayColor,
    hoverOpacity: hoverOpacity ?? this.hoverOpacity,
    focusOpacity: focusOpacity ?? this.focusOpacity,
    pressedOpacity: pressedOpacity ?? this.pressedOpacity,
    interactionRadius: interactionRadius ?? this.interactionRadius,
    duration: duration ?? this.duration,
    curve: curve ?? this.curve,
    transitionBuilder: transitionBuilder ?? this.transitionBuilder,
  );
  HyperStepStyle merge(HyperStepStyle? other) => other == null
      ? this
      : HyperStepStyle(
          nodeFill: other.nodeFill ?? nodeFill,
          material: other.material ?? material,
          materialQuality: other.materialQuality ?? materialQuality,
          reduceTransparency: other.reduceTransparency ?? reduceTransparency,
          nodeBorder: other.nodeBorder ?? nodeBorder,
          nodeBorderRadius: other.nodeBorderRadius ?? nodeBorderRadius,
          foregroundColor: other.foregroundColor ?? foregroundColor,
          titleStyle: titleStyle?.merge(other.titleStyle) ?? other.titleStyle,
          descriptionStyle:
              descriptionStyle?.merge(other.descriptionStyle) ??
              other.descriptionStyle,
          indexStyle: indexStyle?.merge(other.indexStyle) ?? other.indexStyle,
          connectorColor: other.connectorColor ?? connectorColor,
          connectorThickness: other.connectorThickness ?? connectorThickness,
          nodeSize: other.nodeSize ?? nodeSize,
          iconSize: other.iconSize ?? iconSize,
          spacing: other.spacing ?? spacing,
          titleSpacing: other.titleSpacing ?? titleSpacing,
          itemSpacing: other.itemSpacing ?? itemSpacing,
          statusLabel: other.statusLabel ?? statusLabel,
          completedIcon: other.completedIcon ?? completedIcon,
          errorIcon: other.errorIcon ?? errorIcon,
          overlayColor: other.overlayColor ?? overlayColor,
          hoverOpacity: other.hoverOpacity ?? hoverOpacity,
          focusOpacity: other.focusOpacity ?? focusOpacity,
          pressedOpacity: other.pressedOpacity ?? pressedOpacity,
          interactionRadius: other.interactionRadius ?? interactionRadius,
          duration: other.duration ?? duration,
          curve: other.curve ?? curve,
          transitionBuilder: other.transitionBuilder ?? transitionBuilder,
        );
  static HyperStepStyle lerp(HyperStepStyle a, HyperStepStyle b, double t) {
    if (t == 0) {
      return a;
    }
    if (t == 1) {
      return b;
    }
    return HyperStepStyle(
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
      foregroundColor: Color.lerp(a.foregroundColor, b.foregroundColor, t),
      titleStyle: TextStyle.lerp(a.titleStyle, b.titleStyle, t),
      descriptionStyle: TextStyle.lerp(
        a.descriptionStyle,
        b.descriptionStyle,
        t,
      ),
      indexStyle: TextStyle.lerp(a.indexStyle, b.indexStyle, t),
      connectorColor: Color.lerp(a.connectorColor, b.connectorColor, t),
      connectorThickness:
          a.connectorThickness == null || b.connectorThickness == null
          ? (t < .5 ? a.connectorThickness : b.connectorThickness)
          : a.connectorThickness! +
                (b.connectorThickness! - a.connectorThickness!) * t,
      nodeSize: a.nodeSize == null || b.nodeSize == null
          ? (t < .5 ? a.nodeSize : b.nodeSize)
          : a.nodeSize! + (b.nodeSize! - a.nodeSize!) * t,
      iconSize: a.iconSize == null || b.iconSize == null
          ? (t < .5 ? a.iconSize : b.iconSize)
          : a.iconSize! + (b.iconSize! - a.iconSize!) * t,
      spacing: a.spacing == null || b.spacing == null
          ? (t < .5 ? a.spacing : b.spacing)
          : a.spacing! + (b.spacing! - a.spacing!) * t,
      titleSpacing: a.titleSpacing == null || b.titleSpacing == null
          ? (t < .5 ? a.titleSpacing : b.titleSpacing)
          : a.titleSpacing! + (b.titleSpacing! - a.titleSpacing!) * t,
      itemSpacing: a.itemSpacing == null || b.itemSpacing == null
          ? (t < .5 ? a.itemSpacing : b.itemSpacing)
          : a.itemSpacing! + (b.itemSpacing! - a.itemSpacing!) * t,
      statusLabel: t < .5 ? a.statusLabel : b.statusLabel,
      completedIcon: t < .5 ? a.completedIcon : b.completedIcon,
      errorIcon: t < .5 ? a.errorIcon : b.errorIcon,
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
      interactionRadius: BorderRadiusGeometry.lerp(
        a.interactionRadius,
        b.interactionRadius,
        t,
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
      other is HyperStepStyle &&
      nodeFill == other.nodeFill &&
      material == other.material &&
      materialQuality == other.materialQuality &&
      reduceTransparency == other.reduceTransparency &&
      nodeBorder == other.nodeBorder &&
      nodeBorderRadius == other.nodeBorderRadius &&
      foregroundColor == other.foregroundColor &&
      titleStyle == other.titleStyle &&
      descriptionStyle == other.descriptionStyle &&
      indexStyle == other.indexStyle &&
      connectorColor == other.connectorColor &&
      connectorThickness == other.connectorThickness &&
      nodeSize == other.nodeSize &&
      iconSize == other.iconSize &&
      spacing == other.spacing &&
      titleSpacing == other.titleSpacing &&
      itemSpacing == other.itemSpacing &&
      statusLabel == other.statusLabel &&
      completedIcon == other.completedIcon &&
      errorIcon == other.errorIcon &&
      overlayColor == other.overlayColor &&
      hoverOpacity == other.hoverOpacity &&
      focusOpacity == other.focusOpacity &&
      pressedOpacity == other.pressedOpacity &&
      interactionRadius == other.interactionRadius &&
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
    foregroundColor,
    titleStyle,
    descriptionStyle,
    indexStyle,
    connectorColor,
    connectorThickness,
    nodeSize,
    iconSize,
    spacing,
    titleSpacing,
    itemSpacing,
    statusLabel,
    completedIcon,
    errorIcon,
    overlayColor,
    hoverOpacity,
    focusOpacity,
    pressedOpacity,
    interactionRadius,
    duration,
    curve,
    transitionBuilder,
  ]);
}
