import 'package:flutter/widgets.dart';

import '../../theme/material/hyper_material_theme.dart';
import '../../foundation/hyper_surface_material.dart';

/// 高级材质保留真实背景采样；外层透明度 saveLayer 会隔离 BackdropFilter。
/// 高级质量先在降级配方下淡入，再恢复模糊；关闭时反向过渡。
bool _usesAdvancedBackdrop(BuildContext context) {
  final material = HyperMaterialTheme.of(context);
  return material.quality == HyperMaterialQuality.advanced &&
      material.reduceTransparency != true;
}

class HyperBackdropSafeOpacity extends StatelessWidget {
  const HyperBackdropSafeOpacity({
    super.key,
    required this.opacity,
    this.child,
    this.alwaysIncludeSemantics = false,
  });
  final double opacity;
  final Widget? child;
  final bool alwaysIncludeSemantics;
  @override
  Widget build(BuildContext context) {
    final advanced = _usesAdvancedBackdrop(context);
    final split = (HyperMaterialTheme.of(context).transitionFadeFraction ?? .6)
        .clamp(.01, .99);
    final alpha = advanced ? (opacity / split).clamp(0.0, 1.0) : opacity;
    final progress = advanced
        ? ((opacity - split) / (1 - split)).clamp(0.0, 1.0)
        : 1.0;
    return HyperMaterialTheme(
      data: HyperMaterialThemeData(transitionProgress: progress),
      child: Opacity(
        opacity: alpha,
        alwaysIncludeSemantics: alwaysIncludeSemantics,
        child: child,
      ),
    );
  }
}

class HyperBackdropSafeFade extends StatelessWidget {
  const HyperBackdropSafeFade({
    super.key,
    required this.opacity,
    this.child,
    this.alwaysIncludeSemantics = false,
  });
  final Animation<double> opacity;
  final Widget? child;
  final bool alwaysIncludeSemantics;
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: opacity,
    child: child,
    builder: (context, child) => HyperBackdropSafeOpacity(
      opacity: opacity.value,
      alwaysIncludeSemantics: alwaysIncludeSemantics,
      child: child,
    ),
  );
}

class HyperBackdropSafeAnimatedOpacity extends StatelessWidget {
  const HyperBackdropSafeAnimatedOpacity({
    super.key,
    required this.opacity,
    required this.duration,
    this.curve = Curves.linear,
    this.onEnd,
    this.alwaysIncludeSemantics = false,
    this.child,
  });
  final double opacity;
  final Duration duration;
  final Curve curve;
  final VoidCallback? onEnd;
  final bool alwaysIncludeSemantics;
  final Widget? child;
  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
    tween: Tween(end: opacity),
    duration: duration,
    curve: curve,
    onEnd: onEnd,
    child: child,
    builder: (context, value, child) => HyperBackdropSafeOpacity(
      opacity: value,
      alwaysIncludeSemantics: alwaysIncludeSemantics,
      child: child,
    ),
  );
}
