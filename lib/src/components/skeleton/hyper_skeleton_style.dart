import 'package:flutter/foundation.dart';

import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

enum HyperSkeletonEffect { shimmer, pulse, none }

typedef HyperSkeletonEffectBuilder = Widget Function(
  BuildContext context,
  Widget child,
  double progress,
);

@immutable
final class HyperSkeletonStyle {
  const HyperSkeletonStyle({
    this.backgroundColor,
    this.highlightColor,
    this.borderColor,
    this.borderWidth,
    this.radius,
    this.width,
    this.height,
    this.circleSize,
    this.boxShadow,
    this.effect,
    this.duration,
    this.curve,
    this.shimmerWidth,
    this.shimmerAngle,
    this.pulseMinOpacity,
    this.transitionDuration,
    this.transitionBuilder,
    this.effectBuilder,
  });
  final Color? backgroundColor;
  final Color? highlightColor;
  final Color? borderColor;
  final double? borderWidth;
  final double? radius;
  final double? width;
  final double? height;
  final double? circleSize;
  final List<BoxShadow>? boxShadow;
  final HyperSkeletonEffect? effect;
  final Duration? duration;
  final Curve? curve;
  final double? shimmerWidth;
  final double? shimmerAngle;
  final double? pulseMinOpacity;
  final Duration? transitionDuration;
  final AnimatedSwitcherTransitionBuilder? transitionBuilder;
  final HyperSkeletonEffectBuilder? effectBuilder;
  HyperSkeletonStyle copyWith({
    Color? backgroundColor,
    Color? highlightColor,
    Color? borderColor,
    double? borderWidth,
    double? radius,
    double? width,
    double? height,
    double? circleSize,
    List<BoxShadow>? boxShadow,
    HyperSkeletonEffect? effect,
    Duration? duration,
    Curve? curve,
    double? shimmerWidth,
    double? shimmerAngle,
    double? pulseMinOpacity,
    Duration? transitionDuration,
    AnimatedSwitcherTransitionBuilder? transitionBuilder,
    HyperSkeletonEffectBuilder? effectBuilder,
  }) => merge(
    HyperSkeletonStyle(
      backgroundColor: backgroundColor,
      highlightColor: highlightColor,
      borderColor: borderColor,
      borderWidth: borderWidth,
      radius: radius,
      width: width,
      height: height,
      circleSize: circleSize,
      boxShadow: boxShadow,
      effect: effect,
      duration: duration,
      curve: curve,
      shimmerWidth: shimmerWidth,
      shimmerAngle: shimmerAngle,
      pulseMinOpacity: pulseMinOpacity,
      transitionDuration: transitionDuration,
      transitionBuilder: transitionBuilder,
      effectBuilder: effectBuilder,
    ),
  );
  HyperSkeletonStyle merge(HyperSkeletonStyle? other) => other == null
      ? this
      : HyperSkeletonStyle(
          backgroundColor: other.backgroundColor ?? backgroundColor,
          highlightColor: other.highlightColor ?? highlightColor,
          borderColor: other.borderColor ?? borderColor,
          borderWidth: other.borderWidth ?? borderWidth,
          radius: other.radius ?? radius,
          width: other.width ?? width,
          height: other.height ?? height,
          circleSize: other.circleSize ?? circleSize,
          boxShadow: other.boxShadow ?? boxShadow,
          effect: other.effect ?? effect,
          duration: other.duration ?? duration,
          curve: other.curve ?? curve,
          shimmerWidth: other.shimmerWidth ?? shimmerWidth,
          shimmerAngle: other.shimmerAngle ?? shimmerAngle,
          pulseMinOpacity: other.pulseMinOpacity ?? pulseMinOpacity,
          transitionDuration: other.transitionDuration ?? transitionDuration,
          transitionBuilder: other.transitionBuilder ?? transitionBuilder,
          effectBuilder: other.effectBuilder ?? effectBuilder,
        );
  static HyperSkeletonStyle lerp(
    HyperSkeletonStyle a,
    HyperSkeletonStyle b,
    double t,
  ) => t == 0 || a == b
      ? a
      : t == 1
      ? b
      : HyperSkeletonStyle(
          backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
          highlightColor: Color.lerp(a.highlightColor, b.highlightColor, t),
          borderColor: Color.lerp(a.borderColor, b.borderColor, t),
          borderWidth: lerpDouble(a.borderWidth, b.borderWidth, t),
          radius: lerpDouble(a.radius, b.radius, t),
          width: lerpDouble(a.width, b.width, t),
          height: lerpDouble(a.height, b.height, t),
          circleSize: lerpDouble(a.circleSize, b.circleSize, t),
          boxShadow: BoxShadow.lerpList(a.boxShadow, b.boxShadow, t),
          effect: t < .5 ? a.effect : b.effect,
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
          shimmerWidth: lerpDouble(a.shimmerWidth, b.shimmerWidth, t),
          shimmerAngle: lerpDouble(a.shimmerAngle, b.shimmerAngle, t),
          pulseMinOpacity: lerpDouble(a.pulseMinOpacity, b.pulseMinOpacity, t),
          transitionDuration:
              a.transitionDuration == null || b.transitionDuration == null
              ? (t < .5 ? a.transitionDuration : b.transitionDuration)
              : Duration(
                  microseconds:
                      (a.transitionDuration!.inMicroseconds +
                              (b.transitionDuration!.inMicroseconds -
                                      a.transitionDuration!.inMicroseconds) *
                                  t)
                          .round(),
                ),
          transitionBuilder: t < .5 ? a.transitionBuilder : b.transitionBuilder,
          effectBuilder: t < .5 ? a.effectBuilder : b.effectBuilder,
        );
  @override
  bool operator ==(Object other) =>
      other is HyperSkeletonStyle &&
      other.backgroundColor == backgroundColor &&
      other.highlightColor == highlightColor &&
      other.borderColor == borderColor &&
      other.borderWidth == borderWidth &&
      other.radius == radius &&
      other.width == width &&
      other.height == height &&
      other.circleSize == circleSize &&
      listEquals(other.boxShadow, boxShadow) &&
      other.effect == effect &&
      other.duration == duration &&
      other.curve == curve &&
      other.shimmerWidth == shimmerWidth &&
      other.shimmerAngle == shimmerAngle &&
      other.pulseMinOpacity == pulseMinOpacity &&
      other.transitionDuration == transitionDuration &&
      other.transitionBuilder == transitionBuilder &&
      other.effectBuilder == effectBuilder;
  @override
  int get hashCode => Object.hashAll([
    backgroundColor,
    highlightColor,
    borderColor,
    borderWidth,
    radius,
    width,
    height,
    circleSize,
    boxShadow == null ? null : Object.hashAll(boxShadow!),
    effect,
    duration,
    curve,
    shimmerWidth,
    shimmerAngle,
    pulseMinOpacity,
    transitionDuration,
    transitionBuilder,
    effectBuilder,
  ]);
}
