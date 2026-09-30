import 'package:flutter/material.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_slider_style.dart';
import 'hyper_slider_theme.dart';
import 'hyper_slider_thumb_shapes.dart';
import 'hyper_slider_track_shapes.dart';

enum HyperSliderVariant { capsule, thin }

/// 单值滑块；onChanged 为 null 时禁用。
class HyperSlider extends StatelessWidget {
  const HyperSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 1,
    this.divisions,
    this.snapToDivisions = true,
    this.showDivisionPoints = false,
    this.variant = HyperSliderVariant.capsule,
    this.label,
    this.onChangeStart,
    this.onChangeEnd,
    this.semanticFormatterCallback,
    this.style,
    this.autofocus = false,
    this.focusNode,
  });

  final double value;
  final ValueChanged<double>? onChanged;
  final double min;
  final double max;
  final int? divisions;

  /// divisions 非空时是否吸附；false 时仍可显示刻度点并连续取值。
  final bool snapToDivisions;
  final bool showDivisionPoints;
  final HyperSliderVariant variant;
  final String? label;
  final ValueChanged<double>? onChangeStart;
  final ValueChanged<double>? onChangeEnd;
  final SemanticFormatterCallback? semanticFormatterCallback;
  final HyperSliderStyle? style;
  final bool autofocus;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) => _SliderInteraction(
    enabled: onChanged != null,
    builder: (context, hoverFactor, pressFactor) => _sliderTheme(
      context,
      style,
      Slider(
        value: value,
        onChanged: onChanged,
        min: min,
        max: max,
        divisions: snapToDivisions ? divisions : null,
        label: label,
        onChangeStart: onChangeStart,
        onChangeEnd: onChangeEnd,
        semanticFormatterCallback: semanticFormatterCallback,
        autofocus: autofocus,
        focusNode: focusNode,
      ),
      divisions: showDivisionPoints ? divisions : null,
      variant: variant,
      hoverFactor: hoverFactor,
      pressFactor: pressFactor,
    ),
  );
}

/// 双端范围滑块，使用与 [HyperSlider] 相同的主题。
class HyperRangeSlider extends StatefulWidget {
  const HyperRangeSlider({
    super.key,
    required this.values,
    required this.onChanged,
    this.min = 0,
    this.max = 1,
    this.divisions,
    this.snapToDivisions = true,
    this.showDivisionPoints = false,
    this.variant = HyperSliderVariant.capsule,
    this.labels,
    this.onChangeStart,
    this.onChangeEnd,
    this.semanticFormatterCallback,
    this.style,
  });

  final RangeValues values;
  final ValueChanged<RangeValues>? onChanged;
  final double min;
  final double max;
  final int? divisions;
  final bool snapToDivisions;
  final bool showDivisionPoints;
  final HyperSliderVariant variant;
  final RangeLabels? labels;
  final ValueChanged<RangeValues>? onChangeStart;
  final ValueChanged<RangeValues>? onChangeEnd;
  final SemanticFormatterCallback? semanticFormatterCallback;
  final HyperSliderStyle? style;

  @override
  State<HyperRangeSlider> createState() => _HyperRangeSliderState();
}

class _HyperRangeSliderState extends State<HyperRangeSlider> {
  int? _pointer;
  Thumb? _draggedThumb;
  RangeValues? _draggedValues;
  double? _pointerDownValue;
  bool _pointerMoved = false;

  void _releasePointer(int pointer) {
    if (pointer != _pointer) return;
    _pointer = null;
    _pointerDownValue = null;
    _pointerMoved = false;
  }

  void _onNativeChanged(RangeValues values) {
    if (_pointer == null) {
      widget.onChanged?.call(values);
      return;
    }
    if (_draggedThumb != null) {
      if (_pointerMoved || _pointerDownValue == null) return;
      final current = _draggedValues ?? widget.values;
      final tap = _pointerDownValue!;
      final next = _draggedThumb == Thumb.start
          ? RangeValues(tap.clamp(widget.min, current.end), current.end)
          : RangeValues(current.start, tap.clamp(current.start, widget.max));
      if (next != current) {
        _draggedValues = next;
        widget.onChanged?.call(next);
      }
      return;
    }
    final current = _draggedValues ?? widget.values;
    if (values == current) return;
    setState(() {
      _draggedThumb = values.start != current.start ? Thumb.start : Thumb.end;
    });
    _draggedValues = values;
    widget.onChanged?.call(values);
  }

