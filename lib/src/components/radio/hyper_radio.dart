import 'package:flutter/material.dart';

import '../../foundation/hyper_control_state.dart';
import '../../interaction/hyper_pressable.dart';
import '../../theme/core/hyper_theme.dart';
import 'hyper_radio_style.dart';
import 'hyper_radio_theme.dart';

/// 使用 Flutter value/groupValue API 的 MIUIX 风格单选控件。
class HyperRadio<T> extends StatelessWidget {
  const HyperRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.toggleable = false,
    this.style,
    this.child,
    this.spacing = 8,
    this.semanticLabel,
    this.autofocus = false,
  }) : variant = HyperRadioVariant.checkmark;

  /// 显式创建 MIUIX 勾线单选控件。
  const HyperRadio.checkmark({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.toggleable = false,
    this.style,
    this.child,
    this.spacing = 8,
    this.semanticLabel,
    this.autofocus = false,
  }) : variant = HyperRadioVariant.checkmark;

  /// 创建常见的外圈圆点单选控件。
  const HyperRadio.circle({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.toggleable = false,
    this.style,
    this.child,
    this.spacing = 8,
    this.semanticLabel,
    this.autofocus = false,
  }) : variant = HyperRadioVariant.circle;

  /// 创建带弱背景和主题色对勾的高辨识度单选控件。
  const HyperRadio.filled({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.toggleable = false,
    this.style,
    this.child,
    this.spacing = 8,
    this.semanticLabel,
    this.autofocus = false,
  }) : variant = HyperRadioVariant.filled;

  /// 当前选项代表的值。
  final T value;

  /// 当前组已选择的值。
  final T? groupValue;

  /// 选择变化回调；null 表示禁用。
  final ValueChanged<T?>? onChanged;

  /// 再次点击已选项时是否允许取消选择。
  final bool toggleable;

  /// 当前实例的样式覆盖。
  final HyperRadioStyle? style;

  /// 可选内容；提供后会与单选标记组成同一个点击区域。
  final Widget? child;

  /// 单选标记与内容之间的水平间距。
  final double spacing;

  /// 屏幕阅读器使用的语义标签。
  final String? semanticLabel;

  /// 首次显示时是否自动获取键盘焦点。
  final bool autofocus;

  /// 当前视觉变体。
  final HyperRadioVariant variant;

  bool get _selected => value == groupValue;

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final sizes = HyperTheme.sizesOf(context);
    final size = sizes.radio.size;
    final defaults = HyperRadioStyle(
      size: size,
      minimumTapTargetSize: sizes.minimumInteractiveDimension,
      selectedColor: theme.colors.primary,
      disabledSelectedColor: theme.colors.disabled,
      strokeWidth: size * (7 / 56),
      markSize: size,
      borderRadius: BorderRadius.circular(size / 2),
      boxShadow: const [],
      pressScale: .85,
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
    );
    final variantDefaults = switch (variant) {
      HyperRadioVariant.checkmark => const HyperRadioStyle(
        backgroundColor: Colors.transparent,
        selectedBackgroundColor: Colors.transparent,
        border: BorderSide.none,
        selectedBorder: BorderSide.none,
      ),
      HyperRadioVariant.circle => HyperRadioStyle(
        backgroundColor: Colors.transparent,
        selectedBackgroundColor: Colors.transparent,
        border: BorderSide(color: theme.colors.outline, width: 2),
        selectedBorder: BorderSide(color: theme.colors.primary, width: 2),
        indicatorSize: size * .46,
      ),
      HyperRadioVariant.filled => HyperRadioStyle(
        selectedColor: theme.colors.primary,
        backgroundColor: theme.colors.surfaceMuted,
        selectedBackgroundColor: theme.colors.surfaceMuted,
        border: BorderSide.none,
        selectedBorder: BorderSide.none,
        markSize: size * .8,
        strokeWidth: size * (2 / 22),
      ),
    };
    final resolved = defaults
        .merge(variantDefaults)
        .merge(HyperRadioTheme.of(context).resolve(variant))
        .merge(style);
    final enabled = onChanged != null;
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    return Semantics(
      selected: _selected,
      enabled: enabled,
      inMutuallyExclusiveGroup: true,
      label: semanticLabel,
      child: HyperPressable(
        enabled: enabled,
        autofocus: autofocus,
        semanticButton: false,
        excludeFromSemantics: true,
        mouseCursor: SystemMouseCursors.click,
        onTap: () {
          onChanged?.call(_selected && toggleable ? null : value);
        },
        builder: (context, states, _) {
          final pressed = states.contains(HyperControlState.pressed);
          final duration = reduceMotion ? Duration.zero : resolved.duration!;
          final visual = AnimatedScale(
            scale: pressed ? resolved.pressScale! : 1,
            duration: duration,
            curve: resolved.curve!,
            child: _RadioVisual(
              variant: variant,
              selected: _selected,
              enabled: enabled,
              style: resolved,
              duration: duration,
            ),
          );
          if (child == null) {
            return ConstrainedBox(
              constraints: BoxConstraints.tightFor(
                width: resolved.minimumTapTargetSize,
                height: resolved.minimumTapTargetSize,
              ),
              child: Center(child: visual),
            );
          }
          return ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: resolved.minimumTapTargetSize!,
              minWidth: resolved.minimumTapTargetSize!,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: resolved.minimumTapTargetSize,
                  height: resolved.minimumTapTargetSize,
                  child: Center(child: visual),
                ),
                SizedBox(width: spacing),
                child!,
              ],
            ),
          );
        },
      ),
    );
  }
}

