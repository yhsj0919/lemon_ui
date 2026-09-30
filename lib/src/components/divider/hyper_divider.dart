import 'package:flutter/material.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_divider_style.dart';
import 'hyper_divider_theme.dart';

/// 支持纯色、渐变和多种线型的轻量分隔线。
class HyperDivider extends StatelessWidget {
  const HyperDivider({
    super.key,
    this.child,
    this.style,
    this.color,
    this.gradient,
    this.thickness,
    this.length,
    this.indent,
    this.endIndent,
    this.radius,
    this.pattern,
    this.dashLength,
    this.gap,
  }) : axis = Axis.horizontal;

  /// 创建垂直分隔线。
  const HyperDivider.vertical({
    super.key,
    this.child,
    this.style,
    this.color,
    this.gradient,
    this.thickness,
    this.length,
    this.indent,
    this.endIndent,
    this.radius,
    this.pattern,
    this.dashLength,
    this.gap,
  }) : axis = Axis.vertical;

  /// 当前实例的样式，优先级高于全局和局部主题。
  final HyperDividerStyle? style;

  /// 文字、图标或任意自定义内容。
  final Widget? child;

  /// 分隔线方向。
  final Axis axis;

  /// 明确的纯色；[gradient] 不为空时由渐变优先。
  final Color? color;

  /// 明确的渐变。
  final Gradient? gradient;

  /// 明确的线条粗细。
  final double? thickness;

  /// 明确的主轴长度；null 表示占满可用空间。
  final double? length;

  /// 起点缩进。
  final double? indent;

  /// 终点缩进。
  final double? endIndent;

  /// 线段端部圆角，不跟随全局圆角。
  final double? radius;

  /// 实线、虚线或点线。
  final HyperDividerPattern? pattern;

  /// 虚线线段长度。
  final double? dashLength;

  /// 虚线或点线间隔。
  final double? gap;

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final sizes = HyperTheme.sizesOf(context);
    final metrics = sizes.divider;
    final defaults = HyperDividerStyle(
      color: theme.colors.outline,
      thickness: metrics.thickness,
      indent: 0,
      endIndent: 0,
      radius: 0,
      pattern: HyperDividerPattern.solid,
      dashLength: metrics.dashLength,
      gap: metrics.gap,
      contentGap: metrics.contentGap,
      edgeExtent: metrics.edgeExtent,
      iconSize: metrics.iconSize,
      iconColor: theme.colors.textSecondary,
      textStyle: theme.textTheme.labelMedium?.copyWith(
        color: theme.colors.textSecondary,
      ),
      contentAlignment: HyperDividerContentAlignment.center,
    );
    final resolved = defaults
        .merge(HyperDividerTheme.of(context).style)
        .merge(style);
    final resolvedThickness = thickness ?? resolved.thickness!;
    final resolvedLength = length ?? resolved.length;
    final resolvedIndent = indent ?? resolved.indent!;
    final resolvedEndIndent = endIndent ?? resolved.endIndent!;

    final target = resolved.copyWith(
      thickness: resolvedThickness,
      length: resolvedLength,
      indent: resolvedIndent,
      endIndent: resolvedEndIndent,
      color: color,
      gradient: gradient,
      radius: radius,
      pattern: pattern,
      dashLength: dashLength,
      gap: gap,
    );
    final reduce = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    return TweenAnimationBuilder<HyperDividerStyle>(
      tween: _DividerTween(end: target),
      duration: reduce
          ? Duration.zero
          : target.duration ?? theme.motion.fastDuration,
      curve: target.curve ?? theme.motion.fastCurve,
      builder: (context, current, _) => _layout(context, current),
    );
  }

  Widget _layout(BuildContext context, HyperDividerStyle current) {
    Widget line([double? extent]) => ExcludeSemantics(
      child: CustomPaint(
        painter: _HyperDividerPainter(
          axis: axis,
          color: current.color!,
          gradient: current.gradient,
          thickness: current.thickness!,
          radius: current.radius!,
          pattern: current.pattern!,
          dashLength: current.dashLength!,
          gap: current.gap!,
        ),
        size: axis == Axis.horizontal
            ? Size(extent ?? double.infinity, current.thickness!)
            : Size(current.thickness!, extent ?? double.infinity),
      ),
    );
    Widget result;
    if (child == null) {
      result = line(current.length);
    } else {
      final content = Flexible(
        child: DefaultTextStyle(
          style: current.textStyle ?? const TextStyle(),
          child: IconTheme(
            data: IconThemeData(
              size: current.iconSize,
              color: current.iconColor,
            ),
            child: child!,
          ),
        ),
      );
      Widget gap() => axis == Axis.horizontal
          ? SizedBox(width: current.contentGap)
          : SizedBox(height: current.contentGap);
      final position = current.contentAlignment!;
      result = SizedBox(
        width: axis == Axis.horizontal ? current.length : null,
        height: axis == Axis.vertical ? current.length : null,
        child: Flex(
          direction: axis,
          children: [
            if (position == HyperDividerContentAlignment.start)
              line(current.edgeExtent)
            else
              Expanded(child: line()),
            gap(),
            content,
            gap(),
            if (position == HyperDividerContentAlignment.end)
              line(current.edgeExtent)
            else
              Expanded(child: line()),
          ],
        ),
      );
    }
    return Padding(
      padding: axis == Axis.horizontal
          ? EdgeInsetsDirectional.only(
              start: current.indent!,
              end: current.endIndent!,
            )
          : EdgeInsets.only(top: current.indent!, bottom: current.endIndent!),
      child: result,
    );
  }
}