  void _movePointer(PointerMoveEvent event, double Function(double) valueAt) {
    if (event.pointer != _pointer ||
        widget.onChanged == null ||
        widget.max <= widget.min) {
      return;
    }
    final rawPosition = valueAt(event.localPosition.dx)
        .clamp(widget.min, widget.max);
    if (_draggedThumb == null && rawPosition == _pointerDownValue) return;
    _pointerMoved = true;
    final current = _draggedValues ?? widget.values;
    final thumb =
        _draggedThumb ??
        (rawPosition < _pointerDownValue! ? Thumb.start : Thumb.end);
    var position = rawPosition;
    if (widget.snapToDivisions && widget.divisions != null) {
      final step = (widget.max - widget.min) / widget.divisions!;
      position = widget.min + ((position - widget.min) / step).round() * step;
    }
    final RangeValues next;
    var nextThumb = thumb;
    if (thumb == Thumb.start) {
      if (position <= current.end) {
        next = RangeValues(position, current.end);
      } else {
        next = RangeValues(current.end, position);
        nextThumb = Thumb.end;
      }
    } else {
      if (position >= current.start) {
        next = RangeValues(current.start, position);
      } else {
        next = RangeValues(position, current.start);
        nextThumb = Thumb.start;
      }
    }
    if (_draggedThumb != nextThumb) {
      setState(() => _draggedThumb = nextThumb);
    }
    if (next == current) return;
    _draggedValues = next;
    widget.onChanged?.call(next);
  }

  @override
  Widget build(BuildContext context) {
    final metrics = HyperTheme.sizesOf(context).slider;
    final style = HyperSliderTheme.of(context).style.merge(widget.style);
    final radius =
        style.thumbRadius ??
        (widget.variant == HyperSliderVariant.thin
            ? metrics.thinThumbRadius
            : metrics.thumbRadius);
    final padding = (SliderTheme.of(context).padding ?? EdgeInsets.zero)
        .resolve(Directionality.of(context));
    final leading = padding.left;
    final innerPadding = radius;
    final textDirection = Directionality.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final trackLeft = leading + innerPadding;
        final trackWidth =
            constraints.maxWidth - padding.horizontal - innerPadding * 2;
        double valueAt(double x) {
          final fraction = trackWidth <= 0
              ? 0.0
              : ((x - trackLeft) / trackWidth).clamp(0.0, 1.0);
          final logical = textDirection == TextDirection.rtl
              ? 1 - fraction
              : fraction;
          return widget.min + logical * (widget.max - widget.min);
        }

        return _SliderInteraction(
          enabled: widget.onChanged != null,
          builder: (context, hoverFactor, pressFactor) => _sliderTheme(
            context,
            widget.style,
            Listener(
              onPointerDown: (event) {
                if (widget.onChanged == null ||
                    widget.max <= widget.min ||
                    _pointer != null) {
                  return;
                }
                _pointer = event.pointer;
                _draggedValues = widget.values;
                _pointerDownValue = valueAt(event.localPosition.dx);
                _pointerMoved = false;
                final distanceToStart =
                    (_pointerDownValue! - widget.values.start).abs();
                final distanceToEnd = (_pointerDownValue! - widget.values.end)
                    .abs();
                _draggedThumb = widget.values.start == widget.values.end
                    ? null
                    : (distanceToStart <= distanceToEnd
                          ? Thumb.start
                          : Thumb.end);
              },
              onPointerMove: (event) => _movePointer(event, valueAt),
              onPointerUp: (event) => _releasePointer(event.pointer),
              onPointerCancel: (event) => _releasePointer(event.pointer),
              child: RangeSlider(
                values: widget.values,
                onChanged: widget.onChanged == null ? null : _onNativeChanged,
                min: widget.min,
                max: widget.max,
                divisions: widget.snapToDivisions ? widget.divisions : null,
                labels: widget.labels,
                onChangeStart: widget.onChangeStart,
                onChangeEnd: (values) => widget.onChangeEnd?.call(
                  _pointer == null ? values : (_draggedValues ?? values),
                ),
                semanticFormatterCallback: widget.semanticFormatterCallback,
              ),
            ),
            divisions: widget.showDivisionPoints ? widget.divisions : null,
            variant: widget.variant,
            pressedRangeThumb: _draggedThumb,
            hoverFactor: hoverFactor,
            pressFactor: pressFactor,
          ),
        );
      },
    );
  }
}

