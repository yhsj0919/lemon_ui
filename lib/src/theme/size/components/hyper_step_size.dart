import 'package:flutter/foundation.dart';

@immutable
final class HyperStepSize {
  const HyperStepSize({
    required this.nodeSize,
    required this.iconSize,
    required this.connectorThickness,
    required this.spacing,
    required this.titleSpacing,
    required this.itemSpacing,
    required this.interactionRadius,
  });
  final double nodeSize;
  final double iconSize;
  final double connectorThickness;
  final double spacing;
  final double titleSpacing;
  final double itemSpacing;
  final double interactionRadius;
  HyperStepSize copyWith({
    double? nodeSize,
    double? iconSize,
    double? connectorThickness,
    double? spacing,
    double? titleSpacing,
    double? itemSpacing,
    double? interactionRadius,
  }) => HyperStepSize(
    nodeSize: nodeSize ?? this.nodeSize,
    iconSize: iconSize ?? this.iconSize,
    connectorThickness: connectorThickness ?? this.connectorThickness,
    spacing: spacing ?? this.spacing,
    titleSpacing: titleSpacing ?? this.titleSpacing,
    itemSpacing: itemSpacing ?? this.itemSpacing,
    interactionRadius: interactionRadius ?? this.interactionRadius,
  );
  static HyperStepSize lerp(HyperStepSize a, HyperStepSize b, double t) =>
      HyperStepSize(
        nodeSize: a.nodeSize + (b.nodeSize - a.nodeSize) * t,
        iconSize: a.iconSize + (b.iconSize - a.iconSize) * t,
        connectorThickness:
            a.connectorThickness +
            (b.connectorThickness - a.connectorThickness) * t,
        spacing: a.spacing + (b.spacing - a.spacing) * t,
        titleSpacing: a.titleSpacing + (b.titleSpacing - a.titleSpacing) * t,
        itemSpacing: a.itemSpacing + (b.itemSpacing - a.itemSpacing) * t,
        interactionRadius:
            a.interactionRadius +
            (b.interactionRadius - a.interactionRadius) * t,
      );
  @override
  bool operator ==(Object other) =>
      other is HyperStepSize &&
      nodeSize == other.nodeSize &&
      iconSize == other.iconSize &&
      connectorThickness == other.connectorThickness &&
      spacing == other.spacing &&
      titleSpacing == other.titleSpacing &&
      itemSpacing == other.itemSpacing &&
      interactionRadius == other.interactionRadius;
  @override
  int get hashCode => Object.hashAll([
    nodeSize,
    iconSize,
    connectorThickness,
    spacing,
    titleSpacing,
    itemSpacing,
    interactionRadius,
  ]);
}
