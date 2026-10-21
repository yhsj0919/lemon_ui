import 'package:flutter/foundation.dart';

@immutable
final class HyperTableSize {
  const HyperTableSize({
    required this.treeIndent,
    this.liftRadius = 4,
    this.headerFontSize = 14,
    required this.rowHeight,
    required this.headerHeight,
    required this.columnWidth,
    required this.minimumColumnWidth,
    required this.controlColumnWidth,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.iconSize,
    required this.borderWidth,
    required this.radius,
  });
  final double treeIndent;
  final double liftRadius;
  final double headerFontSize;
  final double rowHeight;
  final double headerHeight;
  final double columnWidth;
  final double minimumColumnWidth;
  final double controlColumnWidth;
  final double horizontalPadding;
  final double verticalPadding;
  final double iconSize;
  final double borderWidth;
  final double radius;
  HyperTableSize copyWith({
    double? treeIndent,
    double? liftRadius,
    double? headerFontSize,
    double? rowHeight,
    double? headerHeight,
    double? columnWidth,
    double? minimumColumnWidth,
    double? controlColumnWidth,
    double? horizontalPadding,
    double? verticalPadding,
    double? iconSize,
    double? borderWidth,
    double? radius,
  }) => HyperTableSize(
    treeIndent: treeIndent ?? this.treeIndent,
    liftRadius: liftRadius ?? this.liftRadius,
    headerFontSize: headerFontSize ?? this.headerFontSize,
    rowHeight: rowHeight ?? this.rowHeight,
    headerHeight: headerHeight ?? this.headerHeight,
    columnWidth: columnWidth ?? this.columnWidth,
    minimumColumnWidth: minimumColumnWidth ?? this.minimumColumnWidth,
    controlColumnWidth: controlColumnWidth ?? this.controlColumnWidth,
    horizontalPadding: horizontalPadding ?? this.horizontalPadding,
    verticalPadding: verticalPadding ?? this.verticalPadding,
    iconSize: iconSize ?? this.iconSize,
    borderWidth: borderWidth ?? this.borderWidth,
    radius: radius ?? this.radius,
  );
  static HyperTableSize lerp(HyperTableSize a, HyperTableSize b, double t) =>
      HyperTableSize(
        treeIndent: a.treeIndent + (b.treeIndent - a.treeIndent) * t,
        liftRadius: a.liftRadius + (b.liftRadius - a.liftRadius) * t,
        headerFontSize:
            a.headerFontSize + (b.headerFontSize - a.headerFontSize) * t,
        rowHeight: a.rowHeight + (b.rowHeight - a.rowHeight) * t,
        headerHeight: a.headerHeight + (b.headerHeight - a.headerHeight) * t,
        columnWidth: a.columnWidth + (b.columnWidth - a.columnWidth) * t,
        minimumColumnWidth:
            a.minimumColumnWidth +
            (b.minimumColumnWidth - a.minimumColumnWidth) * t,
        controlColumnWidth:
            a.controlColumnWidth +
            (b.controlColumnWidth - a.controlColumnWidth) * t,
        horizontalPadding:
            a.horizontalPadding +
            (b.horizontalPadding - a.horizontalPadding) * t,
        verticalPadding:
            a.verticalPadding + (b.verticalPadding - a.verticalPadding) * t,
        iconSize: a.iconSize + (b.iconSize - a.iconSize) * t,
        borderWidth: a.borderWidth + (b.borderWidth - a.borderWidth) * t,
        radius: a.radius + (b.radius - a.radius) * t,
      );
  @override
  bool operator ==(Object other) =>
      other is HyperTableSize &&
      treeIndent == other.treeIndent &&
      liftRadius == other.liftRadius &&
      headerFontSize == other.headerFontSize &&
      rowHeight == other.rowHeight &&
      headerHeight == other.headerHeight &&
      columnWidth == other.columnWidth &&
      minimumColumnWidth == other.minimumColumnWidth &&
      controlColumnWidth == other.controlColumnWidth &&
      horizontalPadding == other.horizontalPadding &&
      verticalPadding == other.verticalPadding &&
      iconSize == other.iconSize &&
      borderWidth == other.borderWidth &&
      radius == other.radius;
  @override
  int get hashCode => Object.hashAll([
    treeIndent,
    liftRadius,
    headerFontSize,
    rowHeight,
    headerHeight,
    columnWidth,
    minimumColumnWidth,
    controlColumnWidth,
    horizontalPadding,
    verticalPadding,
    iconSize,
    borderWidth,
    radius,
  ]);
}
