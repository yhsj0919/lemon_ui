import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_skeleton_style.dart';
import 'hyper_skeleton_theme.dart';

enum HyperSkeletonShape { rectangle, text, circle }

/// 明确形状的加载占位，不测量或扫描业务子树。
class HyperSkeleton extends StatefulWidget {
  const HyperSkeleton({
    super.key,
    this.width,
    this.height,
    this.style,
    this.effect,
    this.loading = true,
    this.child,
    this.semanticsLabel,
  }) : shape = HyperSkeletonShape.rectangle;
  const HyperSkeleton.text({
    super.key,
    this.width,
    this.height,
    this.style,
    this.effect,
    this.loading = true,
    this.child,
    this.semanticsLabel,
  }) : shape = HyperSkeletonShape.text;
  const HyperSkeleton.circle({
    super.key,
    double? size,
    this.style,
    this.effect,
    this.loading = true,
    this.child,
    this.semanticsLabel,
  }) : shape = HyperSkeletonShape.circle,
       width = size,
       height = size;
  final HyperSkeletonShape shape;
  final double? width, height;
  final HyperSkeletonStyle? style;
  final HyperSkeletonEffect? effect;
  final bool loading;
  final Widget? child;
  final String? semanticsLabel;
  @override
  State<HyperSkeleton> createState() => _HyperSkeletonState();
}

class _HyperSkeletonState extends State<HyperSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this);
  HyperSkeletonStyle get _style =>
      HyperSkeletonTheme.of(context).style.merge(widget.style);
  void _sync() {
    final theme = HyperTheme.of(context);
    final style = _style;
    final duration = style.duration ?? theme.motion.emphasizedDuration * 4;
    final effect = widget.effect ?? style.effect ?? HyperSkeletonEffect.shimmer;
    final enabled =
        widget.loading &&
        TickerMode.valuesOf(context).enabled &&
        !(MediaQuery.maybeOf(context)?.disableAnimations ?? false) &&
        effect != HyperSkeletonEffect.none &&
        duration > Duration.zero;
    if (!enabled) {
      _controller.stop();
      return;
    }
    if (_controller.duration != duration || !_controller.isAnimating) {
      _controller.duration = duration;
      _controller.repeat();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(HyperSkeleton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final metrics = HyperTheme.sizesOf(context).skeleton;
    final style = _style;
    final reduced = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final effect = widget.effect ?? style.effect ?? HyperSkeletonEffect.shimmer;
    final background = style.backgroundColor ?? theme.colors.surfaceMuted;
    final highlight = style.highlightColor ?? theme.colors.surfaceElevated;
    Widget placeholder = LayoutBuilder(
      builder: (context, constraints) {
        final circle = widget.shape == HyperSkeletonShape.circle;
        final width = circle
            ? widget.width ?? style.circleSize ?? metrics.circleSize
            : widget.width ??
                  style.width ??
                  (widget.shape == HyperSkeletonShape.text
                      ? (constraints.hasBoundedWidth
                            ? constraints.maxWidth
                            : metrics.lineWidth)
                      : metrics.blockWidth);
        final height = circle
            ? width
            : widget.height ??
                  style.height ??
                  (widget.shape == HyperSkeletonShape.text
                      ? metrics.lineHeight
                      : metrics.blockHeight);
        final radius = circle ? width / 2 : style.radius ?? metrics.radius;
        Widget surface = ColoredBox(color: background);
        if (!reduced && effect != HyperSkeletonEffect.none) {
          surface = AnimatedBuilder(
            animation: _controller,
            child: surface,
            builder: (context, child) {
              final progress = (style.curve ?? Curves.linear).transform(
                _controller.value,
              );
              if (style.effectBuilder != null) {
                return style.effectBuilder!(context, child!, progress);
              }
              if (effect == HyperSkeletonEffect.pulse) {
                final minOpacity = (style.pulseMinOpacity ?? .6).clamp(
                  0.0,
                  1.0,
                );
                return Opacity(
                  opacity:
                      minOpacity +
                      (1 - minOpacity) *
                          (.5 - .5 * math.cos(progress * math.pi * 2)),
                  child: child,
                );
              }
              return CustomPaint(
                foregroundPainter: HyperSkeletonShimmerPainter(
                  progress: progress,
                  color: highlight,
                  bandWidth: style.shimmerWidth ?? .28,
                  angle: style.shimmerAngle ?? .18,
                  direction: Directionality.of(context),
                ),
                child: child,
              );
            },
          );
        }
        return SizedBox(
          width: width,
          height: height,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              boxShadow: style.boxShadow,
            ),
            child: DecoratedBox(
              position: DecorationPosition.foreground,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius),
                border: style.borderColor == null
                    ? null
                    : Border.all(
                        color: style.borderColor!,
                        width: style.borderWidth ?? 1,
                      ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(radius),
                child: surface,
              ),
            ),
          ),
        );
      },
    );
    placeholder = ExcludeSemantics(child: placeholder);
    if (widget.semanticsLabel != null) {
      placeholder = Semantics(label: widget.semanticsLabel, child: placeholder);
    }
    if (widget.child == null) {
      return widget.loading ? placeholder : const SizedBox.shrink();
    }
    return AnimatedSwitcher(
      duration: reduced
          ? Duration.zero
          : style.transitionDuration ?? theme.motion.fastDuration,
      switchInCurve: theme.motion.standardCurve,
      switchOutCurve: theme.motion.standardCurve,
      transitionBuilder:
          style.transitionBuilder ?? AnimatedSwitcher.defaultTransitionBuilder,
      child: KeyedSubtree(
        key: ValueKey(widget.loading),
        child: widget.loading ? placeholder : widget.child!,
      ),
    );
  }
}

/// 微光绘制独立于组件数据和布局，可用于离屏检验。
@visibleForTesting
class HyperSkeletonShimmerPainter extends CustomPainter {
  const HyperSkeletonShimmerPainter({
    required this.progress,
    required this.color,
    required this.bandWidth,
    required this.angle,
    required this.direction,
  });
  final double progress, bandWidth, angle;
  final Color color;
  final TextDirection direction;
  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || bandWidth <= 0) return;
    final extent = size.width + size.height;
    final phase = direction == TextDirection.rtl ? 1 - progress : progress;
    final width = extent * bandWidth.clamp(0.0, 1.0);
    final center = (phase * 2 - 1) * (extent + width);
    final band = Rect.fromLTWH(center - width / 2, -extent, width, extent * 2);
    canvas.save();
    canvas.clipRect(Offset.zero & size);
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(angle);
    canvas.drawRect(
      band,
      Paint()
        ..shader = LinearGradient(
          colors: [
            color.withValues(alpha: 0),
            color.withValues(alpha: color.a * .7),
            color.withValues(alpha: 0),
          ],
          stops: const [0, .5, 1],
        ).createShader(band),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(HyperSkeletonShimmerPainter old) =>
      progress != old.progress ||
      color != old.color ||
      bandWidth != old.bandWidth ||
      angle != old.angle ||
      direction != old.direction;
}