/// 竖向单值滑块；最小值在底部，最大值在顶部。
class HyperVerticalSlider extends StatelessWidget {
  const HyperVerticalSlider({
    super.key,
    required this.value,
    required this.onChanged,
    required this.height,
    this.min = 0,
    this.max = 1,
    this.divisions,
    this.snapToDivisions = true,
    this.showDivisionPoints = false,
    this.variant = HyperSliderVariant.capsule,
    this.label,
    this.onChangeStart,
    this.onChangeEnd,
    this.semanticFormatterCallback,
    this.style,
    this.autofocus = false,
    this.focusNode,
    this.reverseDirection = false,
  });

  final double value;
  final ValueChanged<double>? onChanged;
  final double height;
  final double min;
  final double max;
  final int? divisions;
  final bool snapToDivisions;
  final bool showDivisionPoints;
  final HyperSliderVariant variant;
  final String? label;
  final ValueChanged<double>? onChangeStart;
  final ValueChanged<double>? onChangeEnd;
  final SemanticFormatterCallback? semanticFormatterCallback;
  final HyperSliderStyle? style;
  final bool autofocus;
  final FocusNode? focusNode;
  final bool reverseDirection;

  @override
  Widget build(BuildContext context) {
    final metrics = HyperTheme.sizesOf(context).slider;
    final resolvedStyle = HyperSliderTheme.of(context).style.merge(style);
    final radius =
        resolvedStyle.thumbRadius ??
        (variant == HyperSliderVariant.thin
            ? metrics.thinThumbRadius
            : metrics.thumbRadius);
    final overlayRadius = resolvedStyle.overlayRadius ?? radius * 1.5;
    return SizedBox(
      width: overlayRadius * 2,
      height: height,
      child: RotatedBox(
        quarterTurns: reverseDirection ? 1 : 3,
        child: HyperSlider(
          value: value,
          onChanged: onChanged,
          min: min,
          max: max,
          divisions: divisions,
          snapToDivisions: snapToDivisions,
          showDivisionPoints: showDivisionPoints,
          variant: variant,
          label: label,
          onChangeStart: onChangeStart,
          onChangeEnd: onChangeEnd,
          semanticFormatterCallback: semanticFormatterCallback,
          style: style,
          autofocus: autofocus,
          focusNode: focusNode,
        ),
      ),
    );
  }
}

typedef _SliderVisualBuilder = Widget Function(
  BuildContext context,
  double hoverFactor,
  double pressFactor,
);

class _SliderInteraction extends StatefulWidget {
  const _SliderInteraction({required this.enabled, required this.builder});

  final bool enabled;
  final _SliderVisualBuilder builder;

  @override
  State<_SliderInteraction> createState() => _SliderInteractionState();
}

class _SliderInteractionState extends State<_SliderInteraction> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  void didUpdateWidget(_SliderInteraction oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.enabled && !widget.enabled) {
      _hovered = false;
      _pressed = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final motion = HyperTheme.of(context).motion;
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final duration = reduceMotion ? Duration.zero : motion.fastDuration;
    return MouseRegion(
      onEnter: (_) {
        if (widget.enabled) setState(() => _hovered = true);
      },
      onExit: (_) {
        if (_hovered) setState(() => _hovered = false);
      },
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (_) {
          if (widget.enabled) setState(() => _pressed = true);
        },
        onPointerUp: (_) {
          if (_pressed) setState(() => _pressed = false);
        },
        onPointerCancel: (_) {
          if (_pressed) setState(() => _pressed = false);
        },
        child: TweenAnimationBuilder<double>(
          tween: Tween(end: _hovered ? 1 : 0),
          duration: duration,
          curve: motion.fastCurve,
          builder: (context, hoverFactor, _) => TweenAnimationBuilder<double>(
            tween: Tween(end: _pressed ? 1 : 0),
            duration: duration,
            curve: motion.fastCurve,
            builder: (context, pressFactor, _) =>
                widget.builder(context, hoverFactor, pressFactor),
          ),
        ),
      ),
    );
  }
}

