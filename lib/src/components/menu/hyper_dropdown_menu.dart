import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/core/hyper_theme.dart';
import '../../theme/size/components/hyper_button_size.dart';
import '../button/hyper_button.dart';
import '../button/hyper_button_style.dart';
import '../button/hyper_button_theme.dart';
import '../overlay/hyper_anchored_overlay.dart';
import 'hyper_menu.dart';
import 'hyper_menu_model.dart';
import 'hyper_menu_style.dart';
import 'hyper_menu_theme.dart';
import 'hyper_dropdown_menu_style.dart';
import 'hyper_dropdown_menu_theme.dart';

/// 下拉选择器中的一个值。标签用于锚点展示，也作为菜单项的语义名称。
@immutable
final class HyperDropdownOption<T> {
  const HyperDropdownOption({
    required this.value,
    required this.label,
    this.leading,
    this.enabled = true,
  });

  final T value;
  final String label;
  final Widget? leading;
  final bool enabled;
}

/// 从一组值中单选；选中值由调用方通过 [value] 控制。
///
/// 锚点复用 HyperButton，选项、键盘导航与表面复用 HyperMenu。
class HyperDropdownMenu<T> extends StatefulWidget {
  const HyperDropdownMenu({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
    this.placeholder = '请选择',
    this.enabled = true,
    this.size = HyperButtonSizeVariant.medium,
    this.buttonStyle,
    this.menuStyle,
    this.style,
    this.placement = HyperOverlayPlacement.bottomStart,
    this.transitionBuilder,
  });

  final List<HyperDropdownOption<T>> options;
  final T? value;
  final ValueChanged<T>? onChanged;
  final String placeholder;
  final bool enabled;
  final HyperButtonSizeVariant size;
  final HyperButtonStyle? buttonStyle;
  final HyperMenuStyle? menuStyle;
  final HyperDropdownMenuStyle? style;
  final HyperOverlayPlacement placement;
  final HyperOverlayTransitionBuilder? transitionBuilder;

  @override
  State<HyperDropdownMenu<T>> createState() => _HyperDropdownMenuState<T>();
}

class _HyperDropdownMenuState<T> extends State<HyperDropdownMenu<T>> {
  final FocusNode _anchorFocus = FocusNode(debugLabel: 'HyperDropdownMenu');
  bool _open = false;

  bool get _enabled => widget.enabled && widget.onChanged != null;

  @override
  void didUpdateWidget(HyperDropdownMenu<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_enabled && _open) _open = false;
  }

  @override
  void dispose() {
    _anchorFocus.dispose();
    super.dispose();
  }

  void _setOpen(bool value) {
    if (!mounted || _open == value) return;
    setState(() => _open = value);
  }

  KeyEventResult _onAnchorKey(FocusNode node, KeyEvent event) {
    if (!_enabled || event is! KeyDownEvent || _open) {
      return KeyEventResult.ignored;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowDown ||
        event.logicalKey == LogicalKeyboardKey.arrowUp) {
      _setOpen(true);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void _restoreAnchorFocus() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _enabled) _anchorFocus.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final sizes = HyperTheme.sizesOf(context);
    final buttonTheme = HyperButtonTheme.of(context)
        .resolve(HyperButtonVariant.outlined);
    final menuTheme = HyperMenuTheme.of(context).style;
    final metrics = sizes.dropdownMenu;
    final resolved = HyperDropdownMenuStyle(
      width: metrics.width,
      arrowSize: metrics.arrowSize,
      arrowSpacing: metrics.arrowSpacing,
      popupSpacing: sizes.overlaySpacing,
      foregroundColor: buttonTheme.foregroundColor ?? theme.colors.textPrimary,
      arrowColor: theme.colors.textSecondary,
      disabledArrowColor: theme.colors.disabled,
      selectedBackgroundColor:
          menuTheme?.selectedBackgroundColor ??
          theme.colors.stateLayer.withValues(alpha: .08),
    ).merge(HyperDropdownMenuTheme.of(context).style).merge(widget.style);
    final menuWidth = widget.menuStyle?.width ?? resolved.width!;
    final arrowSize = widget.buttonStyle?.iconSize ?? resolved.arrowSize!;
    final selectedIndex = widget.options.indexWhere(
      (option) => option.value == widget.value,
    );
    final selected = selectedIndex < 0 ? null : widget.options[selectedIndex];
    final entries = [
      for (final (index, option) in widget.options.indexed)
        HyperMenuItem(
          id: '$index',
          label: option.label,
          leading: option.leading,
          enabled: option.enabled,
        ),
    ];

    return HyperAnchoredOverlay(
      trigger: HyperOverlayTrigger.manual,
      placement: widget.placement,
      spacing: resolved.popupSpacing!,
      transitionBuilder: widget.transitionBuilder,
      isOpen: _open,
      onOpenChanged: _setOpen,
      anchor: Focus(
        skipTraversal: true,
        onKeyEvent: _onAnchorKey,
        child: Semantics(
          value: selected?.label ?? widget.placeholder,
          expanded: _open,
          child: HyperButton.outlined(
            onPressed: _enabled ? () => _setOpen(!_open) : null,
            focusNode: _anchorFocus,
            size: widget.size,
            style: HyperButtonStyle(
              width: menuWidth,
              foregroundColor: resolved.foregroundColor,
            ).merge(widget.buttonStyle),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Text(
                    selected?.label ?? widget.placeholder,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: resolved.arrowSpacing),
                Icon(
                  _open ? Icons.expand_less : Icons.expand_more,
                  size: arrowSize,
                  color: _enabled
                      ? resolved.arrowColor
                      : resolved.disabledArrowColor,
                ),
              ],
            ),
          ),
        ),
      ),
      overlayBuilder: (context, close) => Focus(
        skipTraversal: true,
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.escape) {
            close();
            _restoreAnchorFocus();
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: HyperMenu(
          items: entries,
          selectedId: selectedIndex < 0 ? null : '$selectedIndex',
          style: HyperMenuStyle(
            width: menuWidth,
            selectedBackgroundColor: resolved.selectedBackgroundColor,
          ).merge(widget.menuStyle),
          onSelected: (id) {
            final index = int.parse(id);
            if (index < 0 || index >= widget.options.length) return;
            final option = widget.options[index];
            if (!option.enabled) return;
            close();
            widget.onChanged?.call(option.value);
            _restoreAnchorFocus();
          },
        ),
      ),
    );
  }
}
