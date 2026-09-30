import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../motion/hyper_elastic_overscroll.dart';
import '../../theme/core/hyper_theme.dart';
import 'hyper_slider_style.dart';
import 'hyper_slider_theme.dart';

/// 整块填充的竖向胶囊滑块；顶部和底部可放置独立的图标操作。
class HyperCapsuleSlider extends StatefulWidget {
  const HyperCapsuleSlider({
    super.key,
    required this.value,
    required this.onChanged,
    required this.height,
    this.min = 0,
    this.max = 1,
    this.topIcon,
    this.bottomIcon,
    this.onTopIconPressed,
    this.onBottomIconPressed,
    this.onChangeStart,
    this.onChangeEnd,
    this.semanticFormatterCallback,
    this.style,
    this.focusNode,
    this.autofocus = false,
  }) : assert(height > 0),
       assert(max >= min);

  final double value;
  final ValueChanged<double>? onChanged;
  final double height;
  final double min;
  final double max;
  final Widget? topIcon;
  final Widget? bottomIcon;
  final VoidCallback? onTopIconPressed;
  final VoidCallback? onBottomIconPressed;
  final ValueChanged<double>? onChangeStart;
  final ValueChanged<double>? onChangeEnd;
  final String Function(double)? semanticFormatterCallback;
  final HyperSliderStyle? style;
  final FocusNode? focusNode;
  final bool autofocus;

  @override
  State<HyperCapsuleSlider> createState() => _HyperCapsuleSliderState();
}

