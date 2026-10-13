import 'dart:async';

import 'package:flutter/material.dart';

import '../../theme/core/hyper_theme.dart';
import '../../theme/color/hyper_color_scheme.dart';
import '../card/hyper_card.dart';
import '../card/hyper_card_style.dart';
import '../menu/hyper_menu_surface.dart';
import '../overlay/hyper_anchored_overlay.dart';
import '../overlay/hyper_overlay_material.dart';

import 'hyper_tooltip_theme.dart';
export 'hyper_tooltip_theme.dart';

/// 悬停、获得焦点或长按时显示简短说明。
///
/// 定位、避让和进出场动画交给 [HyperAnchoredOverlay]；提示内容不接收点击。
class HyperTooltip extends StatefulWidget {
  const HyperTooltip({
    super.key,
    required this.message,
    required this.child,
    this.placement = HyperOverlayPlacement.topStart,
    this.waitDuration = const Duration(milliseconds: 500),
    this.exitDuration = const Duration(milliseconds: 100),
    this.showDuration = const Duration(milliseconds: 800),
    this.transitionBuilder,
    this.appearance,
    this.style,
    this.foregroundColor,
  });

  final String message;
  final Widget child;
  final HyperOverlayPlacement placement;
  final Duration waitDuration;
  final Duration exitDuration;

  /// 长按松开后，提示继续显示的时间。
  final Duration showDuration;
  final HyperOverlayTransitionBuilder? transitionBuilder;
  final HyperTooltipAppearance? appearance;
  final Color? foregroundColor;
  final HyperCardStyle? style;

  @override
  State<HyperTooltip> createState() => _HyperTooltipState();
}

class _HyperTooltipState extends State<HyperTooltip> {
  Timer? _timer;
  bool _hovered = false;
  bool _focused = false;
  bool _longPressed = false;
  bool _open = false;

  @override
  void didUpdateWidget(HyperTooltip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.message.isEmpty && _open) _setOpen(false);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _setOpen(bool value) {
    if (!mounted || _open == value) return;
    setState(() => _open = value);
  }

  void _scheduleOpen(Duration delay) {
    _timer?.cancel();
    if (widget.message.isEmpty) return;
    if (delay == Duration.zero) {
      _setOpen(true);
    } else {
      _timer = Timer(delay, () => _setOpen(true));
    }
  }

  void _scheduleClose() {
    _timer?.cancel();
    if (_hovered || _focused || _longPressed) return;
    if (widget.exitDuration == Duration.zero) {
      _setOpen(false);
    } else {
      _timer = Timer(widget.exitDuration, () => _setOpen(false));
    }
  }

  void _endLongPress() {
    _longPressed = false;
    _timer?.cancel();
    if (_hovered || _focused) return;
    _timer = Timer(widget.showDuration, () => _setOpen(false));
  }

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final sizes = HyperTheme.sizesOf(context);
    final tooltipTheme = HyperTooltipTheme.of(context);
    final appearance =
        widget.appearance ??
        tooltipTheme.appearance ??
        HyperTooltipAppearance.dark;
    final colors = appearance == HyperTooltipAppearance.dark
        ? HyperColorScheme.dark(seedColor: theme.colors.primary)
        : theme.colors;
    final surface = resolveHyperMenuSurface(
      context,
      radius: sizes.menu.itemRadius,
      padding: EdgeInsets.symmetric(
        horizontal: sizes.menu.padding,
        vertical: sizes.menu.padding / 2,
      ),
      style:
          (appearance == HyperTooltipAppearance.dark
                  ? HyperCardStyle(
                      material: HyperOverlayMaterial.fallbackFor(
                        colors: colors,
                      ),
                    )
                  : HyperCardStyle())
              .merge(tooltipTheme.style)
              .merge(widget.style),
    );
    return HyperAnchoredOverlay(
      trigger: HyperOverlayTrigger.manual,
      isOpen: _open,
      onOpenChanged: _setOpen,
      placement: widget.placement,
      transition: HyperOverlayTransition.fade,
      transitionBuilder: widget.transitionBuilder,
      anchor: Focus(
        onFocusChange: (focused) {
          _focused = focused;
          if (focused) {
            _scheduleOpen(Duration.zero);
          } else {
            _scheduleClose();
          }
        },
        child: MouseRegion(
          onEnter: (_) {
            _hovered = true;
            _scheduleOpen(widget.waitDuration);
          },
          onExit: (_) {
            _hovered = false;
            _scheduleClose();
          },
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onLongPressStart: (_) {
              _longPressed = true;
              _scheduleOpen(Duration.zero);
            },
            onLongPressEnd: (_) => _endLongPress(),
            onLongPressCancel: _endLongPress,
            child: Semantics(tooltip: widget.message, child: widget.child),
          ),
        ),
      ),
      overlayBuilder: (context, close) => IgnorePointer(
        child: HyperCard(
          style: surface,
          child: Text(
            widget.message,
            style: theme.textTheme.bodySmall?.copyWith(
              color:
                  widget.foregroundColor ??
                  tooltipTheme.foregroundColor ??
                  colors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
