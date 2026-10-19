import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_field_style.dart';

@immutable
final class HyperFormThemeData {
  const HyperFormThemeData({this.style = const HyperFieldStyle()});
  final HyperFieldStyle style;

  HyperFormThemeData copyWith({HyperFieldStyle? style}) =>
      HyperFormThemeData(style: style ?? this.style);
  HyperFormThemeData merge(HyperFormThemeData? other) => other == null
      ? this
      : HyperFormThemeData(style: style.merge(other.style));
  static HyperFormThemeData lerp(
    HyperFormThemeData a,
    HyperFormThemeData b,
    double t,
  ) => HyperFormThemeData(style: HyperFieldStyle.lerp(a.style, b.style, t));

  @override
  bool operator ==(Object other) =>
      other is HyperFormThemeData && style == other.style;
  @override
  int get hashCode => Object.hashAll([style]);
}

class HyperFormTheme extends StatelessWidget {
  const HyperFormTheme({super.key, required this.data, required this.child});
  final HyperFormThemeData data;
  final Widget child;
  static HyperFormThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_Scope>()?.data ??
      HyperTheme.of(context).formTheme;
  @override
  Widget build(BuildContext context) =>
      _Scope(data: of(context).merge(data), child: child);
}

class _Scope extends InheritedTheme {
  const _Scope({required this.data, required super.child});
  final HyperFormThemeData data;
  @override
  bool updateShouldNotify(_Scope oldWidget) => data != oldWidget.data;
  @override
  Widget wrap(BuildContext context, Widget child) =>
      _Scope(data: data, child: child);
}
