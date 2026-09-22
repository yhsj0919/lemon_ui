import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_button_style.dart';

const _unchanged = Object();

enum HyperButtonVariant { filled, tonal, outlined, ghost, text, gradient }

@immutable
final class HyperButtonThemeData {
  const HyperButtonThemeData({
    this.style,
    this.filled,
    this.tonal,
    this.outlined,
    this.ghost,
    this.text,
    this.gradient,
  });

  final HyperButtonStyle? style;
  final HyperButtonStyle? filled;
  final HyperButtonStyle? tonal;
  final HyperButtonStyle? outlined;
  final HyperButtonStyle? ghost;
  final HyperButtonStyle? text;
  final HyperButtonStyle? gradient;

  HyperButtonStyle? styleFor(HyperButtonVariant variant) => switch (variant) {
    HyperButtonVariant.filled => filled,
    HyperButtonVariant.tonal => tonal,
    HyperButtonVariant.outlined => outlined,
    HyperButtonVariant.ghost => ghost,
    HyperButtonVariant.text => text,
    HyperButtonVariant.gradient => gradient,
  };

  HyperButtonStyle resolve(HyperButtonVariant variant) =>
      (style ?? HyperButtonStyle()).merge(styleFor(variant));

  HyperButtonThemeData merge(HyperButtonThemeData? other) {
    if (other == null) return this;
    return HyperButtonThemeData(
      style: style?.merge(other.style) ?? other.style,
      filled: filled?.merge(other.filled) ?? other.filled,
      tonal: tonal?.merge(other.tonal) ?? other.tonal,
      outlined: outlined?.merge(other.outlined) ?? other.outlined,
      ghost: ghost?.merge(other.ghost) ?? other.ghost,
      text: text?.merge(other.text) ?? other.text,
      gradient: gradient?.merge(other.gradient) ?? other.gradient,
    );
  }

  HyperButtonThemeData copyWith({
    Object? style = _unchanged,
    Object? filled = _unchanged,
    Object? tonal = _unchanged,
    Object? outlined = _unchanged,
    Object? ghost = _unchanged,
    Object? text = _unchanged,
    Object? gradient = _unchanged,
  }) => HyperButtonThemeData(
    style: identical(style, _unchanged)
        ? this.style
        : style as HyperButtonStyle?,
    filled: identical(filled, _unchanged)
        ? this.filled
        : filled as HyperButtonStyle?,
    tonal: identical(tonal, _unchanged)
        ? this.tonal
        : tonal as HyperButtonStyle?,
    outlined: identical(outlined, _unchanged)
        ? this.outlined
        : outlined as HyperButtonStyle?,
    ghost: identical(ghost, _unchanged)
        ? this.ghost
        : ghost as HyperButtonStyle?,
    text: identical(text, _unchanged) ? this.text : text as HyperButtonStyle?,
    gradient: identical(gradient, _unchanged)
        ? this.gradient
        : gradient as HyperButtonStyle?,
  );

  static HyperButtonThemeData lerp(
    HyperButtonThemeData a,
    HyperButtonThemeData b,
    double t,
  ) {
    HyperButtonStyle? blend(HyperButtonStyle? x, HyperButtonStyle? y) {
      if (x == null || y == null) return t < .5 ? x : y;
      return HyperButtonStyle.lerp(x, y, t);
    }

    return HyperButtonThemeData(
      style: blend(a.style, b.style),
      filled: blend(a.filled, b.filled),
      tonal: blend(a.tonal, b.tonal),
      outlined: blend(a.outlined, b.outlined),
      ghost: blend(a.ghost, b.ghost),
      text: blend(a.text, b.text),
      gradient: blend(a.gradient, b.gradient),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HyperButtonThemeData &&
          other.style == style &&
          other.filled == filled &&
          other.tonal == tonal &&
          other.outlined == outlined &&
          other.ghost == ghost &&
          other.text == text &&
          other.gradient == gradient;

  @override
  int get hashCode =>
      Object.hash(style, filled, tonal, outlined, ghost, text, gradient);
}

/// 仅覆盖当前子树按钮主题的轻量作用域。
class HyperButtonTheme extends StatelessWidget {
  const HyperButtonTheme({super.key, required this.data, required this.child});

  final HyperButtonThemeData data;
  final Widget child;

  static HyperButtonThemeData of(BuildContext context) {
    return maybeOf(context) ?? HyperTheme.of(context).buttonTheme;
  }

  static HyperButtonThemeData? maybeOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<_HyperButtonThemeScope>()
      ?.data;

  @override
  Widget build(BuildContext context) =>
      _HyperButtonThemeScope(data: of(context).merge(data), child: child);
}

class _HyperButtonThemeScope extends InheritedTheme {
  const _HyperButtonThemeScope({required this.data, required super.child});

  final HyperButtonThemeData data;

  @override
  bool updateShouldNotify(_HyperButtonThemeScope oldWidget) =>
      data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) =>
      _HyperButtonThemeScope(data: data, child: child);
}
