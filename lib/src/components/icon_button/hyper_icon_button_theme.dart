import 'package:flutter/widgets.dart';

import '../../theme/hyper_theme.dart';
import 'hyper_icon_button_style.dart';

const _unchanged = Object();

enum HyperIconButtonVariant { filled, tonal, outlined, ghost }

@immutable
final class HyperIconButtonThemeData {
  const HyperIconButtonThemeData({
    this.style,
    this.filled,
    this.tonal,
    this.outlined,
    this.ghost,
  });

  final HyperIconButtonStyle? style;
  final HyperIconButtonStyle? filled;
  final HyperIconButtonStyle? tonal;
  final HyperIconButtonStyle? outlined;
  final HyperIconButtonStyle? ghost;

  HyperIconButtonStyle resolve(HyperIconButtonVariant variant) =>
      (style ?? HyperIconButtonStyle()).merge(switch (variant) {
        HyperIconButtonVariant.filled => filled,
        HyperIconButtonVariant.tonal => tonal,
        HyperIconButtonVariant.outlined => outlined,
        HyperIconButtonVariant.ghost => ghost,
      });

  HyperIconButtonThemeData merge(HyperIconButtonThemeData? other) {
    if (other == null) return this;
    return HyperIconButtonThemeData(
      style: style?.merge(other.style) ?? other.style,
      filled: filled?.merge(other.filled) ?? other.filled,
      tonal: tonal?.merge(other.tonal) ?? other.tonal,
      outlined: outlined?.merge(other.outlined) ?? other.outlined,
      ghost: ghost?.merge(other.ghost) ?? other.ghost,
    );
  }

  HyperIconButtonThemeData copyWith({
    Object? style = _unchanged,
    Object? filled = _unchanged,
    Object? tonal = _unchanged,
    Object? outlined = _unchanged,
    Object? ghost = _unchanged,
  }) => HyperIconButtonThemeData(
    style: identical(style, _unchanged)
        ? this.style
        : style as HyperIconButtonStyle?,
    filled: identical(filled, _unchanged)
        ? this.filled
        : filled as HyperIconButtonStyle?,
    tonal: identical(tonal, _unchanged)
        ? this.tonal
        : tonal as HyperIconButtonStyle?,
    outlined: identical(outlined, _unchanged)
        ? this.outlined
        : outlined as HyperIconButtonStyle?,
    ghost: identical(ghost, _unchanged)
        ? this.ghost
        : ghost as HyperIconButtonStyle?,
  );

  static HyperIconButtonThemeData lerp(
    HyperIconButtonThemeData a,
    HyperIconButtonThemeData b,
    double t,
  ) {
    HyperIconButtonStyle? blend(
      HyperIconButtonStyle? x,
      HyperIconButtonStyle? y,
    ) {
      if (x == null || y == null) return t < .5 ? x : y;
      return HyperIconButtonStyle.lerp(x, y, t);
    }

    return HyperIconButtonThemeData(
      style: blend(a.style, b.style),
      filled: blend(a.filled, b.filled),
      tonal: blend(a.tonal, b.tonal),
      outlined: blend(a.outlined, b.outlined),
      ghost: blend(a.ghost, b.ghost),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HyperIconButtonThemeData &&
          other.style == style &&
          other.filled == filled &&
          other.tonal == tonal &&
          other.outlined == outlined &&
          other.ghost == ghost;

  @override
  int get hashCode => Object.hash(style, filled, tonal, outlined, ghost);
}

/// 仅覆盖当前子树图标按钮主题。
class HyperIconButtonTheme extends StatelessWidget {
  const HyperIconButtonTheme({
    super.key,
    required this.data,
    required this.child,
  });

  final HyperIconButtonThemeData data;
  final Widget child;

  static HyperIconButtonThemeData of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<_HyperIconButtonThemeScope>()
          ?.data ??
      HyperTheme.of(context).iconButtonTheme;

  @override
  Widget build(BuildContext context) =>
      _HyperIconButtonThemeScope(data: of(context).merge(data), child: child);
}

class _HyperIconButtonThemeScope extends InheritedTheme {
  const _HyperIconButtonThemeScope({required this.data, required super.child});

  final HyperIconButtonThemeData data;

  @override
  bool updateShouldNotify(_HyperIconButtonThemeScope oldWidget) =>
      data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) =>
      _HyperIconButtonThemeScope(data: data, child: child);
}
