import 'package:flutter/material.dart';

import '../slider/hyper_slider_style.dart';
import '../text_field/hyper_text_field_style.dart';

@immutable
final class HyperColorPickerStyle {
  const HyperColorPickerStyle({
    this.centerRadiusFraction,
    this.pureColorRadiusFraction,
    this.hueSnapDegrees,
    this.endpointSnapThreshold,
    this.width,
    this.paletteHeight,
    this.radius,
    this.spacing,
    this.markerRadius,
    this.previewHeight,
    this.checkerLightColor,
    this.checkerDarkColor,
    this.markerColor,
    this.paletteBorder,
    this.sliderStyle,
    this.fieldStyle,
  });
  final double? centerRadiusFraction;
  final double? pureColorRadiusFraction;
  final double? hueSnapDegrees;
  final double? endpointSnapThreshold;
  final double? width;
  final double? paletteHeight;
  final double? radius;
  final double? spacing;
  final double? markerRadius;
  final double? previewHeight;
  final Color? checkerLightColor;
  final Color? checkerDarkColor;
  final Color? markerColor;
  final BorderSide? paletteBorder;
  final HyperSliderStyle? sliderStyle;
  final HyperTextFieldStyle? fieldStyle;
  HyperColorPickerStyle copyWith({
    double? centerRadiusFraction,
    double? pureColorRadiusFraction,
    double? hueSnapDegrees,
    double? endpointSnapThreshold,
    double? width,
    double? paletteHeight,
    double? radius,
    double? spacing,
    double? markerRadius,
    double? previewHeight,
    Color? checkerLightColor,
    Color? checkerDarkColor,
    Color? markerColor,
    BorderSide? paletteBorder,
    HyperSliderStyle? sliderStyle,
    HyperTextFieldStyle? fieldStyle,
  }) => merge(
    HyperColorPickerStyle(
      centerRadiusFraction: centerRadiusFraction,
      pureColorRadiusFraction: pureColorRadiusFraction,
      hueSnapDegrees: hueSnapDegrees,
      endpointSnapThreshold: endpointSnapThreshold,
      width: width,
      paletteHeight: paletteHeight,
      radius: radius,
      spacing: spacing,
      markerRadius: markerRadius,
      previewHeight: previewHeight,
      checkerLightColor: checkerLightColor,
      checkerDarkColor: checkerDarkColor,
      markerColor: markerColor,
      paletteBorder: paletteBorder,
      sliderStyle: sliderStyle,
      fieldStyle: fieldStyle,
    ),
  );
  HyperColorPickerStyle merge(HyperColorPickerStyle? other) {
    if (other == null) return this;
    return HyperColorPickerStyle(
      centerRadiusFraction: other.centerRadiusFraction ?? centerRadiusFraction,
      pureColorRadiusFraction:
          other.pureColorRadiusFraction ?? pureColorRadiusFraction,
      hueSnapDegrees: other.hueSnapDegrees ?? hueSnapDegrees,
      endpointSnapThreshold:
          other.endpointSnapThreshold ?? endpointSnapThreshold,
      width: other.width ?? width,
      paletteHeight: other.paletteHeight ?? paletteHeight,
      radius: other.radius ?? radius,
      spacing: other.spacing ?? spacing,
      markerRadius: other.markerRadius ?? markerRadius,
      previewHeight: other.previewHeight ?? previewHeight,
      checkerLightColor: other.checkerLightColor ?? checkerLightColor,
      checkerDarkColor: other.checkerDarkColor ?? checkerDarkColor,
      markerColor: other.markerColor ?? markerColor,
      paletteBorder: other.paletteBorder ?? paletteBorder,
      sliderStyle: sliderStyle?.merge(other.sliderStyle) ?? other.sliderStyle,
      fieldStyle: fieldStyle?.merge(other.fieldStyle) ?? other.fieldStyle,
    );
  }

