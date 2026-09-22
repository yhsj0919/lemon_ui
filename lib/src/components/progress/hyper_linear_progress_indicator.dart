import 'package:flutter/material.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_progress_indicator_style.dart';
import 'hyper_progress_indicator_theme.dart';

/// 使用 Hyper 语义色和统一动画的线性进度指示器。
class HyperLinearProgressIndicator extends StatelessWidget {
  const HyperLinearProgressIndicator({
    super.key,
    this.value,
    this.style,
    this.color,
    this.trackColor,
    this.thickness,
    this.length,
    this.radius,
    this.animationDuration,
    this.animationCurve,
    this.semanticsLabel,
    this.semanticsValue,
    this.excludeSemantics = false,
  });

  /// 确定进度；null 表示不确定进度。
  final double? value;
  final HyperProgressIndicatorStyle? style;
  final Color? color;
  final Color? trackColor;
  final double? thickness;
  final double? length;
  final double? radius;
  final Duration? animationDuration;
  final Curve? animationCurve;
  final String? semanticsLabel;
  final String? semanticsValue;
  final bool excludeSemantics;

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final sizes = HyperTheme.sizesOf(context);
    final progressTheme = HyperProgressIndicatorTheme.of(context);
    final defaultThickness = sizes.progressIndicator.linearThickness;
    final resolved = HyperProgressIndicatorStyle(
      color: theme.colors.primary,
      trackColor: theme.colors.surfaceMuted,
      thickness: defaultThickness,
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
      final effectiveThickness = thickness ?? resolved.thickness!;
      return SizedBox(
        width: length ?? resolved.size,
        height: effectiveThickness,
        child: LinearProgressIndicator(
          value: currentValue,
          color: color ?? resolved.color,
          backgroundColor: trackColor ?? resolved.trackColor,
          minHeight: effectiveThickness,
          // 未指定圆角时始终保持 MIUIX 的胶囊轨道。
          borderRadius: BorderRadius.circular(
            radius ?? resolved.radius ?? effectiveThickness / 2,
          ),
          semanticsLabel: semanticsLabel,
          semanticsValue: semanticsValue,
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
