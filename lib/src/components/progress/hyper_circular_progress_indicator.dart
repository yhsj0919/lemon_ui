import 'package:flutter/material.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_progress_indicator_style.dart';
import 'hyper_progress_indicator_theme.dart';

/// 使用 Hyper 语义色和 MIUIX 默认规格的圆形进度指示器。
class HyperCircularProgressIndicator extends StatelessWidget {
  const HyperCircularProgressIndicator({
    super.key,
    this.value,
    this.style,
    this.color,
    this.trackColor,
    this.size,
    this.thickness,
    this.strokeCap,
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
  final double? size;
  final double? thickness;
  final StrokeCap? strokeCap;
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
    final metrics = sizes.progressIndicator;
    final resolved =
        HyperProgressIndicatorStyle(
              color: theme.colors.primary,
              trackColor: theme.colors.surfaceMuted,
              thickness: metrics.circularThickness,
              size: metrics.circularSize,
              strokeCap: StrokeCap.round,
              animationDuration: theme.motion.standardDuration,
              animationCurve: theme.motion.standardCurve,
            )
            .merge(progressTheme.style)
            .merge(progressTheme.circularStyle)
            .merge(style);
    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final resolvedValue = value?.clamp(0.0, 1.0);
    final duration = disableAnimations
        ? Duration.zero
        : animationDuration ?? resolved.animationDuration!;

    Widget buildIndicator(double? currentValue) => SizedBox.square(
      dimension: size ?? resolved.size,
      child: CircularProgressIndicator(
        value: currentValue,
        color: color ?? resolved.color,
        backgroundColor: trackColor ?? resolved.trackColor,
        strokeWidth: thickness ?? resolved.thickness!,
        strokeCap: strokeCap ?? resolved.strokeCap,
        semanticsLabel: semanticsLabel,
        semanticsValue: semanticsValue,
      ),
    );

    Widget result;
    if (resolvedValue == null) {
      result = buildIndicator(disableAnimations ? .75 : null);
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
