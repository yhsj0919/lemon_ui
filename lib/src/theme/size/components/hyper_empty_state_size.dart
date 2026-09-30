import 'package:flutter/painting.dart';
import 'package:flutter/foundation.dart';

@immutable
final class HyperEmptyStateSize {
  const HyperEmptyStateSize({
    required this.iconSize,
    required this.illustrationSize,
    required this.maxWidth,
    required this.contentSpacing,
    required this.titleSpacing,
    required this.actionSpacing,
    required this.actionRunSpacing,
    required this.padding,
  });
  final double iconSize,
      illustrationSize,
      maxWidth,
      contentSpacing,
      titleSpacing,
      actionSpacing,
      actionRunSpacing;
  final EdgeInsetsGeometry padding;
  HyperEmptyStateSize copyWith({
    double? iconSize,
    double? illustrationSize,
    double? maxWidth,
    double? contentSpacing,
    double? titleSpacing,
    double? actionSpacing,
    double? actionRunSpacing,
    EdgeInsetsGeometry? padding,
  }) => HyperEmptyStateSize(
    iconSize: iconSize ?? this.iconSize,
    illustrationSize: illustrationSize ?? this.illustrationSize,
    maxWidth: maxWidth ?? this.maxWidth,
    contentSpacing: contentSpacing ?? this.contentSpacing,
    titleSpacing: titleSpacing ?? this.titleSpacing,
    actionSpacing: actionSpacing ?? this.actionSpacing,
    actionRunSpacing: actionRunSpacing ?? this.actionRunSpacing,
    padding: padding ?? this.padding,
  );
  static HyperEmptyStateSize lerp(
    HyperEmptyStateSize a,
    HyperEmptyStateSize b,
    double t,
  ) => HyperEmptyStateSize(
    iconSize: a.iconSize + (b.iconSize - a.iconSize) * t,
    illustrationSize:
        a.illustrationSize + (b.illustrationSize - a.illustrationSize) * t,
    maxWidth: a.maxWidth + (b.maxWidth - a.maxWidth) * t,
    contentSpacing:
        a.contentSpacing + (b.contentSpacing - a.contentSpacing) * t,
    titleSpacing: a.titleSpacing + (b.titleSpacing - a.titleSpacing) * t,
    actionSpacing: a.actionSpacing + (b.actionSpacing - a.actionSpacing) * t,
    actionRunSpacing:
        a.actionRunSpacing + (b.actionRunSpacing - a.actionRunSpacing) * t,
    padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t)!,
  );
  @override
  bool operator ==(Object other) =>
      other is HyperEmptyStateSize &&
      other.iconSize == iconSize &&
      other.illustrationSize == illustrationSize &&
      other.maxWidth == maxWidth &&
      other.contentSpacing == contentSpacing &&
      other.titleSpacing == titleSpacing &&
      other.actionSpacing == actionSpacing &&
      other.actionRunSpacing == actionRunSpacing &&
      other.padding == padding;
  @override
  int get hashCode => Object.hash(
    iconSize,
    illustrationSize,
    maxWidth,
    contentSpacing,
    titleSpacing,
    actionSpacing,
    actionRunSpacing,
    padding,
  );
}
