import '../../motion/hyper_animated_checkmark.dart';

import 'package:flutter/material.dart';

import '../../foundation/hyper_control_state.dart';
import '../../interaction/hyper_pressable.dart';
import '../../theme/core/hyper_theme.dart';
import 'hyper_checkbox_style.dart';
import 'hyper_checkbox_theme.dart';

/// 支持选中、未选中和半选中的复选框。
class HyperCheckbox extends StatelessWidget {
  const HyperCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.tristate = false,
    this.style,
    this.semanticLabel,
    this.autofocus = false,
  }) : variant = HyperCheckboxVariant.circle,
       assert(tristate || value != null);

  /// 显式创建 MIUIX 圆形复选框。
  const HyperCheckbox.circle({
    super.key,
    required this.value,
    required this.onChanged,
    this.tristate = false,
    this.style,
    this.semanticLabel,
    this.autofocus = false,
  }) : variant = HyperCheckboxVariant.circle,
       assert(tristate || value != null);

  /// 创建圆角矩形复选框。
  const HyperCheckbox.rounded({
    super.key,
    required this.value,
    required this.onChanged,
    this.tristate = false,
    this.style,
    this.semanticLabel,
    this.autofocus = false,
  }) : variant = HyperCheckboxVariant.rounded,
       assert(tristate || value != null);

  /// 当前值：true 为选中，false 为未选中，null 为半选中。
  final bool? value;

  /// 值变化回调；null 表示禁用。
  final ValueChanged<bool?>? onChanged;

  /// 是否允许半选中，并按 false、true、null 的顺序循环。
  final bool tristate;

  /// 当前实例的样式覆盖。
  final HyperCheckboxStyle? style;

  /// 屏幕阅读器使用的语义标签。
  final String? semanticLabel;

  /// 首次显示时是否自动获取键盘焦点。
  final bool autofocus;

  /// 当前外形变体。
  final HyperCheckboxVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final sizes = HyperTheme.sizesOf(context);
    final metrics = sizes.checkbox;
    final colors = theme.colors;
    final defaults = HyperCheckboxStyle(
      size: metrics.size,
      minimumTapTargetSize: sizes.minimumInteractiveDimension,
      activeColor: colors.primary,
      inactiveColor: colors.surfaceMuted,
      checkColor: colors.onPrimary,
      disabledColor: colors.surfaceMuted,
      disabledCheckColor: colors.disabled,
      overlayColor: colors.stateLayer,
      border: BorderSide.none,
      markStrokeWidth: metrics.markStrokeWidth,
      pressScale: .85,
      duration: HyperAnimatedCheckmark.defaultDuration,
      curve: HyperAnimatedCheckmark.defaultCurve,
      boxShadow: const [],
    );
    final variantDefaults = HyperCheckboxStyle(
      borderRadius: BorderRadius.circular(
        variant == HyperCheckboxVariant.circle
            ? metrics.size / 2
            : metrics.roundedRadius,
      ),
    );
    final resolved = defaults
        .merge(variantDefaults)
        .merge(HyperCheckboxTheme.of(context).resolve(variant))
        .merge(style);
    final enabled = onChanged != null;

    return Semantics(
      checked: value,
      enabled: enabled,
      label: semanticLabel,
      child: HyperPressable(
        enabled: enabled,
        autofocus: autofocus,
        semanticButton: false,
        excludeFromSemantics: true,
        onTap: () => onChanged?.call(_nextValue()),
        builder: (context, states, _) {
          final pressed = states.contains(HyperControlState.pressed);
          final hovered = states.contains(HyperControlState.hovered);
          final selected = value != false;
          final background = enabled
              ? selected
                    ? resolved.activeColor!
                    : resolved.inactiveColor!
              : resolved.disabledColor!;
          final overlayAlpha = pressed
              ? .12
              : hovered
              ? .07
              : 0.0;
          final markColor = enabled
              ? resolved.checkColor!
              : resolved.disabledCheckColor!;
          final reduceMotion =
              MediaQuery.maybeOf(context)?.disableAnimations ?? false;
          final duration = reduceMotion ? Duration.zero : resolved.duration!;
          final visual = AnimatedScale(
            scale: pressed ? resolved.pressScale! : 1,
            duration: duration,
            curve: resolved.curve!,
            child: AnimatedContainer(
              key: const ValueKey('hyper_checkbox_visual'),
              duration: duration,
              curve: resolved.curve!,
              width: resolved.size,
              height: resolved.size,
              decoration: BoxDecoration(
                color: Color.alphaBlend(
                  resolved.overlayColor!.withValues(alpha: overlayAlpha),
                  background,
                ),
                border: resolved.border == BorderSide.none
                    ? null
                    : Border.fromBorderSide(resolved.border!),
                borderRadius: resolved.borderRadius,
                boxShadow: resolved.boxShadow,
              ),
              child: HyperAnimatedCheckmark(
                state: value,
                color: markColor,
                strokeWidth: resolved.markStrokeWidth!,
                duration: duration,
                curve: resolved.curve!,
              ),
            ),
          );
          return ConstrainedBox(
            constraints: BoxConstraints.tightFor(
              width: resolved.minimumTapTargetSize,
              height: resolved.minimumTapTargetSize,
            ),
            child: Center(child: visual),
          );
        },
      ),
    );
  }

  bool? _nextValue() {
    if (!tristate) return value != true;
    return switch (value) {
      false => true,
      true => null,
      null => false,
    };
  }
}
