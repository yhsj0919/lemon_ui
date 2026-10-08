import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_notification_center_style.dart';

@immutable
final class HyperNotificationCenterThemeData {
  const HyperNotificationCenterThemeData({
    this.style = const HyperNotificationCenterStyle(),
  });
  final HyperNotificationCenterStyle style;
  HyperNotificationCenterThemeData copyWith({
    HyperNotificationCenterStyle? style,
  }) => HyperNotificationCenterThemeData(style: style ?? this.style);
  HyperNotificationCenterThemeData merge(
    HyperNotificationCenterThemeData? other,
  ) => other == null
      ? this
      : HyperNotificationCenterThemeData(style: style.merge(other.style));
  static HyperNotificationCenterThemeData lerp(
    HyperNotificationCenterThemeData a,
    HyperNotificationCenterThemeData b,
    double t,
  ) => HyperNotificationCenterThemeData(
    style: HyperNotificationCenterStyle.lerp(a.style, b.style, t),
  );
  @override
  bool operator ==(Object other) =>
      other is HyperNotificationCenterThemeData && style == other.style;
  @override
  int get hashCode => style.hashCode;
}

class HyperNotificationCenterTheme extends StatelessWidget {
  const HyperNotificationCenterTheme({
    super.key,
    required this.data,
    required this.child,
  });
  final HyperNotificationCenterThemeData data;
  final Widget child;
  static HyperNotificationCenterThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_Scope>()?.data ??
      HyperTheme.of(context).notificationCenterTheme;
  @override
  Widget build(BuildContext context) =>
      _Scope(data: of(context).merge(data), child: child);
}

class _Scope extends InheritedTheme {
  const _Scope({required this.data, required super.child});
  final HyperNotificationCenterThemeData data;
  @override
  bool updateShouldNotify(_Scope oldWidget) => data != oldWidget.data;
  @override
  Widget wrap(BuildContext context, Widget child) =>
      _Scope(data: data, child: child);
}
