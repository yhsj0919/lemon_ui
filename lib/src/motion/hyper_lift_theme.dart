import 'package:flutter/widgets.dart';

import '../theme/core/hyper_theme.dart';
import 'hyper_lift_style.dart';

@immutable
final class HyperLiftThemeData {
  const HyperLiftThemeData({this.style = const HyperLiftStyle()});
  final HyperLiftStyle style;
  HyperLiftThemeData copyWith({HyperLiftStyle? style}) =>
      HyperLiftThemeData(style: this.style.merge(style));
  HyperLiftThemeData merge(HyperLiftThemeData? other) =>
      copyWith(style: other?.style);
  static HyperLiftThemeData lerp(
    HyperLiftThemeData a,
    HyperLiftThemeData b,
    double t,
  ) => HyperLiftThemeData(style: HyperLiftStyle.lerp(a.style, b.style, t));
  @override
  bool operator ==(Object other) =>
      other is HyperLiftThemeData && style == other.style;
  @override
  int get hashCode => style.hashCode;
}

/// Scoped lift overrides, captured by the shared overlay theme infrastructure.
class HyperLiftTheme extends StatelessWidget {
  const HyperLiftTheme({super.key, required this.data, required this.child});
  final HyperLiftThemeData data;
  final Widget child;
  static HyperLiftThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_LiftScope>()?.data ??
      HyperTheme.of(context).motion.lift;
  @override
  Widget build(BuildContext context) =>
      _LiftScope(data: of(context).merge(data), child: child);
}

class _LiftScope extends InheritedTheme {
  const _LiftScope({required this.data, required super.child});
  final HyperLiftThemeData data;
  @override
  Widget wrap(BuildContext context, Widget child) =>
      _LiftScope(data: data, child: child);
  @override
  bool updateShouldNotify(_LiftScope oldWidget) => data != oldWidget.data;
}
