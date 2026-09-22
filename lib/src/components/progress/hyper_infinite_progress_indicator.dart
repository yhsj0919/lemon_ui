import 'package:flutter/material.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_progress_indicator_style.dart';
import 'hyper_progress_indicator_theme.dart';

/// MIUIX 风格的圆环加轨道圆点无限进度指示器。
class HyperInfiniteProgressIndicator extends StatefulWidget {
  const HyperInfiniteProgressIndicator({
    super.key,
    this.style,
    this.color,
    this.size,
    this.thickness,
    this.orbitingDotSize,
    this.animationDuration,
    this.semanticsLabel,
    this.semanticsValue,
    this.excludeSemantics = false,
  });

  final HyperProgressIndicatorStyle? style;
  final Color? color;
  final double? size;
  final double? thickness;

  /// 轨道圆点的半径，与 MIUIX 的同名参数保持一致。
  final double? orbitingDotSize;
  final Duration? animationDuration;
  final String? semanticsLabel;
  final String? semanticsValue;
  final bool excludeSemantics;

  @override
  State<HyperInfiniteProgressIndicator> createState() =>
      _HyperInfiniteProgressIndicatorState();
}

class _HyperInfiniteProgressIndicatorState
    extends State<HyperInfiniteProgressIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this);

  HyperProgressIndicatorStyle _resolveStyle() {
    final theme = HyperTheme.of(context);
    final sizes = HyperTheme.sizesOf(context);
    final progressTheme = HyperProgressIndicatorTheme.of(context);
    final metrics = sizes.progressIndicator;
    return HyperProgressIndicatorStyle(
          color: theme.colors.textTertiary,
          size: metrics.infiniteSize,
          thickness: 2,
          orbitingDotSize: metrics.infiniteDotRadius,
          animationDuration: const Duration(milliseconds: 800),
        )
        .merge(progressTheme.style)
        .merge(progressTheme.infiniteStyle)
        .merge(widget.style);
  }

  void _syncAnimation() {
    final style = _resolveStyle();
    _controller.duration = widget.animationDuration ?? style.animationDuration!;
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (reduceMotion) {
      _controller
        ..stop()
        ..value = 0;
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncAnimation();
  }

  @override
  void didUpdateWidget(HyperInfiniteProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncAnimation();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = _resolveStyle();
    final size = widget.size ?? style.size!;
    final thickness = widget.thickness ?? style.thickness!;
    final dotRadius = widget.orbitingDotSize ?? style.orbitingDotSize!;
    Widget result = SizedBox.square(
      dimension: size,
      child: RotationTransition(
        turns: _controller,
        child: CustomPaint(
          painter: _HyperInfiniteProgressPainter(
            color: widget.color ?? style.color!,
            thickness: thickness,
            dotRadius: dotRadius,
          ),
        ),
      ),
    );
    result = Semantics(
      label: widget.semanticsLabel,
      value: widget.semanticsValue,
      child: result,
    );
    return widget.excludeSemantics ? ExcludeSemantics(child: result) : result;
  }
}

class _HyperInfiniteProgressPainter extends CustomPainter {
  const _HyperInfiniteProgressPainter({
    required this.color,
    required this.thickness,
    required this.dotRadius,
  });

  final Color color;
  final double thickness;
  final double dotRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - thickness) / 2;
    final ringPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, ringPaint);

    final orbitRadius = radius - 2 * dotRadius;
    final dotCenter = center + Offset(orbitRadius, 0);
    canvas.drawCircle(dotCenter, dotRadius, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_HyperInfiniteProgressPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.thickness != thickness ||
      oldDelegate.dotRadius != dotRadius;
}
