import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_scaffold_style.dart';

/// 页面框架的全局或局部视觉主题。
@immutable
final class HyperScaffoldThemeData {
  const HyperScaffoldThemeData({this.style});

  final HyperScaffoldStyle? style;

  HyperScaffoldThemeData copyWith({HyperScaffoldStyle? style}) =>
      HyperScaffoldThemeData(style: style ?? this.style);

  HyperScaffoldThemeData merge(HyperScaffoldThemeData? other) =>
      HyperScaffoldThemeData(style: style?.merge(other?.style) ?? other?.style);

  static HyperScaffoldThemeData lerp(
    HyperScaffoldThemeData a,
    HyperScaffoldThemeData b,
    double t,
  ) => HyperScaffoldThemeData(
    style: a.style == null || b.style == null
        ? (t < .5 ? a.style : b.style)
        : HyperScaffoldStyle.lerp(a.style!, b.style!, t),
  );

  @override
  bool operator ==(Object other) =>
      other is HyperScaffoldThemeData && other.style == style;

  @override
  int get hashCode => style.hashCode;
}

/// 为当前子树覆盖页面框架主题。
class HyperScaffoldTheme extends StatelessWidget {
  const HyperScaffoldTheme({
    super.key,
    required this.data,
    required this.child,
  });

  final HyperScaffoldThemeData data;
  final Widget child;

  static HyperScaffoldThemeData of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<_HyperScaffoldThemeScope>()
          ?.data ??
      HyperTheme.of(context).scaffoldTheme;

  @override
  Widget build(BuildContext context) =>
      _HyperScaffoldThemeScope(data: of(context).merge(data), child: child);
}

class _HyperScaffoldThemeScope extends InheritedTheme {
  const _HyperScaffoldThemeScope({required this.data, required super.child});

  final HyperScaffoldThemeData data;

  @override
  bool updateShouldNotify(_HyperScaffoldThemeScope oldWidget) =>
      data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) =>
      _HyperScaffoldThemeScope(data: data, child: child);
}
