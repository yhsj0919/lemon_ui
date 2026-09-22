import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_switch_style.dart';

@immutable
final class HyperSwitchThemeData {
  const HyperSwitchThemeData({this.style});
  final HyperSwitchStyle? style;

  HyperSwitchThemeData merge(HyperSwitchThemeData? other) =>
      HyperSwitchThemeData(
        style: style?.merge(other?.style) ?? other?.style ?? style,
      );

  static HyperSwitchThemeData lerp(
    HyperSwitchThemeData a,
    HyperSwitchThemeData b,
    double t,
  ) {
    if (a.style == null || b.style == null) return t < .5 ? a : b;
    return HyperSwitchThemeData(
      style: HyperSwitchStyle.lerp(a.style!, b.style!, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HyperSwitchThemeData && other.style == style;
  @override
  int get hashCode => style.hashCode;
}

class HyperSwitchTheme extends StatelessWidget {
  const HyperSwitchTheme({super.key, required this.data, required this.child});
  final HyperSwitchThemeData data;
  final Widget child;

  static HyperSwitchThemeData of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<_HyperSwitchThemeScope>()
          ?.data ??
      HyperTheme.of(context).switchTheme;

  @override
  Widget build(BuildContext context) =>
      _HyperSwitchThemeScope(data: of(context).merge(data), child: child);
}

class _HyperSwitchThemeScope extends InheritedTheme {
  const _HyperSwitchThemeScope({required this.data, required super.child});
  final HyperSwitchThemeData data;
  @override
  bool updateShouldNotify(_HyperSwitchThemeScope oldWidget) =>
      data != oldWidget.data;
  @override
  Widget wrap(BuildContext context, Widget child) =>
      _HyperSwitchThemeScope(data: data, child: child);
}
