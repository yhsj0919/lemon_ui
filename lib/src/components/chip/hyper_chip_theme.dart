import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import '../../foundation/hyper_control_state.dart';
import 'hyper_chip_style.dart';

@immutable
final class HyperChipThemeData {
  const HyperChipThemeData({
    this.style = const HyperChipStyle(),
    this.selected = const HyperChipStyle(),
    this.hovered = const HyperChipStyle(),
    this.pressed = const HyperChipStyle(),
    this.focused = const HyperChipStyle(),
    this.disabled = const HyperChipStyle(),
  });
  final HyperChipStyle style, selected, hovered, pressed, focused, disabled;
  HyperChipStyle resolve(Set<HyperControlState> states) => style
      .merge(states.contains(HyperControlState.selected) ? selected : null)
      .merge(states.contains(HyperControlState.hovered) ? hovered : null)
      .merge(states.contains(HyperControlState.focused) ? focused : null)
      .merge(states.contains(HyperControlState.pressed) ? pressed : null)
      .merge(states.contains(HyperControlState.disabled) ? disabled : null);
  HyperChipThemeData copyWith({
    HyperChipStyle? style,
    HyperChipStyle? selected,
    HyperChipStyle? hovered,
    HyperChipStyle? pressed,
    HyperChipStyle? focused,
    HyperChipStyle? disabled,
  }) => HyperChipThemeData(
    style: style ?? this.style,
    selected: selected ?? this.selected,
    hovered: hovered ?? this.hovered,
    pressed: pressed ?? this.pressed,
    focused: focused ?? this.focused,
    disabled: disabled ?? this.disabled,
  );
  HyperChipThemeData merge(HyperChipThemeData? other) => other == null
      ? this
      : HyperChipThemeData(
          style: style.merge(other.style),
          selected: selected.merge(other.selected),
          hovered: hovered.merge(other.hovered),
          pressed: pressed.merge(other.pressed),
          focused: focused.merge(other.focused),
          disabled: disabled.merge(other.disabled),
        );
  static HyperChipThemeData lerp(
    HyperChipThemeData a,
    HyperChipThemeData b,
    double t,
  ) => HyperChipThemeData(
    style: HyperChipStyle.lerp(a.style, b.style, t),
    selected: HyperChipStyle.lerp(a.selected, b.selected, t),
    hovered: HyperChipStyle.lerp(a.hovered, b.hovered, t),
    pressed: HyperChipStyle.lerp(a.pressed, b.pressed, t),
    focused: HyperChipStyle.lerp(a.focused, b.focused, t),
    disabled: HyperChipStyle.lerp(a.disabled, b.disabled, t),
  );
  @override
  bool operator ==(Object other) =>
      other is HyperChipThemeData &&
      other.style == style &&
      other.selected == selected &&
      other.hovered == hovered &&
      other.pressed == pressed &&
      other.focused == focused &&
      other.disabled == disabled;
  @override
  int get hashCode =>
      Object.hash(style, selected, hovered, pressed, focused, disabled);
}

class HyperChipTheme extends StatelessWidget {
  const HyperChipTheme({super.key, required this.data, required this.child});
  final HyperChipThemeData data;
  final Widget child;
  static HyperChipThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_ChipScope>()?.data ??
      HyperTheme.of(context).chipTheme;
  @override
  Widget build(BuildContext context) =>
      _ChipScope(data: of(context).merge(data), child: child);
}

class _ChipScope extends InheritedTheme {
  const _ChipScope({required this.data, required super.child});
  final HyperChipThemeData data;
  @override
  bool updateShouldNotify(_ChipScope oldWidget) => data != oldWidget.data;
  @override
  Widget wrap(BuildContext context, Widget child) =>
      _ChipScope(data: data, child: child);
}
