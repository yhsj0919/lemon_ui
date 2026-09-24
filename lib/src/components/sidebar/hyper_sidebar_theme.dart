import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_sidebar_style.dart';

/// 侧栏全局与局部主题。
@immutable
final class HyperSidebarThemeData {
  const HyperSidebarThemeData({this.style});

  final HyperSidebarStyle? style;

  HyperSidebarThemeData copyWith({HyperSidebarStyle? style}) =>
      HyperSidebarThemeData(style: style ?? this.style);

  HyperSidebarThemeData merge(HyperSidebarThemeData? other) =>
      HyperSidebarThemeData(style: style?.merge(other?.style) ?? other?.style);

  static HyperSidebarThemeData lerp(
    HyperSidebarThemeData a,
    HyperSidebarThemeData b,
    double t,
  ) => HyperSidebarThemeData(
    style: a.style == null || b.style == null
        ? (t < .5 ? a.style : b.style)
        : HyperSidebarStyle.lerp(a.style!, b.style!, t),
  );

  @override
  bool operator ==(Object other) =>
      other is HyperSidebarThemeData && other.style == style;

  @override
  int get hashCode => style.hashCode;
}

/// 为当前子树覆盖侧栏主题。
class HyperSidebarTheme extends StatelessWidget {
  const HyperSidebarTheme({super.key, required this.data, required this.child});

  final HyperSidebarThemeData data;
  final Widget child;

  static HyperSidebarThemeData of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<_HyperSidebarThemeScope>()
          ?.data ??
      HyperTheme.of(context).sidebarTheme;

  @override
  Widget build(BuildContext context) =>
      _HyperSidebarThemeScope(data: of(context).merge(data), child: child);
}

class _HyperSidebarThemeScope extends InheritedTheme {
  const _HyperSidebarThemeScope({required this.data, required super.child});

  final HyperSidebarThemeData data;

  @override
  bool updateShouldNotify(_HyperSidebarThemeScope oldWidget) =>
      data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) =>
      _HyperSidebarThemeScope(data: data, child: child);
}
