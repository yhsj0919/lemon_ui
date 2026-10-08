import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

@immutable
final class HyperNotificationCenterSize {
  const HyperNotificationCenterSize({
    required this.padding,
    required this.spacing,
    required this.groupSpacing,
  });
  final EdgeInsetsGeometry padding;
  final double spacing, groupSpacing;
  HyperNotificationCenterSize copyWith({
    EdgeInsetsGeometry? padding,
    double? spacing,
    double? groupSpacing,
  }) => HyperNotificationCenterSize(
    padding: padding ?? this.padding,
    spacing: spacing ?? this.spacing,
    groupSpacing: groupSpacing ?? this.groupSpacing,
  );
  static HyperNotificationCenterSize lerp(
    HyperNotificationCenterSize a,
    HyperNotificationCenterSize b,
    double t,
  ) => HyperNotificationCenterSize(
    padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t)!,
    spacing: a.spacing + (b.spacing - a.spacing) * t,
    groupSpacing: a.groupSpacing + (b.groupSpacing - a.groupSpacing) * t,
  );
  @override
  bool operator ==(Object other) =>
      other is HyperNotificationCenterSize &&
      padding == other.padding &&
      spacing == other.spacing &&
      groupSpacing == other.groupSpacing;
  @override
  int get hashCode => Object.hash(padding, spacing, groupSpacing);
}
