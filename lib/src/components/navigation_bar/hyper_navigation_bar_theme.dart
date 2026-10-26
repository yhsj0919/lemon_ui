import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_navigation_bar_style.dart';

@immutable
final class HyperNavigationBarThemeData {
  const HyperNavigationBarThemeData({
    this.style = const HyperNavigationBarStyle(),
  });
  final HyperNavigationBarStyle style;
  HyperNavigationBarThemeData copyWith({HyperNavigationBarStyle? style}) =>
      HyperNavigationBarThemeData(style: this.style.merge(style));
  HyperNavigationBarThemeData merge(HyperNavigationBarThemeData? other) =>
      copyWith(style: other?.style);
  static HyperNavigationBarThemeData lerp(
    HyperNavigationBarThemeData a,
    HyperNavigationBarThemeData b,
    double t,
  ) => HyperNavigationBarThemeData(
    style: HyperNavigationBarStyle.lerp(a.style, b.style, t),
  );
  @override
  bool operator ==(Object other) =>
      other is HyperNavigationBarThemeData && other.style == style;
  @override
  int get hashCode => style.hashCode;
}

class HyperNavigationBarTheme extends StatelessWidget {
  const HyperNavigationBarTheme({
    super.key,
    required this.data,
    required this.child,
  });
  final HyperNavigationBarThemeData data;
  final Widget child;
  static HyperNavigationBarThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_Scope>()?.data ??
      HyperTheme.of(context).navigationBarTheme;
  @override
  Widget build(BuildContext context) =>
      _Scope(data: of(context).merge(data), child: child);
}

class _Scope extends InheritedTheme {
  const _Scope({required this.data, required super.child});
  final HyperNavigationBarThemeData data;
  @override
  Widget wrap(BuildContext context, Widget child) =>
      _Scope(data: data, child: child);
  @override
  bool updateShouldNotify(_Scope oldWidget) => data != oldWidget.data;
}
