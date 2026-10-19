import 'package:flutter/foundation.dart';

@immutable
final class HyperCalendarSize {
  const HyperCalendarSize({
    this.dayMinHeight = 32,
    this.width = 280,
    this.spacing = 4,
    this.radius = 6,
    this.selectionSize,
  });
  final double dayMinHeight;
  final double width;
  final double spacing;
  final double radius;
  final double? selectionSize;
  HyperCalendarSize copyWith({
    double? dayMinHeight,
    double? width,
    double? spacing,
    double? radius,
    double? selectionSize,
  }) => HyperCalendarSize(
    dayMinHeight: dayMinHeight ?? this.dayMinHeight,
    width: width ?? this.width,
    spacing: spacing ?? this.spacing,
    radius: radius ?? this.radius,
    selectionSize: selectionSize ?? this.selectionSize,
  );
  static HyperCalendarSize lerp(
    HyperCalendarSize a,
    HyperCalendarSize b,
    double t,
  ) => HyperCalendarSize(
    dayMinHeight: a.dayMinHeight + (b.dayMinHeight - a.dayMinHeight) * t,
    width: a.width + (b.width - a.width) * t,
    spacing: a.spacing + (b.spacing - a.spacing) * t,
    radius: a.radius + (b.radius - a.radius) * t,
    selectionSize: a.selectionSize == null || b.selectionSize == null
        ? (t < .5 ? a.selectionSize : b.selectionSize)
        : a.selectionSize! + (b.selectionSize! - a.selectionSize!) * t,
  );
  @override
  bool operator ==(Object other) =>
      other is HyperCalendarSize &&
      other.dayMinHeight == dayMinHeight &&
      other.width == width &&
      other.spacing == spacing &&
      other.radius == radius &&
      other.selectionSize == selectionSize;
  @override
  int get hashCode =>
      Object.hash(dayMinHeight, width, spacing, radius, selectionSize);
}
