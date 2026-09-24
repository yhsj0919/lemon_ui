import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../overlay/hyper_anchored_overlay.dart';
import 'hyper_menu.dart';
import 'hyper_menu_model.dart';
import 'hyper_menu_style.dart';

/// 右键或长按 child 时，在指针或触点位置打开菜单。
class HyperContextMenu extends StatefulWidget {
  const HyperContextMenu({
    super.key,
    required this.child,
    this.items = const [],
    this.groups = const [],
    this.selectedId,
    this.onSelected,
    this.menuStyle,
    this.transitionBuilder,
    this.enabled = true,
  });

  final Widget child;
  final List<HyperMenuItem> items;
  final List<HyperMenuGroup> groups;
  final String? selectedId;
  final ValueChanged<String>? onSelected;
  final HyperMenuStyle? menuStyle;
  final HyperOverlayTransitionBuilder? transitionBuilder;
  final bool enabled;

  @override
  State<HyperContextMenu> createState() => _HyperContextMenuState();
}

class _HyperContextMenuState extends State<HyperContextMenu> {
  final FocusNode _focusNode = FocusNode();
  bool _open = false;
  Offset? _position;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _show(Offset? position) {
    if (!widget.enabled) return;
    setState(() {
      _position = position;
      _open = true;
    });
  }

  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    if (!widget.enabled || event is! KeyDownEvent) {
      return KeyEventResult.ignored;
    }
    final key = event.logicalKey;
    if (key != LogicalKeyboardKey.contextMenu &&
        !(key == LogicalKeyboardKey.f10 &&
            HardwareKeyboard.instance.isShiftPressed)) {
      return KeyEventResult.ignored;
    }
    _show(null);
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) => Focus(
    focusNode: _focusNode,
    onKeyEvent: _onKeyEvent,
    child: HyperAnchoredOverlay(
      trigger: HyperOverlayTrigger.manual,
      anchorPosition: _position,
      transitionBuilder: widget.transitionBuilder,
      isOpen: _open,
      onOpenChanged: (open) => setState(() => _open = open),
      anchor: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onSecondaryTapDown: widget.enabled
            ? (details) {
                _focusNode.requestFocus();
                _show(details.localPosition);
              }
            : null,
        onLongPressStart: widget.enabled
            ? (details) {
                _focusNode.requestFocus();
                _show(details.localPosition);
              }
            : null,
        child: widget.child,
      ),
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
    ),
  );
}