  static HyperColorPickerStyle lerp(
    HyperColorPickerStyle a,
    HyperColorPickerStyle b,
    double t,
  ) => HyperColorPickerStyle(
    centerRadiusFraction:
        a.centerRadiusFraction == null || b.centerRadiusFraction == null
        ? (t < .5 ? a.centerRadiusFraction : b.centerRadiusFraction)
        : a.centerRadiusFraction! +
              (b.centerRadiusFraction! - a.centerRadiusFraction!) * t,
    pureColorRadiusFraction:
        a.pureColorRadiusFraction == null || b.pureColorRadiusFraction == null
        ? (t < .5 ? a.pureColorRadiusFraction : b.pureColorRadiusFraction)
        : a.pureColorRadiusFraction! +
              (b.pureColorRadiusFraction! - a.pureColorRadiusFraction!) * t,
    hueSnapDegrees: a.hueSnapDegrees == null || b.hueSnapDegrees == null
        ? (t < .5 ? a.hueSnapDegrees : b.hueSnapDegrees)
        : a.hueSnapDegrees! + (b.hueSnapDegrees! - a.hueSnapDegrees!) * t,
    endpointSnapThreshold:
        a.endpointSnapThreshold == null || b.endpointSnapThreshold == null
        ? (t < .5 ? a.endpointSnapThreshold : b.endpointSnapThreshold)
        : a.endpointSnapThreshold! +
              (b.endpointSnapThreshold! - a.endpointSnapThreshold!) * t,
    width: a.width == null || b.width == null
        ? (t < .5 ? a.width : b.width)
        : a.width! + (b.width! - a.width!) * t,
    paletteHeight: a.paletteHeight == null || b.paletteHeight == null
        ? (t < .5 ? a.paletteHeight : b.paletteHeight)
        : a.paletteHeight! + (b.paletteHeight! - a.paletteHeight!) * t,
    radius: a.radius == null || b.radius == null
        ? (t < .5 ? a.radius : b.radius)
        : a.radius! + (b.radius! - a.radius!) * t,
    spacing: a.spacing == null || b.spacing == null
        ? (t < .5 ? a.spacing : b.spacing)
        : a.spacing! + (b.spacing! - a.spacing!) * t,
    markerRadius: a.markerRadius == null || b.markerRadius == null
        ? (t < .5 ? a.markerRadius : b.markerRadius)
        : a.markerRadius! + (b.markerRadius! - a.markerRadius!) * t,
    previewHeight: a.previewHeight == null || b.previewHeight == null
        ? (t < .5 ? a.previewHeight : b.previewHeight)
        : a.previewHeight! + (b.previewHeight! - a.previewHeight!) * t,
    checkerLightColor:
        a.checkerLightColor == null || b.checkerLightColor == null
        ? (t < .5 ? a.checkerLightColor : b.checkerLightColor)
        : Color.lerp(a.checkerLightColor, b.checkerLightColor, t),
    checkerDarkColor: a.checkerDarkColor == null || b.checkerDarkColor == null
        ? (t < .5 ? a.checkerDarkColor : b.checkerDarkColor)
        : Color.lerp(a.checkerDarkColor, b.checkerDarkColor, t),
    markerColor: a.markerColor == null || b.markerColor == null
        ? (t < .5 ? a.markerColor : b.markerColor)
        : Color.lerp(a.markerColor!, b.markerColor!, t),
    paletteBorder: a.paletteBorder == null || b.paletteBorder == null
        ? (t < .5 ? a.paletteBorder : b.paletteBorder)
        : BorderSide.lerp(a.paletteBorder!, b.paletteBorder!, t),
    sliderStyle: a.sliderStyle == null || b.sliderStyle == null
        ? (t < .5 ? a.sliderStyle : b.sliderStyle)
        : HyperSliderStyle.lerp(a.sliderStyle!, b.sliderStyle!, t),
    fieldStyle: a.fieldStyle == null || b.fieldStyle == null
        ? (t < .5 ? a.fieldStyle : b.fieldStyle)
        : HyperTextFieldStyle.lerp(a.fieldStyle!, b.fieldStyle!, t),
  );
  @override
  bool operator ==(Object other) =>
      other is HyperColorPickerStyle &&
      other.centerRadiusFraction == centerRadiusFraction &&
      other.pureColorRadiusFraction == pureColorRadiusFraction &&
      other.hueSnapDegrees == hueSnapDegrees &&
      other.endpointSnapThreshold == endpointSnapThreshold &&
      other.width == width &&
      other.paletteHeight == paletteHeight &&
      other.radius == radius &&
      other.spacing == spacing &&
      other.markerRadius == markerRadius &&
      other.previewHeight == previewHeight &&
      other.checkerLightColor == checkerLightColor &&
      other.checkerDarkColor == checkerDarkColor &&
      other.markerColor == markerColor &&
      other.paletteBorder == paletteBorder &&
      other.sliderStyle == sliderStyle &&
      other.fieldStyle == fieldStyle;
  @override
  int get hashCode => Object.hashAll([
    centerRadiusFraction,
    pureColorRadiusFraction,
    hueSnapDegrees,
    endpointSnapThreshold,
    width,
    paletteHeight,
    radius,
    spacing,
    markerRadius,
    previewHeight,
    checkerLightColor,
    checkerDarkColor,
    markerColor,
    paletteBorder,
    sliderStyle,
    fieldStyle,
  ]);
}
