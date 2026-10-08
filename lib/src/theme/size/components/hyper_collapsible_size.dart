import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

@immutable
final class HyperCollapsibleSize {
  const HyperCollapsibleSize({
    required this.radius,
    required this.headerPadding,
    required this.contentPadding,
    required this.headerMinHeight,
    required this.iconSize,
    required this.spacing,
  });
  final double radius;
  final EdgeInsetsGeometry headerPadding;
  final EdgeInsetsGeometry contentPadding;
  final double headerMinHeight;
  final double iconSize;
  final double spacing;
  HyperCollapsibleSize copyWith({
    double? radius,
    EdgeInsetsGeometry? headerPadding,
    EdgeInsetsGeometry? contentPadding,
    double? headerMinHeight,
    double? iconSize,
    double? spacing,
  }) => HyperCollapsibleSize(
    radius: radius ?? this.radius,
    headerPadding: headerPadding ?? this.headerPadding,
    contentPadding: contentPadding ?? this.contentPadding,
    headerMinHeight: headerMinHeight ?? this.headerMinHeight,
    iconSize: iconSize ?? this.iconSize,
    spacing: spacing ?? this.spacing,
  );
  static HyperCollapsibleSize lerp(
    HyperCollapsibleSize a,
    HyperCollapsibleSize b,
    double t,
  ) => HyperCollapsibleSize(
    radius: a.radius + (b.radius - a.radius) * t,
    headerPadding: EdgeInsetsGeometry.lerp(
      a.headerPadding,
      b.headerPadding,
      t,
    )!,
    contentPadding: EdgeInsetsGeometry.lerp(
      a.contentPadding,
      b.contentPadding,
      t,
    )!,
    headerMinHeight:
        a.headerMinHeight + (b.headerMinHeight - a.headerMinHeight) * t,
    iconSize: a.iconSize + (b.iconSize - a.iconSize) * t,
    spacing: a.spacing + (b.spacing - a.spacing) * t,
  );
  @override
  bool operator ==(Object other) =>
      other is HyperCollapsibleSize &&
      radius == other.radius &&
      headerPadding == other.headerPadding &&
      contentPadding == other.contentPadding &&
      headerMinHeight == other.headerMinHeight &&
      iconSize == other.iconSize &&
      spacing == other.spacing;
  @override
  int get hashCode => Object.hashAll([
    radius,
    headerPadding,
    contentPadding,
    headerMinHeight,
    iconSize,
    spacing,
  ]);
}
