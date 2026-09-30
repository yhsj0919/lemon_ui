import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// 徽标视觉覆盖；未指定的字段继承主题与当前设备尺寸。
@immutable
final class HyperBadgeStyle {
  const HyperBadgeStyle({
    this.dotSize,
    this.dotRadius,
    this.contentHeight,
    this.contentRadius,
    this.horizontalPadding,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderWidth,
    this.textStyle,
    this.boxShadow,
    this.duration,
    this.curve,
    this.transitionBuilder,
  });

  final double? dotSize;
  final double? dotRadius;
  final double? contentHeight;
  final double? contentRadius;
  final double? horizontalPadding;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final TextStyle? textStyle;
  final List<BoxShadow>? boxShadow;
  final Duration? duration;
  final Curve? curve;
  final AnimatedSwitcherTransitionBuilder? transitionBuilder;

  HyperBadgeStyle merge(HyperBadgeStyle? other) => other == null
      ? this
      : HyperBadgeStyle(
          dotSize: other.dotSize ?? dotSize,
          dotRadius: other.dotRadius ?? dotRadius,
          contentHeight: other.contentHeight ?? contentHeight,
          contentRadius: other.contentRadius ?? contentRadius,
          horizontalPadding: other.horizontalPadding ?? horizontalPadding,
          backgroundColor: other.backgroundColor ?? backgroundColor,
          foregroundColor: other.foregroundColor ?? foregroundColor,
          borderColor: other.borderColor ?? borderColor,
          borderWidth: other.borderWidth ?? borderWidth,
          textStyle: other.textStyle ?? textStyle,
          boxShadow: other.boxShadow ?? boxShadow,
          duration: other.duration ?? duration,
          curve: other.curve ?? curve,
          transitionBuilder: other.transitionBuilder ?? transitionBuilder,
        );

  static HyperBadgeStyle lerp(HyperBadgeStyle a, HyperBadgeStyle b, double t) =>
      HyperBadgeStyle(
        dotSize: _lerpDouble(a.dotSize, b.dotSize, t),
        dotRadius: _lerpDouble(a.dotRadius, b.dotRadius, t),
        contentHeight: _lerpDouble(a.contentHeight, b.contentHeight, t),
        contentRadius: _lerpDouble(a.contentRadius, b.contentRadius, t),
        horizontalPadding: _lerpDouble(
          a.horizontalPadding,
          b.horizontalPadding,
          t,
        ),
        backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
        foregroundColor: Color.lerp(a.foregroundColor, b.foregroundColor, t),
        borderColor: Color.lerp(a.borderColor, b.borderColor, t),
        borderWidth: _lerpDouble(a.borderWidth, b.borderWidth, t),
        textStyle: TextStyle.lerp(a.textStyle, b.textStyle, t),
        boxShadow: BoxShadow.lerpList(a.boxShadow, b.boxShadow, t),
        duration: t < .5 ? a.duration : b.duration,
        curve: t < .5 ? a.curve : b.curve,
        transitionBuilder: t < .5 ? a.transitionBuilder : b.transitionBuilder,
      );

  static double? _lerpDouble(double? a, double? b, double t) =>
      a == null || b == null ? (t < .5 ? a : b) : a + (b - a) * t;

  @override
  bool operator ==(Object other) =>
      other is HyperBadgeStyle &&
      other.dotSize == dotSize &&
      other.dotRadius == dotRadius &&
      other.contentHeight == contentHeight &&
      other.contentRadius == contentRadius &&
      other.horizontalPadding == horizontalPadding &&
      other.backgroundColor == backgroundColor &&
      other.foregroundColor == foregroundColor &&
      other.borderColor == borderColor &&
      other.borderWidth == borderWidth &&
      other.textStyle == textStyle &&
      listEquals(other.boxShadow, boxShadow) &&
      other.duration == duration &&
      other.curve == curve &&
      other.transitionBuilder == transitionBuilder;

  @override
  int get hashCode => Object.hashAll([
    dotSize,
    dotRadius,
    contentHeight,
    contentRadius,
    horizontalPadding,
    backgroundColor,
    foregroundColor,
    borderColor,
    borderWidth,
    textStyle,
    boxShadow == null ? null : Object.hashAll(boxShadow!),
    duration,
    curve,
    transitionBuilder,
  ]);
}
