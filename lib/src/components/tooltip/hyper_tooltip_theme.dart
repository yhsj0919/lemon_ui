import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import '../card/hyper_card_style.dart';

enum HyperTooltipAppearance { theme, dark }

@immutable
final class HyperTooltipThemeData {
  const HyperTooltipThemeData({
    this.appearance,
    this.foregroundColor,
    this.style,
  });
  final HyperTooltipAppearance? appearance;
  final Color? foregroundColor;
  final HyperCardStyle? style;
  HyperTooltipThemeData copyWith({
    HyperTooltipAppearance? appearance,
    Color? foregroundColor,
    HyperCardStyle? style,
  }) => HyperTooltipThemeData(
    appearance: appearance ?? this.appearance,
    foregroundColor: foregroundColor ?? this.foregroundColor,
    style: style ?? this.style,
  );
  HyperTooltipThemeData merge(HyperTooltipThemeData? other) => other == null
      ? this
      : copyWith(
          appearance: other.appearance,
          foregroundColor: other.foregroundColor,
          style: (style ?? HyperCardStyle()).merge(other.style),
        );
  static HyperTooltipThemeData lerp(
    HyperTooltipThemeData a,
    HyperTooltipThemeData b,
    double t,
  ) => HyperTooltipThemeData(
    appearance: t < .5 ? a.appearance : b.appearance,
    foregroundColor: Color.lerp(a.foregroundColor, b.foregroundColor, t),
    style: HyperCardStyle.lerp(
      a.style ?? HyperCardStyle(),
      b.style ?? HyperCardStyle(),
      t,
    ),
  );
  @override
  bool operator ==(Object other) =>
      other is HyperTooltipThemeData &&
      other.appearance == appearance &&
      other.foregroundColor == foregroundColor &&
      other.style == style;
  @override
  int get hashCode => Object.hash(appearance, foregroundColor, style);
}

class HyperTooltipTheme extends StatelessWidget {
  const HyperTooltipTheme({super.key, required this.data, required this.child});
  final HyperTooltipThemeData data;
  final Widget child;
  static HyperTooltipThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_TooltipScope>()?.data ??
      HyperTheme.of(context).tooltipTheme;
  @override
  Widget build(BuildContext context) =>
      _TooltipScope(data: of(context).merge(data), child: child);
}

class _TooltipScope extends InheritedTheme {
  const _TooltipScope({required this.data, required super.child});
  final HyperTooltipThemeData data;
  @override
  bool updateShouldNotify(_TooltipScope oldWidget) => data != oldWidget.data;
  @override
  Widget wrap(BuildContext context, Widget child) =>
      _TooltipScope(data: data, child: child);
}
