import 'package:flutter/foundation.dart';

/// 当前设备的通用抽屉尺寸。
@immutable
final class HyperDrawerSize {
  const HyperDrawerSize({required this.width, this.radius});

  final double width;
  final double? radius;

  HyperDrawerSize copyWith({double? width, double? radius}) => HyperDrawerSize(
    width: width ?? this.width,
    radius: radius ?? this.radius,
  );

  static HyperDrawerSize lerp(HyperDrawerSize a, HyperDrawerSize b, double t) =>
      HyperDrawerSize(
        width: a.width + (b.width - a.width) * t,
        radius: a.radius == null || b.radius == null
            ? (t < .5 ? a.radius : b.radius)
            : a.radius! + (b.radius! - a.radius!) * t,
      );

  @override
  bool operator ==(Object other) =>
      other is HyperDrawerSize &&
      other.width == width &&
      other.radius == radius;

  @override
  int get hashCode => Object.hash(width, radius);
}
