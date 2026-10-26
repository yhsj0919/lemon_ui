import 'package:flutter/material.dart';

/// Explicit visual overrides. Unspecified geometry inherits current semantic sizes.
@immutable
final class HyperRatingStyle {
  const HyperRatingStyle({
    this.iconSize,
    this.gap,
    this.hitExtent,
    this.activeColor,
    this.inactiveColor,
    this.disabledColor,
    this.hoverColor,
    this.focusColor,
    this.icon,
    this.duration,
    this.curve,
  });
  final double? iconSize;
  final double? gap;
  /// Perpendicular hit dimension; does not add space between visible stars.
  final double? hitExtent;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? disabledColor;
  final Color? hoverColor;
  final Color? focusColor;
  final IconData? icon;
  final Duration? duration;
  final Curve? curve;
  HyperRatingStyle copyWith({
    double? iconSize,
    double? gap,
    double? hitExtent,
    Color? activeColor,
    Color? inactiveColor,
    Color? disabledColor,
    Color? hoverColor,
    Color? focusColor,
    IconData? icon,
    Duration? duration,
    Curve? curve,
  }) => merge(
    HyperRatingStyle(
      iconSize: iconSize,
      gap: gap,
      hitExtent: hitExtent,
      activeColor: activeColor,
      inactiveColor: inactiveColor,
      disabledColor: disabledColor,
      hoverColor: hoverColor,
      focusColor: focusColor,
      icon: icon,
      duration: duration,
      curve: curve,
    ),
  );
  HyperRatingStyle merge(HyperRatingStyle? other) => other == null
      ? this
      : HyperRatingStyle(
          iconSize: other.iconSize ?? iconSize,
          gap: other.gap ?? gap,
          hitExtent: other.hitExtent ?? hitExtent,
          activeColor: other.activeColor ?? activeColor,
          inactiveColor: other.inactiveColor ?? inactiveColor,
          disabledColor: other.disabledColor ?? disabledColor,
          hoverColor: other.hoverColor ?? hoverColor,
          focusColor: other.focusColor ?? focusColor,
          icon: other.icon ?? icon,
          duration: other.duration ?? duration,
          curve: other.curve ?? curve,
        );
  static HyperRatingStyle lerp(
    HyperRatingStyle a,
    HyperRatingStyle b,
    double t,
  ) => HyperRatingStyle(
    iconSize: a.iconSize == null || b.iconSize == null
        ? (t < .5 ? a.iconSize : b.iconSize)
        : a.iconSize! + (b.iconSize! - a.iconSize!) * t,
    gap: a.gap == null || b.gap == null
        ? (t < .5 ? a.gap : b.gap)
        : a.gap! + (b.gap! - a.gap!) * t,
    hitExtent: a.hitExtent == null || b.hitExtent == null
        ? (t < .5 ? a.hitExtent : b.hitExtent)
        : a.hitExtent! + (b.hitExtent! - a.hitExtent!) * t,
    activeColor: Color.lerp(a.activeColor, b.activeColor, t),
    inactiveColor: Color.lerp(a.inactiveColor, b.inactiveColor, t),
    disabledColor: Color.lerp(a.disabledColor, b.disabledColor, t),
    hoverColor: Color.lerp(a.hoverColor, b.hoverColor, t),
    focusColor: Color.lerp(a.focusColor, b.focusColor, t),
    icon: t < .5 ? a.icon : b.icon,
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
      other is HyperRatingStyle &&
      other.iconSize == iconSize &&
      other.gap == gap &&
      other.hitExtent == hitExtent &&
      other.activeColor == activeColor &&
      other.inactiveColor == inactiveColor &&
      other.disabledColor == disabledColor &&
      other.hoverColor == hoverColor &&
      other.focusColor == focusColor &&
      other.icon == icon &&
      other.duration == duration &&
      other.curve == curve;
  @override
  int get hashCode => Object.hashAll([
    iconSize,
    gap,
    hitExtent,
    activeColor,
    inactiveColor,
    disabledColor,
    hoverColor,
    focusColor,
    icon,
    duration,
    curve,
  ]);
}
