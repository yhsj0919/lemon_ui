import 'package:flutter/widgets.dart';

/// Per-device lift geometry. Initial offsets follow the requested legacy effect.
@immutable
final class HyperLiftSize {
  const HyperLiftSize({
    required this.hoverOffset,
    required this.pressedOffset,
    required this.shadowRadius,
  });
  final Offset hoverOffset, pressedOffset;
  final double shadowRadius;
  HyperLiftSize copyWith({
    Offset? hoverOffset,
    Offset? pressedOffset,
    double? shadowRadius,
  }) => HyperLiftSize(
    hoverOffset: hoverOffset ?? this.hoverOffset,
    pressedOffset: pressedOffset ?? this.pressedOffset,
    shadowRadius: shadowRadius ?? this.shadowRadius,
  );
  static HyperLiftSize lerp(HyperLiftSize a, HyperLiftSize b, double t) =>
      HyperLiftSize(
        hoverOffset: Offset.lerp(a.hoverOffset, b.hoverOffset, t)!,
        pressedOffset: Offset.lerp(a.pressedOffset, b.pressedOffset, t)!,
        shadowRadius: a.shadowRadius + (b.shadowRadius - a.shadowRadius) * t,
      );
  @override
  bool operator ==(Object other) =>
      other is HyperLiftSize &&
      hoverOffset == other.hoverOffset &&
      pressedOffset == other.pressedOffset &&
      shadowRadius == other.shadowRadius;
  @override
  int get hashCode => Object.hash(hoverOffset, pressedOffset, shadowRadius);
}
