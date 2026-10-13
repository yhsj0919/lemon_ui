import '../../foundation/hyper_fill.dart';
import '../../foundation/hyper_label_palette.dart';
import '../../painting/hyper_box_decoration.dart';
import '../../theme/color/hyper_color_scheme.dart';
import '../../theme/color/hyper_contrast_theme.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

typedef HyperTagColorVariant = HyperLabelColorVariant;
typedef HyperTagForegroundMode = HyperLabelForegroundMode;

/// 标签自身绘制的视觉与尺寸覆盖。
@immutable
final class HyperTagStyle {
  const HyperTagStyle({
    this.colorVariant,
    this.baseColor,
    this.foregroundMode,
    this.backgroundFade,
    this.borderFade,
    this.foregroundFade,
    this.background,
    this.boxBorder,
    this.height,
    this.horizontalPadding,
    this.radius,
    this.iconSize,
    this.iconSpacing,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderWidth,
    this.boxShadow,
    this.textStyle,
    this.duration,
    this.curve,
  });

  final HyperTagColorVariant? colorVariant;
  final Color? baseColor;
  final HyperTagForegroundMode? foregroundMode;
  final double? backgroundFade;
  final double? borderFade;
  final double? foregroundFade;
  final HyperFill? background;
  final BoxBorder? boxBorder;
  final double? height;
  final double? horizontalPadding;
  final double? radius;
  final double? iconSize;
  final double? iconSpacing;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final List<BoxShadow>? boxShadow;
  final TextStyle? textStyle;
  final Duration? duration;
  final Curve? curve;

  HyperTagStyle copyWith({
    HyperTagColorVariant? colorVariant,
    Color? baseColor,
    HyperTagForegroundMode? foregroundMode,
    double? backgroundFade,
    double? borderFade,
    double? foregroundFade,
    HyperFill? background,
    BoxBorder? boxBorder,
    double? height,
    double? horizontalPadding,
    double? radius,
    double? iconSize,
    double? iconSpacing,
    Color? backgroundColor,
    Color? foregroundColor,
    Color? borderColor,
    double? borderWidth,
    List<BoxShadow>? boxShadow,
    TextStyle? textStyle,
    Duration? duration,
    Curve? curve,
  }) => merge(
    HyperTagStyle(
      colorVariant: colorVariant,
      baseColor: baseColor,
      foregroundMode: foregroundMode,
      backgroundFade: backgroundFade,
      borderFade: borderFade,
      foregroundFade: foregroundFade,
      background: background,
      boxBorder: boxBorder,
      height: height,
      horizontalPadding: horizontalPadding,
      radius: radius,
      iconSize: iconSize,
      iconSpacing: iconSpacing,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      borderColor: borderColor,
      borderWidth: borderWidth,
      boxShadow: boxShadow,
      textStyle: textStyle,
      duration: duration,
      curve: curve,
    ),
  );

  HyperTagStyle resolvePalette(
    HyperColorScheme colors,
    HyperContrastThemeData contrast,
  ) {
    final palette = resolveHyperLabelPalette(
      colors: colors,
      contrast: contrast,
      colorVariant: colorVariant,
      baseColor: baseColor,
      foregroundMode: foregroundMode,
      backgroundFade: backgroundFade,
      borderFade: borderFade,
      foregroundFade: foregroundFade,
    );
    if (palette == null) return this;
    return HyperTagStyle(
      background: backgroundColor == null
          ? palette.background
          : HyperFill.color(backgroundColor!),
      foregroundColor: palette.foregroundColor,
      borderColor: palette.borderColor,
      borderWidth: palette.borderWidth,
    ).merge(this);
  }