class _HyperCapsuleSliderState extends State<HyperCapsuleSlider>
    with SingleTickerProviderStateMixin {
  bool _dragging = false;
  double? _dragValue;
  double _dragStartY = 0;
  double _dragStartValue = 0;
  late final HyperElasticOverscrollController _overscroll;

  @override
  void initState() {
    super.initState();
    _overscroll = HyperElasticOverscrollController(vsync: this);
  }

  @override
  void dispose() {
    _overscroll.dispose();
    super.dispose();
  }

  bool get _enabled => widget.onChanged != null && widget.max > widget.min;

  Color _readableColor(Color preferred, Color surface) {
    final visible = Color.alphaBlend(preferred, surface);
    final luminance = surface.computeLuminance();
    final iconLuminance = visible.computeLuminance();
    final lighter = math.max(luminance, iconLuminance);
    final darker = math.min(luminance, iconLuminance);
    if ((lighter + .05) / (darker + .05) >= 3) return preferred;
    return luminance > .179 ? Colors.black : Colors.white;
  }

  double get _fraction => widget.max <= widget.min
      ? 0
      : ((widget.value - widget.min) / (widget.max - widget.min)).clamp(
          0.0,
          1.0,
        );

  void _change(double value) {
    if (!_enabled) return;
    final next = value.clamp(widget.min, widget.max);
    _dragValue = next;
    if (next != widget.value) widget.onChanged?.call(next);
  }

  void _step(bool increase) {
    if (!_enabled) return;
    final delta = (widget.max - widget.min) / 20;
    _change(widget.value + (increase ? delta : -delta));
  }

  void _dragTo(double y, double maxExtent, bool reduceMotion) {
    final range = widget.max - widget.min;
    final rawY =
        widget.height * (1 - (_dragStartValue - widget.min) / range) +
        (y - _dragStartY);
    _change(widget.min + (1 - rawY / widget.height).clamp(0.0, 1.0) * range);
    final beyond = rawY < 0
        ? rawY
        : (rawY > widget.height ? rawY - widget.height : 0.0);
    _overscroll.pull(beyond, maxExtent: maxExtent, disabled: reduceMotion);
  }

  void _endDrag(SpringDescription spring, bool reduceMotion) {
    setState(() => _dragging = false);
    _overscroll.release(spring: spring, disabled: reduceMotion);
    widget.onChangeEnd?.call(_dragValue ?? widget.value);
    _dragValue = null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final colors = theme.colors;
    final metrics = HyperTheme.sizesOf(context).slider;
    final style = HyperSliderTheme.of(context).style.merge(widget.style);
    final width = style.capsuleWidth ?? metrics.capsuleWidth;
    final radius = style.capsuleCornerRadius ?? metrics.capsuleCornerRadius;
    final iconSize = style.capsuleIconSize ?? metrics.capsuleIconSize;
    final iconInset = style.capsuleIconInset ?? metrics.capsuleIconInset;
    final iconExtent = (width - iconInset * 2).clamp(iconSize, width);
    final background =
        style.capsuleBackgroundColor ??
        Color.alphaBlend(
          colors.textPrimary.withValues(alpha: .52),
          colors.surfaceElevated,
        );
    final fill = style.capsuleFillColor ?? colors.surfaceElevated;
    final borderWidth = style.capsuleBorderWidth ?? 0;
    final maxExtent =
        style.capsuleOverscrollExtent ?? metrics.capsuleOverscrollExtent;
    final maxScale = style.capsuleOverscrollScale ?? 1.025;
    final autoIconContrast = style.capsuleAutoIconContrast ?? true;
    final motionSpring = theme.motion.spring;
    final spring =
        style.capsuleOverscrollSpring ??
        HyperElasticOverscrollController.springFromMotion(motionSpring);
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final duration = reduceMotion || _dragging
        ? Duration.zero
        : (style.capsuleAnimationDuration ?? theme.motion.fastDuration);
    final curve = style.capsuleAnimationCurve ?? theme.motion.fastCurve;
    final fraction = _fraction;
    final valueLabel =
        widget.semanticFormatterCallback?.call(widget.value) ??
        '${(fraction * 100).round()}%';

    Widget iconAction({
      required Widget icon,
      required Color color,
      required double turns,
      required double progress,
      required VoidCallback? onPressed,
    }) {
      final child = Transform.rotate(
        angle: progress * turns * math.pi * 2,
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          child: IconTheme.merge(
            data: IconThemeData(size: iconSize, color: color),
            child: icon,
          ),
        ),
      );
      if (onPressed == null) {
        return IgnorePointer(
          child: SizedBox(
            width: iconExtent,
            height: iconExtent,
            child: Center(child: child),
          ),
        );
      }
      return IconButton(
        onPressed: onPressed,
        icon: child,
        iconSize: iconSize,
        color: color,
        padding: EdgeInsets.zero,
        constraints: BoxConstraints.tightFor(
          width: iconExtent,
          height: iconExtent,
        ),
      );
    }

    Widget displaced(Widget child) => HyperElasticOverscrollTransform(
      controller: _overscroll,
      axis: Axis.vertical,
      maxExtent: maxExtent,
      maxScale: maxScale,
      enabled: !reduceMotion,
      transformHitTests: true,
      child: child,
    );

    return Semantics(
      slider: true,
      enabled: _enabled,
      value: valueLabel,
      increasedValue: widget.semanticFormatterCallback?.call(
        (widget.value + (widget.max - widget.min) / 20).clamp(
          widget.min,
          widget.max,
        ),
      ),
      decreasedValue: widget.semanticFormatterCallback?.call(
        (widget.value - (widget.max - widget.min) / 20).clamp(
          widget.min,
          widget.max,
        ),
      ),
      onIncrease: _enabled ? () => _step(true) : null,
      onDecrease: _enabled ? () => _step(false) : null,
      explicitChildNodes: true,
      child: Focus(
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        canRequestFocus: _enabled,
        onKeyEvent: (_, event) {
          if (!_enabled || event is! KeyDownEvent) {
            return KeyEventResult.ignored;
          }
          if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
            _step(true);
            return KeyEventResult.handled;
          }
          if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
            _step(false);
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: SizedBox(
          width: width,
          height: widget.height,
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(end: fraction),
            duration: duration,
            curve: curve,
            builder: (context, progress, child) {
              final fillStart = widget.height * (1 - progress);
              final iconCenter = iconInset + iconExtent / 2;
              final topSurface = iconCenter >= fillStart ? fill : background;
              final bottomSurface = widget.height - iconCenter >= fillStart
                  ? fill
                  : background;
              Color iconColor(
                Color? override,
                Color preferred,
                Color surface,
              ) =>
                  override ??
                  (autoIconContrast
                      ? _readableColor(
                          preferred,
                          Color.alphaBlend(surface, colors.surfaceElevated),
                        )
                      : preferred);
              return Stack(
                clipBehavior: Clip.none,
                fit: StackFit.expand,
                children: [
                  displaced(
                    IgnorePointer(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(radius),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ColoredBox(color: background),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: SizedBox(
                                width: width,
                                height: widget.height * progress,
                                child: ColoredBox(color: fill),
                              ),
                            ),
                            if (borderWidth > 0)
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(radius),
                                  border: Border.all(
                                    color:
                                        style.capsuleBorderColor ??
                                        colors.outline,
                                    width: borderWidth,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onVerticalDragStart: _enabled
                        ? (details) {
                            _dragStartY = details.localPosition.dy;
                            _dragStartValue = widget.value;
                            _overscroll.stop();
                            setState(() => _dragging = true);
                            widget.onChangeStart?.call(widget.value);
                          }
                        : null,
                    onVerticalDragUpdate: _enabled
                        ? (details) => _dragTo(
                            details.localPosition.dy,
                            maxExtent,
                            reduceMotion,
                          )
                        : null,
                    onVerticalDragEnd: _enabled
                        ? (_) => _endDrag(spring, reduceMotion)
                        : null,
                    onVerticalDragCancel: _enabled
                        ? () => _endDrag(spring, reduceMotion)
                        : null,
                  ),
                  if (widget.topIcon != null || widget.bottomIcon != null)
                    displaced(
                      ClipRRect(
                        borderRadius: BorderRadius.circular(radius),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            if (widget.topIcon != null)
                              Positioned(
                                top: iconInset,
                                left: 0,
                                right: 0,
                                child: Center(
                                  child: iconAction(
                                    icon: widget.topIcon!,
                                    color: iconColor(
                                      style.capsuleTopIconColor,
                                      Colors.white.withValues(alpha: .5),
                                      topSurface,
                                    ),
                                    turns: style.capsuleTopIconTurns ?? 0,
                                    progress: progress,
                                    onPressed: widget.onTopIconPressed,
                                  ),
                                ),
                              ),
                            if (widget.bottomIcon != null)
                              Positioned(
                                bottom: iconInset,
                                left: 0,
                                right: 0,
                                child: Center(
                                  child: iconAction(
                                    icon: widget.bottomIcon!,
                                    color: iconColor(
                                      style.capsuleBottomIconColor,
                                      colors.primary,
                                      bottomSurface,
                                    ),
                                    turns: style.capsuleBottomIconTurns ?? 0,
                                    progress: progress,
                                    onPressed: widget.onBottomIconPressed,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
