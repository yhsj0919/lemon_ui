import 'package:flutter/foundation.dart';

/// 当前设备的尺寸；可选字段为空时保留组件已有的几何推导。
@immutable
final class HyperSwitchSize {
  const HyperSwitchSize({
    required this.width,
    required this.height,
    required this.thumbSize,
    required this.thumbInset,
    this.thumbWidth,
    this.thumbHeight,
    this.minimumTapTargetSize,
    this.radius,
    this.thumbRadius,
    this.uncheckedThumbOffset,
    this.checkedThumbOffset,
  });
  final double width;
  final double height;
  final double? thumbWidth;
  final double? thumbHeight;
  final double thumbSize;
  final double thumbInset;
  final double? minimumTapTargetSize;
  final double? radius;
  final double? thumbRadius;
  final double? uncheckedThumbOffset;
  final double? checkedThumbOffset;
  HyperSwitchSize copyWith({
    double? width,
    double? height,
    double? thumbWidth,
    double? thumbHeight,
    double? thumbSize,
    double? thumbInset,
    double? minimumTapTargetSize,
    double? radius,
    double? thumbRadius,
    double? uncheckedThumbOffset,
    double? checkedThumbOffset,
  }) => HyperSwitchSize(
    width: width ?? this.width,
    height: height ?? this.height,
    thumbWidth: thumbWidth ?? this.thumbWidth,
    thumbHeight: thumbHeight ?? this.thumbHeight,
    thumbSize: thumbSize ?? this.thumbSize,
    thumbInset: thumbInset ?? this.thumbInset,
    minimumTapTargetSize: minimumTapTargetSize ?? this.minimumTapTargetSize,
    radius: radius ?? this.radius,
    thumbRadius: thumbRadius ?? this.thumbRadius,
    uncheckedThumbOffset: uncheckedThumbOffset ?? this.uncheckedThumbOffset,
    checkedThumbOffset: checkedThumbOffset ?? this.checkedThumbOffset,
  );
  static HyperSwitchSize lerp(HyperSwitchSize a, HyperSwitchSize b, double t) {
    double? optional(double? x, double? y) =>
        x == null || y == null ? (t < .5 ? x : y) : x + (y - x) * t;
    return HyperSwitchSize(
      width: a.width + (b.width - a.width) * t,
      height: a.height + (b.height - a.height) * t,
      thumbWidth: optional(a.thumbWidth, b.thumbWidth),
      thumbHeight: optional(a.thumbHeight, b.thumbHeight),
      thumbSize: a.thumbSize + (b.thumbSize - a.thumbSize) * t,
      thumbInset: a.thumbInset + (b.thumbInset - a.thumbInset) * t,
      minimumTapTargetSize: optional(
        a.minimumTapTargetSize,
        b.minimumTapTargetSize,
      ),
      radius: optional(a.radius, b.radius),
      thumbRadius: optional(a.thumbRadius, b.thumbRadius),
      uncheckedThumbOffset: optional(
        a.uncheckedThumbOffset,
        b.uncheckedThumbOffset,
      ),
      checkedThumbOffset: optional(a.checkedThumbOffset, b.checkedThumbOffset),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is HyperSwitchSize &&
      other.width == width &&
      other.height == height &&
      other.thumbWidth == thumbWidth &&
      other.thumbHeight == thumbHeight &&
      other.thumbSize == thumbSize &&
      other.thumbInset == thumbInset &&
      other.minimumTapTargetSize == minimumTapTargetSize &&
      other.radius == radius &&
      other.thumbRadius == thumbRadius &&
      other.uncheckedThumbOffset == uncheckedThumbOffset &&
      other.checkedThumbOffset == checkedThumbOffset;
  @override
  int get hashCode => Object.hashAll([
    width,
    height,
    thumbWidth,
    thumbHeight,
    thumbSize,
    thumbInset,
    minimumTapTargetSize,
    radius,
    thumbRadius,
    uncheckedThumbOffset,
    checkedThumbOffset,
  ]);
}
