import 'dart:math' as math;

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_text.dart';
import 'hyper_text_style.dart';
import 'hyper_text_theme.dart';

enum HyperTextScrollTrigger { automatic, hover }

enum HyperTextScrollMode { pingPong, loop }

/// 仅在单行文字溢出时往返或单向循环滚动；完整文字只向无障碍树提供一次。
///
/// 宽度由父布局决定，无界宽度下保持普通单行文字。减少动画时停止自动
/// 位移，仍可通过横向拖动查看完整文字。
class HyperScrollingText extends StatefulWidget {
  const HyperScrollingText(
    this.data, {
    super.key,
    this.trigger = HyperTextScrollTrigger.automatic,
    this.mode = HyperTextScrollMode.pingPong,
    this.loopGap,
    this.variant = HyperTextVariant.body,
    this.style,
    this.duration,
    this.speed = 40,
    this.pauseDuration,
    this.curve = Curves.linear,
    this.semanticsLabel,
  }) : assert(loopGap == null || loopGap >= 0),
       assert(speed > 0 && speed < double.infinity);

  final String data;
  final HyperTextScrollTrigger trigger;
  final HyperTextScrollMode mode;

  /// 循环副本之间的间隔；默认四个空格的排版宽度。
  final double? loopGap;
  final HyperTextVariant variant;
  final TextStyle? style;

  /// 滚动速度，单位为逻辑像素/秒；两种模式使用相同速度。
  final double speed;

  /// 显式单程时长，提供时优先于 [speed]；null 时按路程和速度计算。
  final Duration? duration;

  /// 往返模式到达两端的停留时长；循环模式连续移动，不停留。
  final Duration? pauseDuration;
  final Curve curve;
  final String? semanticsLabel;

  @override
  State<HyperScrollingText> createState() => _HyperScrollingTextState();
}

