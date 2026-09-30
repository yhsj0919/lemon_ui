import 'package:flutter/foundation.dart';

@immutable
final class HyperSkeletonSize {
  const HyperSkeletonSize({
    required this.lineHeight,
    required this.lineWidth,
    required this.circleSize,
    required this.blockWidth,
    required this.blockHeight,
    required this.radius,
  });
  final double lineHeight,
      lineWidth,
      circleSize,
      blockWidth,
      blockHeight,
      radius;
  HyperSkeletonSize copyWith({
    double? lineHeight,
    double? lineWidth,
    double? circleSize,
    double? blockWidth,
    double? blockHeight,
    double? radius,
  }) => HyperSkeletonSize(
    lineHeight: lineHeight ?? this.lineHeight,
    lineWidth: lineWidth ?? this.lineWidth,
    circleSize: circleSize ?? this.circleSize,
    blockWidth: blockWidth ?? this.blockWidth,
    blockHeight: blockHeight ?? this.blockHeight,
    radius: radius ?? this.radius,
  );
  static HyperSkeletonSize lerp(
    HyperSkeletonSize a,
    HyperSkeletonSize b,
    double t,
  ) => HyperSkeletonSize(
    lineHeight: a.lineHeight + (b.lineHeight - a.lineHeight) * t,
    lineWidth: a.lineWidth + (b.lineWidth - a.lineWidth) * t,
    circleSize: a.circleSize + (b.circleSize - a.circleSize) * t,
    blockWidth: a.blockWidth + (b.blockWidth - a.blockWidth) * t,
    blockHeight: a.blockHeight + (b.blockHeight - a.blockHeight) * t,
    radius: a.radius + (b.radius - a.radius) * t,
  );
  @override
  bool operator ==(Object other) =>
      other is HyperSkeletonSize &&
      other.lineHeight == lineHeight &&
      other.lineWidth == lineWidth &&
      other.circleSize == circleSize &&
      other.blockWidth == blockWidth &&
      other.blockHeight == blockHeight &&
      other.radius == radius;
  @override
  int get hashCode => Object.hash(
    lineHeight,
    lineWidth,
    circleSize,
    blockWidth,
    blockHeight,
    radius,
  );
}
