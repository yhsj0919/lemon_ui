import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_field_style.dart';

@immutable
final class HyperFieldThemeData {
  const HyperFieldThemeData({this.style = const HyperFieldStyle()});
  final HyperFieldStyle style;

  HyperFieldThemeData copyWith({HyperFieldStyle? style}) =>
      HyperFieldThemeData(style: style ?? this.style);
  HyperFieldThemeData merge(HyperFieldThemeData? other) => other == null
      ? this
      : HyperFieldThemeData(style: style.merge(other.style));
  static HyperFieldThemeData lerp(
    HyperFieldThemeData a,
    HyperFieldThemeData b,
    double t,
  ) => HyperFieldThemeData(style: HyperFieldStyle.lerp(a.style, b.style, t));

  @override
  bool operator ==(Object other) =>
      other is HyperFieldThemeData && style == other.style;
  @override
  int get hashCode => Object.hashAll([style]);
}

class HyperFieldTheme extends StatelessWidget {
  const HyperFieldTheme({super.key, required this.data, required this.child});
  final HyperFieldThemeData data;
  final Widget child;
  static HyperFieldThemeData of(BuildContext context) =>
      HyperTheme.of(context).fieldTheme.merge(maybeOf(context));
  static HyperFieldThemeData? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_Scope>()?.data;
  @override
  Widget build(BuildContext context) => _Scope(
    data: (maybeOf(context) ?? const HyperFieldThemeData()).merge(data),
    child: child,
  );
}

class _Scope extends InheritedTheme {
  const _Scope({required this.data, required super.child});
  final HyperFieldThemeData data;
  @override
  bool updateShouldNotify(_Scope oldWidget) => data != oldWidget.data;
  @override
  Widget wrap(BuildContext context, Widget child) =>
      _Scope(data: data, child: child);
}
