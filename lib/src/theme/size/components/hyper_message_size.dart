import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

@immutable
final class HyperMessageSize {
  const HyperMessageSize({
    required this.maxWidth,
    required this.radius,
    required this.padding,
    required this.iconSize,
    required this.spacing,
  });
  final double maxWidth;
  final double radius;
  final EdgeInsetsGeometry padding;
  final double iconSize;
  final double spacing;
  HyperMessageSize copyWith({
    double? maxWidth,
    double? radius,
    EdgeInsetsGeometry? padding,
    double? iconSize,
    double? spacing,
  }) => HyperMessageSize(
    maxWidth: maxWidth ?? this.maxWidth,
    radius: radius ?? this.radius,
    padding: padding ?? this.padding,
    iconSize: iconSize ?? this.iconSize,
    spacing: spacing ?? this.spacing,
  );
  static HyperMessageSize lerp(
    HyperMessageSize a,
    HyperMessageSize b,
    double t,
  ) => HyperMessageSize(
    maxWidth: a.maxWidth + (b.maxWidth - a.maxWidth) * t,
    radius: a.radius + (b.radius - a.radius) * t,
    padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t)!,
    iconSize: a.iconSize + (b.iconSize - a.iconSize) * t,
    spacing: a.spacing + (b.spacing - a.spacing) * t,
  );
  @override
  bool operator ==(Object other) =>
      other is HyperMessageSize &&
      maxWidth == other.maxWidth &&
      radius == other.radius &&
      padding == other.padding &&
      iconSize == other.iconSize &&
      spacing == other.spacing;
  @override
  int get hashCode => Object.hash(maxWidth, radius, padding, iconSize, spacing);
}
