import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_table_style.dart';

@immutable
final class HyperTableThemeData {
  const HyperTableThemeData({this.style = const HyperTableStyle()});
  final HyperTableStyle style;

  HyperTableThemeData copyWith({HyperTableStyle? style}) =>
      HyperTableThemeData(style: style ?? this.style);
  HyperTableThemeData merge(HyperTableThemeData? other) => other == null
      ? this
      : HyperTableThemeData(style: style.merge(other.style));
  static HyperTableThemeData lerp(
    HyperTableThemeData a,
    HyperTableThemeData b,
    double t,
  ) => HyperTableThemeData(style: HyperTableStyle.lerp(a.style, b.style, t));

  @override
  bool operator ==(Object other) =>
      other is HyperTableThemeData && style == other.style;
  @override
  int get hashCode => Object.hashAll([style]);
}

class HyperTableTheme extends StatelessWidget {
  const HyperTableTheme({super.key, required this.data, required this.child});
  final HyperTableThemeData data;
  final Widget child;
  static HyperTableThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_Scope>()?.data ??
      HyperTheme.of(context).tableTheme;
  @override
  Widget build(BuildContext context) =>
      _Scope(data: of(context).merge(data), child: child);
}

class _Scope extends InheritedTheme {
  const _Scope({required this.data, required super.child});
  final HyperTableThemeData data;
  @override
  bool updateShouldNotify(_Scope oldWidget) => data != oldWidget.data;
  @override
  Widget wrap(BuildContext context, Widget child) =>
      _Scope(data: data, child: child);
}
