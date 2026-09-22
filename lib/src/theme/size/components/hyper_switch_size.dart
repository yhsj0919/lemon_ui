import 'package:flutter/foundation.dart';

/// 当前设备的 HyperSwitch 尺寸规格。
@immutable
final class HyperSwitchSize {
  const HyperSwitchSize({
    required this.width,
    required this.height,
    required this.thumbSize,
    required this.thumbInset,
  });
  final double width;
  final double height;
  final double thumbSize;
  final double thumbInset;
  HyperSwitchSize copyWith({
    double? width,
    double? height,
    double? thumbSize,
    double? thumbInset,
  }) => HyperSwitchSize(
    width: width ?? this.width,
    height: height ?? this.height,
    thumbSize: thumbSize ?? this.thumbSize,
    thumbInset: thumbInset ?? this.thumbInset,
  );
  static HyperSwitchSize lerp(HyperSwitchSize a, HyperSwitchSize b, double t) =>
      HyperSwitchSize(
        width: a.width + (b.width - a.width) * t,
        height: a.height + (b.height - a.height) * t,
        thumbSize: a.thumbSize + (b.thumbSize - a.thumbSize) * t,
        thumbInset: a.thumbInset + (b.thumbInset - a.thumbInset) * t,
      );
  @override
  bool operator ==(Object other) =>
      other is HyperSwitchSize &&
      other.width == width &&
      other.height == height &&
      other.thumbSize == thumbSize &&
      other.thumbInset == thumbInset;
  @override
  int get hashCode => Object.hash(width, height, thumbSize, thumbInset);
}
