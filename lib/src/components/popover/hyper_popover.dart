import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import '../card/hyper_card.dart';
import '../menu/hyper_menu_surface.dart';
import '../overlay/hyper_anchored_overlay.dart';
import 'hyper_popover_style.dart';
import 'hyper_popover_theme.dart';

/// 带菜单语义表面的锚定浮层，内容由调用方提供。
class HyperPopover extends StatelessWidget {
  const HyperPopover({
    super.key,
    required this.anchor,
    required this.contentBuilder,
    this.trigger = HyperOverlayTrigger.tap,
    this.placement = HyperOverlayPlacement.bottomStart,
    this.style,
    this.transitionBuilder,
    this.isOpen,
    this.onOpenChanged,
    this.anchorPosition,
  }) : anchorBuilder = null;

  const HyperPopover.builder({
    super.key,
    required this.anchorBuilder,
    required this.contentBuilder,
    this.placement = HyperOverlayPlacement.bottomStart,
    this.style,
    this.transitionBuilder,
    this.isOpen,
    this.onOpenChanged,
    this.anchorPosition,
  }) : anchor = null,
       trigger = HyperOverlayTrigger.manual;

  final Widget? anchor;
  final HyperOverlayAnchorBuilder? anchorBuilder;
  final HyperOverlayBuilder contentBuilder;
  final HyperOverlayTrigger trigger;
  final HyperOverlayPlacement placement;
  final HyperPopoverStyle? style;

  /// 自定义过渡需使用安全材质透明度，避免隔离背景采样。
  final HyperOverlayTransitionBuilder? transitionBuilder;
  final bool? isOpen;
  final ValueChanged<bool>? onOpenChanged;
  final Offset? anchorPosition;

  @override
  Widget build(BuildContext context) {
    final resolved = HyperPopoverTheme.of(context).style.merge(style);
    Widget panel(BuildContext context, VoidCallback close) {
      final sizes = HyperTheme.sizesOf(context);
      return HyperCard(
        style: resolveHyperMenuSurface(
          context,
          radius: sizes.menu.surfaceRadius,
          padding: EdgeInsets.all(sizes.menu.padding),
          style: resolved.surfaceStyle,
        ),
        child: contentBuilder(context, close),
      );
    }

    if (anchorBuilder != null) {
      return HyperAnchoredOverlay.builder(
        anchorBuilder: anchorBuilder!,
        overlayBuilder: panel,
        placement: placement,
        spacing: resolved.spacing,
        transition: resolved.transition ?? HyperOverlayTransition.fadeScale,
        transitionBuilder: transitionBuilder,
        isOpen: isOpen,
        onOpenChanged: onOpenChanged,
        anchorPosition: anchorPosition,
      );
    }
    return HyperAnchoredOverlay(
      anchor: anchor!,
      overlayBuilder: panel,
      trigger: trigger,
      placement: placement,
      spacing: resolved.spacing,
      transition: resolved.transition ?? HyperOverlayTransition.fadeScale,
      transitionBuilder: transitionBuilder,
      isOpen: isOpen,
      onOpenChanged: onOpenChanged,
      anchorPosition: anchorPosition,
    );
  }
}
