import 'package:flutter/widgets.dart';

@immutable
final class HyperTreeViewSize {
  const HyperTreeViewSize({
    this.rowSpacing,
    required this.rowHeight,
    required this.indent,
    required this.iconSize,
    required this.contentSpacing,
    required this.rowRadius,
    required this.rowPadding,
  });
  final double? rowSpacing;
  final double rowHeight;
  final double indent;
  final double iconSize;
  final double contentSpacing;
  final double rowRadius;
  final EdgeInsetsGeometry rowPadding;
  HyperTreeViewSize copyWith({
    double? rowSpacing,
    double? rowHeight,
    double? indent,
    double? iconSize,
    double? contentSpacing,
    double? rowRadius,
    EdgeInsetsGeometry? rowPadding,
  }) => HyperTreeViewSize(
    rowSpacing: rowSpacing ?? this.rowSpacing,
    rowHeight: rowHeight ?? this.rowHeight,
    indent: indent ?? this.indent,
    iconSize: iconSize ?? this.iconSize,
    contentSpacing: contentSpacing ?? this.contentSpacing,
    rowRadius: rowRadius ?? this.rowRadius,
    rowPadding: rowPadding ?? this.rowPadding,
  );
  static HyperTreeViewSize lerp(
    HyperTreeViewSize a,
    HyperTreeViewSize b,
    double t,
  ) => HyperTreeViewSize(
    rowSpacing: a.rowSpacing == null || b.rowSpacing == null
        ? (t < .5 ? a.rowSpacing : b.rowSpacing)
        : a.rowSpacing! + (b.rowSpacing! - a.rowSpacing!) * t,
    rowHeight: a.rowHeight + (b.rowHeight - a.rowHeight) * t,
    indent: a.indent + (b.indent - a.indent) * t,
    iconSize: a.iconSize + (b.iconSize - a.iconSize) * t,
    contentSpacing:
        a.contentSpacing + (b.contentSpacing - a.contentSpacing) * t,
    rowRadius: a.rowRadius + (b.rowRadius - a.rowRadius) * t,
    rowPadding: EdgeInsetsGeometry.lerp(a.rowPadding, b.rowPadding, t)!,
  );
  @override
  bool operator ==(Object other) =>
      other is HyperTreeViewSize &&
      rowSpacing == other.rowSpacing &&
      rowHeight == other.rowHeight &&
      indent == other.indent &&
      iconSize == other.iconSize &&
      contentSpacing == other.contentSpacing &&
      rowRadius == other.rowRadius &&
      rowPadding == other.rowPadding;
  @override
  int get hashCode => Object.hash(
    rowSpacing,
    rowHeight,
    indent,
    iconSize,
    contentSpacing,
    rowRadius,
    rowPadding,
  );
}
