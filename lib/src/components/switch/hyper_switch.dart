import 'package:flutter/material.dart';

import '../../foundation/hyper_control_state.dart';
import '../../interaction/hyper_pressable.dart';
import '../../theme/core/hyper_theme.dart';
import 'hyper_switch_style.dart';
import 'hyper_switch_theme.dart';

/// 支持点击、键盘和拖动的 HyperOS 风格开关。
class HyperSwitch extends StatefulWidget {
  const HyperSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.style,
    this.semanticLabel,
    this.autofocus = false,
  });

  /// 当前是否处于开启状态。
  final bool value;

  /// 状态变化回调；null 表示禁用。
  final ValueChanged<bool>? onChanged;

  /// 当前实例的样式覆盖。
  final HyperSwitchStyle? style;

  /// 屏幕阅读器使用的语义标签。
  final String? semanticLabel;

  /// 首次显示时是否自动获取键盘焦点。
  final bool autofocus;

  @override
  State<HyperSwitch> createState() => _HyperSwitchState();
}

class _HyperSwitchState extends State<HyperSwitch> {
  double _dragOffset = 0;
  bool _dragging = false;

  void _toggle() => widget.onChanged?.call(!widget.value);

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final sizes = HyperTheme.sizesOf(context);
    final colors = theme.colors;
    final metrics = sizes.switchSize;
    final defaults = HyperSwitchStyle(
      width: metrics.width,
      height: metrics.height,
      thumbSize: metrics.thumbSize,
      minimumTapTargetSize: sizes.minimumInteractiveDimension,
      activeTrackColor: colors.primary,
      inactiveTrackColor: colors.surfaceMuted,
      disabledTrackColor: colors.surfaceMuted,
      disabledActiveTrackColor: colors.primary.withValues(alpha: .35),
      disabledInactiveTrackColor: colors.surfaceMuted,
      activeThumbColor: colors.onPrimary,
      inactiveThumbColor: colors.surfaceElevated,
      disabledThumbColor: colors.disabled,
      disabledActiveThumbColor: colors.surfaceElevated,
      disabledInactiveThumbColor: colors.surfaceElevated,
      overlayColor: Colors.transparent,
      border: BorderSide.none,
      borderRadius: BorderRadius.circular(metrics.height / 2),
      thumbRadius: BorderRadius.circular(metrics.thumbSize / 2),
      uncheckedThumbOffset: metrics.thumbInset,
      checkedThumbOffset:
          metrics.width - metrics.thumbSize - metrics.thumbInset,
      interactionThumbScale: 1.127,
      thumbShadow: const [],
      duration: theme.motion.fastDuration,
      curve: theme.motion.fastCurve,
    );
    final style = defaults
        .merge(HyperSwitchTheme.of(context).style)
        .merge(widget.style);
    final enabled = widget.onChanged != null;
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    Widget result = HyperPressable(
      enabled: enabled,
      autofocus: widget.autofocus,
      semanticButton: false,
      semanticLabel: widget.semanticLabel,
      onTap: _toggle,
      onPanStart: (_) => setState(() {
        _dragOffset = 0;
        _dragging = true;
      }),
      onPanUpdate: (details) {
        final rtl = Directionality.of(context) == TextDirection.rtl;
        final delta = (rtl ? -details.delta.dx : details.delta.dx) / 2;
        final travel = style.checkedThumbOffset! - style.uncheckedThumbOffset!;
        setState(() {
          _dragOffset = widget.value
              ? (_dragOffset + delta).clamp(-travel, 0)
              : (_dragOffset + delta).clamp(0, travel);
        });
      },
      onPanEnd: (_) {
        final travel = style.checkedThumbOffset! - style.uncheckedThumbOffset!;
        if (_dragOffset.abs() > travel / 2) _toggle();
        setState(() {
          _dragOffset = 0;
          _dragging = false;
        });
      },
      onPanCancel: () => setState(() {
        _dragOffset = 0;
        _dragging = false;
      }),
      builder: (context, states, _) {
        final hovered = states.contains(HyperControlState.hovered);
        final pressed =
            states.contains(HyperControlState.pressed) ||
            states.contains(HyperControlState.dragged);
        final alpha = pressed
            ? .12
            : hovered
            ? .07
            : 0.0;
        final baseTrack = switch ((enabled, widget.value)) {
          (true, true) => style.activeTrackColor!,
          (true, false) => style.inactiveTrackColor!,
          (false, true) =>
            style.disabledActiveTrackColor ?? style.disabledTrackColor!,
          (false, false) =>
            style.disabledInactiveTrackColor ?? style.disabledTrackColor!,
        };
        final track = Color.alphaBlend(
          style.overlayColor!.withValues(alpha: alpha),
          baseTrack,
        );
        final thumb = switch ((enabled, widget.value)) {
          (true, true) => style.activeThumbColor!,
          (true, false) => style.inactiveThumbColor!,
          (false, true) =>
            style.disabledActiveThumbColor ?? style.disabledThumbColor!,
          (false, false) =>
            style.disabledInactiveThumbColor ?? style.disabledThumbColor!,
        };
        final duration = reduceMotion ? Duration.zero : style.duration!;
        final visual = AnimatedContainer(
          duration: duration,
          curve: style.curve!,
          width: style.width,
          height: style.height,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: track,
            border: style.border == BorderSide.none
                ? null
                : Border.fromBorderSide(style.border!),
            borderRadius: style.borderRadius,
          ),
          child: Stack(
            children: [
              AnimatedPositionedDirectional(
                duration: _dragging ? Duration.zero : duration,
                curve: style.curve!,
                start:
                    (widget.value
                        ? style.checkedThumbOffset!
                        : style.uncheckedThumbOffset!) +
                    _dragOffset,
                top: (style.height! - style.thumbSize!) / 2,
                child: AnimatedScale(
                  duration: duration,
                  curve: style.curve!,
                  scale: enabled && (hovered || pressed)
                      ? style.interactionThumbScale!
                      : 1,
                  child: Container(
                    width: style.thumbSize,
                    height: style.thumbSize,
                    decoration: BoxDecoration(
                      color: thumb,
                      borderRadius: style.thumbRadius,
                      boxShadow: style.thumbShadow,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
        return ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: style.minimumTapTargetSize!,
            minHeight: style.minimumTapTargetSize!,
          ),
          child: Center(widthFactor: 1, heightFactor: 1, child: visual),
        );
      },
    );
    return Semantics(toggled: widget.value, enabled: enabled, child: result);
  }
}
