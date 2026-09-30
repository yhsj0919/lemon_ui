import 'package:flutter/foundation.dart';

/// 当前设备的徽标尺寸，单位为逻辑像素。
@immutable
final class HyperBadgeSize {
  const HyperBadgeSize({
    required this.dotSize,
    required this.dotRadius,
    required this.contentHeight,
    required this.textSize,
    required this.contentRadius,
    required this.horizontalPadding,
  });

  final double dotSize;
  final double dotRadius;
  final double contentHeight;
  final double textSize;
  final double contentRadius;
  final double horizontalPadding;

  HyperBadgeSize copyWith({
    double? dotSize,
    double? dotRadius,
    double? contentHeight,
    double? textSize,
    double? contentRadius,
    double? horizontalPadding,
  }) => HyperBadgeSize(
    dotSize: dotSize ?? this.dotSize,
    dotRadius: dotRadius ?? this.dotRadius,
    contentHeight: contentHeight ?? this.contentHeight,
    textSize: textSize ?? this.textSize,
    contentRadius: contentRadius ?? this.contentRadius,
    horizontalPadding: horizontalPadding ?? this.horizontalPadding,
  );

  static HyperBadgeSize lerp(
    HyperBadgeSize a,
    HyperBadgeSize b,
    double t,
  ) => HyperBadgeSize(
    dotSize: a.dotSize + (b.dotSize - a.dotSize) * t,
    dotRadius: a.dotRadius + (b.dotRadius - a.dotRadius) * t,
    contentHeight: a.contentHeight + (b.contentHeight - a.contentHeight) * t,
    textSize: a.textSize + (b.textSize - a.textSize) * t,
    contentRadius: a.contentRadius + (b.contentRadius - a.contentRadius) * t,
    horizontalPadding:
        a.horizontalPadding + (b.horizontalPadding - a.horizontalPadding) * t,
  );

  @override
  bool operator ==(Object other) =>
      other is HyperBadgeSize &&
      other.dotSize == dotSize &&
      other.dotRadius == dotRadius &&
      other.contentHeight == contentHeight &&
      other.textSize == textSize &&
      other.contentRadius == contentRadius &&
      other.horizontalPadding == horizontalPadding;

  @override
  int get hashCode => Object.hash(
    dotSize,
    dotRadius,
    contentHeight,
    textSize,
    contentRadius,
    horizontalPadding,
  );
}
