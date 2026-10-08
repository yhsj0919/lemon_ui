import 'package:flutter/foundation.dart';

@immutable
final class HyperAccordionSize {
  const HyperAccordionSize({
    required this.spacing,
    required this.dividerThickness,
  });
  final double spacing;
  final double dividerThickness;
  HyperAccordionSize copyWith({double? spacing, double? dividerThickness}) =>
      HyperAccordionSize(
        spacing: spacing ?? this.spacing,
        dividerThickness: dividerThickness ?? this.dividerThickness,
      );
  static HyperAccordionSize lerp(
    HyperAccordionSize a,
    HyperAccordionSize b,
    double t,
  ) => HyperAccordionSize(
    spacing: a.spacing + (b.spacing - a.spacing) * t,
    dividerThickness:
        a.dividerThickness + (b.dividerThickness - a.dividerThickness) * t,
  );
  @override
  bool operator ==(Object other) =>
      other is HyperAccordionSize &&
      spacing == other.spacing &&
      dividerThickness == other.dividerThickness;
  @override
  int get hashCode => Object.hashAll([spacing, dividerThickness]);
}
