import 'package:flutter/foundation.dart';

/// Rating geometry in logical pixels; defaults explicitly requested by the user.
@immutable
final class HyperRatingSize {
  const HyperRatingSize({this.iconSize = 24, this.hitExtent = 32});
  final double iconSize, hitExtent;
  HyperRatingSize copyWith({double? iconSize, double? hitExtent}) =>
      HyperRatingSize(
        iconSize: iconSize ?? this.iconSize,
        hitExtent: hitExtent ?? this.hitExtent,
      );
  static HyperRatingSize lerp(HyperRatingSize a, HyperRatingSize b, double t) =>
      HyperRatingSize(
        iconSize: a.iconSize + (b.iconSize - a.iconSize) * t,
        hitExtent: a.hitExtent + (b.hitExtent - a.hitExtent) * t,
      );
  @override
  bool operator ==(Object other) =>
      other is HyperRatingSize &&
      other.iconSize == iconSize &&
      other.hitExtent == hitExtent;
  @override
  int get hashCode => Object.hash(iconSize, hitExtent);
}
