import 'package:flutter/foundation.dart';

/// 侧栏在当前设备上的尺寸规格。
@immutable
final class HyperSidebarSize {
  const HyperSidebarSize({
    required this.width,
    required this.collapsedWidth,
    required this.itemHeight,
    required this.iconSize,
    required this.itemSpacing,
    required this.rowGap,
    required this.indent,
    required this.sectionSpacing,
    required this.horizontalPadding,
    required this.popupWidth,
    required this.itemRadius,
  });

  final double width;
  final double collapsedWidth;
  final double itemHeight;
  final double iconSize;
  final double itemSpacing;
  final double rowGap;
  final double indent;
  final double sectionSpacing;
  final double horizontalPadding;
  final double popupWidth;
  final double itemRadius;

  HyperSidebarSize copyWith({
    double? width,
    double? collapsedWidth,
    double? itemHeight,
    double? iconSize,
    double? itemSpacing,
    double? rowGap,
    double? indent,
    double? sectionSpacing,
    double? horizontalPadding,
    double? popupWidth,
    double? itemRadius,
  }) => HyperSidebarSize(
    width: width ?? this.width,
    collapsedWidth: collapsedWidth ?? this.collapsedWidth,
    itemHeight: itemHeight ?? this.itemHeight,
    iconSize: iconSize ?? this.iconSize,
    itemSpacing: itemSpacing ?? this.itemSpacing,
    rowGap: rowGap ?? this.rowGap,
    indent: indent ?? this.indent,
    sectionSpacing: sectionSpacing ?? this.sectionSpacing,
    horizontalPadding: horizontalPadding ?? this.horizontalPadding,
    popupWidth: popupWidth ?? this.popupWidth,
    itemRadius: itemRadius ?? this.itemRadius,
  );

  static HyperSidebarSize lerp(
    HyperSidebarSize a,
    HyperSidebarSize b,
    double t,
  ) {
    double value(double x, double y) => x + (y - x) * t;
    return HyperSidebarSize(
      width: value(a.width, b.width),
      collapsedWidth: value(a.collapsedWidth, b.collapsedWidth),
      itemHeight: value(a.itemHeight, b.itemHeight),
      iconSize: value(a.iconSize, b.iconSize),
      itemSpacing: value(a.itemSpacing, b.itemSpacing),
      rowGap: value(a.rowGap, b.rowGap),
      indent: value(a.indent, b.indent),
      sectionSpacing: value(a.sectionSpacing, b.sectionSpacing),
      horizontalPadding: value(a.horizontalPadding, b.horizontalPadding),
      popupWidth: value(a.popupWidth, b.popupWidth),
      itemRadius: value(a.itemRadius, b.itemRadius),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HyperSidebarSize &&
          other.width == width &&
          other.collapsedWidth == collapsedWidth &&
          other.itemHeight == itemHeight &&
          other.iconSize == iconSize &&
          other.itemSpacing == itemSpacing &&
          other.rowGap == rowGap &&
          other.indent == indent &&
          other.sectionSpacing == sectionSpacing &&
          other.horizontalPadding == horizontalPadding &&
          other.popupWidth == popupWidth &&
          other.itemRadius == itemRadius;

  @override
  int get hashCode => Object.hash(
    width,
    collapsedWidth,
    itemHeight,
    iconSize,
    itemSpacing,
    rowGap,
    indent,
    sectionSpacing,
    horizontalPadding,
    popupWidth,
    itemRadius,
  );
}
