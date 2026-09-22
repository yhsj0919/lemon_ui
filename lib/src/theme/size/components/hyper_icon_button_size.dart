import 'package:flutter/foundation.dart';

/// 当前设备的 HyperIconButton 尺寸规格。
@immutable
final class HyperIconButtonSize {
  const HyperIconButtonSize({
    required this.size,
    required this.iconSize,
    required this.progressSize,
    required this.radius,
  });

  final double size;
  final double iconSize;
  final double progressSize;
  final double radius;

  HyperIconButtonSize copyWith({
    double? size,
    double? iconSize,
    double? progressSize,
    double? radius,
  }) => HyperIconButtonSize(
    size: size ?? this.size,
    iconSize: iconSize ?? this.iconSize,
    progressSize: progressSize ?? this.progressSize,
    radius: radius ?? this.radius,
  );

  static HyperIconButtonSize lerp(
    HyperIconButtonSize a,
    HyperIconButtonSize b,
    double t,
  ) {
    double value(double x, double y) => x + (y - x) * t;
    return HyperIconButtonSize(
      size: value(a.size, b.size),
      iconSize: value(a.iconSize, b.iconSize),
      progressSize: value(a.progressSize, b.progressSize),
      radius: value(a.radius, b.radius),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HyperIconButtonSize &&
          other.size == size &&
          other.iconSize == iconSize &&
          other.progressSize == progressSize &&
          other.radius == radius;

  @override
  int get hashCode => Object.hash(size, iconSize, progressSize, radius);
}
