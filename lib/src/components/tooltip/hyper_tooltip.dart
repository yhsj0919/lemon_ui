import 'dart:async';

import 'package:flutter/material.dart';

import '../../theme/core/hyper_theme.dart';
import '../card/hyper_card.dart';
import '../card/hyper_card_style.dart';
import '../card/hyper_card_theme.dart';
import '../overlay/hyper_anchored_overlay.dart';
import '../overlay/hyper_overlay_material.dart';

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
  });

  final String message;
  final Widget child;
  final HyperOverlayPlacement placement;
  final Duration waitDuration;
  final Duration exitDuration;

  /// 长按松开后，提示继续显示的时间。
  final Duration showDuration;
  final HyperOverlayTransitionBuilder? transitionBuilder;

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
          style: HyperCardStyle(
            material: HyperOverlayMaterial.fallback(
              context,
              componentMaterial: HyperCardTheme.of(context).style?.material,
              hasExplicitBackground:
                  HyperCardTheme.of(context).style?.background != null,
            ),
            borderRadius: BorderRadius.circular(sizes.menu.itemRadius),
            padding: EdgeInsets.symmetric(
              horizontal: sizes.menu.padding,
              vertical: sizes.menu.padding / 2,
            ),
          ),
          child: Text(
            widget.message,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
