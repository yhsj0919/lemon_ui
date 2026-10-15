import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

@immutable
final class HyperDescriptionListSize {
  const HyperDescriptionListSize({
    required this.radius,
    required this.cellPadding,
    required this.columnSpacing,
    required this.rowSpacing,
    required this.labelValueSpacing,
    this.contentHeight,
    required this.minimumColumnWidth,
    required this.borderThickness,
  });
  final double? contentHeight;
  final double radius;
  final EdgeInsetsGeometry cellPadding;
  final double columnSpacing;
  final double rowSpacing;
  final double labelValueSpacing;
  final double minimumColumnWidth;
  final double borderThickness;
  HyperDescriptionListSize copyWith({
    double? contentHeight,
    double? radius,
    EdgeInsetsGeometry? cellPadding,
    double? columnSpacing,
    double? rowSpacing,
    double? labelValueSpacing,
    double? minimumColumnWidth,
    double? borderThickness,
  }) => HyperDescriptionListSize(
    contentHeight: contentHeight ?? this.contentHeight,
    radius: radius ?? this.radius,
    cellPadding: cellPadding ?? this.cellPadding,
    columnSpacing: columnSpacing ?? this.columnSpacing,
    rowSpacing: rowSpacing ?? this.rowSpacing,
    labelValueSpacing: labelValueSpacing ?? this.labelValueSpacing,
    minimumColumnWidth: minimumColumnWidth ?? this.minimumColumnWidth,
    borderThickness: borderThickness ?? this.borderThickness,
  );
  static HyperDescriptionListSize lerp(
    HyperDescriptionListSize a,
    HyperDescriptionListSize b,
    double t,
  ) => HyperDescriptionListSize(
    contentHeight: a.contentHeight == null || b.contentHeight == null
        ? (t < .5 ? a.contentHeight : b.contentHeight)
        : a.contentHeight! + (b.contentHeight! - a.contentHeight!) * t,
    radius: a.radius + (b.radius - a.radius) * t,
    cellPadding: EdgeInsetsGeometry.lerp(a.cellPadding, b.cellPadding, t)!,
    columnSpacing: a.columnSpacing + (b.columnSpacing - a.columnSpacing) * t,
    rowSpacing: a.rowSpacing + (b.rowSpacing - a.rowSpacing) * t,
    labelValueSpacing:
        a.labelValueSpacing + (b.labelValueSpacing - a.labelValueSpacing) * t,
    minimumColumnWidth:
        a.minimumColumnWidth +
        (b.minimumColumnWidth - a.minimumColumnWidth) * t,
    borderThickness:
        a.borderThickness + (b.borderThickness - a.borderThickness) * t,
  );
  @override
  bool operator ==(Object other) =>
      other is HyperDescriptionListSize &&
      contentHeight == other.contentHeight &&
      radius == other.radius &&
      cellPadding == other.cellPadding &&
      columnSpacing == other.columnSpacing &&
      rowSpacing == other.rowSpacing &&
      labelValueSpacing == other.labelValueSpacing &&
      minimumColumnWidth == other.minimumColumnWidth &&
      borderThickness == other.borderThickness;
  @override
  int get hashCode => Object.hashAll([
    contentHeight,
    radius,
    cellPadding,
    columnSpacing,
    rowSpacing,
    labelValueSpacing,
    minimumColumnWidth,
    borderThickness,
  ]);
}
