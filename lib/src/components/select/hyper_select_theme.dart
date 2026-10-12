import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_select_style.dart';

@immutable
final class HyperSelectThemeData {
  const HyperSelectThemeData({this.style});

  final HyperSelectStyle? style;

  HyperSelectThemeData copyWith({HyperSelectStyle? style}) =>
      HyperSelectThemeData(style: this.style?.merge(style) ?? style);

  HyperSelectThemeData merge(HyperSelectThemeData? other) =>
      HyperSelectThemeData(style: style?.merge(other?.style) ?? other?.style);

  static HyperSelectThemeData lerp(
    HyperSelectThemeData a,
    HyperSelectThemeData b,
    double t,
  ) => HyperSelectThemeData(
    style: a.style == null || b.style == null
        ? (t < .5 ? a.style : b.style)
        : HyperSelectStyle.lerp(a.style!, b.style!, t),
  );

  @override
  bool operator ==(Object other) =>
      other is HyperSelectThemeData && other.style == style;

  @override
  int get hashCode => style.hashCode;
}

/// 为当前子树局部覆盖下拉选择器样式。
class HyperSelectTheme extends StatelessWidget {
  const HyperSelectTheme({super.key, required this.data, required this.child});

  final HyperSelectThemeData data;
  final Widget child;

  static HyperSelectThemeData of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<_HyperSelectThemeScope>()
          ?.data ??
      HyperTheme.of(context).selectTheme;

  @override
  Widget build(BuildContext context) =>
      _HyperSelectThemeScope(data: of(context).merge(data), child: child);
}

class _HyperSelectThemeScope extends InheritedTheme {
  const _HyperSelectThemeScope({required this.data, required super.child});

  final HyperSelectThemeData data;

  @override
  bool updateShouldNotify(_HyperSelectThemeScope oldWidget) =>
      data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) =>
      _HyperSelectThemeScope(data: data, child: child);
}
