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
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
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
              child: _AnimatedCheckboxMark(
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

class _AnimatedCheckboxMark extends StatefulWidget {
  const _AnimatedCheckboxMark({
    required this.state,
    required this.color,
    required this.strokeWidth,
    required this.duration,
    required this.curve,
  });

  final bool? state;
  final Color color;
  final double strokeWidth;
  final Duration duration;
  final Curve curve;

  @override
  State<_AnimatedCheckboxMark> createState() => _AnimatedCheckboxMarkState();
}

class _AnimatedCheckboxMarkState extends State<_AnimatedCheckboxMark>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late bool? _fromState;

  @override
  void initState() {
    super.initState();
    _fromState = widget.state;
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..value = 1;
  }

  @override
  void didUpdateWidget(_AnimatedCheckboxMark oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.duration = widget.duration;
    if (oldWidget.state == widget.state) return;
    _fromState = oldWidget.state;
    if (widget.duration == Duration.zero) {
      _controller.value = 1;
    } else {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => CustomPaint(
        painter: _CheckboxMarkPainter(
          fromState: _fromState,
          toState: widget.state,
          progress: widget.curve.transform(_controller.value),
          color: widget.color,
          strokeWidth: widget.strokeWidth,
        ),
      ),
    );
  }
}

class _CheckboxMarkPainter extends CustomPainter {
  const _CheckboxMarkPainter({
    required this.fromState,
    required this.toState,
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  final bool? fromState;
  final bool? toState;
  final double progress;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    final from = _pointsFor(fromState, size);
    final to = _pointsFor(toState, size);
    final points = [
      Offset.lerp(from.$1, to.$1, progress)!,
      Offset.lerp(from.$2, to.$2, progress)!,
      Offset.lerp(from.$3, to.$3, progress)!,
    ];
    final visibleProgress = switch ((fromState, toState)) {
      (false, false) => 0.0,
      (false, _) => progress,
      (_, false) => 1 - progress,
      _ => 1.0,
    };
    _drawPartialPath(canvas, paint, points, visibleProgress);
  }

  @override
  bool shouldRepaint(_CheckboxMarkPainter oldDelegate) =>
      fromState != oldDelegate.fromState ||
      toState != oldDelegate.toState ||
      progress != oldDelegate.progress ||
      color != oldDelegate.color ||
      strokeWidth != oldDelegate.strokeWidth;

  static (Offset, Offset, Offset) _pointsFor(bool? state, Size size) {
    if (state == null) {
      final start = Offset(size.width * (7.4 / 23), size.height * .5);
      final end = Offset(size.width * (15.36 / 23), size.height * .5);
      return (start, Offset.lerp(start, end, .5)!, end);
    }
    return (
      Offset(size.width * (7.59 / 23), size.height * (12.08 / 23)),
      Offset(size.width * (10.3 / 23), size.height * (14.9 / 23)),
      Offset(size.width * (15.48 / 23), size.height * (8.22 / 23)),
    );
  }

  static void _drawPartialPath(
    Canvas canvas,
    Paint paint,
    List<Offset> points,
    double progress,
  ) {
    if (progress <= 0) return;
    final firstLength = (points[1] - points[0]).distance;
    final secondLength = (points[2] - points[1]).distance;
    final visibleLength = (firstLength + secondLength) * progress;
    final path = Path()..moveTo(points[0].dx, points[0].dy);
    if (visibleLength <= firstLength) {
      final end = Offset.lerp(
        points[0],
        points[1],
        visibleLength / firstLength,
      )!;
      path.lineTo(end.dx, end.dy);
    } else {
      path.lineTo(points[1].dx, points[1].dy);
      final end = Offset.lerp(
        points[1],
        points[2],
        ((visibleLength - firstLength) / secondLength).clamp(0, 1),
      )!;
      path.lineTo(end.dx, end.dy);
    }
    canvas.drawPath(path, paint);
  }
}
