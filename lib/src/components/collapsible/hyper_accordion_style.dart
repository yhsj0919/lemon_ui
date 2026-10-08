import 'package:flutter/material.dart';

import 'hyper_collapsible_theme.dart';

@immutable
final class HyperAccordionStyle {
  const HyperAccordionStyle({
    this.spacing,
    this.dividerColor,
    this.dividerThickness,
    this.showDividers,
    this.itemTheme,
  });
  final double? spacing;
  final Color? dividerColor;
  final double? dividerThickness;
  final bool? showDividers;
  final HyperCollapsibleThemeData? itemTheme;
  HyperAccordionStyle copyWith({
    double? spacing,
    Color? dividerColor,
    double? dividerThickness,
    bool? showDividers,
    HyperCollapsibleThemeData? itemTheme,
  }) => HyperAccordionStyle(
    spacing: spacing ?? this.spacing,
    dividerColor: dividerColor ?? this.dividerColor,
    dividerThickness: dividerThickness ?? this.dividerThickness,
    showDividers: showDividers ?? this.showDividers,
    itemTheme: itemTheme ?? this.itemTheme,
  );
  HyperAccordionStyle merge(HyperAccordionStyle? other) => other == null
      ? this
      : HyperAccordionStyle(
          spacing: other.spacing ?? spacing,
          dividerColor: other.dividerColor ?? dividerColor,
          dividerThickness: other.dividerThickness ?? dividerThickness,
          showDividers: other.showDividers ?? showDividers,
          itemTheme: itemTheme?.merge(other.itemTheme) ?? other.itemTheme,
        );
  static HyperAccordionStyle lerp(
    HyperAccordionStyle a,
    HyperAccordionStyle b,
    double t,
  ) {
    if (t == 0) {
      return a;
    }
    if (t == 1) {
      return b;
    }
    return HyperAccordionStyle(
      spacing: a.spacing == null || b.spacing == null
          ? (t < .5 ? a.spacing : b.spacing)
          : a.spacing! + (b.spacing! - a.spacing!) * t,
      dividerColor: Color.lerp(a.dividerColor, b.dividerColor, t),
      dividerThickness: a.dividerThickness == null || b.dividerThickness == null
          ? (t < .5 ? a.dividerThickness : b.dividerThickness)
          : a.dividerThickness! +
                (b.dividerThickness! - a.dividerThickness!) * t,
      showDividers: t < .5 ? a.showDividers : b.showDividers,
      itemTheme: a.itemTheme == null || b.itemTheme == null
          ? (t < .5 ? a.itemTheme : b.itemTheme)
          : HyperCollapsibleThemeData.lerp(a.itemTheme!, b.itemTheme!, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is HyperAccordionStyle &&
      spacing == other.spacing &&
      dividerColor == other.dividerColor &&
      dividerThickness == other.dividerThickness &&
      showDividers == other.showDividers &&
      itemTheme == other.itemTheme;
  @override
  int get hashCode => Object.hashAll([
    spacing,
    dividerColor,
    dividerThickness,
    showDividers,
    itemTheme,
  ]);
}
