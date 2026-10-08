import 'package:flutter/foundation.dart';

@immutable
final class HyperTimelineSize {
  const HyperTimelineSize({
    required this.nodeSize,
    required this.iconSize,
    required this.lineThickness,
    required this.spacing,
    required this.itemSpacing,
    required this.textSpacing,
  });
  final double nodeSize;
  final double iconSize;
  final double lineThickness;
  final double spacing;
  final double itemSpacing;
  final double textSpacing;
  HyperTimelineSize copyWith({
    double? nodeSize,
    double? iconSize,
    double? lineThickness,
    double? spacing,
    double? itemSpacing,
    double? textSpacing,
  }) => HyperTimelineSize(
    nodeSize: nodeSize ?? this.nodeSize,
    iconSize: iconSize ?? this.iconSize,
    lineThickness: lineThickness ?? this.lineThickness,
    spacing: spacing ?? this.spacing,
    itemSpacing: itemSpacing ?? this.itemSpacing,
    textSpacing: textSpacing ?? this.textSpacing,
  );
  static HyperTimelineSize lerp(
    HyperTimelineSize a,
    HyperTimelineSize b,
    double t,
  ) => HyperTimelineSize(
    nodeSize: a.nodeSize + (b.nodeSize - a.nodeSize) * t,
    iconSize: a.iconSize + (b.iconSize - a.iconSize) * t,
    lineThickness: a.lineThickness + (b.lineThickness - a.lineThickness) * t,
    spacing: a.spacing + (b.spacing - a.spacing) * t,
    itemSpacing: a.itemSpacing + (b.itemSpacing - a.itemSpacing) * t,
    textSpacing: a.textSpacing + (b.textSpacing - a.textSpacing) * t,
  );
  @override
  bool operator ==(Object other) =>
      other is HyperTimelineSize &&
      nodeSize == other.nodeSize &&
      iconSize == other.iconSize &&
      lineThickness == other.lineThickness &&
      spacing == other.spacing &&
      itemSpacing == other.itemSpacing &&
      textSpacing == other.textSpacing;
  @override
  int get hashCode => Object.hashAll([
    nodeSize,
    iconSize,
    lineThickness,
    spacing,
    itemSpacing,
    textSpacing,
  ]);
}
