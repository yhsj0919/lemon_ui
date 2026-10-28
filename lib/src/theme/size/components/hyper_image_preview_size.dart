import 'package:flutter/foundation.dart';

@immutable
final class HyperImagePreviewSize {
  const HyperImagePreviewSize({
    required this.spacing,
    required this.padding,
    required this.iconSize,
  });
  final double spacing, padding, iconSize;
  HyperImagePreviewSize copyWith({
    double? spacing,
    double? padding,
    double? iconSize,
  }) => HyperImagePreviewSize(
    spacing: spacing ?? this.spacing,
    padding: padding ?? this.padding,
    iconSize: iconSize ?? this.iconSize,
  );
  static HyperImagePreviewSize lerp(
    HyperImagePreviewSize a,
    HyperImagePreviewSize b,
    double t,
  ) => HyperImagePreviewSize(
    spacing: a.spacing + (b.spacing - a.spacing) * t,
    padding: a.padding + (b.padding - a.padding) * t,
    iconSize: a.iconSize + (b.iconSize - a.iconSize) * t,
  );
  @override
  bool operator ==(Object other) =>
      other is HyperImagePreviewSize &&
      spacing == other.spacing &&
      padding == other.padding &&
      iconSize == other.iconSize;
  @override
  int get hashCode => Object.hash(spacing, padding, iconSize);
}
