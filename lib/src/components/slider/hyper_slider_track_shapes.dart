import 'package:flutter/material.dart';

/// 胶囊轨道：刻度中心沿拇指可移动区间排布，并裁剪在轨道内。
class HyperSliderTrackShape extends RoundedRectSliderTrackShape {
  const HyperSliderTrackShape({
    this.divisions,
    this.pointRadius = 0,
    this.activePointColor = const Color(0xA3FFFFFF),
    this.inactivePointColor = const Color(0x6B000000),
  });

  final int? divisions;
  final double pointRadius;
  final Color activePointColor;
  final Color inactivePointColor;

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 2,
  }) {
    final height = sliderTheme.trackHeight ?? 0;
    if (height <= 0) return;
    final travel = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    final half = height / 2;
    final pointTravel = _pointTravel(travel);
    final radius = Radius.circular(half);
    final track = RRect.fromRectAndRadius(travel, radius);
    final canvas = context.canvas;
    final inactive = Color.lerp(
      sliderTheme.disabledInactiveTrackColor,
      sliderTheme.inactiveTrackColor,
      enableAnimation.value,
    )!;
    final active = Color.lerp(
      sliderTheme.disabledActiveTrackColor,
      sliderTheme.activeTrackColor,
      enableAnimation.value,
    )!;
    canvas.save();
    canvas.clipRRect(track);
    canvas.drawRRect(
      track,
      Paint()
        ..isAntiAlias = true
        ..color = inactive,
    );
    final selected = textDirection == TextDirection.ltr
        ? Rect.fromLTRB(
            travel.left,
            travel.top,
            thumbCenter.dx + half,
            travel.bottom,
          )
        : Rect.fromLTRB(
            thumbCenter.dx - half,
            travel.top,
            travel.right,
            travel.bottom,
          );
    canvas.drawRRect(
      RRect.fromRectAndRadius(selected, radius),
      Paint()
        ..isAntiAlias = true
        ..color = active,
    );
    _paintPoints(
      canvas: canvas,
      travel: pointTravel,
      divisions: divisions,
      radius: pointRadius,
      enabledAnimation: enableAnimation,
      disabledColor: sliderTheme.disabledThumbColor!,
      activeColor: activePointColor,
      inactiveColor: inactivePointColor,
      isSelected: (x) => textDirection == TextDirection.ltr
          ? x <= thumbCenter.dx
          : x >= thumbCenter.dx,
    );
    canvas.restore();
  }
}

/// 范围滑块与单值滑块共用同一端点规则。
class HyperRangeSliderTrackShape extends RoundedRectRangeSliderTrackShape {
  const HyperRangeSliderTrackShape({
    this.divisions,
    this.pointRadius = 0,
    this.activePointColor = const Color(0xA3FFFFFF),
    this.inactivePointColor = const Color(0x6B000000),
  });

  final int? divisions;
  final double pointRadius;
  final Color activePointColor;
  final Color inactivePointColor;

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset startThumbCenter,
    required Offset endThumbCenter,
    bool isEnabled = false,
    bool isDiscrete = false,
    required TextDirection textDirection,
    double additionalActiveTrackHeight = 2,
  }) {
    final height = sliderTheme.trackHeight ?? 0;
    if (height <= 0) return;
    final travel = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    final half = height / 2;
    final pointTravel = _pointTravel(travel);
    final radius = Radius.circular(half);
    final track = RRect.fromRectAndRadius(travel, radius);
    final left = startThumbCenter.dx < endThumbCenter.dx
        ? startThumbCenter.dx
        : endThumbCenter.dx;
    final right = startThumbCenter.dx > endThumbCenter.dx
        ? startThumbCenter.dx
        : endThumbCenter.dx;
    final canvas = context.canvas;
    final inactive = Color.lerp(
      sliderTheme.disabledInactiveTrackColor,
      sliderTheme.inactiveTrackColor,
      enableAnimation.value,
    )!;
    final active = Color.lerp(
      sliderTheme.disabledActiveTrackColor,
      sliderTheme.activeTrackColor,
      enableAnimation.value,
    )!;
    canvas.save();
    canvas.clipRRect(track);
    canvas.drawRRect(
      track,
      Paint()
        ..isAntiAlias = true
        ..color = inactive,
    );
    canvas.drawRRect(
      RRect.fromLTRBR(
        left - half,
        travel.top,
        right + half,
        travel.bottom,
        radius,
      ),
      Paint()
        ..isAntiAlias = true
        ..color = active,
    );
    _paintPoints(
      canvas: canvas,
      travel: pointTravel,
      divisions: divisions,
      radius: pointRadius,
      enabledAnimation: enableAnimation,
      disabledColor: sliderTheme.disabledThumbColor!,
      activeColor: activePointColor,
      inactiveColor: inactivePointColor,
      isSelected: (x) => x >= left && x <= right,
    );
    canvas.restore();
  }
}

Rect _pointTravel(Rect track) {
  // Rounded Flutter sliders place the thumb at least half a track height
  // inside each end. Tick centers follow those same endpoints.
  final inset = (track.height / 2).clamp(0.0, track.width / 2);
  return Rect.fromLTRB(
    track.left + inset,
    track.top,
    track.right - inset,
    track.bottom,
  );
}

void _paintPoints({
  required Canvas canvas,
  required Rect travel,
  required int? divisions,
  required double radius,
  required Animation<double> enabledAnimation,
  required Color disabledColor,
  required Color activeColor,
  required Color inactiveColor,
  required bool Function(double x) isSelected,
}) {
  if (divisions == null || divisions <= 0 || radius <= 0) return;
  for (var index = 0; index <= divisions; index++) {
    final x = travel.left + travel.width * index / divisions;
    canvas.drawCircle(
      Offset(x, travel.center.dy),
      radius,
      Paint()
        ..isAntiAlias = true
        ..color = Color.lerp(
          disabledColor,
          isSelected(x) ? activeColor : inactiveColor,
          enabledAnimation.value,
        )!,
    );
  }
}
