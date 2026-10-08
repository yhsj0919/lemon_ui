import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import '../../foundation/hyper_control_state.dart';
import 'hyper_text_field_style.dart';

@immutable
final class HyperTextFieldThemeData {
  const HyperTextFieldThemeData({
    this.style = const HyperTextFieldStyle(),
    this.hovered = const HyperTextFieldStyle(),
    this.focused = const HyperTextFieldStyle(),
    this.error = const HyperTextFieldStyle(),
    this.disabled = const HyperTextFieldStyle(),
  });
  final HyperTextFieldStyle style;
  final HyperTextFieldStyle hovered;
  final HyperTextFieldStyle focused;
  final HyperTextFieldStyle error;
  final HyperTextFieldStyle disabled;
  HyperTextFieldStyle resolve(Set<HyperControlState> states) => style
      .merge(states.contains(HyperControlState.hovered) ? hovered : null)
      .merge(states.contains(HyperControlState.focused) ? focused : null)
      .merge(states.contains(HyperControlState.error) ? error : null)
      .merge(states.contains(HyperControlState.disabled) ? disabled : null);
  HyperTextFieldThemeData copyWith({
    HyperTextFieldStyle? style,
    HyperTextFieldStyle? hovered,
    HyperTextFieldStyle? focused,
    HyperTextFieldStyle? error,
    HyperTextFieldStyle? disabled,
  }) => HyperTextFieldThemeData(
    style: style ?? this.style,
    hovered: hovered ?? this.hovered,
    focused: focused ?? this.focused,
    error: error ?? this.error,
    disabled: disabled ?? this.disabled,
  );
  HyperTextFieldThemeData merge(HyperTextFieldThemeData? other) => other == null
      ? this
      : HyperTextFieldThemeData(
          style: style.merge(other.style),
          hovered: hovered.merge(other.hovered),
          focused: focused.merge(other.focused),
          error: error.merge(other.error),
          disabled: disabled.merge(other.disabled),
        );
  static HyperTextFieldThemeData lerp(
    HyperTextFieldThemeData a,
    HyperTextFieldThemeData b,
    double t,
  ) => HyperTextFieldThemeData(
    style: HyperTextFieldStyle.lerp(a.style, b.style, t),
    hovered: HyperTextFieldStyle.lerp(a.hovered, b.hovered, t),
    focused: HyperTextFieldStyle.lerp(a.focused, b.focused, t),
    error: HyperTextFieldStyle.lerp(a.error, b.error, t),
    disabled: HyperTextFieldStyle.lerp(a.disabled, b.disabled, t),
  );
  @override
  bool operator ==(Object other) =>
      other is HyperTextFieldThemeData &&
      style == other.style &&
      hovered == other.hovered &&
      focused == other.focused &&
      error == other.error &&
      disabled == other.disabled;
  @override
  int get hashCode =>
      Object.hashAll([style, hovered, focused, error, disabled]);
}

class HyperTextFieldTheme extends StatelessWidget {
  const HyperTextFieldTheme({
    super.key,
    required this.data,
    required this.child,
  });
  final HyperTextFieldThemeData data;
  final Widget child;
  static HyperTextFieldThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_Scope>()?.data ??
      HyperTheme.of(context).textFieldTheme;
  @override
  Widget build(BuildContext context) =>
      _Scope(data: of(context).merge(data), child: child);
}

class _Scope extends InheritedTheme {
  const _Scope({required this.data, required super.child});
  final HyperTextFieldThemeData data;
  @override
  bool updateShouldNotify(_Scope oldWidget) => data != oldWidget.data;
  @override
  Widget wrap(BuildContext context, Widget child) =>
      _Scope(data: data, child: child);
}
