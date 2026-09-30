import 'package:flutter/material.dart';

/// 白色圆心与轨道同色外圈，绘制在厚胶囊轨道内。
class HyperSliderThumbShape extends RoundSliderThumbShape {
  const HyperSliderThumbShape({
    required double radius,
    required this.outlineWidth,
    this.outlineColor,
    required this.pressedScale,
    required this.pressFactor,
    required this.reduceMotion,
  }) : super(enabledThumbRadius: radius, elevation: 0, pressedElevation: 0);

  final double outlineWidth;
  final Color? outlineColor;
  final double pressedScale;
  final double pressFactor;
  final bool reduceMotion;

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    _paintThumb(
      context.canvas,
      center,
      enabledThumbRadius,
      outlineWidth,
      reduceMotion ? 1 : 1 + (pressedScale - 1) * pressFactor,
      Color.lerp(
        sliderTheme.disabledActiveTrackColor,
        outlineColor ?? sliderTheme.activeTrackColor,
        enableAnimation.value,
      )!,
      Color.lerp(
        sliderTheme.disabledThumbColor,
        sliderTheme.thumbColor,
        enableAnimation.value,
      )!,
    );
  }
}

class HyperRangeSliderThumbShape extends RoundRangeSliderThumbShape {
  const HyperRangeSliderThumbShape({
    required double radius,
    required this.outlineWidth,
    this.outlineColor,
    required this.pressedScale,
    required this.pressFactor,
    required this.reduceMotion,
    this.pressedThumb,
  }) : super(enabledThumbRadius: radius, elevation: 0, pressedElevation: 0);

  final double outlineWidth;
  final Color? outlineColor;
  final double pressedScale;
  final double pressFactor;
  final bool reduceMotion;
  final Thumb? pressedThumb;

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool isDiscrete = false,
    bool isEnabled = false,
    bool? isOnTop,
    required SliderThemeData sliderTheme,
    TextDirection? textDirection,
    Thumb? thumb,
    bool? isPressed,
  }) {
    _paintThumb(
      context.canvas,
      center,
      enabledThumbRadius,
      outlineWidth,
      reduceMotion ||
              (pressedThumb == null ? isPressed != true : thumb != pressedThumb)
          ? 1
          : 1 + (pressedScale - 1) * pressFactor,
      Color.lerp(
        sliderTheme.disabledActiveTrackColor,
        outlineColor ?? sliderTheme.activeTrackColor,
        enableAnimation.value,
      )!,
      Color.lerp(
        sliderTheme.disabledThumbColor,
        sliderTheme.thumbColor,
        enableAnimation.value,
      )!,
    );
  }
}

void _paintThumb(
  Canvas canvas,
  Offset center,
  double radius,
  double outlineWidth,
  double innerScale,
  Color outline,
  Color fill,
) {
  canvas.drawCircle(center, radius, Paint()..color = outline);
  canvas.drawCircle(
    center,
    ((radius - outlineWidth) * innerScale).clamp(0.0, radius),
    Paint()..color = fill,
  );
}
