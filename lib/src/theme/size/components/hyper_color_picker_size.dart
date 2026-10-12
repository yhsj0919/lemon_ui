import 'package:flutter/foundation.dart';

@immutable
final class HyperColorPickerSize {
  const HyperColorPickerSize({
    required this.width,
    required this.paletteHeight,
    required this.radius,
    required this.spacing,
    required this.markerRadius,
    required this.previewHeight,
  });
  final double width;
  final double paletteHeight;
  final double radius;
  final double spacing;
  final double markerRadius;
  final double previewHeight;
  HyperColorPickerSize copyWith({
    double? width,
    double? paletteHeight,
    double? radius,
    double? spacing,
    double? markerRadius,
    double? previewHeight,
  }) => HyperColorPickerSize(
    width: width ?? this.width,
    paletteHeight: paletteHeight ?? this.paletteHeight,
    radius: radius ?? this.radius,
    spacing: spacing ?? this.spacing,
    markerRadius: markerRadius ?? this.markerRadius,
    previewHeight: previewHeight ?? this.previewHeight,
  );
  static HyperColorPickerSize lerp(
    HyperColorPickerSize a,
    HyperColorPickerSize b,
    double t,
  ) => HyperColorPickerSize(
    width: a.width + (b.width - a.width) * t,
    paletteHeight: a.paletteHeight + (b.paletteHeight - a.paletteHeight) * t,
    radius: a.radius + (b.radius - a.radius) * t,
    spacing: a.spacing + (b.spacing - a.spacing) * t,
    markerRadius: a.markerRadius + (b.markerRadius - a.markerRadius) * t,
    previewHeight: a.previewHeight + (b.previewHeight - a.previewHeight) * t,
  );
  @override
  bool operator ==(Object other) =>
      other is HyperColorPickerSize &&
      other.width == width &&
      other.paletteHeight == paletteHeight &&
      other.radius == radius &&
      other.spacing == spacing &&
      other.markerRadius == markerRadius &&
      other.previewHeight == previewHeight;
  @override
  int get hashCode => Object.hashAll([
    width,
    paletteHeight,
    radius,
    spacing,
    markerRadius,
    previewHeight,
  ]);
}
