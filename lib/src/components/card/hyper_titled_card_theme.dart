import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_titled_card_style.dart';

@immutable
final class HyperTitledCardThemeData {
  const HyperTitledCardThemeData({this.style});

  final HyperTitledCardStyle? style;

  HyperTitledCardThemeData copyWith({HyperTitledCardStyle? style}) =>
      HyperTitledCardThemeData(style: style ?? this.style);

  HyperTitledCardThemeData merge(HyperTitledCardThemeData? other) =>
      HyperTitledCardThemeData(
        style: style?.merge(other?.style) ?? other?.style,
      );

  static HyperTitledCardThemeData lerp(
    HyperTitledCardThemeData a,
    HyperTitledCardThemeData b,
    double t,
  ) => HyperTitledCardThemeData(
    style: a.style == null || b.style == null
        ? (t < .5 ? a.style : b.style)
        : HyperTitledCardStyle.lerp(a.style!, b.style!, t),
  );

  @override
  bool operator ==(Object other) =>
      other is HyperTitledCardThemeData && other.style == style;

  @override
  int get hashCode => style.hashCode;
}

/// 为当前子树覆盖带标题卡片的标题行样式。
class HyperTitledCardTheme extends StatelessWidget {
  const HyperTitledCardTheme({
    super.key,
    required this.data,
    required this.child,
  });

  final HyperTitledCardThemeData data;
  final Widget child;

  static HyperTitledCardThemeData of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<_HyperTitledCardThemeScope>()
          ?.data ??
      HyperTheme.of(context).titledCardTheme;

  @override
  Widget build(BuildContext context) =>
      _HyperTitledCardThemeScope(data: of(context).merge(data), child: child);
}

class _HyperTitledCardThemeScope extends InheritedTheme {
  const _HyperTitledCardThemeScope({required this.data, required super.child});

  final HyperTitledCardThemeData data;

  @override
  bool updateShouldNotify(_HyperTitledCardThemeScope oldWidget) =>
      data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) =>
      _HyperTitledCardThemeScope(data: data, child: child);
}
