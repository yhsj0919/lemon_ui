import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/core/hyper_theme.dart';
import '../slider/hyper_slider.dart';
import '../icon_button/hyper_icon_button.dart';
import '../slider/hyper_slider_style.dart';
import '../text_field/hyper_text_field.dart';
import 'hyper_color_picker_style.dart';
import 'hyper_color_picker_theme.dart';

/// 受控 HSV 颜色选择器；支持透明度及 #RRGGBB / #AARRGGBB 输入。
class HyperColorPicker extends StatefulWidget {
  const HyperColorPicker({
    super.key,
    required this.value,
    this.onChanged,
    this.showAlpha = true,
    this.style,
    this.recommendedColors = const [],
  });
  final Color value;
  final ValueChanged<Color>? onChanged;
  final bool showAlpha;
  final HyperColorPickerStyle? style;

  /// 可选推荐色；空列表不显示推荐区域，选择时使用该颜色的完整值。
  final List<Color> recommendedColors;

  static Color? parseHex(String source) {
    final hex = source.trim().replaceFirst(RegExp(r'^#'), '');
    if (!RegExp(r'^(?:[0-9a-fA-F]{6}|[0-9a-fA-F]{8})$').hasMatch(hex)) {
      return null;
    }
    return Color(int.parse(hex.length == 6 ? 'ff$hex' : hex, radix: 16));
  }

  @override
  State<HyperColorPicker> createState() => _HyperColorPickerState();
}

