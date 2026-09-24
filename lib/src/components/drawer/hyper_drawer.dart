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
      backgroundColor: theme.colors.surfaceElevated,
    ).merge(HyperDrawerTheme.of(context).style).merge(style);
    final drawer = Drawer(
      width: resolved.width,
      backgroundColor: resolved.backgroundColor,
      elevation: resolved.elevation,
      shape: resolved.shape,
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
    // Flutter 的 DrawerController 在桌面端不安装拖动识别器。
    final desktop = switch (Theme.of(context).platform) {
      TargetPlatform.windows ||
      TargetPlatform.linux ||
      TargetPlatform.macOS => true,
      _ => false,
    };
    return desktop
        ? _DesktopDrawerCloseGesture(width: resolved.width!, child: drawer)
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