class _RadioVisual extends StatelessWidget {
  const _RadioVisual({
    required this.variant,
    required this.selected,
    required this.enabled,
    required this.style,
    required this.duration,
  });

  final HyperRadioVariant variant;
  final bool selected;
  final bool enabled;
  final HyperRadioStyle style;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final color = enabled ? style.selectedColor! : style.disabledSelectedColor!;
    if (variant == HyperRadioVariant.checkmark && !_usesDecoration) {
      return SizedBox.square(
        key: const ValueKey('hyper_radio_visual'),
        dimension: style.size,
        child: Center(child: _buildCheckmarkBox(color)),
      );
    }
    final borderSide = selected ? style.selectedBorder! : style.border!;
    return AnimatedContainer(
      key: const ValueKey('hyper_radio_visual'),
      duration: duration,
      curve: style.curve!,
      width: style.size,
      height: style.size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? style.selectedBackgroundColor : style.backgroundColor,
        border: borderSide == BorderSide.none
            ? null
            : Border.fromBorderSide(borderSide),
        borderRadius: style.borderRadius,
        boxShadow: style.boxShadow,
      ),
      child: switch (variant) {
        HyperRadioVariant.checkmark ||
        HyperRadioVariant.filled => _buildCheckmarkBox(color),
        HyperRadioVariant.circle => AnimatedContainer(
          duration: duration,
          curve: style.curve!,
          width: selected ? style.indicatorSize : 0,
          height: selected ? style.indicatorSize : 0,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
      },
    );
  }

  /// 两种状态都没有装饰时，默认勾线直接绘制且不创建容器。
  bool get _usesDecoration =>
      style.backgroundColor != Colors.transparent ||
      style.selectedBackgroundColor != Colors.transparent ||
      style.border != BorderSide.none ||
      style.selectedBorder != BorderSide.none ||
      style.boxShadow!.isNotEmpty;

  Widget _buildCheckmarkBox(Color color) =>
      SizedBox.square(dimension: style.markSize, child: _buildCheckmark(color));

  Widget _buildCheckmark(Color color) => _AnimatedRadioMark(
    selected: selected,
    color: color,
    strokeWidth: style.strokeWidth!,
    duration: duration,
    curve: style.curve!,
  );
}

class _AnimatedRadioMark extends StatefulWidget {
  const _AnimatedRadioMark({
    required this.selected,
    required this.color,
    required this.strokeWidth,
    required this.duration,
    required this.curve,
  });

  final bool selected;
  final Color color;
  final double strokeWidth;
  final Duration duration;
  final Curve curve;

  @override
  State<_AnimatedRadioMark> createState() => _AnimatedRadioMarkState();
}

class _AnimatedRadioMarkState extends State<_AnimatedRadioMark>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      value: widget.selected ? 1 : 0,
    );
  }

  @override
  void didUpdateWidget(_AnimatedRadioMark oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.duration = widget.duration;
    if (oldWidget.selected == widget.selected) return;
    if (widget.duration == Duration.zero) {
      _controller.value = widget.selected ? 1 : 0;
    } else {
      _controller.animateTo(widget.selected ? 1 : 0, curve: widget.curve);
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
        painter: _RadioMarkPainter(
          progress: _controller.value,
          color: widget.color,
          strokeWidth: widget.strokeWidth,
        ),
      ),
    );
  }
}

class _RadioMarkPainter extends CustomPainter {
  const _RadioMarkPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  final double progress;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;
    final points = [
      Offset(size.width * (10.9 / 56), size.height * (29 / 56)),
      Offset(size.width * (23.1 / 56), size.height * (40.8 / 56)),
      Offset(size.width * (44 / 56), size.height * (16 / 56)),
    ];
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
    canvas.drawPath(
      path,
      Paint()
        ..color = color.withValues(alpha: progress)
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(_RadioMarkPainter oldDelegate) =>
      progress != oldDelegate.progress ||
      color != oldDelegate.color ||
      strokeWidth != oldDelegate.strokeWidth;
}