class _HyperColorPickerState extends State<HyperColorPicker> {
  late HSVColor _hsv = HSVColor.fromColor(widget.value);
  late final _input = TextEditingController(text: _hex(widget.value));
  String? _error;
  String _hex(Color color) =>
      '#${color.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}';
  @override
  void didUpdateWidget(HyperColorPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _hsv.toColor()) _hsv = HSVColor.fromColor(widget.value);
    if (oldWidget.value != widget.value) {
      _input.text = _hex(widget.value);
      _error = null;
    }
  }

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  void _change(HSVColor value) {
    if (widget.onChanged == null) return;
    // 保留黑色或灰色时所选色相；父级仍是最终颜色的所有者。
    _hsv = value;
    widget.onChanged!(value.toColor());
  }

  void _submit(String text) {
    final color = HyperColorPicker.parseHex(text);
    if (color == null) {
      setState(() => _error = '请输入 6 位 RGB 或 8 位 ARGB');
      return;
    }
    setState(() => _error = null);
    _change(
      HSVColor.fromColor(
        widget.showAlpha ? color : color.withValues(alpha: widget.value.a),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final size = HyperTheme.sizesOf(context).colorPicker;
    final style = HyperColorPickerStyle(
      centerRadiusFraction: .12,
      pureColorRadiusFraction: .9,
      hueSnapDegrees: 3,
      endpointSnapThreshold: .02,
      width: size.width,
      paletteHeight: size.paletteHeight,
      radius: size.radius,
      spacing: size.spacing,
      markerRadius: size.markerRadius,
      previewHeight: size.previewHeight,
      markerColor: theme.colors.surface,
      checkerLightColor: Colors.white,
      checkerDarkColor: const Color(0xFFBDBDBD),
      paletteBorder: BorderSide(color: theme.colors.outline),
    ).merge(HyperColorPickerTheme.of(context).style).merge(widget.style);
    final hsv = widget.value == _hsv.toColor()
        ? _hsv
        : HSVColor.fromColor(widget.value);
    final centerFraction = style.centerRadiusFraction!.clamp(0.0, .99);
    final edgeFraction = style.pureColorRadiusFraction!.clamp(
      centerFraction + .001,
      1.0,
    );
    double snapEndpoint(double value) {
      final threshold = style.endpointSnapThreshold!.clamp(0.0, .49);
      if (value <= threshold) return 0;
      if (value >= 1 - threshold) return 1;
      return value;
    }

    final enabled = widget.onChanged != null;
    final sliderSize = HyperTheme.sizesOf(context).slider;
    final sliderRadius =
        style.sliderStyle?.thumbRadius ?? sliderSize.thumbRadius;
    final sliderWidth =
        (style.sliderStyle?.overlayRadius ?? sliderRadius * 1.5) * 2;
    HyperSliderStyle gradientStyle(
      List<Color> colors, {
      bool checker = false,
    }) => HyperSliderStyle(
      showValueIndicator: ShowValueIndicator.never,
      trackShape: _ColorTrackShape(
        colors,
        checker: checker,
        light: style.checkerLightColor!,
        dark: style.checkerDarkColor!,
      ),
      thumbOutlineColor: theme.colors.outline,
      trackHeight: sliderSize.trackHeight * .65,
      thumbRadius: sliderRadius * .65,
      overlayRadius: sliderRadius * 1.5,
    ).merge(style.sliderStyle);
    return SizedBox(
      width: style.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final extent = math.min(
                style.paletteHeight!,
                math.max(
                  0.0,
                  constraints.maxWidth - sliderWidth - style.spacing!,
                ),
              );
              return Row(
                children: [
                  Expanded(
                    child: Focus(
                      canRequestFocus: enabled,
                      onKeyEvent: (node, event) {
                        if (event is! KeyDownEvent || !enabled) {
                          return KeyEventResult.ignored;
                        }
                        final delta = switch (event.logicalKey) {
                          LogicalKeyboardKey.arrowLeft => const Offset(-1, 0),
                          LogicalKeyboardKey.arrowRight => const Offset(1, 0),
                          LogicalKeyboardKey.arrowUp => const Offset(0, .01),
                          LogicalKeyboardKey.arrowDown => const Offset(0, -.01),
                          _ => null,
                        };
                        if (delta == null) return KeyEventResult.ignored;
                        _change(
                          hsv
                              .withHue((hsv.hue + delta.dx) % 360)
                              .withSaturation(
                                (hsv.saturation + delta.dy).clamp(0, 1),
                              ),
                        );
                        return KeyEventResult.handled;
                      },
                      child: Semantics(
                        label: '色相与饱和度',
                        enabled: enabled,
                        value:
                            '${hsv.hue.round()} 度，${(hsv.saturation * 100).round()}%',
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final extent = math.min(
                              constraints.maxWidth,
                              style.paletteHeight!,
                            );
                            void select(Offset point) {
                              if (extent <= 0) return;
                              final delta =
                                  point - Offset(extent / 2, extent / 2);
                              var hue =
                                  (math.atan2(delta.dy, delta.dx) *
                                          180 /
                                          math.pi +
                                      90) %
                                  360;
                              final nearestHue =
                                  ((hue / 60).round() * 60) % 360;
                              final difference = (hue - nearestHue).abs();
                              if (math.min(difference, 360 - difference) <=
                                  style.hueSnapDegrees!) {
                                hue = nearestHue.toDouble();
                              }
                              final radial = delta.distance / (extent / 2);
                              final saturation =
                                  ((radial - centerFraction) /
                                          (edgeFraction - centerFraction))
                                      .clamp(0.0, 1.0);
                              _change(
                                hsv
                                    .withHue(saturation == 0 ? hsv.hue : hue)
                                    .withSaturation(saturation),
                              );
                            }

                            return GestureDetector(
                              onTapDown: enabled
                                  ? (event) => select(event.localPosition)
                                  : null,
                              onPanStart: enabled
                                  ? (event) => select(event.localPosition)
                                  : null,
                              onPanUpdate: enabled
                                  ? (event) => select(event.localPosition)
                                  : null,
                              child: ClipOval(
                                child: CustomPaint(
                                  key: const ValueKey(
                                    'hyper-color-picker-palette',
                                  ),
                                  size: Size.square(extent),
                                  painter: _PalettePainter(hsv, style),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: style.spacing),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: HyperVerticalSlider(
                      height: extent,
                      value: hsv.value,
                      label: '明度',
                      style: gradientStyle([
                        Colors.black,
                        hsv.withAlpha(1).withValue(1).toColor(),
                      ]),
                      semanticFormatterCallback: (value) =>
                          '明度 ${(value * 100).round()}%',
                      onChanged: enabled
                          ? (value) =>
                                _change(hsv.withValue(snapEndpoint(value)))
                          : null,
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: style.spacing),
          if (widget.showAlpha)
            HyperSlider(
              value: widget.value.a,
              label: '不透明度',
              style: gradientStyle([
                widget.value.withValues(alpha: 0),
                widget.value.withValues(alpha: 1),
              ], checker: true),
              semanticFormatterCallback: (value) =>
                  '不透明度 ${(value * 100).round()}%',
              onChanged: enabled
                  ? (value) => _change(hsv.withAlpha(snapEndpoint(value)))
                  : null,
            ),
          SizedBox(height: style.spacing),
          if (widget.recommendedColors.isNotEmpty)
            Wrap(
              spacing: style.spacing!,
              runSpacing: style.spacing!,
              children: [
                for (final color in widget.recommendedColors)
                  HyperIconButton.outlined(
                    tooltip: _hex(color),
                    icon: Icon(Icons.circle, color: color),
                    onPressed: enabled
                        ? () => _change(
                            HSVColor.fromColor(
                              widget.showAlpha
                                  ? color
                                  : color.withValues(alpha: 1),
                            ),
                          )
                        : null,
                  ),
              ],
            ),
          if (widget.recommendedColors.isNotEmpty)
            SizedBox(height: style.spacing),
          HyperTextField(
            controller: _input,
            enabled: enabled,
            label: 'HEX',
            hintText: '#AARRGGBB',
            errorText: _error,
            style: style.fieldStyle,
            onChanged: (text) {
              final hex = text.trim().replaceFirst('#', '');
              if (hex.length == 8 && HyperColorPicker.parseHex(text) != null) {
                _submit(text);
              }
            },
            onSubmitted: _submit,
          ),
        ],
      ),
    );
  }
}

class _PalettePainter extends CustomPainter {
  _PalettePainter(this.hsv, this.style);
  final HSVColor hsv;
  final HyperColorPickerStyle style;
  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final rect = Offset.zero & size;
    final origin = rect.center;
    final wheelRadius = math.min(size.width, size.height) / 2;
    canvas.drawCircle(
      origin,
      wheelRadius,
      Paint()
        ..shader = SweepGradient(
          transform: const GradientRotation(-math.pi / 2),
          colors: List.generate(
            7,
            (i) => HSVColor.fromAHSV(1, (i * 60) % 360, 1, hsv.value).toColor(),
          ),
        ).createShader(rect),
    );
    canvas.drawCircle(
      origin,
      wheelRadius,
      Paint()
        ..shader = RadialGradient(
          colors: [
            HSVColor.fromAHSV(1, 0, 0, hsv.value).toColor(),
            HSVColor.fromAHSV(1, 0, 0, hsv.value).toColor(),
            HSVColor.fromAHSV(0, 0, 0, hsv.value).toColor(),
            HSVColor.fromAHSV(0, 0, 0, hsv.value).toColor(),
          ],
          stops: [
            0,
            style.centerRadiusFraction!.clamp(0.0, .99),
            style.pureColorRadiusFraction!.clamp(
              style.centerRadiusFraction!.clamp(0.0, .99) + .001,
              1.0,
            ),
            1,
          ],
        ).createShader(rect),
    );
    final border = style.paletteBorder!;
    canvas.drawCircle(
      origin,
      math.max(0, wheelRadius - border.width / 2),
      Paint()
        ..color = border.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = border.width,
    );
    final radius = style.markerRadius!.clamp(0.0, wheelRadius);
    final angle = (hsv.hue - 90) * math.pi / 180;
    final distance = math.min(
      (hsv.saturation == 0
              ? 0
              : style.centerRadiusFraction!.clamp(0.0, .99) +
                    hsv.saturation *
                        (style.pureColorRadiusFraction!.clamp(
                              style.centerRadiusFraction!.clamp(0.0, .99) +
                                  .001,
                              1.0,
                            ) -
                            style.centerRadiusFraction!.clamp(0.0, .99))) *
          wheelRadius,
      wheelRadius - radius,
    );
    final center = origin + Offset(math.cos(angle), math.sin(angle)) * distance;
    canvas.drawCircle(
      center,
      radius,
      Paint()..color = hsv.withAlpha(1).toColor(),
    );
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = style.markerColor!
        ..style = PaintingStyle.stroke
        ..strokeWidth = border.width,
    );
  }

  @override
  bool shouldRepaint(_PalettePainter old) =>
      old.hsv != hsv || old.style != style;
}

class _ColorTrackShape extends RoundedRectSliderTrackShape {
  const _ColorTrackShape(
    this.colors, {
    required this.checker,
    required this.light,
    required this.dark,
  });
  final List<Color> colors;
  final bool checker;
  final Color light, dark;
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
    final rect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    if (rect.isEmpty) return;
    final canvas = context.canvas;
    canvas.save();
    canvas.clipRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(rect.height / 2)),
    );
    if (checker) {
      final cell = rect.height / 4;
      for (var y = 0; y < 4; y++) {
        for (var x = 0; x * cell < rect.width; x++) {
          canvas.drawRect(
            Rect.fromLTWH(
              rect.left + x * cell,
              rect.top + y * cell,
              cell,
              cell,
            ),
            Paint()..color = (x + y).isEven ? light : dark,
          );
        }
      }
    }
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          colors: colors,
          begin: textDirection == TextDirection.ltr
              ? Alignment.centerLeft
              : Alignment.centerRight,
          end: textDirection == TextDirection.ltr
              ? Alignment.centerRight
              : Alignment.centerLeft,
        ).createShader(rect),
    );
    if (!isEnabled) {
      canvas.drawRect(rect, Paint()..color = light.withValues(alpha: .5));
    }
    canvas.restore();
  }
}