class _DividerTween extends Tween<HyperDividerStyle> {
  _DividerTween({required HyperDividerStyle end}) : super(end: end);
  @override
  HyperDividerStyle lerp(double t) => HyperDividerStyle.lerp(begin!, end!, t);
}

class _HyperDividerPainter extends CustomPainter {
  const _HyperDividerPainter({
    required this.axis,
    required this.color,
    required this.gradient,
    required this.thickness,
    required this.radius,
    required this.pattern,
    required this.dashLength,
    required this.gap,
  });

  final Axis axis;
  final Color color;
  final Gradient? gradient;
  final double thickness;
  final double radius;
  final HyperDividerPattern pattern;
  final double dashLength;
  final double gap;

  @override
  void paint(Canvas canvas, Size size) {
    if (!size.isFinite || size.isEmpty || thickness <= 0) return;
    final rect = Offset.zero & size;
    canvas.save();
    canvas.clipRect(rect);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..shader = gradient?.createShader(rect);
    final extent = axis == Axis.horizontal ? size.width : size.height;

    if (pattern == HyperDividerPattern.solid) {
      _drawSegment(canvas, paint, 0, extent);
      canvas.restore();
      return;
    }

    final segmentLength = pattern == HyperDividerPattern.dotted
        ? 0.0
        : dashLength;
    final step =
        (pattern == HyperDividerPattern.dotted ? thickness : dashLength) + gap;
    for (
      var start = 0.0;
      start <= extent;
      start += step > 0 ? step : extent + 1
    ) {
      _drawSegment(
        canvas,
        paint,
        start,
        (start + segmentLength).clamp(0, extent),
      );
    }
    canvas.restore();
  }

  void _drawSegment(Canvas canvas, Paint paint, double start, double end) {
    if (pattern == HyperDividerPattern.dotted) {
      final center = axis == Axis.horizontal
          ? Offset(start + thickness / 2, thickness / 2)
          : Offset(thickness / 2, start + thickness / 2);
      canvas.drawCircle(center, thickness / 2, paint);
      return;
    }

    final segmentRect = axis == Axis.horizontal
        ? Rect.fromLTWH(start, 0, end - start, thickness)
        : Rect.fromLTWH(0, start, thickness, end - start);
    final resolvedRadius = radius
        .clamp(
          0,
          (axis == Axis.horizontal ? segmentRect.width : segmentRect.height) /
              2,
        )
        .toDouble();
    canvas.drawRRect(
      RRect.fromRectAndRadius(segmentRect, Radius.circular(resolvedRadius)),
      paint,
    );
  }

  @override
  bool shouldRepaint(_HyperDividerPainter oldDelegate) =>
      axis != oldDelegate.axis ||
      color != oldDelegate.color ||
      gradient != oldDelegate.gradient ||
      thickness != oldDelegate.thickness ||
      radius != oldDelegate.radius ||
      pattern != oldDelegate.pattern ||
      dashLength != oldDelegate.dashLength ||
      gap != oldDelegate.gap;
}
