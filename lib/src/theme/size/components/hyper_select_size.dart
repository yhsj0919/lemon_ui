import 'package:flutter/foundation.dart';

/// 当前设备的下拉选择器锚点尺寸。
@immutable
final class HyperSelectSize {
  const HyperSelectSize({
    required this.width,
    required this.arrowSize,
    required this.arrowSpacing,
  });

  final double width;
  final double arrowSize;
  final double arrowSpacing;

  HyperSelectSize copyWith({
    double? width,
    double? arrowSize,
    double? arrowSpacing,
  }) => HyperSelectSize(
    width: width ?? this.width,
    arrowSize: arrowSize ?? this.arrowSize,
    arrowSpacing: arrowSpacing ?? this.arrowSpacing,
  );

  static HyperSelectSize lerp(HyperSelectSize a, HyperSelectSize b, double t) =>
      HyperSelectSize(
        width: a.width + (b.width - a.width) * t,
        arrowSize: a.arrowSize + (b.arrowSize - a.arrowSize) * t,
        arrowSpacing: a.arrowSpacing + (b.arrowSpacing - a.arrowSpacing) * t,
      );

  @override
  bool operator ==(Object other) =>
      other is HyperSelectSize &&
      other.width == width &&
      other.arrowSize == arrowSize &&
      other.arrowSpacing == arrowSpacing;

  @override
  int get hashCode => Object.hash(width, arrowSize, arrowSpacing);
}
