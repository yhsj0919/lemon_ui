import 'package:flutter/material.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_progress_style.dart';
import 'hyper_progress_theme.dart';

/// 使用 Hyper 语义色和统一动画的线性进度指示器。
class HyperLinearProgress extends StatelessWidget {
  const HyperLinearProgress({
    super.key,
    this.value,
    this.variant,
    this.style,
    this.color,
    this.trackColor,
    this.thickness,
    this.length,
    this.radius,
    this.fillRadius,
    this.animationDuration,
    this.animationCurve,
    this.semanticsLabel,
    this.semanticsValue,
    this.excludeSemantics = false,
  });

  /// 确定进度；null 表示不确定进度。
  final double? value;
  final HyperProgressVariant? variant;
  final HyperProgressStyle? style;
  final Color? color;
  final Color? trackColor;
  final double? thickness;
  final double? length;
  final double? radius;
  final double? fillRadius;
  final Duration? animationDuration;
  final Curve? animationCurve;
  final String? semanticsLabel;
  final String? semanticsValue;
  final bool excludeSemantics;

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final sizes = HyperTheme.sizesOf(context);
    final progressTheme = HyperProgressTheme.of(context);
    final metrics = sizes.progress;
    final resolved = HyperProgressStyle(
      color: theme.colors.primary,
      trackColor: theme.colors.surfaceMuted,
      variant: HyperProgressVariant.thin,
      animationDuration: theme.motion.standardDuration,
      animationCurve: theme.motion.standardCurve,
    ).merge(progressTheme.style).merge(progressTheme.linearStyle).merge(style);
    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final resolvedValue = value?.clamp(0.0, 1.0);
    final duration = disableAnimations
        ? Duration.zero
        : animationDuration ?? resolved.animationDuration!;

    Widget buildIndicator(double? currentValue) {
      final effectiveThickness =
          thickness ??
          resolved.thickness ??
          ((variant ?? resolved.variant) == HyperProgressVariant.wide
              ? metrics.wideLinearThickness
              : metrics.linearThickness);
      return SizedBox(
        width: length ?? resolved.size,
        height: effectiveThickness,
        // 圆角只裁剪完整轨道；进度片段按矩形填充，不能随宽度压缩圆角。
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            radius ?? resolved.radius ?? effectiveThickness / 2,
          ),
          child: currentValue != null
              ? Semantics(
                  label: semanticsLabel,
                  value: semanticsValue ?? '${(currentValue * 100).round()}%',
                  child: CustomPaint(
                    painter: _ProgressFillPainter(
                      value: currentValue,
                      color: color ?? resolved.color!,
                      trackColor: trackColor ?? resolved.trackColor!,
                      radius:
                          fillRadius ??
                          resolved.fillRadius ??
                          effectiveThickness / 2,
                      direction: Directionality.of(context),
                    ),
                  ),
                )
              : LinearProgressIndicator(
                  value: currentValue,
                  color: color ?? resolved.color,
                  backgroundColor: trackColor ?? resolved.trackColor,
                  minHeight: effectiveThickness,
                  trackGap: 0,
                  stopIndicatorColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(
                    fillRadius ?? resolved.fillRadius ?? effectiveThickness / 2,
                  ),
                  semanticsLabel: semanticsLabel,
                  semanticsValue: semanticsValue,
                ),
        ),
      );
    }

    Widget result;
    if (resolvedValue == null) {
      result = buildIndicator(disableAnimations ? .35 : null);
    } else {
      result = TweenAnimationBuilder<double>(
        tween: Tween(end: resolvedValue),
        duration: duration,
        curve: animationCurve ?? resolved.animationCurve!,
        builder: (context, currentValue, child) => buildIndicator(currentValue),
      );
    }
    return excludeSemantics ? ExcludeSemantics(child: result) : result;
  }
}

class _ProgressFillPainter extends CustomPainter {
  const _ProgressFillPainter({
    required this.value,
    required this.color,
    required this.trackColor,
    required this.radius,
    required this.direction,
  });
  final double value, radius;
  final Color color, trackColor;
  final TextDirection direction;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..isAntiAlias = true
        ..color = trackColor,
    );
    if (value <= 0) return;
    final width = size.width * value;
    // 保持完整轨道的尺寸，平移其末端到进度位置；外层只裁出填充区。
    final rect = direction == TextDirection.ltr
        ? Rect.fromLTWH(width - size.width, 0, size.width, size.height)
        : Rect.fromLTWH(size.width - width, 0, size.width, size.height);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        rect,
        Radius.circular(radius.clamp(0.0, size.height / 2)),
      ),
      Paint()
        ..isAntiAlias = true
        ..color = color,
    );
  }

  @override
  bool shouldRepaint(_ProgressFillPainter old) =>
      value != old.value ||
      color != old.color ||
      trackColor != old.trackColor ||
      radius != old.radius ||
      direction != old.direction;
}
