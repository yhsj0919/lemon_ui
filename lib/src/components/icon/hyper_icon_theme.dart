import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_icon_style.dart';

/// HyperIcon 的全局或局部主题。
@immutable
final class HyperIconThemeData {
  const HyperIconThemeData({this.style = const HyperIconStyle()});

  /// 所有 HyperIcon 共用的样式。
  final HyperIconStyle style;

  /// 合并一层主题覆盖。
  HyperIconThemeData merge(HyperIconThemeData? other) {
    if (other == null) return this;
    return HyperIconThemeData(style: style.merge(other.style));
  }

  static HyperIconThemeData lerp(
    HyperIconThemeData a,
    HyperIconThemeData b,
    double t,
  ) => HyperIconThemeData(style: HyperIconStyle.lerp(a.style, b.style, t));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HyperIconThemeData && other.style == style;

  @override
  int get hashCode => style.hashCode;
}

/// 仅覆盖当前子树图标主题的轻量作用域。
class HyperIconTheme extends StatelessWidget {
  const HyperIconTheme({super.key, required this.data, required this.child});

  /// 当前子树追加的图标主题。
  final HyperIconThemeData data;

  /// 使用局部主题的子树。
  final Widget child;

  static HyperIconThemeData of(BuildContext context) =>
      maybeOf(context) ?? HyperTheme.of(context).iconTheme;

  static HyperIconThemeData? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_HyperIconThemeScope>()?.data;

  @override
  Widget build(BuildContext context) =>
      _HyperIconThemeScope(data: of(context).merge(data), child: child);
}

class _HyperIconThemeScope extends InheritedTheme {
  const _HyperIconThemeScope({required this.data, required super.child});

  final HyperIconThemeData data;

  @override
  bool updateShouldNotify(_HyperIconThemeScope oldWidget) =>
      data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) =>
      _HyperIconThemeScope(data: data, child: child);
}
