import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Explicit overrides for [HyperMotion.lift]'s visual states and timing.
@immutable
final class HyperLiftStyle {
  const HyperLiftStyle({
    this.surface,
    this.showShadow,
    this.hoverOffset,
    this.pressedOffset,
    this.hoverScale,
    this.pressedScale,
    this.hoverShadows,
    this.pressedShadows,
    this.shadowRadius,
    this.duration,
    this.pressDuration,
    this.curve,
    this.alignment,
  });
  final Offset? hoverOffset, pressedOffset;

  /// Whether the lift wrapper paints a shadow surface around its bounds.
  final bool? surface;

  /// Overrides the legacy [surface] setting for the wrapper shadow.
  final bool? showShadow;
  final double? hoverScale, pressedScale, shadowRadius;
  final List<BoxShadow>? hoverShadows, pressedShadows;
  final Duration? duration, pressDuration;
  final Curve? curve;
  final AlignmentGeometry? alignment;

  HyperLiftStyle copyWith({
    bool? surface,
    bool? showShadow,
    Offset? hoverOffset,
    Offset? pressedOffset,
    double? hoverScale,
    double? pressedScale,
    List<BoxShadow>? hoverShadows,
    List<BoxShadow>? pressedShadows,
    double? shadowRadius,
    Duration? duration,
    Duration? pressDuration,
    Curve? curve,
    AlignmentGeometry? alignment,
  }) => HyperLiftStyle(
    surface: surface ?? this.surface,
    showShadow: showShadow ?? this.showShadow,
    hoverOffset: hoverOffset ?? this.hoverOffset,
    pressedOffset: pressedOffset ?? this.pressedOffset,
    hoverScale: hoverScale ?? this.hoverScale,
    pressedScale: pressedScale ?? this.pressedScale,
    hoverShadows: hoverShadows ?? this.hoverShadows,
    pressedShadows: pressedShadows ?? this.pressedShadows,
    shadowRadius: shadowRadius ?? this.shadowRadius,
    duration: duration ?? this.duration,
    pressDuration: pressDuration ?? this.pressDuration,
    curve: curve ?? this.curve,
    alignment: alignment ?? this.alignment,
  );
  HyperLiftStyle merge(HyperLiftStyle? other) => other == null
      ? this
      : copyWith(
          surface: other.surface,
          showShadow: other.showShadow,
          hoverOffset: other.hoverOffset,
          pressedOffset: other.pressedOffset,
          hoverScale: other.hoverScale,
          pressedScale: other.pressedScale,
          hoverShadows: other.hoverShadows,
          pressedShadows: other.pressedShadows,
          shadowRadius: other.shadowRadius,
          duration: other.duration,
          pressDuration: other.pressDuration,
          curve: other.curve,
          alignment: other.alignment,
        );
  static HyperLiftStyle lerp(HyperLiftStyle a, HyperLiftStyle b, double t) {
    double? number(double? x, double? y) =>
        x == null || y == null ? (t < .5 ? x : y) : x + (y - x) * t;
    Duration? time(Duration? x, Duration? y) => x == null || y == null
        ? (t < .5 ? x : y)
        : Duration(
            microseconds:
                (x.inMicroseconds + (y.inMicroseconds - x.inMicroseconds) * t)
                    .round(),
          );
    return HyperLiftStyle(
      surface: t < .5 ? a.surface : b.surface,
      showShadow: t < .5 ? a.showShadow : b.showShadow,
      hoverOffset: a.hoverOffset == null || b.hoverOffset == null
          ? (t < .5 ? a.hoverOffset : b.hoverOffset)
          : Offset.lerp(a.hoverOffset, b.hoverOffset, t),
      pressedOffset: a.pressedOffset == null || b.pressedOffset == null
          ? (t < .5 ? a.pressedOffset : b.pressedOffset)
          : Offset.lerp(a.pressedOffset, b.pressedOffset, t),
      hoverScale: number(a.hoverScale, b.hoverScale),
      pressedScale: number(a.pressedScale, b.pressedScale),
      shadowRadius: number(a.shadowRadius, b.shadowRadius),
      hoverShadows: BoxShadow.lerpList(a.hoverShadows, b.hoverShadows, t),
      pressedShadows: BoxShadow.lerpList(a.pressedShadows, b.pressedShadows, t),
      duration: time(a.duration, b.duration),
      pressDuration: time(a.pressDuration, b.pressDuration),
      curve: t < .5 ? a.curve : b.curve,
      alignment: a.alignment == null || b.alignment == null
          ? (t < .5 ? a.alignment : b.alignment)
          : AlignmentGeometry.lerp(a.alignment, b.alignment, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is HyperLiftStyle &&
      surface == other.surface &&
      showShadow == other.showShadow &&
      hoverOffset == other.hoverOffset &&
      pressedOffset == other.pressedOffset &&
      hoverScale == other.hoverScale &&
      pressedScale == other.pressedScale &&
      listEquals(hoverShadows, other.hoverShadows) &&
      listEquals(pressedShadows, other.pressedShadows) &&
      shadowRadius == other.shadowRadius &&
      duration == other.duration &&
      pressDuration == other.pressDuration &&
      curve == other.curve &&
      alignment == other.alignment;
  @override
  int get hashCode => Object.hash(
    surface,
    showShadow,
    hoverOffset,
    pressedOffset,
    hoverScale,
    pressedScale,
    hoverShadows == null ? null : Object.hashAll(hoverShadows!),
    pressedShadows == null ? null : Object.hashAll(pressedShadows!),
    shadowRadius,
    duration,
    pressDuration,
    curve,
    alignment,
  );
}
