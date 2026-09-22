import 'package:flutter/foundation.dart';

/// 当前设备的 HyperIcon 尺寸规格。
@immutable
final class HyperIconSize {
  const HyperIconSize({required this.size});
  final double size;
  HyperIconSize copyWith({double? size}) =>
      HyperIconSize(size: size ?? this.size);
  static HyperIconSize lerp(HyperIconSize a, HyperIconSize b, double t) =>
      HyperIconSize(size: a.size + (b.size - a.size) * t);
  @override
  bool operator ==(Object other) =>
      other is HyperIconSize && other.size == size;
  @override
  int get hashCode => size.hashCode;
}
