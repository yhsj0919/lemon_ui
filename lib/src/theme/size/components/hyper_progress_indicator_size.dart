import 'package:flutter/foundation.dart';

/// 当前设备的进度指示器尺寸规格。
@immutable
final class HyperProgressIndicatorSize {
  const HyperProgressIndicatorSize({
    required this.circularSize,
    required this.circularThickness,
    required this.linearThickness,
    required this.infiniteSize,
    required this.infiniteDotRadius,
  });
  final double circularSize;
  final double circularThickness;
  final double linearThickness;
  final double infiniteSize;
  final double infiniteDotRadius;
  HyperProgressIndicatorSize copyWith({
    double? circularSize,
    double? circularThickness,
    double? linearThickness,
    double? infiniteSize,
    double? infiniteDotRadius,
  }) => HyperProgressIndicatorSize(
    circularSize: circularSize ?? this.circularSize,
    circularThickness: circularThickness ?? this.circularThickness,
    linearThickness: linearThickness ?? this.linearThickness,
    infiniteSize: infiniteSize ?? this.infiniteSize,
    infiniteDotRadius: infiniteDotRadius ?? this.infiniteDotRadius,
  );
  static HyperProgressIndicatorSize lerp(
    HyperProgressIndicatorSize a,
    HyperProgressIndicatorSize b,
    double t,
  ) => HyperProgressIndicatorSize(
    circularSize: a.circularSize + (b.circularSize - a.circularSize) * t,
    circularThickness:
        a.circularThickness + (b.circularThickness - a.circularThickness) * t,
    linearThickness:
        a.linearThickness + (b.linearThickness - a.linearThickness) * t,
    infiniteSize: a.infiniteSize + (b.infiniteSize - a.infiniteSize) * t,
    infiniteDotRadius:
        a.infiniteDotRadius + (b.infiniteDotRadius - a.infiniteDotRadius) * t,
  );
  @override
  bool operator ==(Object other) =>
      other is HyperProgressIndicatorSize &&
      other.circularSize == circularSize &&
      other.circularThickness == circularThickness &&
      other.linearThickness == linearThickness &&
      other.infiniteSize == infiniteSize &&
      other.infiniteDotRadius == infiniteDotRadius;
  @override
  int get hashCode => Object.hash(
    circularSize,
    circularThickness,
    linearThickness,
    infiniteSize,
    infiniteDotRadius,
  );
}
