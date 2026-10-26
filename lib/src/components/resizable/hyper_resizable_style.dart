import 'package:flutter/material.dart';

/// Explicit visual overrides. Unspecified geometry inherits current semantic sizes.
@immutable
final class HyperResizableStyle {
  const HyperResizableStyle({
    this.handleExtent,
    this.thickness,
    this.gripSize,
    this.gripBackground,
    this.handleColor,
    this.activeColor,
    this.focusColor,
    this.duration,
    this.curve,
  });
  final double? handleExtent;
  final double? thickness;
  final double? gripSize;
  final Color? gripBackground;
  final Color? handleColor;
  final Color? activeColor;
  final Color? focusColor;
  final Duration? duration;
  final Curve? curve;
  HyperResizableStyle copyWith({
    double? handleExtent,
    double? thickness,
    double? gripSize,
    Color? gripBackground,
    Color? handleColor,
    Color? activeColor,
    Color? focusColor,
    Duration? duration,
    Curve? curve,
  }) => merge(
    HyperResizableStyle(
      handleExtent: handleExtent,
      thickness: thickness,
      gripSize: gripSize,
      gripBackground: gripBackground,
      handleColor: handleColor,
      activeColor: activeColor,
      focusColor: focusColor,
      duration: duration,
      curve: curve,
    ),
  );
  HyperResizableStyle merge(HyperResizableStyle? other) => other == null
      ? this
      : HyperResizableStyle(
          handleExtent: other.handleExtent ?? handleExtent,
          thickness: other.thickness ?? thickness,
          gripSize: other.gripSize ?? gripSize,
          gripBackground: other.gripBackground ?? gripBackground,
          handleColor: other.handleColor ?? handleColor,
          activeColor: other.activeColor ?? activeColor,
          focusColor: other.focusColor ?? focusColor,
          duration: other.duration ?? duration,
          curve: other.curve ?? curve,
        );
  static HyperResizableStyle lerp(
    HyperResizableStyle a,
    HyperResizableStyle b,
    double t,
  ) => HyperResizableStyle(
    handleExtent: a.handleExtent == null || b.handleExtent == null
        ? (t < .5 ? a.handleExtent : b.handleExtent)
        : a.handleExtent! + (b.handleExtent! - a.handleExtent!) * t,
    gripBackground: Color.lerp(a.gripBackground, b.gripBackground, t),
    gripSize: a.gripSize == null || b.gripSize == null
        ? (t < .5 ? a.gripSize : b.gripSize)
        : a.gripSize! + (b.gripSize! - a.gripSize!) * t,
    thickness: a.thickness == null || b.thickness == null
        ? (t < .5 ? a.thickness : b.thickness)
        : a.thickness! + (b.thickness! - a.thickness!) * t,
    handleColor: Color.lerp(a.handleColor, b.handleColor, t),
    activeColor: Color.lerp(a.activeColor, b.activeColor, t),
    focusColor: Color.lerp(a.focusColor, b.focusColor, t),
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
      other is HyperResizableStyle &&
      other.handleExtent == handleExtent &&
      other.thickness == thickness &&
      other.gripSize == gripSize &&
      other.gripBackground == gripBackground &&
      other.handleColor == handleColor &&
      other.activeColor == activeColor &&
      other.focusColor == focusColor &&
      other.duration == duration &&
      other.curve == curve;
  @override
  int get hashCode => Object.hashAll([
    handleExtent,
    thickness,
    gripSize,
    gripBackground,
    handleColor,
    activeColor,
    focusColor,
    duration,
    curve,
  ]);
}
