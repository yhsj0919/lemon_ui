import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_app_bar_style.dart';

/// 固定与滚动顶栏共用的视觉主题。
@immutable
final class HyperAppBarThemeData {
  const HyperAppBarThemeData({this.style});

  final HyperAppBarStyle? style;

  HyperAppBarThemeData copyWith({HyperAppBarStyle? style}) =>
      HyperAppBarThemeData(style: style ?? this.style);

  HyperAppBarThemeData merge(HyperAppBarThemeData? other) =>
      HyperAppBarThemeData(style: style?.merge(other?.style) ?? other?.style);

  static HyperAppBarThemeData lerp(
    HyperAppBarThemeData a,
    HyperAppBarThemeData b,
    double t,
  ) => HyperAppBarThemeData(
    style: a.style == null || b.style == null
        ? (t < .5 ? a.style : b.style)
        : HyperAppBarStyle.lerp(a.style!, b.style!, t),
  );

  @override
  bool operator ==(Object other) =>
      other is HyperAppBarThemeData && other.style == style;

  @override
  int get hashCode => style.hashCode;
}

/// 为子树覆盖顶栏主题。
class HyperAppBarTheme extends StatelessWidget {
  const HyperAppBarTheme({super.key, required this.data, required this.child});

  final HyperAppBarThemeData data;
  final Widget child;

  static HyperAppBarThemeData of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<_HyperAppBarThemeScope>()
          ?.data ??
      HyperTheme.of(context).appBarTheme;

  @override
  Widget build(BuildContext context) =>
      _HyperAppBarThemeScope(data: of(context).merge(data), child: child);
}

class _HyperAppBarThemeScope extends InheritedTheme {
  const _HyperAppBarThemeScope({required this.data, required super.child});

  final HyperAppBarThemeData data;

  @override
  bool updateShouldNotify(_HyperAppBarThemeScope oldWidget) =>
      data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) =>
      _HyperAppBarThemeScope(data: data, child: child);
}
