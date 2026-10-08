import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

@immutable
final class HyperLoadingOverlaySize {
  const HyperLoadingOverlaySize({
    required this.radius,
    required this.padding,
    required this.maxContentWidth,
    required this.spacing,
  });
  final double radius;
  final EdgeInsetsGeometry padding;
  final double maxContentWidth;
  final double spacing;
  HyperLoadingOverlaySize copyWith({
    double? radius,
    EdgeInsetsGeometry? padding,
    double? maxContentWidth,
    double? spacing,
  }) => HyperLoadingOverlaySize(
    radius: radius ?? this.radius,
    padding: padding ?? this.padding,
    maxContentWidth: maxContentWidth ?? this.maxContentWidth,
    spacing: spacing ?? this.spacing,
  );
  static HyperLoadingOverlaySize lerp(
    HyperLoadingOverlaySize a,
    HyperLoadingOverlaySize b,
    double t,
  ) => HyperLoadingOverlaySize(
    radius: a.radius + (b.radius - a.radius) * t,
    padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t)!,
    maxContentWidth:
        a.maxContentWidth + (b.maxContentWidth - a.maxContentWidth) * t,
    spacing: a.spacing + (b.spacing - a.spacing) * t,
  );
  @override
  bool operator ==(Object other) =>
      other is HyperLoadingOverlaySize &&
      radius == other.radius &&
      padding == other.padding &&
      maxContentWidth == other.maxContentWidth &&
      spacing == other.spacing;
  @override
  int get hashCode => Object.hash(radius, padding, maxContentWidth, spacing);
}
