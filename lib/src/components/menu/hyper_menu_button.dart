import 'package:flutter/material.dart';

import '../../theme/size/components/hyper_button_size.dart';
import '../button/hyper_button.dart';
import '../button/hyper_button_style.dart';
import '../button/hyper_button_theme.dart';
import '../overlay/hyper_anchored_overlay.dart';
import 'hyper_menu.dart';
import 'hyper_menu_model.dart';
import 'hyper_menu_style.dart';

/// 用 HyperButton 打开操作菜单；菜单内容仍由 HyperMenu 负责。
class HyperMenuButton extends StatefulWidget {
  const HyperMenuButton({
    super.key,
    required this.child,
    this.items = const [],
    this.groups = const [],
    this.selectedId,
    this.onSelected,
    this.variant = HyperButtonVariant.tonal,
    this.size = HyperButtonSizeVariant.medium,
    this.buttonStyle,
    this.menuStyle,
    this.placement = HyperOverlayPlacement.bottomStart,
    this.transitionBuilder,
    this.enabled = true,
  });

  final Widget child;
  final List<HyperMenuItem> items;
  final List<HyperMenuGroup> groups;
  final String? selectedId;
  final ValueChanged<String>? onSelected;
  final HyperButtonVariant variant;
  final HyperButtonSizeVariant size;
  final HyperButtonStyle? buttonStyle;
  final HyperMenuStyle? menuStyle;
  final HyperOverlayPlacement placement;
  final HyperOverlayTransitionBuilder? transitionBuilder;
  final bool enabled;

  @override
  State<HyperMenuButton> createState() => _HyperMenuButtonState();
}

class _HyperMenuButtonState extends State<HyperMenuButton> {
  bool _open = false;

  void _toggle() => setState(() => _open = !_open);

  @override
  Widget build(BuildContext context) {
    final onPressed = widget.enabled ? _toggle : null;
    final button = switch (widget.variant) {
      HyperButtonVariant.filled => HyperButton.filled(
        onPressed: onPressed,
        size: widget.size,
        style: widget.buttonStyle,
        child: widget.child,
      ),
      HyperButtonVariant.tonal => HyperButton.tonal(
        onPressed: onPressed,
        size: widget.size,
        style: widget.buttonStyle,
        child: widget.child,
      ),
      HyperButtonVariant.outlined => HyperButton.outlined(
        onPressed: onPressed,
        size: widget.size,
        style: widget.buttonStyle,
        child: widget.child,
      ),
      HyperButtonVariant.ghost => HyperButton.ghost(
        onPressed: onPressed,
        size: widget.size,
        style: widget.buttonStyle,
        child: widget.child,
      ),
      HyperButtonVariant.text => HyperButton.text(
        onPressed: onPressed,
        size: widget.size,
        style: widget.buttonStyle,
        child: widget.child,
      ),
      HyperButtonVariant.gradient => HyperButton.gradient(
        onPressed: onPressed,
        size: widget.size,
        style: widget.buttonStyle,
        child: widget.child,
      ),
    };
    return HyperAnchoredOverlay(
      trigger: HyperOverlayTrigger.manual,
      placement: widget.placement,
      transitionBuilder: widget.transitionBuilder,
      isOpen: _open,
      onOpenChanged: (open) => setState(() => _open = open),
      anchor: button,
      overlayBuilder: (context, close) => HyperMenu(
        items: widget.items,
        groups: widget.groups,
        selectedId: widget.selectedId,
        style: widget.menuStyle,
        onSelected: (id) {
          close();
          widget.onSelected?.call(id);
        },
      ),
    );
  }
}
