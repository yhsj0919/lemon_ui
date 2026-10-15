import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_titled_card_style.dart';

@immutable
final class HyperTitledCardThemeData {
  const HyperTitledCardThemeData({this.style, this.inside, this.outside});

  final HyperTitledCardStyle? inside;
  final HyperTitledCardStyle? outside;

  final HyperTitledCardStyle? style;

  HyperTitledCardThemeData copyWith({
    HyperTitledCardStyle? style,
    HyperTitledCardStyle? inside,
    HyperTitledCardStyle? outside,
  }) => HyperTitledCardThemeData(
    style: style ?? this.style,
    inside: inside ?? this.inside,
    outside: outside ?? this.outside,
  );

  HyperTitledCardThemeData merge(HyperTitledCardThemeData? other) =>
      HyperTitledCardThemeData(
        style: style?.merge(other?.style) ?? other?.style,
        inside: inside?.merge(other?.inside) ?? other?.inside,
        outside: outside?.merge(other?.outside) ?? other?.outside,
      );

  static HyperTitledCardThemeData lerp(
    HyperTitledCardThemeData a,
    HyperTitledCardThemeData b,
    double t,
  ) => HyperTitledCardThemeData(
    inside: a.inside == null || b.inside == null
        ? (t < .5 ? a.inside : b.inside)
        : HyperTitledCardStyle.lerp(a.inside!, b.inside!, t),
    outside: a.outside == null || b.outside == null
        ? (t < .5 ? a.outside : b.outside)
        : HyperTitledCardStyle.lerp(a.outside!, b.outside!, t),
    style: a.style == null || b.style == null
        ? (t < .5 ? a.style : b.style)
        : HyperTitledCardStyle.lerp(a.style!, b.style!, t),
  );

  @override
  bool operator ==(Object other) =>
      other is HyperTitledCardThemeData &&
      other.style == style &&
      other.inside == inside &&
      other.outside == outside;

  @override
  int get hashCode => Object.hash(style, inside, outside);
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
