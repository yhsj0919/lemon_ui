import 'package:flutter/painting.dart';
import 'package:flutter/foundation.dart';

@immutable
final class HyperBottomSheetSize {
  const HyperBottomSheetSize({
    required this.maxWidth,
    required this.radius,
    required this.titleSpacing,
    required this.actionSpacing,
    required this.actionRunSpacing,
    required this.closeIconSize,
    required this.dragHandleRadius,
    required this.dragHandleSize,
    required this.dragHandlePadding,
    required this.padding,
  });
  final double maxWidth;
  final double radius;
  final double titleSpacing;
  final double actionSpacing;
  final double actionRunSpacing;
  final double closeIconSize;
  final double dragHandleRadius;
  final Size dragHandleSize;
  final EdgeInsetsGeometry dragHandlePadding;
  final EdgeInsetsGeometry padding;
  HyperBottomSheetSize copyWith({
    double? maxWidth,
    double? radius,
    double? titleSpacing,
    double? actionSpacing,
    double? actionRunSpacing,
    double? closeIconSize,
    double? dragHandleRadius,
    Size? dragHandleSize,
    EdgeInsetsGeometry? dragHandlePadding,
    EdgeInsetsGeometry? padding,
  }) => HyperBottomSheetSize(
    maxWidth: maxWidth ?? this.maxWidth,
    radius: radius ?? this.radius,
    titleSpacing: titleSpacing ?? this.titleSpacing,
    actionSpacing: actionSpacing ?? this.actionSpacing,
    actionRunSpacing: actionRunSpacing ?? this.actionRunSpacing,
    closeIconSize: closeIconSize ?? this.closeIconSize,
    dragHandleRadius: dragHandleRadius ?? this.dragHandleRadius,
    dragHandleSize: dragHandleSize ?? this.dragHandleSize,
    dragHandlePadding: dragHandlePadding ?? this.dragHandlePadding,
    padding: padding ?? this.padding,
  );
  static HyperBottomSheetSize lerp(
    HyperBottomSheetSize a,
    HyperBottomSheetSize b,
    double t,
  ) => HyperBottomSheetSize(
    maxWidth: a.maxWidth + (b.maxWidth - a.maxWidth) * t,
    radius: a.radius + (b.radius - a.radius) * t,
    titleSpacing: a.titleSpacing + (b.titleSpacing - a.titleSpacing) * t,
    actionSpacing: a.actionSpacing + (b.actionSpacing - a.actionSpacing) * t,
    actionRunSpacing:
        a.actionRunSpacing + (b.actionRunSpacing - a.actionRunSpacing) * t,
    closeIconSize: a.closeIconSize + (b.closeIconSize - a.closeIconSize) * t,
    dragHandleRadius:
        a.dragHandleRadius + (b.dragHandleRadius - a.dragHandleRadius) * t,
    dragHandleSize: Size.lerp(a.dragHandleSize, b.dragHandleSize, t)!,
    dragHandlePadding: EdgeInsetsGeometry.lerp(
      a.dragHandlePadding,
      b.dragHandlePadding,
      t,
    )!,
    padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t)!,
  );
  @override
  bool operator ==(Object other) =>
      other is HyperBottomSheetSize &&
      maxWidth == other.maxWidth &&
      radius == other.radius &&
      titleSpacing == other.titleSpacing &&
      actionSpacing == other.actionSpacing &&
      actionRunSpacing == other.actionRunSpacing &&
      closeIconSize == other.closeIconSize &&
      dragHandleRadius == other.dragHandleRadius &&
      dragHandleSize == other.dragHandleSize &&
      dragHandlePadding == other.dragHandlePadding &&
      padding == other.padding;
  @override
  int get hashCode => Object.hashAll([
    maxWidth,
    radius,
    titleSpacing,
    actionSpacing,
    actionRunSpacing,
    closeIconSize,
    dragHandleRadius,
    dragHandleSize,
    dragHandlePadding,
    padding,
  ]);
}
