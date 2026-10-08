import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

@immutable
final class HyperNotificationSize {
  const HyperNotificationSize({
    required this.radius,
    required this.padding,
    required this.iconSize,
    required this.unreadSize,
    required this.closeIconSize,
    required this.closeButtonSize,
    required this.spacing,
    required this.titleSpacing,
    required this.actionSpacing,
    required this.actionRunSpacing,
  });
  final double radius;
  final EdgeInsetsGeometry padding;
  final double iconSize;
  final double unreadSize;
  final double closeIconSize;
  final double closeButtonSize;
  final double spacing;
  final double titleSpacing;
  final double actionSpacing;
  final double actionRunSpacing;
  HyperNotificationSize copyWith({
    double? radius,
    EdgeInsetsGeometry? padding,
    double? iconSize,
    double? unreadSize,
    double? closeIconSize,
    double? closeButtonSize,
    double? spacing,
    double? titleSpacing,
    double? actionSpacing,
    double? actionRunSpacing,
  }) => HyperNotificationSize(
    radius: radius ?? this.radius,
    padding: padding ?? this.padding,
    iconSize: iconSize ?? this.iconSize,
    unreadSize: unreadSize ?? this.unreadSize,
    closeIconSize: closeIconSize ?? this.closeIconSize,
    closeButtonSize: closeButtonSize ?? this.closeButtonSize,
    spacing: spacing ?? this.spacing,
    titleSpacing: titleSpacing ?? this.titleSpacing,
    actionSpacing: actionSpacing ?? this.actionSpacing,
    actionRunSpacing: actionRunSpacing ?? this.actionRunSpacing,
  );
  static HyperNotificationSize lerp(
    HyperNotificationSize a,
    HyperNotificationSize b,
    double t,
  ) => HyperNotificationSize(
    radius: a.radius + (b.radius - a.radius) * t,
    padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t)!,
    iconSize: a.iconSize + (b.iconSize - a.iconSize) * t,
    unreadSize: a.unreadSize + (b.unreadSize - a.unreadSize) * t,
    closeIconSize: a.closeIconSize + (b.closeIconSize - a.closeIconSize) * t,
    closeButtonSize:
        a.closeButtonSize + (b.closeButtonSize - a.closeButtonSize) * t,
    spacing: a.spacing + (b.spacing - a.spacing) * t,
    titleSpacing: a.titleSpacing + (b.titleSpacing - a.titleSpacing) * t,
    actionSpacing: a.actionSpacing + (b.actionSpacing - a.actionSpacing) * t,
    actionRunSpacing:
        a.actionRunSpacing + (b.actionRunSpacing - a.actionRunSpacing) * t,
  );
  @override
  bool operator ==(Object other) =>
      other is HyperNotificationSize &&
      radius == other.radius &&
      padding == other.padding &&
      iconSize == other.iconSize &&
      unreadSize == other.unreadSize &&
      closeIconSize == other.closeIconSize &&
      closeButtonSize == other.closeButtonSize &&
      spacing == other.spacing &&
      titleSpacing == other.titleSpacing &&
      actionSpacing == other.actionSpacing &&
      actionRunSpacing == other.actionRunSpacing;
  @override
  int get hashCode => Object.hashAll([
    radius,
    padding,
    iconSize,
    unreadSize,
    closeIconSize,
    closeButtonSize,
    spacing,
    titleSpacing,
    actionSpacing,
    actionRunSpacing,
  ]);
}
