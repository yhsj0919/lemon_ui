import '../../theme/size/hyper_size_theme_data.dart';
import '../../theme/material/hyper_material_theme.dart';
import '../../foundation/hyper_fill.dart';
import '../card/hyper_card_style.dart';
import '../surface/hyper_navigation_surface.dart';

import 'package:flutter/material.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_drawer_style.dart';
import 'hyper_drawer_theme.dart';

/// 承载任意内容的侧滑抽屉；开合与遮罩由所在 Scaffold 管理。
class HyperDrawer extends StatelessWidget {
  const HyperDrawer({
    super.key,
    required this.child,
    this.header,
    this.footer,
    this.style,
    this.semanticLabel,
    this.clipBehavior,
  });

  final Widget child;

  /// 固定在抽屉顶部的自由内容。
  final Widget? header;

  /// 固定在抽屉底部的自由内容。
  final Widget? footer;

  final HyperDrawerStyle? style;
  final String? semanticLabel;
  final Clip? clipBehavior;

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final resolved = HyperDrawerStyle(
      width: HyperTheme.sizesOf(context).drawer.width,
      margin: HyperTheme.sizesOf(context).drawer.margin,
      backgroundColor: theme.colors.surfaceElevated,
    ).merge(HyperDrawerTheme.of(context).style).merge(style);
    final sizes = HyperTheme.sizesOf(context);
    final radius =
        sizes.drawer.radius ??
        const HyperSizeThemeData().resolve(sizes.deviceType).drawer.radius!;
    final defaultRadius =
        DrawerController.maybeOf(context)?.alignment == DrawerAlignment.end
        ? BorderRadiusDirectional.horizontal(start: Radius.circular(radius))
        : BorderRadiusDirectional.horizontal(end: Radius.circular(radius));
    final effectiveRadius =
        resolved.surfaceStyle?.borderRadius ??
        sizes.drawer.borderRadius ??
        defaultRadius;
    final useSurface =
        resolved.surfaceStyle != null ||
        HyperMaterialTheme.of(context).material != null;
    final content = Drawer(
      width: resolved.width,
      backgroundColor: useSurface
          ? Colors.transparent
          : resolved.backgroundColor,
      elevation: resolved.surfaceStyle?.boxShadow != null
          ? 0
          : (HyperMaterialTheme.of(context).material != null ||
                    resolved.surfaceStyle?.material != null
                ? resolved.elevation ?? 0
                : resolved.elevation),
      shape:
          resolved.shape ??
          RoundedRectangleBorder(borderRadius: effectiveRadius),
      semanticLabel: semanticLabel,
      clipBehavior: clipBehavior,
      child: header == null && footer == null
          ? child
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ?header,
                // 中间内容只占剩余高度，滚动时不会带动头部和尾部。
                Expanded(child: child),
                ?footer,
              ],
            ),
    );
    final surface = !useSurface
        ? content
        : HyperNavigationSurface(
            inheritMaterial: true,
            style: HyperCardStyle(
              background: HyperFill.color(resolved.backgroundColor!),
              borderRadius: effectiveRadius,
              padding: EdgeInsets.zero,
            ).merge(resolved.surfaceStyle),
            child: content,
          );
    final margin = resolved.margin!.resolve(Directionality.of(context));
    assert(margin.isNonNegative, '抽屉外边距不能为负');
    final drawer = AnimatedPadding(
      padding: margin,
      duration: (MediaQuery.maybeOf(context)?.disableAnimations ?? false)
          ? Duration.zero
          : theme.motion.fastDuration,
      curve: theme.motion.fastCurve,
      child: surface,
    );
    // Flutter 的 DrawerController 在桌面端不安装拖动识别器。
    final desktop = switch (Theme.of(context).platform) {
      TargetPlatform.windows ||
      TargetPlatform.linux ||
      TargetPlatform.macOS => true,
      _ => false,
    };
    return desktop
        ? _DesktopDrawerCloseGesture(
            width: resolved.width! + margin.horizontal,
            child: drawer,
          )
        : drawer;
  }
}

/// 桌面端补齐关闭手势，开合动画与抽屉状态仍由 Scaffold 管理。
class _DesktopDrawerCloseGesture extends StatefulWidget {
  const _DesktopDrawerCloseGesture({required this.width, required this.child});

  final double width;
  final Widget child;

  @override
  State<_DesktopDrawerCloseGesture> createState() =>
      _DesktopDrawerCloseGestureState();
}

class _DesktopDrawerCloseGestureState
    extends State<_DesktopDrawerCloseGesture> {
  double _dragDistance = 0;

  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.translucent,
    onHorizontalDragStart: (_) => _dragDistance = 0,
    onHorizontalDragUpdate: (details) =>
        _dragDistance += details.primaryDelta ?? 0,
    onHorizontalDragEnd: (details) {
      final alignment = DrawerController.maybeOf(context)?.alignment;
      final scaffold = Scaffold.maybeOf(context);
      if (alignment == null || scaffold == null) return;

      final closeTowardLeft =
          (alignment == DrawerAlignment.start) ==
          (Directionality.of(context) == TextDirection.ltr);
      final direction = closeTowardLeft ? -1 : 1;
      final velocity = details.velocity.pixelsPerSecond.dx * direction;
      final distance = _dragDistance * direction;
      // 与 Flutter DrawerController 一样：快速滑动按方向，慢速拖动过半才关闭。
      final close = velocity.abs() >= 365
          ? velocity > 0
          : distance > widget.width / 2;
      if (close) {
        if (alignment == DrawerAlignment.start) {
          scaffold.closeDrawer();
        } else {
          scaffold.closeEndDrawer();
        }
      }
    },
    child: widget.child,
  );
}
