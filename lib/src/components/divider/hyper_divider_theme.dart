import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_divider_style.dart';

/// HyperDivider 的全局或局部主题。
@immutable
final class HyperDividerThemeData {
  const HyperDividerThemeData({this.style = const HyperDividerStyle()});

  /// 所有 HyperDivider 共用的样式。
  final HyperDividerStyle style;

  /// 合并一层主题覆盖。
  HyperDividerThemeData merge(HyperDividerThemeData? other) {
    if (other == null) return this;
    return HyperDividerThemeData(style: style.merge(other.style));
  }

  static HyperDividerThemeData lerp(
    HyperDividerThemeData a,
    HyperDividerThemeData b,
    double t,
  ) =>
      HyperDividerThemeData(style: HyperDividerStyle.lerp(a.style, b.style, t));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HyperDividerThemeData && other.style == style;

  @override
  int get hashCode => style.hashCode;
}

/// 仅覆盖当前子树分隔线主题的轻量作用域。
class HyperDividerTheme extends StatelessWidget {
  const HyperDividerTheme({super.key, required this.data, required this.child});

  /// 当前子树追加的分隔线主题。
  final HyperDividerThemeData data;

  /// 使用局部主题的子树。
  final Widget child;

  static HyperDividerThemeData of(BuildContext context) =>
      maybeOf(context) ?? HyperTheme.of(context).dividerTheme;

  static HyperDividerThemeData? maybeOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<_HyperDividerThemeScope>()
      ?.data;

  @override
  Widget build(BuildContext context) =>
      _HyperDividerThemeScope(data: of(context).merge(data), child: child);
}

class _HyperDividerThemeScope extends InheritedTheme {
  const _HyperDividerThemeScope({required this.data, required super.child});

  final HyperDividerThemeData data;

  @override
  bool updateShouldNotify(_HyperDividerThemeScope oldWidget) =>
      data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) =>
      _HyperDividerThemeScope(data: data, child: child);
}
