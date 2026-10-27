import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_badge.dart';
import 'hyper_badge_style.dart';

/// 徽标相对目标的九宫格位置，均为物理方位。
enum HyperBadgePosition {
  topLeft,
  topCenter,
  topRight,
  centerLeft,
  center,
  centerRight,
  bottomLeft,
  bottomCenter,
  bottomRight,
}

/// 将任意徽标放在目标的角或边上，不规定徽标本身的视觉样式。
class HyperBadgeAnchor extends StatelessWidget {
  const HyperBadgeAnchor({
    super.key,
    required this.child,
    required this.badge,
    this.position = HyperBadgePosition.topRight,
    this.alignment,
    this.offset = Offset.zero,
    this.duration,
    this.curve,
  });

  /// 数字角标的组合简写，数字与显隐规则沿用 [HyperBadge]。
  factory HyperBadgeAnchor.count({
    Key? key,
    required int count,
    required Widget child,
    int maxCount = 99,
    bool showZero = false,
    bool visible = true,
    String? semanticsLabel,
    HyperBadgeStyle? badgeStyle,
    HyperBadgePosition position = HyperBadgePosition.topRight,
    AlignmentGeometry? alignment,
    Offset offset = Offset.zero,
    Duration? duration,
    Curve? curve,
  }) => HyperBadgeAnchor(
    key: key,
    badge: HyperBadge(
      count: count,
      maxCount: maxCount,
      showZero: showZero,
      visible: visible,
      semanticsLabel: semanticsLabel,
      style: badgeStyle,
    ),
    position: position,
    alignment: alignment,
    offset: offset,
    duration: duration,
    curve: curve,
    child: child,
  );

  final Widget child;
  final Widget badge;
  final HyperBadgePosition position;

  /// 更精细的对齐位置；也可传入方向感知的 AlignmentDirectional。
  final AlignmentGeometry? alignment;

  /// 物理坐标偏移，正 x 向右、正 y 向下。
  final Offset offset;
  final Duration? duration;
  final Curve? curve;

  AlignmentGeometry get _positionAlignment => switch (position) {
    HyperBadgePosition.topLeft => Alignment.topLeft,
    HyperBadgePosition.topCenter => Alignment.topCenter,
    HyperBadgePosition.topRight => Alignment.topRight,
    HyperBadgePosition.centerLeft => Alignment.centerLeft,
    HyperBadgePosition.center => Alignment.center,
    HyperBadgePosition.centerRight => Alignment.centerRight,
    HyperBadgePosition.bottomLeft => Alignment.bottomLeft,
    HyperBadgePosition.bottomCenter => Alignment.bottomCenter,
    HyperBadgePosition.bottomRight => Alignment.bottomRight,
  };

  @override
  Widget build(BuildContext context) {
    final resolved = (alignment ?? _positionAlignment).resolve(
      Directionality.of(context),
    );
    final motion = HyperTheme.of(context).motion;
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final animationDuration = reduceMotion
        ? Duration.zero
        : (duration ?? motion.standardDuration);
    final animationCurve = curve ?? motion.standardCurve;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned.fill(
          child: TweenAnimationBuilder<Alignment>(
            tween: Tween<Alignment>(end: resolved),
            duration: animationDuration,
            curve: animationCurve,
            builder: (context, currentAlignment, child) => Align(
              alignment: currentAlignment,
              child: FractionalTranslation(
                translation: Offset(
                  currentAlignment.x / 2,
                  currentAlignment.y / 2,
                ),
                child: TweenAnimationBuilder<Offset>(
                  tween: Tween<Offset>(end: offset),
                  duration: animationDuration,
                  curve: animationCurve,
                  child: IgnorePointer(child: badge),
                  builder: (context, currentOffset, child) =>
                      Transform.translate(offset: currentOffset, child: child),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
