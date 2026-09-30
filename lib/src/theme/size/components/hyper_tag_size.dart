import 'package:flutter/foundation.dart';

/// 当前设备的静态标签尺寸，单位为逻辑像素。
@immutable
final class HyperTagSize {
  const HyperTagSize({
    required this.height,
    required this.horizontalPadding,
    required this.radius,
    required this.iconSize,
    required this.iconSpacing,
  });

  final double height;
  final double horizontalPadding;
  final double radius;
  final double iconSize;
  final double iconSpacing;

  HyperTagSize copyWith({
    double? height,
    double? horizontalPadding,
    double? radius,
    double? iconSize,
    double? iconSpacing,
  }) => HyperTagSize(
    height: height ?? this.height,
    horizontalPadding: horizontalPadding ?? this.horizontalPadding,
    radius: radius ?? this.radius,
    iconSize: iconSize ?? this.iconSize,
    iconSpacing: iconSpacing ?? this.iconSpacing,
  );

  static HyperTagSize lerp(HyperTagSize a, HyperTagSize b, double t) =>
      HyperTagSize(
        height: a.height + (b.height - a.height) * t,
        horizontalPadding:
            a.horizontalPadding +
            (b.horizontalPadding - a.horizontalPadding) * t,
        radius: a.radius + (b.radius - a.radius) * t,
        iconSize: a.iconSize + (b.iconSize - a.iconSize) * t,
        iconSpacing: a.iconSpacing + (b.iconSpacing - a.iconSpacing) * t,
      );

  @override
  bool operator ==(Object other) =>
      other is HyperTagSize &&
      other.height == height &&
      other.horizontalPadding == horizontalPadding &&
      other.radius == radius &&
      other.iconSize == iconSize &&
      other.iconSpacing == iconSpacing;

  @override
  int get hashCode =>
      Object.hash(height, horizontalPadding, radius, iconSize, iconSpacing);
}
