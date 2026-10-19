import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_calendar_style.dart';

@immutable
final class HyperCalendarThemeData {
  const HyperCalendarThemeData({this.style = const HyperCalendarStyle()});
  final HyperCalendarStyle style;

  HyperCalendarThemeData copyWith({HyperCalendarStyle? style}) =>
      HyperCalendarThemeData(style: style ?? this.style);
  HyperCalendarThemeData merge(HyperCalendarThemeData? other) => other == null
      ? this
      : HyperCalendarThemeData(style: style.merge(other.style));
  static HyperCalendarThemeData lerp(
    HyperCalendarThemeData a,
    HyperCalendarThemeData b,
    double t,
  ) => HyperCalendarThemeData(
    style: HyperCalendarStyle.lerp(a.style, b.style, t),
  );

  @override
  bool operator ==(Object other) =>
      other is HyperCalendarThemeData && style == other.style;
  @override
  int get hashCode => Object.hashAll([style]);
}

class HyperCalendarTheme extends StatelessWidget {
  const HyperCalendarTheme({
    super.key,
    required this.data,
    required this.child,
  });
  final HyperCalendarThemeData data;
  final Widget child;
  static HyperCalendarThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_Scope>()?.data ??
      HyperTheme.of(context).calendarTheme;
  @override
  Widget build(BuildContext context) =>
      _Scope(data: of(context).merge(data), child: child);
}

class _Scope extends InheritedTheme {
  const _Scope({required this.data, required super.child});
  final HyperCalendarThemeData data;
  @override
  bool updateShouldNotify(_Scope oldWidget) => data != oldWidget.data;
  @override
  Widget wrap(BuildContext context, Widget child) =>
      _Scope(data: data, child: child);
}
