import 'package:flutter/material.dart';

/// 白色圆心与轨道同色外圈，绘制在厚胶囊轨道内。
class HyperSliderThumbShape extends RoundSliderThumbShape {
  const HyperSliderThumbShape({
    required double radius,
    this.width,
    this.height,
    this.shadows,
    required this.outlineWidth,
    this.outlineColor,
    required this.pressedScale,
    required this.pressFactor,
    required this.reduceMotion,
  }) : super(enabledThumbRadius: radius, elevation: 0, pressedElevation: 0);

  final double? width, height;
  final List<BoxShadow>? shadows;
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      Size(width ?? enabledThumbRadius * 2, height ?? enabledThumbRadius * 2);

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
      Size(width ?? enabledThumbRadius * 2, height ?? enabledThumbRadius * 2),
      shadows,
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
    this.width,
    this.height,
    this.shadows,
    required this.outlineWidth,
    this.outlineColor,
    required this.pressedScale,
    required this.pressFactor,
    required this.reduceMotion,
    this.pressedThumb,
  }) : super(enabledThumbRadius: radius, elevation: 0, pressedElevation: 0);

  final double? width, height;
  final List<BoxShadow>? shadows;
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      Size(width ?? enabledThumbRadius * 2, height ?? enabledThumbRadius * 2);
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
      Size(width ?? enabledThumbRadius * 2, height ?? enabledThumbRadius * 2),
      shadows,
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
  Size size,
  List<BoxShadow>? shadows,
  double outlineWidth,
  double innerScale,
  Color outline,
  Color fill,
) {
  final rect = Rect.fromCenter(
    center: center,
    width: size.width,
    height: size.height,
  );
  final radius = size.shortestSide / 2;
  final shape = RRect.fromRectAndRadius(rect, Radius.circular(radius));
  for (final shadow in shadows ?? const <BoxShadow>[]) {
    final shadowRect = rect.shift(shadow.offset).inflate(shadow.spreadRadius);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        shadowRect,
        Radius.circular(
          (radius + shadow.spreadRadius).clamp(0, double.infinity),
        ),
      ),
      shadow.toPaint(),
    );
  }
  canvas.drawRRect(
    shape,
    Paint()
      ..isAntiAlias = true
      ..color = outline,
  );
  final inset = outlineWidth.clamp(0.0, radius);
  final inner = rect.deflate(inset);
  final scaled = Rect.fromCenter(
    center: center,
    width: (inner.width * innerScale).clamp(0, rect.width),
    height: (inner.height * innerScale).clamp(0, rect.height),
  );
  canvas.drawRRect(
    RRect.fromRectAndRadius(scaled, Radius.circular(scaled.shortestSide / 2)),
    Paint()
      ..isAntiAlias = true
      ..color = fill,
  );
}
