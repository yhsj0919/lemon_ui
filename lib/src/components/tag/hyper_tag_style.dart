import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// 标签自身绘制的视觉与尺寸覆盖。
@immutable
final class HyperTagStyle {
  const HyperTagStyle({
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

  HyperTagStyle merge(HyperTagStyle? other) => other == null
      ? this
      : HyperTagStyle(
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
