import 'package:flutter/material.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_progress_style.dart';
import 'hyper_progress_theme.dart';

/// 使用 Hyper 语义色和统一动画的线性进度指示器。
class HyperLinearProgress extends StatelessWidget {
  const HyperLinearProgress({
    super.key,
    this.bufferValue,
    this.bufferColor,
    this.bufferGradient,
    this.value,
    this.variant,
    this.style,
    this.color,
    this.gradient,
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
  final double? bufferValue;
  final Color? bufferColor;
  final Gradient? bufferGradient;
  final double? value;
  final HyperProgressVariant? variant;
  final HyperProgressStyle? style;
  final Color? color;
  final Gradient? gradient;
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
      size: metrics.linearSize,
      radius: metrics.radius,
      fillRadius: metrics.fillRadius,
      animationDuration: theme.motion.standardDuration,
      animationCurve: theme.motion.standardCurve,
    ).merge(progressTheme.style).merge(progressTheme.linearStyle).merge(style);
    final fillGradient = gradient ?? (color != null ? null : resolved.gradient);
    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final resolvedValue = value?.clamp(0.0, 1.0);
    final resolvedBuffer = bufferValue
        ?.clamp(resolvedValue ?? 0.0, 1.0)
        .toDouble();
    final secondaryColor =
        bufferColor ?? resolved.bufferColor ?? theme.colors.primaryContainer;
    final secondaryGradient =
        bufferGradient ??
        (bufferColor != null ? null : resolved.bufferGradient);
    final duration = disableAnimations
        ? Duration.zero
        : animationDuration ?? resolved.animationDuration!;

    Widget buildIndicator(double? currentValue, double? currentBuffer) {
      final effectiveThickness =
          thickness ??
          resolved.thickness ??
          ((variant ?? resolved.variant) == HyperProgressVariant.wide
              ? metrics.wideLinearThickness
              : metrics.linearThickness);
      return SizedBox(
        width: length ?? resolved.size ?? double.infinity,
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
                      bufferValue: currentBuffer,
                      bufferColor: secondaryColor,
                      bufferGradient: secondaryGradient,
                      gradient: fillGradient,
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
              : fillGradient == null && currentBuffer == null
              ? LinearProgressIndicator(
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
                )
              : Stack(
                  fit: StackFit.expand,
                  children: [
                    CustomPaint(
                      painter: _ProgressFillPainter(
                        value: 0,
                        bufferValue: currentBuffer,
                        bufferColor: secondaryColor,
                        bufferGradient: secondaryGradient,
                        color: color ?? resolved.color!,
                        trackColor: trackColor ?? resolved.trackColor!,
                        radius:
                            fillRadius ??
                            resolved.fillRadius ??
                            effectiveThickness / 2,
                        direction: Directionality.of(context),
                      ),
                    ),
                    if (fillGradient != null)
                      ShaderMask(
                        shaderCallback: (bounds) =>
                            fillGradient.createShader(bounds),
                        blendMode: BlendMode.srcIn,
                        child: LinearProgressIndicator(
                          value: currentValue,
                          color: Colors.white,
                          backgroundColor: Colors.transparent,
                          minHeight: effectiveThickness,
                          trackGap: 0,
                          stopIndicatorColor: Colors.transparent,
                          borderRadius: BorderRadius.circular(
                            fillRadius ??
                                resolved.fillRadius ??
                                effectiveThickness / 2,
                          ),
                          semanticsLabel: semanticsLabel,
                          semanticsValue: semanticsValue,
                        ),
                      )
                    else
                      LinearProgressIndicator(
                        value: null,
                        color: color ?? resolved.color,
                        backgroundColor: Colors.transparent,
                        minHeight: effectiveThickness,
                        trackGap: 0,
                        stopIndicatorColor: Colors.transparent,
                        borderRadius: BorderRadius.circular(
                          fillRadius ??
                              resolved.fillRadius ??
                              effectiveThickness / 2,
                        ),
                        semanticsLabel: semanticsLabel,
                        semanticsValue: semanticsValue,
                      ),
                  ],
                ),
        ),
      );
    }

    Widget result;
    if (resolvedValue == null) {
      result = TweenAnimationBuilder<double>(
        tween: Tween(end: resolvedBuffer ?? 0),
        duration: duration,
        curve: animationCurve ?? resolved.animationCurve!,
        builder: (context, value, child) => buildIndicator(
          disableAnimations ? .35 : null,
          resolvedBuffer == null ? null : value,
        ),
      );
    } else {
      result = TweenAnimationBuilder<Offset>(
        tween: Tween(end: Offset(resolvedValue, resolvedBuffer ?? 0)),
        duration: duration,
        curve: animationCurve ?? resolved.animationCurve!,
        builder: (context, current, child) => buildIndicator(
          current.dx,
          resolvedBuffer == null
              ? null
              : current.dy.clamp(current.dx, 1.0).toDouble(),
        ),
      );
    }
    return excludeSemantics ? ExcludeSemantics(child: result) : result;
  }
}

class _ProgressFillPainter extends CustomPainter {
  const _ProgressFillPainter({
    required this.value,
    this.bufferValue,
    this.bufferColor,
    this.bufferGradient,
    this.gradient,
    required this.color,
    required this.trackColor,
    required this.radius,
    required this.direction,
  });
  final double? bufferValue;
  final Color? bufferColor;
  final Gradient? bufferGradient;
  final Gradient? gradient;
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
    void fill(double amount, Color fillColor, Gradient? fillGradient) {
      if (amount <= 0) return;
      final width = size.width * amount;
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
          ..color = fillColor
          ..shader = fillGradient?.createShader(Offset.zero & size),
      );
    }

    if (bufferValue != null) fill(bufferValue!, bufferColor!, bufferGradient);
    fill(value, color, gradient);
  }

  @override
  bool shouldRepaint(_ProgressFillPainter old) =>
      bufferValue != old.bufferValue ||
      bufferColor != old.bufferColor ||
      bufferGradient != old.bufferGradient ||
      gradient != old.gradient ||
      value != old.value ||
      color != old.color ||
      trackColor != old.trackColor ||
      radius != old.radius ||
      direction != old.direction;
}
