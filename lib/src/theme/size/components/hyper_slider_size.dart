import 'package:flutter/foundation.dart';

/// 当前设备的单值滑块尺寸，单位为逻辑像素。
@immutable
final class HyperSliderSize {
  const HyperSliderSize({
    required this.trackHeight,
    required this.thumbRadius,
    required this.stepPointRadius,
    required this.thinTrackHeight,
    required this.thinThumbRadius,
    required this.capsuleWidth,
    required this.capsuleCornerRadius,
    required this.capsuleIconSize,
    required this.capsuleIconInset,
    required this.capsuleOverscrollExtent,
  });

  final double trackHeight;
  final double thumbRadius;
  final double stepPointRadius;
  final double thinTrackHeight;
  final double thinThumbRadius;
  final double capsuleWidth;
  final double capsuleCornerRadius;
  final double capsuleIconSize;
  final double capsuleIconInset;
  final double capsuleOverscrollExtent;

  HyperSliderSize copyWith({
    double? trackHeight,
    double? thumbRadius,
    double? stepPointRadius,
    double? thinTrackHeight,
    double? thinThumbRadius,
    double? capsuleWidth,
    double? capsuleCornerRadius,
    double? capsuleIconSize,
    double? capsuleIconInset,
    double? capsuleOverscrollExtent,
  }) => HyperSliderSize(
    trackHeight: trackHeight ?? this.trackHeight,
    thumbRadius: thumbRadius ?? this.thumbRadius,
    stepPointRadius: stepPointRadius ?? this.stepPointRadius,
    thinTrackHeight: thinTrackHeight ?? this.thinTrackHeight,
    thinThumbRadius: thinThumbRadius ?? this.thinThumbRadius,
    capsuleWidth: capsuleWidth ?? this.capsuleWidth,
    capsuleCornerRadius: capsuleCornerRadius ?? this.capsuleCornerRadius,
    capsuleIconSize: capsuleIconSize ?? this.capsuleIconSize,
    capsuleIconInset: capsuleIconInset ?? this.capsuleIconInset,
    capsuleOverscrollExtent:
        capsuleOverscrollExtent ?? this.capsuleOverscrollExtent,
  );

  static HyperSliderSize lerp(HyperSliderSize a, HyperSliderSize b, double t) =>
      HyperSliderSize(
        trackHeight: a.trackHeight + (b.trackHeight - a.trackHeight) * t,
        thumbRadius: a.thumbRadius + (b.thumbRadius - a.thumbRadius) * t,
        stepPointRadius:
            a.stepPointRadius + (b.stepPointRadius - a.stepPointRadius) * t,
        thinTrackHeight:
            a.thinTrackHeight + (b.thinTrackHeight - a.thinTrackHeight) * t,
        thinThumbRadius:
            a.thinThumbRadius + (b.thinThumbRadius - a.thinThumbRadius) * t,
        capsuleWidth: a.capsuleWidth + (b.capsuleWidth - a.capsuleWidth) * t,
        capsuleCornerRadius:
            a.capsuleCornerRadius +
            (b.capsuleCornerRadius - a.capsuleCornerRadius) * t,
        capsuleIconSize:
            a.capsuleIconSize + (b.capsuleIconSize - a.capsuleIconSize) * t,
        capsuleIconInset:
            a.capsuleIconInset + (b.capsuleIconInset - a.capsuleIconInset) * t,
        capsuleOverscrollExtent:
            a.capsuleOverscrollExtent +
            (b.capsuleOverscrollExtent - a.capsuleOverscrollExtent) * t,
      );

  @override
  bool operator ==(Object other) =>
      other is HyperSliderSize &&
      other.trackHeight == trackHeight &&
      other.thumbRadius == thumbRadius &&
      other.stepPointRadius == stepPointRadius &&
      other.thinTrackHeight == thinTrackHeight &&
      other.thinThumbRadius == thinThumbRadius &&
      other.capsuleWidth == capsuleWidth &&
      other.capsuleCornerRadius == capsuleCornerRadius &&
      other.capsuleIconSize == capsuleIconSize &&
      other.capsuleIconInset == capsuleIconInset &&
      other.capsuleOverscrollExtent == capsuleOverscrollExtent;

  @override
  int get hashCode => Object.hash(
    trackHeight,
    thumbRadius,
    stepPointRadius,
    thinTrackHeight,
    thinThumbRadius,
    capsuleWidth,
    capsuleCornerRadius,
    capsuleIconSize,
    capsuleIconInset,
    capsuleOverscrollExtent,
  );
}
