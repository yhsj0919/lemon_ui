import 'package:flutter/material.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_badge_style.dart';

@immutable
final class HyperBadgeThemeData {
  const HyperBadgeThemeData({
    this.style = const HyperBadgeStyle(),
    this.lightBackgroundColor,
    this.darkBackgroundColor,
    this.defaultForegroundColor,
  });

  final HyperBadgeStyle style;
  final Color? lightBackgroundColor;
  final Color? darkBackgroundColor;
  final Color? defaultForegroundColor;

  Color backgroundColorFor(Brightness brightness) =>
      brightness == Brightness.light
      ? lightBackgroundColor ?? const Color(0xFFE94634)
      : darkBackgroundColor ?? const Color(0xFFF12522);

  HyperBadgeThemeData copyWith({
    HyperBadgeStyle? style,
    Color? lightBackgroundColor,
    Color? darkBackgroundColor,
    Color? defaultForegroundColor,
  }) => HyperBadgeThemeData(
    style: style ?? this.style,
    lightBackgroundColor: lightBackgroundColor ?? this.lightBackgroundColor,
    darkBackgroundColor: darkBackgroundColor ?? this.darkBackgroundColor,
    defaultForegroundColor:
        defaultForegroundColor ?? this.defaultForegroundColor,
  );

  HyperBadgeThemeData merge(HyperBadgeThemeData? other) => other == null
      ? this
      : HyperBadgeThemeData(
          style: style.merge(other.style),
          lightBackgroundColor:
              other.lightBackgroundColor ?? lightBackgroundColor,
          darkBackgroundColor: other.darkBackgroundColor ?? darkBackgroundColor,
          defaultForegroundColor:
              other.defaultForegroundColor ?? defaultForegroundColor,
        );

  static HyperBadgeThemeData lerp(
    HyperBadgeThemeData a,
    HyperBadgeThemeData b,
    double t,
  ) => HyperBadgeThemeData(
    style: HyperBadgeStyle.lerp(a.style, b.style, t),
    lightBackgroundColor: Color.lerp(
      a.lightBackgroundColor,
      b.lightBackgroundColor,
      t,
    ),
    darkBackgroundColor: Color.lerp(
      a.darkBackgroundColor,
      b.darkBackgroundColor,
      t,
    ),
    defaultForegroundColor: Color.lerp(
      a.defaultForegroundColor,
      b.defaultForegroundColor,
      t,
    ),
  );

  @override
  bool operator ==(Object other) =>
      other is HyperBadgeThemeData &&
      other.style == style &&
      other.lightBackgroundColor == lightBackgroundColor &&
      other.darkBackgroundColor == darkBackgroundColor &&
      other.defaultForegroundColor == defaultForegroundColor;

  @override
  int get hashCode => Object.hash(
    style,
    lightBackgroundColor,
    darkBackgroundColor,
    defaultForegroundColor,
  );
}

class HyperBadgeTheme extends StatelessWidget {
  const HyperBadgeTheme({super.key, required this.data, required this.child});

  final HyperBadgeThemeData data;
  final Widget child;

  static HyperBadgeThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_BadgeScope>()?.data ??
      HyperTheme.of(context).badgeTheme;

  @override
  Widget build(BuildContext context) =>
      _BadgeScope(data: of(context).merge(data), child: child);
}

class _BadgeScope extends InheritedTheme {
  const _BadgeScope({required this.data, required super.child});

  final HyperBadgeThemeData data;

  @override
  bool updateShouldNotify(_BadgeScope oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) =>
      _BadgeScope(data: data, child: child);
}
