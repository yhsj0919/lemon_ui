import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_drawer_style.dart';

/// 通用抽屉的全局或局部主题。
@immutable
final class HyperDrawerThemeData {
  const HyperDrawerThemeData({this.style});

  final HyperDrawerStyle? style;

  HyperDrawerThemeData copyWith({HyperDrawerStyle? style}) =>
      HyperDrawerThemeData(style: style ?? this.style);

  HyperDrawerThemeData merge(HyperDrawerThemeData? other) =>
      HyperDrawerThemeData(style: style?.merge(other?.style) ?? other?.style);

  static HyperDrawerThemeData lerp(
    HyperDrawerThemeData a,
    HyperDrawerThemeData b,
    double t,
  ) => HyperDrawerThemeData(
    style: a.style == null || b.style == null
        ? (t < .5 ? a.style : b.style)
        : HyperDrawerStyle.lerp(a.style!, b.style!, t),
  );

  @override
  bool operator ==(Object other) =>
      other is HyperDrawerThemeData && other.style == style;

  @override
  int get hashCode => style.hashCode;
}

/// 为当前子树覆盖抽屉主题。
class HyperDrawerTheme extends StatelessWidget {
  const HyperDrawerTheme({super.key, required this.data, required this.child});

  final HyperDrawerThemeData data;
  final Widget child;

  static HyperDrawerThemeData of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<_HyperDrawerThemeScope>()
          ?.data ??
      HyperTheme.of(context).drawerTheme;

  @override
  Widget build(BuildContext context) =>
      _HyperDrawerThemeScope(data: of(context).merge(data), child: child);
}

class _HyperDrawerThemeScope extends InheritedTheme {
  const _HyperDrawerThemeScope({required this.data, required super.child});

  final HyperDrawerThemeData data;

  @override
  bool updateShouldNotify(_HyperDrawerThemeScope oldWidget) =>
      data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) =>
      _HyperDrawerThemeScope(data: data, child: child);
}
