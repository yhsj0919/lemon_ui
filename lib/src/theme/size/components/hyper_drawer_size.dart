import 'package:flutter/foundation.dart';

/// 当前设备的通用抽屉尺寸。
@immutable
final class HyperDrawerSize {
  const HyperDrawerSize({required this.width});

  final double width;

  HyperDrawerSize copyWith({double? width}) =>
      HyperDrawerSize(width: width ?? this.width);

  static HyperDrawerSize lerp(HyperDrawerSize a, HyperDrawerSize b, double t) =>
      HyperDrawerSize(width: a.width + (b.width - a.width) * t);

  @override
  bool operator ==(Object other) =>
      other is HyperDrawerSize && other.width == width;

  @override
  int get hashCode => width.hashCode;
}
