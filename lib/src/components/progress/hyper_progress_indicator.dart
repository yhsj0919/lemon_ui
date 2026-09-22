import 'package:flutter/material.dart';

import 'hyper_circular_progress_indicator.dart';
import 'hyper_infinite_progress_indicator.dart';
import 'hyper_linear_progress_indicator.dart';
import 'hyper_progress_indicator_style.dart';

/// 线性和圆形进度指示器的统一便捷入口。
class HyperProgressIndicator extends StatelessWidget {
  const HyperProgressIndicator.linear({
    super.key,
    this.value,
    this.style,
    this.color,
    this.trackColor,
    this.thickness,
    this.size,
    this.radius,
    this.animationDuration,
    this.animationCurve,
    this.semanticsLabel,
    this.semanticsValue,
    this.excludeSemantics = false,
  }) : circular = false,
       infinite = false,
       orbitingDotSize = null,
       strokeCap = null;

  const HyperProgressIndicator.circular({
    super.key,
    this.value,
    this.style,
    this.color,
    this.trackColor,
    this.thickness,
    this.size,
    this.strokeCap,
    this.animationDuration,
    this.animationCurve,
    this.semanticsLabel,
    this.semanticsValue,
    this.excludeSemantics = false,
  }) : circular = true,
       infinite = false,
       orbitingDotSize = null,
       radius = null;

  const HyperProgressIndicator.infinite({
    super.key,
    this.style,
    this.color,
    this.thickness,
    this.size,
    this.orbitingDotSize,
    this.animationDuration,
    this.semanticsLabel,
    this.semanticsValue,
    this.excludeSemantics = false,
  }) : circular = false,
       infinite = true,
       value = null,
       trackColor = null,
       radius = null,
       strokeCap = null,
       animationCurve = null;

  final bool circular;
  final bool infinite;
  final double? value;
  final HyperProgressIndicatorStyle? style;
  final Color? color;
  final Color? trackColor;
  final double? thickness;
  final double? size;
  final double? radius;
  final StrokeCap? strokeCap;
  final double? orbitingDotSize;
  final Duration? animationDuration;
  final Curve? animationCurve;
  final String? semanticsLabel;
  final String? semanticsValue;
  final bool excludeSemantics;

  @override
  Widget build(BuildContext context) {
    if (infinite) {
      return HyperInfiniteProgressIndicator(
        style: style,
        color: color,
        size: size,
        thickness: thickness,
        orbitingDotSize: orbitingDotSize,
        animationDuration: animationDuration,
        semanticsLabel: semanticsLabel,
        semanticsValue: semanticsValue,
        excludeSemantics: excludeSemantics,
      );
    }
    if (circular) {
      return HyperCircularProgressIndicator(
        value: value,
        style: style,
        color: color,
        trackColor: trackColor,
        size: size,
        thickness: thickness,
        strokeCap: strokeCap,
        animationDuration: animationDuration,
        animationCurve: animationCurve,
        semanticsLabel: semanticsLabel,
        semanticsValue: semanticsValue,
        excludeSemantics: excludeSemantics,
      );
    }
    return HyperLinearProgressIndicator(
      value: value,
      style: style,
      color: color,
      trackColor: trackColor,
      length: size,
      thickness: thickness,
      radius: radius,
      animationDuration: animationDuration,
      animationCurve: animationCurve,
      semanticsLabel: semanticsLabel,
      semanticsValue: semanticsValue,
      excludeSemantics: excludeSemantics,
    );
  }
}
