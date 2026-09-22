import 'package:flutter/foundation.dart';

/// 当前设备的 HyperRadio 尺寸规格。
@immutable
final class HyperRadioSize {
  const HyperRadioSize({required this.size});
  final double size;
  HyperRadioSize copyWith({double? size}) =>
      HyperRadioSize(size: size ?? this.size);
  static HyperRadioSize lerp(HyperRadioSize a, HyperRadioSize b, double t) =>
      HyperRadioSize(size: a.size + (b.size - a.size) * t);
  @override
  bool operator ==(Object other) =>
      other is HyperRadioSize && other.size == size;
  @override
  int get hashCode => size.hashCode;
}
