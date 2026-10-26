import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_rating_style.dart';
import 'hyper_rating_theme.dart';

/// Controlled rating with fractional steps, pointer preview and keyboard input.
class HyperRating extends StatefulWidget {
  HyperRating({
    super.key,
    required this.value,
    this.onChanged,
    this.count = 5,
    this.step = .5,
    this.enabled = true,
    this.readOnly = false,
    this.allowClear = false,
    this.direction = Axis.horizontal,
    this.focusNode,
    this.semanticLabel = '评分',
    this.style,
    this.itemBuilder,
  }) {
    if (count <= 0 ||
        !value.isFinite ||
        value < 0 ||
        value > count ||
        !step.isFinite ||
        step <= 0 ||
        step > count) {
      throw ArgumentError('评分值、数量或步长无效');
    }
  }
  final double value, step;
  final int count;
  final ValueChanged<double>? onChanged;
  final bool enabled, readOnly, allowClear;
  final Axis direction;
  final FocusNode? focusNode;
  final String semanticLabel;
  final HyperRatingStyle? style;
  final Widget Function(BuildContext context, int index, double fraction)?
  itemBuilder;
  @override
  State<HyperRating> createState() => _HyperRatingState();
}

class _HyperRatingState extends State<HyperRating> {
  final _ownedFocus = FocusNode();
  @override
  void dispose() {
    _ownedFocus.dispose();
    super.dispose();
  }

  double? _preview;
  bool _focused = false;
  bool get interactive =>
      widget.enabled && !widget.readOnly && widget.onChanged != null;
  double quantize(double value) =>
      ((value / widget.step - 1e-9).ceil() * widget.step)
          .clamp(0, widget.count)
          .toDouble();
  void commit(double value, {bool pointer = false}) {
    if (!interactive) return;
    if (pointer) (widget.focusNode ?? _ownedFocus).requestFocus();
    var next = quantize(value);
    if (pointer && widget.allowClear && next == widget.value) next = 0;
    if (_preview != null) setState(() => _preview = null);
    if (next != widget.value) widget.onChanged!(next);
  }

  @override
  void didUpdateWidget(covariant HyperRating oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!interactive ||
        oldWidget.value != widget.value ||
        oldWidget.count != widget.count ||
        oldWidget.step != widget.step) {
      _preview = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context), sizes = HyperTheme.sizesOf(context);
    final style = HyperRatingTheme.of(context).style.merge(widget.style);
    final iconSize = style.iconSize ?? sizes.rating.iconSize;
    final extent = math.max(
      iconSize,
      style.hitExtent ?? sizes.rating.hitExtent,
    );
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final active = !widget.enabled
        ? style.disabledColor ?? theme.colors.disabled
        : _preview != null
        ? style.hoverColor ?? style.activeColor ?? theme.colors.primary
        : _focused
        ? style.focusColor ?? style.activeColor ?? theme.colors.primary
        : style.activeColor ?? theme.colors.primary;
    final inactive = !widget.enabled
        ? style.disabledColor ?? theme.colors.disabled
        : style.inactiveColor ?? theme.colors.outline;
    final duration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : style.duration ?? theme.motion.fastDuration;
    final current = _preview ?? widget.value;
    double at(int i, Offset position) {
      var fraction = widget.direction == Axis.horizontal
          ? position.dx / iconSize
          : position.dy / iconSize;
      if (widget.direction == Axis.horizontal && rtl) fraction = 1 - fraction;
      return quantize(i + fraction.clamp(0, 1));
    }

    Widget icon(Color color) =>
        Icon(style.icon ?? Icons.star_rounded, size: iconSize, color: color);
    final children = <Widget>[];
    for (var i = 0; i < widget.count; i++) {
      if (i > 0) {
        children.add(
          SizedBox(
            width: widget.direction == Axis.horizontal
                ? style.gap ?? sizes.button.iconSpacing
                : null,
            height: widget.direction == Axis.vertical
                ? style.gap ?? sizes.button.iconSpacing
                : null,
          ),
        );
      }
      final fraction = (current - i).clamp(0.0, 1.0);
      children.add(
        MouseRegion(
          cursor: interactive
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          onHover: interactive
              ? (e) => setState(() => _preview = at(i, e.localPosition))
              : null,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapUp: interactive
                ? (e) => commit(at(i, e.localPosition), pointer: true)
                : null,
            child: SizedBox(
              // Expand only perpendicular to the rating axis. Main-axis hit
              // geometry and gaps must match the visible stars exactly.
              width: widget.direction == Axis.horizontal ? iconSize : extent,
              height: widget.direction == Axis.horizontal ? extent : iconSize,
              child: Center(
                child:
                    widget.itemBuilder?.call(context, i, fraction) ??
                    TweenAnimationBuilder<double>(
                      tween: Tween(end: fraction),
                      duration: duration,
                      curve: style.curve ?? theme.motion.fastCurve,
                      builder: (_, amount, _) => SizedBox(
                        width: iconSize,
                        height: iconSize,
                        child: Stack(
                          children: [
                            icon(inactive),
                            ClipRect(
                              child: Align(
                                alignment: AlignmentDirectional.centerStart,
                                widthFactor: amount,
                                child: icon(active),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              ),
            ),
          ),
        ),
      );
    }
    final bar = Flex(
      direction: widget.direction,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
    return Semantics(
      label: widget.semanticLabel,
      value: '${widget.value} / ${widget.count}',
      increasedValue:
          '${quantize(widget.value + widget.step)} / ${widget.count}',
      decreasedValue:
          '${quantize(widget.value - widget.step)} / ${widget.count}',
      enabled: widget.enabled,
      slider: true,
      onIncrease: interactive ? () => commit(widget.value + widget.step) : null,
      onDecrease: interactive ? () => commit(widget.value - widget.step) : null,
      child: Focus(
        focusNode: widget.focusNode ?? _ownedFocus,
        canRequestFocus: interactive,
        onFocusChange: (value) => setState(() => _focused = value),
        onKeyEvent: (_, event) {
          if (!interactive ||
              event is! KeyDownEvent && event is! KeyRepeatEvent) {
            return KeyEventResult.ignored;
          }
          final key = event.logicalKey;
          if (key == LogicalKeyboardKey.home ||
              key == LogicalKeyboardKey.delete) {
            commit(0);
          } else if (key == LogicalKeyboardKey.end) {
            commit(widget.count.toDouble());
          } else if (key == LogicalKeyboardKey.arrowUp ||
              key ==
                  (rtl
                      ? LogicalKeyboardKey.arrowLeft
                      : LogicalKeyboardKey.arrowRight)) {
            commit(widget.value + widget.step);
          } else if (key == LogicalKeyboardKey.arrowDown ||
              key ==
                  (rtl
                      ? LogicalKeyboardKey.arrowRight
                      : LogicalKeyboardKey.arrowLeft)) {
            commit(widget.value - widget.step);
          } else {
            return KeyEventResult.ignored;
          }
          return KeyEventResult.handled;
        },
        child: ExcludeSemantics(
          child: SingleChildScrollView(
            scrollDirection: widget.direction,
            child: MouseRegion(
              onExit: (_) {
                if (_preview != null) setState(() => _preview = null);
              },
              child: bar,
            ),
          ),
        ),
      ),
    );
  }
}