  HyperTagStyle merge(HyperTagStyle? other) => other == null
      ? this
      : HyperTagStyle(
          colorVariant: other.colorVariant ?? colorVariant,
          baseColor: other.baseColor ?? baseColor,
          foregroundMode: other.foregroundMode ?? foregroundMode,
          backgroundFade: other.backgroundFade ?? backgroundFade,
          borderFade: other.borderFade ?? borderFade,
          foregroundFade: other.foregroundFade ?? foregroundFade,
          background:
              other.background ??
              (other.backgroundColor == null
                  ? background
                  : HyperFill.color(other.backgroundColor!)),
          boxBorder: other.boxBorder ?? boxBorder,
          height: other.height ?? height,
          horizontalPadding: other.horizontalPadding ?? horizontalPadding,
          radius: other.radius ?? radius,
          iconSize: other.iconSize ?? iconSize,
          iconSpacing: other.iconSpacing ?? iconSpacing,
          backgroundColor: other.backgroundColor ?? backgroundColor,
          foregroundColor: other.foregroundColor ?? foregroundColor,
          borderColor: other.borderColor ?? borderColor,
          borderWidth: other.borderWidth ?? borderWidth,
          boxShadow: other.boxShadow ?? boxShadow,
          textStyle: other.textStyle ?? textStyle,
          duration: other.duration ?? duration,
          curve: other.curve ?? curve,
        );

  static HyperTagStyle lerp(HyperTagStyle a, HyperTagStyle b, double t) {
    double? number(double? x, double? y) =>
        x == null || y == null ? (t < .5 ? x : y) : x + (y - x) * t;
    return HyperTagStyle(
      colorVariant: t < .5 ? a.colorVariant : b.colorVariant,
      baseColor: Color.lerp(a.baseColor, b.baseColor, t),
      foregroundMode: t < .5 ? a.foregroundMode : b.foregroundMode,
      backgroundFade: number(a.backgroundFade, b.backgroundFade),
      borderFade: number(a.borderFade, b.borderFade),
      foregroundFade: number(a.foregroundFade, b.foregroundFade),
      background: a.background == null || b.background == null
          ? (t < .5 ? a.background : b.background)
          : HyperFill.lerp(a.background!, b.background!, t),
      boxBorder: lerpHyperBoxBorder(a.boxBorder, b.boxBorder, t),
      height: number(a.height, b.height),
      horizontalPadding: number(a.horizontalPadding, b.horizontalPadding),
      radius: number(a.radius, b.radius),
      iconSize: number(a.iconSize, b.iconSize),
      iconSpacing: number(a.iconSpacing, b.iconSpacing),
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      foregroundColor: Color.lerp(a.foregroundColor, b.foregroundColor, t),
      borderColor: Color.lerp(a.borderColor, b.borderColor, t),
      borderWidth: number(a.borderWidth, b.borderWidth),
      boxShadow: BoxShadow.lerpList(a.boxShadow, b.boxShadow, t),
      textStyle: TextStyle.lerp(a.textStyle, b.textStyle, t),
      duration: t < .5 ? a.duration : b.duration,
      curve: t < .5 ? a.curve : b.curve,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is HyperTagStyle &&
      other.colorVariant == colorVariant &&
      other.baseColor == baseColor &&
      other.foregroundMode == foregroundMode &&
      other.backgroundFade == backgroundFade &&
      other.borderFade == borderFade &&
      other.foregroundFade == foregroundFade &&
      other.background == background &&
      other.boxBorder == boxBorder &&
      other.height == height &&
      other.horizontalPadding == horizontalPadding &&
      other.radius == radius &&
      other.iconSize == iconSize &&
      other.iconSpacing == iconSpacing &&
      other.backgroundColor == backgroundColor &&
      other.foregroundColor == foregroundColor &&
      other.borderColor == borderColor &&
      other.borderWidth == borderWidth &&
      listEquals(other.boxShadow, boxShadow) &&
      other.textStyle == textStyle &&
      other.duration == duration &&
      other.curve == curve;

  @override
  int get hashCode => Object.hashAll([
    colorVariant,
    baseColor,
    foregroundMode,
    backgroundFade,
    borderFade,
    foregroundFade,
    background,
    boxBorder,
    height,
    horizontalPadding,
    radius,
    iconSize,
    iconSpacing,
    backgroundColor,
    foregroundColor,
    borderColor,
    borderWidth,
    boxShadow == null ? null : Object.hashAll(boxShadow!),
    textStyle,
    duration,
    curve,
  ]);
}
