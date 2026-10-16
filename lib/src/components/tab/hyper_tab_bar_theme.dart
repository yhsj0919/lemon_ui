import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_tab_bar_style.dart';

@immutable
final class HyperTabBarThemeData {
  const HyperTabBarThemeData({
    this.style = const HyperTabBarStyle(),
    this.segmented,
    this.separated,
    this.underline,
  });
  final HyperTabBarStyle style;
  final HyperTabBarStyle? segmented, separated, underline;
  HyperTabBarStyle resolve(HyperTabBarVariant variant) =>
      style.merge(switch (variant) {
        HyperTabBarVariant.segmented => segmented,
        HyperTabBarVariant.separated => separated,
        HyperTabBarVariant.underline => underline,
      });
  HyperTabBarThemeData copyWith({
    HyperTabBarStyle? style,
    HyperTabBarStyle? segmented,
    HyperTabBarStyle? separated,
    HyperTabBarStyle? underline,
  }) => HyperTabBarThemeData(
    style: style ?? this.style,
    segmented: segmented ?? this.segmented,
    separated: separated ?? this.separated,
    underline: underline ?? this.underline,
  );
  HyperTabBarThemeData merge(HyperTabBarThemeData? other) => other == null
      ? this
      : HyperTabBarThemeData(
          style: style.merge(other.style),
          segmented: segmented?.merge(other.segmented) ?? other.segmented,
          separated: separated?.merge(other.separated) ?? other.separated,
          underline: underline?.merge(other.underline) ?? other.underline,
        );
  static HyperTabBarThemeData lerp(
    HyperTabBarThemeData a,
    HyperTabBarThemeData b,
    double t,
  ) => HyperTabBarThemeData(
    style: HyperTabBarStyle.lerp(a.style, b.style, t),
    segmented: a.segmented == null || b.segmented == null
        ? (t < .5 ? a.segmented : b.segmented)
        : HyperTabBarStyle.lerp(a.segmented!, b.segmented!, t),
    separated: a.separated == null || b.separated == null
        ? (t < .5 ? a.separated : b.separated)
        : HyperTabBarStyle.lerp(a.separated!, b.separated!, t),
    underline: a.underline == null || b.underline == null
        ? (t < .5 ? a.underline : b.underline)
        : HyperTabBarStyle.lerp(a.underline!, b.underline!, t),
  );
  @override
  bool operator ==(Object other) =>
      other is HyperTabBarThemeData &&
      style == other.style &&
      segmented == other.segmented &&
      separated == other.separated &&
      underline == other.underline;
  @override
  int get hashCode => Object.hash(style, segmented, separated, underline);
}

class HyperTabBarTheme extends StatelessWidget {
  const HyperTabBarTheme({super.key, required this.data, required this.child});

  final HyperTabBarThemeData data;
  final Widget child;

  static HyperTabBarThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_TabBarScope>()?.data ??
      HyperTheme.of(context).tabBarTheme;

  @override
  Widget build(BuildContext context) =>
      _TabBarScope(data: of(context).merge(data), child: child);
}

class _TabBarScope extends InheritedTheme {
  const _TabBarScope({required this.data, required super.child});

  final HyperTabBarThemeData data;

  @override
  bool updateShouldNotify(_TabBarScope oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) =>
      _TabBarScope(data: data, child: child);
}
