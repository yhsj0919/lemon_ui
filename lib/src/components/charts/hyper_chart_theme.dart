import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_chart_style.dart';

/// 所有基础图表形态共用的全局或局部主题。
@immutable
final class HyperChartThemeData {
  static const defaults = HyperChartStyle(
    gridOpacity: .55,
    inactiveOpacity: .32,
    hoverScale: 1.12,
    pieLabelMinPercent: 6,
  );
  const HyperChartThemeData({this.style = const HyperChartStyle()});

  /// 各类图表共同继承的属性。
  final HyperChartStyle style;

  HyperChartThemeData copyWith({HyperChartStyle? style}) =>
      HyperChartThemeData(style: style ?? this.style);

  HyperChartThemeData merge(HyperChartThemeData? other) {
    if (other == null) return this;
    return HyperChartThemeData(style: style.merge(other.style));
  }

  static HyperChartThemeData lerp(
    HyperChartThemeData a,
    HyperChartThemeData b,
    double t,
  ) => HyperChartThemeData(style: HyperChartStyle.lerp(a.style, b.style, t));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HyperChartThemeData && other.style == style;

  @override
  int get hashCode => style.hashCode;
}

/// 仅覆盖当前子树图表主题的轻量作用域。
class HyperChartTheme extends StatelessWidget {
  const HyperChartTheme({super.key, required this.data, required this.child});

  final HyperChartThemeData data;
  final Widget child;

  static HyperChartThemeData of(BuildContext context) =>
      maybeOf(context) ?? HyperTheme.of(context).chartTheme;

  static HyperChartThemeData? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_HyperChartThemeScope>()?.data;

  @override
  Widget build(BuildContext context) =>
      _HyperChartThemeScope(data: of(context).merge(data), child: child);
}

class _HyperChartThemeScope extends InheritedTheme {
  const _HyperChartThemeScope({required this.data, required super.child});

  final HyperChartThemeData data;

  @override
  bool updateShouldNotify(_HyperChartThemeScope oldWidget) =>
      data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) =>
      _HyperChartThemeScope(data: data, child: child);
}
