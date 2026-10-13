import 'package:flutter/foundation.dart';

/// 当前设备的下拉选择器锚点尺寸。
@immutable
final class HyperSelectSize {
  const HyperSelectSize({
    this.itemHeight,
    this.itemPadding,
    this.itemSpacing,
    this.itemRadius,
    this.surfaceRadius,
    this.minimumHeight,
    this.paddingHorizontal,
    this.paddingVertical,
    this.radius,
    this.minimumTapTargetSize,
    this.popupSpacing,
    required this.width,
    required this.arrowSize,
    required this.arrowSpacing,
  });

  final double? itemHeight;
  final double? itemPadding;
  final double? itemSpacing;
  final double? itemRadius;
  final double? surfaceRadius;
  final double? minimumHeight;
  final double? paddingHorizontal;
  final double? paddingVertical;
  final double? radius;
  final double? minimumTapTargetSize;
  final double? popupSpacing;
  final double width;
  final double arrowSize;
  final double arrowSpacing;

  HyperSelectSize copyWith({
    double? itemHeight,
    double? itemPadding,
    double? itemSpacing,
    double? itemRadius,
    double? surfaceRadius,
    double? minimumHeight,
    double? paddingHorizontal,
    double? paddingVertical,
    double? radius,
    double? minimumTapTargetSize,
    double? popupSpacing,
    double? width,
    double? arrowSize,
    double? arrowSpacing,
  }) => HyperSelectSize(
    itemHeight: itemHeight ?? this.itemHeight,
    itemPadding: itemPadding ?? this.itemPadding,
    itemSpacing: itemSpacing ?? this.itemSpacing,
    itemRadius: itemRadius ?? this.itemRadius,
    surfaceRadius: surfaceRadius ?? this.surfaceRadius,
    minimumHeight: minimumHeight ?? this.minimumHeight,
    paddingHorizontal: paddingHorizontal ?? this.paddingHorizontal,
    paddingVertical: paddingVertical ?? this.paddingVertical,
    radius: radius ?? this.radius,
    minimumTapTargetSize: minimumTapTargetSize ?? this.minimumTapTargetSize,
    popupSpacing: popupSpacing ?? this.popupSpacing,
    width: width ?? this.width,
    arrowSize: arrowSize ?? this.arrowSize,
    arrowSpacing: arrowSpacing ?? this.arrowSpacing,
  );

  static HyperSelectSize lerp(HyperSelectSize a, HyperSelectSize b, double t) =>
      HyperSelectSize(
        itemHeight: a.itemHeight == null || b.itemHeight == null
            ? (t < .5 ? a.itemHeight : b.itemHeight)
            : a.itemHeight! + (b.itemHeight! - a.itemHeight!) * t,
        itemPadding: a.itemPadding == null || b.itemPadding == null
            ? (t < .5 ? a.itemPadding : b.itemPadding)
            : a.itemPadding! + (b.itemPadding! - a.itemPadding!) * t,
        itemSpacing: a.itemSpacing == null || b.itemSpacing == null
            ? (t < .5 ? a.itemSpacing : b.itemSpacing)
            : a.itemSpacing! + (b.itemSpacing! - a.itemSpacing!) * t,
        itemRadius: a.itemRadius == null || b.itemRadius == null
            ? (t < .5 ? a.itemRadius : b.itemRadius)
            : a.itemRadius! + (b.itemRadius! - a.itemRadius!) * t,
        surfaceRadius: a.surfaceRadius == null || b.surfaceRadius == null
            ? (t < .5 ? a.surfaceRadius : b.surfaceRadius)
            : a.surfaceRadius! + (b.surfaceRadius! - a.surfaceRadius!) * t,
        minimumHeight: a.minimumHeight == null || b.minimumHeight == null
            ? (t < .5 ? a.minimumHeight : b.minimumHeight)
            : a.minimumHeight! + (b.minimumHeight! - a.minimumHeight!) * t,
        paddingHorizontal:
            a.paddingHorizontal == null || b.paddingHorizontal == null
            ? (t < .5 ? a.paddingHorizontal : b.paddingHorizontal)
            : a.paddingHorizontal! +
                  (b.paddingHorizontal! - a.paddingHorizontal!) * t,
        paddingVertical: a.paddingVertical == null || b.paddingVertical == null
            ? (t < .5 ? a.paddingVertical : b.paddingVertical)
            : a.paddingVertical! +
                  (b.paddingVertical! - a.paddingVertical!) * t,
        radius: a.radius == null || b.radius == null
            ? (t < .5 ? a.radius : b.radius)
            : a.radius! + (b.radius! - a.radius!) * t,
        minimumTapTargetSize:
            a.minimumTapTargetSize == null || b.minimumTapTargetSize == null
            ? (t < .5 ? a.minimumTapTargetSize : b.minimumTapTargetSize)
            : a.minimumTapTargetSize! +
                  (b.minimumTapTargetSize! - a.minimumTapTargetSize!) * t,
        popupSpacing: a.popupSpacing == null || b.popupSpacing == null
            ? (t < .5 ? a.popupSpacing : b.popupSpacing)
            : a.popupSpacing! + (b.popupSpacing! - a.popupSpacing!) * t,
        width: a.width + (b.width - a.width) * t,
        arrowSize: a.arrowSize + (b.arrowSize - a.arrowSize) * t,
        arrowSpacing: a.arrowSpacing + (b.arrowSpacing - a.arrowSpacing) * t,
      );

  @override
  bool operator ==(Object other) =>
      other is HyperSelectSize &&
      other.itemHeight == itemHeight &&
      other.itemPadding == itemPadding &&
      other.itemSpacing == itemSpacing &&
      other.itemRadius == itemRadius &&
      other.surfaceRadius == surfaceRadius &&
      other.minimumHeight == minimumHeight &&
      other.paddingHorizontal == paddingHorizontal &&
      other.paddingVertical == paddingVertical &&
      other.radius == radius &&
      other.minimumTapTargetSize == minimumTapTargetSize &&
      other.popupSpacing == popupSpacing &&
      other.width == width &&
      other.arrowSize == arrowSize &&
      other.arrowSpacing == arrowSpacing;

  @override
  int get hashCode => Object.hash(
    width,
    arrowSize,
    arrowSpacing,
    popupSpacing,
    itemHeight,
    itemPadding,
    itemSpacing,
    itemRadius,
    surfaceRadius,
  );
}
