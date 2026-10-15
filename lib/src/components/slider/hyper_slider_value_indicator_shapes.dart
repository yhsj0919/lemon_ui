import 'dart:math' as math;

import 'package:flutter/material.dart';

// Shared painter keeps single and range value labels identical.
void _paintLabel(
  PaintingContext context,
  Offset center,
  RenderBox parent,
  TextPainter label,
  SliderThemeData theme,
  double progress,
  Size bounds,
  EdgeInsets padding,
  double radius,
) {
  if (progress <= 0) return;
  final size = Size(
    label.width + padding.horizontal,
    label.height + padding.vertical,
  );
  final global = parent.localToGlobal(center);
  final available = bounds.width;
  final dx = available > size.width
      ? global.dx.clamp(size.width / 2, available - size.width / 2) - global.dx
      : 0.0;
  final thumbHeight =
      theme.thumbShape?.getPreferredSize(true, false).height ?? 0;
  final rect = Rect.fromLTWH(
    center.dx + dx - size.width / 2,
    center.dy - thumbHeight / 2 - padding.bottom - size.height,
    size.width,
    size.height,
  );
  final canvas = context.canvas;
  canvas.save();
  canvas.translate(rect.center.dx, rect.bottom);
  canvas.scale(progress);
  canvas.translate(-rect.center.dx, -rect.bottom);
  canvas.drawRRect(
    RRect.fromRectAndRadius(
      rect,
      Radius.circular(math.min(radius, size.shortestSide / 2)),
    ),
    Paint()
      ..isAntiAlias = true
      ..color = theme.valueIndicatorColor!,
  );
  label.paint(canvas, rect.topLeft + Offset(padding.left, padding.top));
  canvas.restore();
}

typedef HyperSliderLabelCallback = void Function(
  RenderBox parent,
  Offset center,
  TextPainter painter,
  Thumb? thumb,
);

class HyperSliderValueIndicatorShape extends SliderComponentShape {
  const HyperSliderValueIndicatorShape({
    required this.padding,
    required this.radius,
    this.onLabel,
  });
  final HyperSliderLabelCallback? onLabel;
  final EdgeInsets padding;
  final double radius;
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      Size(padding.horizontal, padding.vertical);
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
    if (onLabel != null) {
      final rect = sliderTheme.trackShape!.getPreferredRect(
        parentBox: parentBox,
        sliderTheme: sliderTheme,
        isEnabled: true,
        isDiscrete: isDiscrete,
      );
      final inset = sliderTheme.trackShape!.isRounded
          ? (sliderTheme.trackHeight ?? 0) / 2
          : 0.0;
      final fraction = textDirection == TextDirection.rtl ? 1 - value : value;
      onLabel!(
        parentBox,
        Offset(
          rect.left + inset + (rect.width - 2 * inset) * fraction,
          rect.center.dy,
        ),
        labelPainter,
        null,
      );
      return;
    }
    _paintLabel(
      context,
      center,
      parentBox,
      labelPainter,
      sliderTheme,
      activationAnimation.value,
      sizeWithOverflow,
      padding,
      radius,
    );
  }
}

class HyperRangeSliderValueIndicatorShape
    extends RangeSliderValueIndicatorShape {
  const HyperRangeSliderValueIndicatorShape({
    required this.padding,
    required this.radius,
    this.onLabel,
  });
  final HyperSliderLabelCallback? onLabel;
  final EdgeInsets padding;
  final double radius;
  @override
  Size getPreferredSize(
    bool isEnabled,
    bool isDiscrete, {
    required TextPainter labelPainter,
    required double textScaleFactor,
  }) => Size(
    labelPainter.width + padding.horizontal,
    labelPainter.height + padding.vertical,
  );
  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool isDiscrete = false,
    bool isOnTop = false,
    required TextPainter labelPainter,
    double textScaleFactor = 1,
    Size sizeWithOverflow = Size.zero,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    TextDirection textDirection = TextDirection.ltr,
    double value = 0,
    Thumb thumb = Thumb.start,
  }) {
    if (onLabel != null) {
      final rect = sliderTheme.rangeTrackShape!.getPreferredRect(
        parentBox: parentBox,
        sliderTheme: sliderTheme,
        isEnabled: true,
        isDiscrete: isDiscrete,
      );
      final fraction = textDirection == TextDirection.rtl ? 1 - value : value;
      onLabel!(
        parentBox,
        Offset(rect.left + rect.width * fraction, rect.center.dy),
        labelPainter,
        thumb,
      );
      return;
    }
    _paintLabel(
      context,
      center,
      parentBox,
      labelPainter,
      sliderTheme,
      activationAnimation.value,
      sizeWithOverflow,
      padding,
      radius,
    );
  }
}
