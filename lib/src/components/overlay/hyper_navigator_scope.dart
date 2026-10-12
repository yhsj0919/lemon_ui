import 'package:flutter/widgets.dart';

/// 为嵌套工作区指定模态入口默认使用的 Navigator。
///
/// 不管理路由或样式；显式调用参数优先，无作用域时保持根 Navigator 默认。
class HyperNavigatorScope extends InheritedTheme {
  const HyperNavigatorScope({
    super.key,
    required this.useRootNavigator,
    required super.child,
  });

  final bool useRootNavigator;

  static bool resolve(BuildContext context, {bool? useRootNavigator}) =>
      useRootNavigator ??
      context
          .dependOnInheritedWidgetOfExactType<HyperNavigatorScope>()
          ?.useRootNavigator ??
      true;

  @override
  bool updateShouldNotify(HyperNavigatorScope oldWidget) =>
      oldWidget.useRootNavigator != useRootNavigator;

  @override
  Widget wrap(BuildContext context, Widget child) =>
      HyperNavigatorScope(useRootNavigator: useRootNavigator, child: child);
}
