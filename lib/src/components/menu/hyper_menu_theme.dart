import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_menu_style.dart';

@immutable
final class HyperMenuThemeData {
  const HyperMenuThemeData({this.style});

  final HyperMenuStyle? style;

  HyperMenuThemeData copyWith({HyperMenuStyle? style}) =>
      HyperMenuThemeData(style: this.style?.merge(style) ?? style);

  HyperMenuThemeData merge(HyperMenuThemeData? other) =>
      HyperMenuThemeData(style: style?.merge(other?.style) ?? other?.style);

  static HyperMenuThemeData lerp(
    HyperMenuThemeData a,
    HyperMenuThemeData b,
    double t,
  ) => HyperMenuThemeData(
    style: a.style == null || b.style == null
        ? (t < .5 ? a.style : b.style)
        : HyperMenuStyle.lerp(a.style!, b.style!, t),
  );

  @override
  bool operator ==(Object other) =>
      other is HyperMenuThemeData && other.style == style;

  @override
  int get hashCode => style.hashCode;
}

/// 为当前子树局部覆盖菜单样式。
class HyperMenuTheme extends StatelessWidget {
  const HyperMenuTheme({super.key, required this.data, required this.child});

  final HyperMenuThemeData data;
  final Widget child;

  static HyperMenuThemeData of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<_HyperMenuThemeScope>()
          ?.data ??
      HyperTheme.of(context).menuTheme;

  @override
  Widget build(BuildContext context) =>
      _HyperMenuThemeScope(data: of(context).merge(data), child: child);
}

class _HyperMenuThemeScope extends InheritedTheme {
  const _HyperMenuThemeScope({required this.data, required super.child});

  final HyperMenuThemeData data;

  @override
  bool updateShouldNotify(_HyperMenuThemeScope oldWidget) =>
      data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) =>
      _HyperMenuThemeScope(data: data, child: child);
}
