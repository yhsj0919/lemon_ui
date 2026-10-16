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
          if (style.effectBuilder != null) {
            surface = AnimatedBuilder(
              animation: _controller,
              child: surface,
              builder: (context, child) => style.effectBuilder!(
                context,
                child!,
                (style.curve ?? Curves.linear).transform(_controller.value),
              ),
            );
          } else {
            surface = CustomPaint(
              willChange: true,
              painter: _SkeletonEffectPainter(
                animation: _controller,
                curve: style.curve ?? Curves.linear,
                effect: effect,
                background: background,
                highlight: highlight,
                bandWidth: style.shimmerWidth ?? .28,
                angle: style.shimmerAngle ?? .18,
                minOpacity: style.pulseMinOpacity ?? .6,
                direction: Directionality.of(context),
              ),
            );
          }
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
                border:
                    (style.borderWidth ??
                            (style.borderColor != null ? 1 : 0)) <=
                        0
                    ? null
                    : Border.all(
                        color: style.borderColor ?? theme.colors.outline,
                        width: style.borderWidth ?? 1,
                      ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(radius),
                child: RepaintBoundary(child: surface),
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
    if (reduced) {
      return widget.loading ? placeholder : widget.child!;
    }
    return AnimatedSwitcher(
      duration: style.transitionDuration ?? theme.motion.fastDuration,
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
    _SkeletonShimmerBand(
      color,
      bandWidth,
    ).paint(canvas, size, progress, angle, direction);
  }

  @override
  bool shouldRepaint(HyperSkeletonShimmerPainter old) =>
      progress != old.progress ||
      color != old.color ||
      bandWidth != old.bandWidth ||
      angle != old.angle ||
      direction != old.direction;
}

// Default effects listen at the paint layer. Widget/layout and ancestor material
// surfaces stay unchanged throughout the animation; custom builders opt in to
// rebuilding only their own isolated subtree.
class _SkeletonEffectPainter extends CustomPainter {
  _SkeletonEffectPainter({
    required this.animation,
    required this.curve,
    required this.effect,
    required this.background,
    required Color highlight,
    required double bandWidth,
    required this.angle,
    required this.minOpacity,
    required this.direction,
  }) : band = _SkeletonShimmerBand(highlight, bandWidth),
       super(repaint: animation);
  final Animation<double> animation;
  final Curve curve;
  final HyperSkeletonEffect effect;
  final Color background;
  final double angle, minOpacity;
  final TextDirection direction;
  final _SkeletonShimmerBand band;

  @override
  void paint(Canvas canvas, Size size) {
    final progress = curve.transform(animation.value);
    final alpha = effect == HyperSkeletonEffect.pulse
        ? minOpacity.clamp(0.0, 1.0) +
              (1 - minOpacity.clamp(0.0, 1.0)) *
                  (.5 - .5 * math.cos(progress * math.pi * 2))
        : 1.0;
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = background.withValues(alpha: background.a * alpha),
    );
    if (effect == HyperSkeletonEffect.shimmer) {
      band.paint(canvas, size, progress, angle, direction);
    }
  }

  @override
  bool shouldRepaint(_SkeletonEffectPainter old) =>
      animation != old.animation ||
      curve != old.curve ||
      effect != old.effect ||
      background != old.background ||
      band.color != old.band.color ||
      band.bandWidth != old.band.bandWidth ||
      angle != old.angle ||
      minOpacity != old.minOpacity ||
      direction != old.direction;
}

class _SkeletonShimmerBand {
  _SkeletonShimmerBand(this.color, this.bandWidth);
  final Color color;
  final double bandWidth;
  Size? _size;
  Rect _rect = Rect.zero;
  Shader? _shader;

  void paint(
    Canvas canvas,
    Size size,
    double progress,
    double angle,
    TextDirection direction,
  ) {
    if (size.isEmpty || bandWidth <= 0) return;
    final extent = size.width + size.height;
    final width = extent * bandWidth.clamp(0.0, 1.0);
    if (_size != size) {
      _size = size;
      _rect = Rect.fromLTWH(-width / 2, -extent, width, extent * 2);
      _shader = LinearGradient(
        colors: [
          color.withValues(alpha: 0),
          color.withValues(alpha: color.a * .7),
          color.withValues(alpha: 0),
        ],
        stops: const [0, .5, 1],
      ).createShader(_rect);
    }
    final phase = direction == TextDirection.rtl ? 1 - progress : progress;
    final center = (phase * 2 - 1) * (extent + width);
    canvas.save();
    canvas.clipRect(Offset.zero & size);
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(angle);
    canvas.translate(center, 0);
    canvas.drawRect(
      _rect,
      Paint()
        ..isAntiAlias = true
        ..shader = _shader,
    );
    canvas.restore();
  }
}
