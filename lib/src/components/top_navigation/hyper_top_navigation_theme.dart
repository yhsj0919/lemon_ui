import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_top_navigation_style.dart';

/// 全局或局部的顶部导航外观。
@immutable
final class HyperTopNavigationThemeData {
  const HyperTopNavigationThemeData({this.style});

  /// 非空字段覆盖上一级；按钮及菜单样式逐字段合并。
  final HyperTopNavigationStyle? style;
  HyperTopNavigationThemeData copyWith({HyperTopNavigationStyle? style}) =>
      HyperTopNavigationThemeData(style: style ?? this.style);
  HyperTopNavigationThemeData merge(HyperTopNavigationThemeData? other) =>
      HyperTopNavigationThemeData(
        style: style?.merge(other?.style) ?? other?.style,
      );
  static HyperTopNavigationThemeData lerp(
    HyperTopNavigationThemeData a,
    HyperTopNavigationThemeData b,
    double t,
  ) => HyperTopNavigationThemeData(
    style: a.style == null || b.style == null
        ? (t < .5 ? a.style : b.style)
        : HyperTopNavigationStyle.lerp(a.style!, b.style!, t),
  );
  @override
  bool operator ==(Object other) =>
      other is HyperTopNavigationThemeData && other.style == style;
  @override
  int get hashCode => style.hashCode;
}

/// 仅覆盖子树内显式提供的顶部导航配置。
class HyperTopNavigationTheme extends StatelessWidget {
  const HyperTopNavigationTheme({
    super.key,
    required this.data,
    required this.child,
  });

  /// 当前子树的主题覆盖。
  final HyperTopNavigationThemeData data;

  /// 应用主题的子树。
  final Widget child;
  static HyperTopNavigationThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_Scope>()?.data ??
      HyperTheme.of(context).topNavigationTheme;
  @override
  Widget build(BuildContext context) =>
      _Scope(data: of(context).merge(data), child: child);
}

class _Scope extends InheritedTheme {
  const _Scope({required this.data, required super.child});
  final HyperTopNavigationThemeData data;
  @override
  bool updateShouldNotify(_Scope oldWidget) => oldWidget.data != data;
  @override
  Widget wrap(BuildContext context, Widget child) =>
      _Scope(data: data, child: child);
}
