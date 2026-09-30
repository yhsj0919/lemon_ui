import 'package:flutter/foundation.dart';

/// 当前设备的进度指示器尺寸规格。
@immutable
final class HyperProgressSize {
  const HyperProgressSize({
    required this.circularSize,
    required this.circularThickness,
    required this.linearThickness,
    this.wideLinearThickness = 24,
    required this.infiniteSize,
    required this.infiniteDotRadius,
  });
  final double circularSize;
  final double circularThickness;
  final double linearThickness;
  final double wideLinearThickness;
  final double infiniteSize;
  final double infiniteDotRadius;
  HyperProgressSize copyWith({
    double? circularSize,
    double? circularThickness,
    double? linearThickness,
    double? wideLinearThickness,
    double? infiniteSize,
    double? infiniteDotRadius,
  }) => HyperProgressSize(
    circularSize: circularSize ?? this.circularSize,
    circularThickness: circularThickness ?? this.circularThickness,
    linearThickness: linearThickness ?? this.linearThickness,
    wideLinearThickness: wideLinearThickness ?? this.wideLinearThickness,
    infiniteSize: infiniteSize ?? this.infiniteSize,
    infiniteDotRadius: infiniteDotRadius ?? this.infiniteDotRadius,
  );
  static HyperProgressSize lerp(
    HyperProgressSize a,
    HyperProgressSize b,
    double t,
  ) => HyperProgressSize(
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
  );
  @override
  bool operator ==(Object other) =>
      other is HyperProgressSize &&
      other.circularSize == circularSize &&
      other.circularThickness == circularThickness &&
      other.linearThickness == linearThickness &&
      other.wideLinearThickness == wideLinearThickness &&
      other.infiniteSize == infiniteSize &&
      other.infiniteDotRadius == infiniteDotRadius;
  @override
  int get hashCode => Object.hash(
    circularSize,
    circularThickness,
    linearThickness,
    wideLinearThickness,
    infiniteSize,
    infiniteDotRadius,
  );
}
