import 'package:flutter/foundation.dart';

/// 当前设备的尺寸；可选字段为空时保留组件已有的几何推导。
@immutable
final class HyperProgressSize {
  const HyperProgressSize({
    required this.circularSize,
    required this.circularThickness,
    required this.linearThickness,
    required this.infiniteSize,
    required this.infiniteDotRadius,
    this.wideLinearThickness = 24,
    this.linearSize,
    this.radius,
    this.fillRadius,
    this.infiniteThickness,
  });
  final double circularSize;
  final double circularThickness;
  final double linearThickness;
  final double wideLinearThickness;
  final double infiniteSize;
  final double infiniteDotRadius;
  final double? linearSize;
  final double? radius;
  final double? fillRadius;
  final double? infiniteThickness;
  HyperProgressSize copyWith({
    double? circularSize,
    double? circularThickness,
    double? linearThickness,
    double? wideLinearThickness,
    double? infiniteSize,
    double? infiniteDotRadius,
    double? linearSize,
    double? radius,
    double? fillRadius,
    double? infiniteThickness,
  }) => HyperProgressSize(
    circularSize: circularSize ?? this.circularSize,
    circularThickness: circularThickness ?? this.circularThickness,
    linearThickness: linearThickness ?? this.linearThickness,
    wideLinearThickness: wideLinearThickness ?? this.wideLinearThickness,
    infiniteSize: infiniteSize ?? this.infiniteSize,
    infiniteDotRadius: infiniteDotRadius ?? this.infiniteDotRadius,
    linearSize: linearSize ?? this.linearSize,
    radius: radius ?? this.radius,
    fillRadius: fillRadius ?? this.fillRadius,
    infiniteThickness: infiniteThickness ?? this.infiniteThickness,
  );
  static HyperProgressSize lerp(
    HyperProgressSize a,
    HyperProgressSize b,
    double t,
  ) {
    double? optional(double? x, double? y) =>
        x == null || y == null ? (t < .5 ? x : y) : x + (y - x) * t;
    return HyperProgressSize(
      circularSize: a.circularSize + (b.circularSize - a.circularSize) * t,
      circularThickness:
          a.circularThickness + (b.circularThickness - a.circularThickness) * t,
      linearThickness:
          a.linearThickness + (b.linearThickness - a.linearThickness) * t,
      wideLinearThickness:
          a.wideLinearThickness +
          (b.wideLinearThickness - a.wideLinearThickness) * t,
      infiniteSize: a.infiniteSize + (b.infiniteSize - a.infiniteSize) * t,
      infiniteDotRadius:
          a.infiniteDotRadius + (b.infiniteDotRadius - a.infiniteDotRadius) * t,
      linearSize: optional(a.linearSize, b.linearSize),
      radius: optional(a.radius, b.radius),
      fillRadius: optional(a.fillRadius, b.fillRadius),
      infiniteThickness: optional(a.infiniteThickness, b.infiniteThickness),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is HyperProgressSize &&
      other.circularSize == circularSize &&
      other.circularThickness == circularThickness &&
      other.linearThickness == linearThickness &&
      other.wideLinearThickness == wideLinearThickness &&
      other.infiniteSize == infiniteSize &&
      other.infiniteDotRadius == infiniteDotRadius &&
      other.linearSize == linearSize &&
      other.radius == radius &&
      other.fillRadius == fillRadius &&
      other.infiniteThickness == infiniteThickness;
  @override
  int get hashCode => Object.hashAll([
    circularSize,
    circularThickness,
    linearThickness,
    wideLinearThickness,
    infiniteSize,
    infiniteDotRadius,
    linearSize,
    radius,
    fillRadius,
    infiniteThickness,
  ]);
}