class _HyperScrollingTextState extends State<HyperScrollingText>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker = createTicker(_tick);
  final ScrollController _scroll = ScrollController();
  bool _hovered = false;
  final ValueNotifier<double> _loopOffset = ValueNotifier(0);
  bool _resetting = false;
  double _resetFrom = 0;
  Duration _resetElapsed = Duration.zero;
  Duration _resetDuration = Duration.zero;
  Curve _resetCurve = Curves.linear;
  Duration _elapsed = Duration.zero;
  Duration _last = Duration.zero;
  double _distance = 0;
  bool _looping = false;
  Duration _travel = Duration.zero;
  Duration _pause = Duration.zero;

  void _tick(Duration elapsed) {
    final delta = elapsed - _last;
    _last = elapsed;
    if (_resetting) {
      _resetElapsed += delta;
      final t = _resetDuration == Duration.zero
          ? 1.0
          : (_resetElapsed.inMicroseconds / _resetDuration.inMicroseconds)
                .clamp(0.0, 1.0);
      _loopOffset.value = _resetFrom * (1 - _resetCurve.transform(t));
      if (t == 1) {
        _resetting = false;
        _ticker.stop();
      }
      return;
    }
    _elapsed += delta;
    final travel = _travel.inMicroseconds;
    final pause = _pause.inMicroseconds;
    if (travel <= 0) return;
    if (_looping) {
      final fraction = (_elapsed.inMicroseconds % travel) / travel;
      _loopOffset.value = _distance * fraction;
      return;
    }
    final cycle = (_elapsed.inMicroseconds % (2 * (travel + pause)));
    final double fraction;
    if (cycle < pause) {
      fraction = 0;
    } else if (cycle < pause + travel) {
      fraction = widget.curve.transform((cycle - pause) / travel);
    } else if (cycle < 2 * pause + travel) {
      fraction = 1;
    } else {
      fraction =
          1 - widget.curve.transform((cycle - 2 * pause - travel) / travel);
    }
    if (!_scroll.hasClients) return;
    _scroll.jumpTo(
      math.min(_scroll.position.maxScrollExtent, _distance * fraction),
    );
  }

  @override
  void didUpdateWidget(HyperScrollingText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data ||
        oldWidget.variant != widget.variant ||
        oldWidget.mode != widget.mode ||
        oldWidget.loopGap != widget.loopGap ||
        oldWidget.style != widget.style) {
      _elapsed = Duration.zero;
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _scroll.dispose();
    _loopOffset.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(widget.duration == null || widget.duration! > Duration.zero);
    assert(
      widget.pauseDuration == null || widget.pauseDuration! >= Duration.zero,
    );
    final theme = HyperTheme.of(context);
    final base = widget.variant == HyperTextVariant.body
        ? DefaultTextStyle.of(context).style
        : widget.variant.resolve(theme.textTheme) ?? const TextStyle();
    final style = base
        .merge(HyperTextTheme.of(context).resolve(widget.variant))
        .merge(widget.style);
    final direction = Directionality.of(context);
    final scaler = MediaQuery.textScalerOf(context);
    final reduced = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final enabled = TickerMode.valuesOf(context).enabled;

    _pause = widget.pauseDuration ?? theme.motion.emphasizedDuration;
    _resetDuration = reduced ? Duration.zero : theme.motion.fastDuration;
    _resetCurve = theme.motion.fastCurve;
    return LayoutBuilder(
      builder: (context, constraints) {
        final painter = TextPainter(
          text: TextSpan(text: widget.data, style: style),
          textDirection: direction,
          textScaler: scaler,
          locale: Localizations.maybeLocaleOf(context),
          textHeightBehavior:
              DefaultTextStyle.of(context).textHeightBehavior ??
              DefaultTextHeightBehavior.maybeOf(context),
          maxLines: 1,
        )..layout();
        _distance = constraints.hasBoundedWidth
            ? math.max(0, painter.width - constraints.maxWidth)
            : 0;
        final overflowing = _distance > 0;
        final textWidth = painter.width;
        final textHeight = painter.height;
        painter.text = TextSpan(text: '    ', style: style);
        painter.layout();
        final gap = widget.loopGap ?? painter.width;
        painter.dispose();
        _looping =
            overflowing && !reduced && widget.mode == HyperTextScrollMode.loop;
        if (_looping) _distance = textWidth + gap;
        _travel =
            widget.duration ??
            Duration(
              microseconds: math.max(
                1,
                (_distance / widget.speed * Duration.microsecondsPerSecond)
                    .round(),
              ),
            );
        final active =
            _distance > 0 &&
            !reduced &&
            enabled &&
            _travel > Duration.zero &&
            (widget.trigger == HyperTextScrollTrigger.automatic ||
                _hovered ||
                _resetting);
        if (active && !_ticker.isActive) {
          _last = Duration.zero;
          _ticker.start();
        } else if (!active && _ticker.isActive) {
          _ticker.stop();
        }
        final text = HyperText(
          widget.data,
          variant: widget.variant,
          style: widget.style,
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.visible,
        );
        return MouseRegion(
          onEnter: (_) => setState(() {
            _hovered = true;
            _resetting = false;
          }),
          onExit: (_) {
            if (widget.trigger == HyperTextScrollTrigger.hover) {
              _ticker.stop();
              _elapsed = Duration.zero;
              _resetFrom = _loopOffset.value;
              _resetElapsed = Duration.zero;
              _resetting = _looping && _resetFrom > 0 && !reduced;
              if (!_resetting) _loopOffset.value = 0;
              if (_scroll.hasClients) {
                _scroll.animateTo(
                  0,
                  duration:
                      reduced || theme.motion.fastDuration == Duration.zero
                      ? const Duration(microseconds: 1)
                      : theme.motion.fastDuration,
                  curve: theme.motion.fastCurve,
                );
              }
            }
            setState(() => _hovered = false);
          },
          child: Semantics(
            label: widget.semanticsLabel ?? widget.data,
            child: ExcludeSemantics(
              child: _looping
                  ? ClipRect(
                      child: SizedBox(
                        height: textHeight,
                        child: OverflowBox(
                          alignment: AlignmentDirectional.centerStart,
                          minWidth: textWidth * 2 + gap,
                          maxWidth: textWidth * 2 + gap,
                          child: ValueListenableBuilder<double>(
                            valueListenable: _loopOffset,
                            builder: (context, offset, child) =>
                                Transform.translate(
                                  key: const ValueKey(
                                    'hyper-scrolling-text-offset',
                                  ),
                                  offset: Offset(
                                    direction == TextDirection.rtl
                                        ? offset
                                        : -offset,
                                    0,
                                  ),
                                  child: child,
                                ),
                            child: RepaintBoundary(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(width: textWidth, child: text),
                                  SizedBox(width: gap),
                                  SizedBox(width: textWidth, child: text),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : constraints.hasBoundedWidth
                  ? SingleChildScrollView(
                      controller: _scroll,
                      scrollDirection: Axis.horizontal,
                      child: text,
                    )
                  : text,
            ),
          ),
        );
      },
    );
  }
}
