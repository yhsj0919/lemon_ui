import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

@immutable
final class HyperPaginationSize {
  const HyperPaginationSize({
    required this.height,
    required this.minWidth,
    required this.radius,
    required this.padding,
    required this.iconSize,
    required this.spacing,
    required this.runSpacing,
  });
  final double height;
  final double minWidth;
  final double radius;
  final EdgeInsetsGeometry padding;
  final double iconSize;
  final double spacing;
  final double runSpacing;
  HyperPaginationSize copyWith({
    double? height,
    double? minWidth,
    double? radius,
    EdgeInsetsGeometry? padding,
    double? iconSize,
    double? spacing,
    double? runSpacing,
  }) => HyperPaginationSize(
    height: height ?? this.height,
    minWidth: minWidth ?? this.minWidth,
    radius: radius ?? this.radius,
    padding: padding ?? this.padding,
    iconSize: iconSize ?? this.iconSize,
    spacing: spacing ?? this.spacing,
    runSpacing: runSpacing ?? this.runSpacing,
  );
  static HyperPaginationSize lerp(
    HyperPaginationSize a,
    HyperPaginationSize b,
    double t,
  ) => HyperPaginationSize(
    height: a.height + (b.height - a.height) * t,
    minWidth: a.minWidth + (b.minWidth - a.minWidth) * t,
    radius: a.radius + (b.radius - a.radius) * t,
    padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t)!,
    iconSize: a.iconSize + (b.iconSize - a.iconSize) * t,
    spacing: a.spacing + (b.spacing - a.spacing) * t,
    runSpacing: a.runSpacing + (b.runSpacing - a.runSpacing) * t,
  );
  @override
  bool operator ==(Object other) =>
      other is HyperPaginationSize &&
      height == other.height &&
      minWidth == other.minWidth &&
      radius == other.radius &&
      padding == other.padding &&
      iconSize == other.iconSize &&
      spacing == other.spacing &&
      runSpacing == other.runSpacing;
  @override
  int get hashCode => Object.hashAll([
    height,
    minWidth,
    radius,
    padding,
    iconSize,
    spacing,
    runSpacing,
  ]);
}
