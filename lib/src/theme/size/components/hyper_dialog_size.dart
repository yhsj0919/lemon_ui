import 'package:flutter/painting.dart';
import 'package:flutter/foundation.dart';

@immutable
final class HyperDialogSize {
  const HyperDialogSize({
    required this.maxWidth,
    required this.radius,
    required this.titleSpacing,
    required this.actionSpacing,
    required this.actionRunSpacing,
    required this.closeIconSize,
    required this.padding,
    required this.insetPadding,
  });
  final double maxWidth;
  final double radius;
  final double titleSpacing;
  final double actionSpacing;
  final double actionRunSpacing;
  final double closeIconSize;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry insetPadding;
  HyperDialogSize copyWith({
    double? maxWidth,
    double? radius,
    double? titleSpacing,
    double? actionSpacing,
    double? actionRunSpacing,
    double? closeIconSize,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? insetPadding,
  }) => HyperDialogSize(
    maxWidth: maxWidth ?? this.maxWidth,
    radius: radius ?? this.radius,
    titleSpacing: titleSpacing ?? this.titleSpacing,
    actionSpacing: actionSpacing ?? this.actionSpacing,
    actionRunSpacing: actionRunSpacing ?? this.actionRunSpacing,
    closeIconSize: closeIconSize ?? this.closeIconSize,
    padding: padding ?? this.padding,
    insetPadding: insetPadding ?? this.insetPadding,
  );
  static HyperDialogSize lerp(
    HyperDialogSize a,
    HyperDialogSize b,
    double t,
  ) => HyperDialogSize(
    maxWidth: a.maxWidth + (b.maxWidth - a.maxWidth) * t,
    radius: a.radius + (b.radius - a.radius) * t,
    titleSpacing: a.titleSpacing + (b.titleSpacing - a.titleSpacing) * t,
    actionSpacing: a.actionSpacing + (b.actionSpacing - a.actionSpacing) * t,
    actionRunSpacing:
        a.actionRunSpacing + (b.actionRunSpacing - a.actionRunSpacing) * t,
    closeIconSize: a.closeIconSize + (b.closeIconSize - a.closeIconSize) * t,
    padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t)!,
    insetPadding: EdgeInsetsGeometry.lerp(a.insetPadding, b.insetPadding, t)!,
  );
  @override
  bool operator ==(Object other) =>
      other is HyperDialogSize &&
      maxWidth == other.maxWidth &&
      radius == other.radius &&
      titleSpacing == other.titleSpacing &&
      actionSpacing == other.actionSpacing &&
      actionRunSpacing == other.actionRunSpacing &&
      closeIconSize == other.closeIconSize &&
      padding == other.padding &&
      insetPadding == other.insetPadding;
  @override
  int get hashCode => Object.hashAll([
    maxWidth,
    radius,
    titleSpacing,
    actionSpacing,
    actionRunSpacing,
    closeIconSize,
    padding,
    insetPadding,
  ]);
}
