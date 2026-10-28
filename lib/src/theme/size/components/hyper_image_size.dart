import 'package:flutter/foundation.dart';

@immutable
final class HyperImageSize {
  const HyperImageSize({
    required this.iconSize,
    required this.progressSize,
    required this.progressThickness,
    required this.spacing,
    required this.padding,
    required this.radius,
  });
  final double iconSize,
      progressSize,
      progressThickness,
      spacing,
      padding,
      radius;
  HyperImageSize copyWith({
    double? iconSize,
    double? progressSize,
    double? progressThickness,
    double? spacing,
    double? padding,
    double? radius,
  }) => HyperImageSize(
    iconSize: iconSize ?? this.iconSize,
    progressSize: progressSize ?? this.progressSize,
    progressThickness: progressThickness ?? this.progressThickness,
    spacing: spacing ?? this.spacing,
    padding: padding ?? this.padding,
    radius: radius ?? this.radius,
  );
  static HyperImageSize lerp(HyperImageSize a, HyperImageSize b, double t) =>
      HyperImageSize(
        iconSize: a.iconSize + (b.iconSize - a.iconSize) * t,
        progressSize: a.progressSize + (b.progressSize - a.progressSize) * t,
        progressThickness:
            a.progressThickness +
            (b.progressThickness - a.progressThickness) * t,
        spacing: a.spacing + (b.spacing - a.spacing) * t,
        padding: a.padding + (b.padding - a.padding) * t,
        radius: a.radius + (b.radius - a.radius) * t,
      );
  @override
  bool operator ==(Object other) =>
      other is HyperImageSize &&
      iconSize == other.iconSize &&
      progressSize == other.progressSize &&
      progressThickness == other.progressThickness &&
      spacing == other.spacing &&
      padding == other.padding &&
      radius == other.radius;
  @override
  int get hashCode => Object.hash(
    iconSize,
    progressSize,
    progressThickness,
    spacing,
    padding,
    radius,
  );
}