Widget _sliderTheme(
  BuildContext context,
  HyperSliderStyle? instanceStyle,
  Widget child, {
  int? divisions,
  HyperSliderVariant variant = HyperSliderVariant.capsule,
  Thumb? pressedRangeThumb,
  double hoverFactor = 0,
  double pressFactor = 0,
}) {
  final theme = HyperTheme.of(context);
  final metrics = HyperTheme.sizesOf(context).slider;
  final style = HyperSliderTheme.of(context).style.merge(instanceStyle);
  final colors = theme.colors;
  final radius =
      style.thumbRadius ??
      (variant == HyperSliderVariant.thin
          ? metrics.thinThumbRadius
          : metrics.thumbRadius);
  final overlayRadius = style.overlayRadius ?? radius * 1.5;
  final reduceMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
  final inherited = SliderTheme.of(context);
  final trackHeight =
      style.trackHeight ??
      (variant == HyperSliderVariant.thin
          ? metrics.thinTrackHeight
          : metrics.trackHeight);
  final pointRadius =
      style.stepPointRadius ??
      (variant == HyperSliderVariant.thin
          ? trackHeight / 4
          : metrics.stepPointRadius);
  final activePointColor =
      style.activeStepPointColor ?? Colors.white.withValues(alpha: .64);
  final inactiveTrackColor = style.inactiveTrackColor ?? colors.surfaceMuted;
  final inactivePointColor =
      style.inactiveStepPointColor ??
      colors.textSecondary.withValues(alpha: .42);
  final hoveredInactiveTrackColor =
      style.hoverInactiveTrackColor ??
      Color.alphaBlend(
        colors.stateLayer.withValues(alpha: .06),
        inactiveTrackColor,
      );
  return SliderTheme(
    data: inherited.copyWith(
      padding: inherited.padding ?? EdgeInsets.zero,
      trackHeight: trackHeight,
      activeTrackColor: style.activeTrackColor ?? colors.primary,
      inactiveTrackColor: Color.lerp(
        inactiveTrackColor,
        hoveredInactiveTrackColor,
        hoverFactor,
      ),
      disabledActiveTrackColor:
          style.disabledActiveTrackColor ?? colors.disabled,
      disabledInactiveTrackColor:
          style.disabledInactiveTrackColor ?? colors.surfaceMuted,
      minThumbSeparation: 0,
      thumbColor: style.thumbColor ?? colors.surfaceElevated,
      disabledThumbColor: style.disabledThumbColor ?? colors.disabled,
      overlayColor: style.overlayColor ?? Colors.transparent,
      valueIndicatorColor: style.valueIndicatorColor ?? colors.primary,
      valueIndicatorTextStyle:
          style.valueIndicatorTextStyle ??
          theme.textTheme.labelMedium?.copyWith(color: colors.onPrimary),
      activeTickMarkColor: Colors.transparent,
      inactiveTickMarkColor: Colors.transparent,
      disabledActiveTickMarkColor: Colors.transparent,
      disabledInactiveTickMarkColor: Colors.transparent,
      trackShape:
          style.trackShape ??
          HyperSliderTrackShape(
            divisions: divisions,
            pointRadius: pointRadius,
            activePointColor: activePointColor,
            inactivePointColor: inactivePointColor,
          ),
      thumbShape:
          style.thumbShape ??
          HyperSliderThumbShape(
            radius: radius,
            outlineWidth: style.thumbOutlineWidth ?? radius * .28,
            outlineColor: style.thumbOutlineColor,
            pressedScale: style.pressedThumbScale ?? 1.127,
            pressFactor: pressFactor,
            reduceMotion: reduceMotion,
          ),
      overlayShape:
          style.overlayShape ??
          RoundSliderOverlayShape(overlayRadius: overlayRadius),
      rangeTrackShape:
          style.rangeTrackShape ??
          HyperRangeSliderTrackShape(
            divisions: divisions,
            pointRadius: pointRadius,
            activePointColor: activePointColor,
            inactivePointColor: inactivePointColor,
          ),
      rangeThumbShape:
          style.rangeThumbShape ??
          HyperRangeSliderThumbShape(
            radius: radius,
            outlineWidth: style.thumbOutlineWidth ?? radius * .28,
            outlineColor: style.thumbOutlineColor,
            pressedScale: style.pressedThumbScale ?? 1.127,
            pressFactor: pressFactor,
            reduceMotion: reduceMotion,
            pressedThumb: pressedRangeThumb,
          ),
      rangeValueIndicatorShape:
          style.rangeValueIndicatorShape ??
          const PaddleRangeSliderValueIndicatorShape(),
      valueIndicatorShape: style.valueIndicatorShape,
    ),
    child: child,
  );
}
