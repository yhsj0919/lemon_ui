import 'package:flutter/foundation.dart';

@immutable
final class HyperImageEditorSize {
  const HyperImageEditorSize({
    this.cropPadding,
    required this.spacing,
    required this.padding,
    required this.iconSize,
    required this.handleLength,
    required this.handleThickness,
    required this.lineWidth,
    required this.handleHitSize,
  });
  final double? cropPadding;
  final double spacing,
      padding,
      iconSize,
      handleLength,
      handleThickness,
      lineWidth,
      handleHitSize;
  HyperImageEditorSize copyWith({
    double? cropPadding,
    double? spacing,
    double? padding,
    double? iconSize,
    double? handleLength,
    double? handleThickness,
    double? lineWidth,
    double? handleHitSize,
  }) => HyperImageEditorSize(
    cropPadding: cropPadding ?? this.cropPadding,
    spacing: spacing ?? this.spacing,
    padding: padding ?? this.padding,
    iconSize: iconSize ?? this.iconSize,
    handleLength: handleLength ?? this.handleLength,
    handleThickness: handleThickness ?? this.handleThickness,
    lineWidth: lineWidth ?? this.lineWidth,
    handleHitSize: handleHitSize ?? this.handleHitSize,
  );
  static HyperImageEditorSize lerp(
    HyperImageEditorSize a,
    HyperImageEditorSize b,
    double t,
  ) => HyperImageEditorSize(
    cropPadding: a.cropPadding == null || b.cropPadding == null
        ? (t < .5 ? a.cropPadding : b.cropPadding)
        : a.cropPadding! + (b.cropPadding! - a.cropPadding!) * t,
    spacing: a.spacing + (b.spacing - a.spacing) * t,
    padding: a.padding + (b.padding - a.padding) * t,
    iconSize: a.iconSize + (b.iconSize - a.iconSize) * t,
    handleLength: a.handleLength + (b.handleLength - a.handleLength) * t,
    handleThickness:
        a.handleThickness + (b.handleThickness - a.handleThickness) * t,
    lineWidth: a.lineWidth + (b.lineWidth - a.lineWidth) * t,
    handleHitSize: a.handleHitSize + (b.handleHitSize - a.handleHitSize) * t,
  );
  @override
  bool operator ==(Object other) =>
      other is HyperImageEditorSize &&
      cropPadding == other.cropPadding &&
      spacing == other.spacing &&
      padding == other.padding &&
      iconSize == other.iconSize &&
      handleLength == other.handleLength &&
      handleThickness == other.handleThickness &&
      lineWidth == other.lineWidth &&
      handleHitSize == other.handleHitSize;
  @override
  int get hashCode => Object.hash(
    cropPadding,
    spacing,
    padding,
    iconSize,
    handleLength,
    handleThickness,
    lineWidth,
    handleHitSize,
  );
}
