import '../../foundation/hyper_icons.dart';
import 'hyper_color_swatch.dart';
import '../select/hyper_select_focus.dart';

import 'dart:async';

import 'package:flutter/material.dart';

import '../../theme/core/hyper_theme.dart';
import '../button/hyper_button.dart';
import '../text/hyper_scrolling_text.dart';
import '../button/hyper_button_style.dart';
import '../card/hyper_card.dart';
import '../card/hyper_card_style.dart';
import '../overlay/hyper_anchored_overlay.dart';
import '../menu/hyper_menu_theme.dart';
import '../menu/hyper_menu_surface.dart';
import '../select/hyper_select_model.dart';
import '../select/hyper_select_presenter.dart';
import '../select/hyper_select_theme.dart';
import 'hyper_color_picker.dart';
import 'hyper_color_picker_style.dart';

/// 选色字段的显示内容。
enum HyperColorPickerFieldDisplay { colorAndValue, swatch }

/// 显示色块及色值，按设备使用跟随浮层、底部弹窗或独立页面。
/// 跟随浮层实时更新；模态呈现通过确定提交，取消保留原值。
/// 字段、浮层和取色器分别复用 Button、Card 和 ColorPicker 的主题。
class HyperColorPickerField extends StatefulWidget {
  const HyperColorPickerField({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
    this.showAlpha = true,
    this.display = HyperColorPickerFieldDisplay.colorAndValue,
    this.pickerStyle,
    this.buttonStyle,
    this.panelStyle,
    this.recommendedColors = const [],
    this.placement = HyperOverlayPlacement.bottomStart,
    this.transitionBuilder,
    this.presentation = HyperSelectPresentation.adaptive,
  });
  final Color value;
  final ValueChanged<Color>? onChanged;
  final bool enabled, showAlpha;
  final HyperColorPickerFieldDisplay display;
  final HyperColorPickerStyle? pickerStyle;
  final HyperButtonStyle? buttonStyle;
  final HyperCardStyle? panelStyle;
  final List<Color> recommendedColors;
  final HyperOverlayPlacement placement;
  final HyperOverlayTransitionBuilder? transitionBuilder;
  final HyperSelectPresentation presentation;

  @override
  State<HyperColorPickerField> createState() => _HyperColorPickerFieldState();
}

class _HyperColorPickerFieldState extends State<HyperColorPickerField> {
  bool _open = false;
  bool _modal = false;
  bool get _enabled => widget.enabled && widget.onChanged != null;

  void _toggle() {
    if (!_enabled || _modal) return;
    if (_open) {
      setState(() => _open = false);
      return;
    }
    final presentation = hyperResolveSelectPresentation(
      widget.presentation,
      HyperTheme.sizesOf(context).deviceType,
    );
    if (presentation == HyperSelectPresentation.anchored ||
        presentation == HyperSelectPresentation.trailing) {
      setState(() => _open = true);
    } else {
      unawaited(_showModal(presentation));
    }
  }

  Future<void> _showModal(HyperSelectPresentation presentation) async {
    var draft = widget.value;
    Color? confirmed;
    setState(() {
      _open = true;
      _modal = true;
    });
    try {
      await showHyperSelectModal(
        context: context,
        presentation: presentation,
        title: '选择颜色',
        builder: (context) => StatefulBuilder(
          builder: (context, update) => SingleChildScrollView(
            child: Column(
              children: [
                HyperColorPicker(
                  recommendedColors: widget.recommendedColors,
                  value: draft,
                  showAlpha: widget.showAlpha,
                  style: widget.pickerStyle,
                  onChanged: (color) => update(() => draft = color),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    HyperButton.ghost(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('取消'),
                    ),
                    HyperButton.filled(
                      onPressed: () {
                        confirmed = draft;
                        Navigator.of(context).pop();
                      },
                      child: const Text('确定'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
      if (mounted && _enabled && confirmed != null) {
        widget.onChanged!(confirmed!);
      }
    } finally {
      if (mounted) {
        setState(() {
          _open = false;
          _modal = false;
        });
      }
    }
  }

  @override
  void didUpdateWidget(HyperColorPickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_enabled) _open = false;
  }

  @override
  Widget build(BuildContext context) {
    final hex =
        '#${widget.value.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}';
    final gap = HyperTheme.sizesOf(context).colorPicker.spacing;
    final sizes = HyperTheme.sizesOf(context);
    final select = HyperSelectTheme.of(context).style;
    return HyperAnchoredOverlay.builder(
      isOpen: _open && !_modal,
      onOpenChanged: (open) => setState(() => _open = open && _enabled),
      placement: widget.presentation == HyperSelectPresentation.trailing
          ? HyperOverlayPlacement.bottomEnd
          : widget.placement,
      transitionBuilder: widget.transitionBuilder,
      anchorBuilder: (context, toggle, open) => Semantics(
        label: '选择颜色',
        value: hex,
        expanded: _open,
        child: HyperSelectFocus(
          open: _open,
          enabled: _enabled,
          builder: (focusStyle) => HyperButton.outlined(
            onPressed: _enabled ? _toggle : null,
            focusHighlight: _open ? true : null,
            style:
                HyperButtonStyle(
                      width:
                          widget.display == HyperColorPickerFieldDisplay.swatch
                          ? null
                          : select?.width ?? sizes.select.width,
                      minimumSize: Size(
                        0,
                        sizes.select.minimumHeight ??
                            sizes.textField.minimumHeight,
                      ),
                      borderRadius: sizes.select.radius == null
                          ? null
                          : BorderRadius.circular(sizes.select.radius!),
                      foregroundColor: select?.foregroundColor,
                    )
                    .merge(focusStyle)
                    .merge(select?.buttonStyle)
                    .merge(widget.buttonStyle),
            child: Row(
              mainAxisSize:
                  widget.display == HyperColorPickerFieldDisplay.swatch
                  ? MainAxisSize.min
                  : MainAxisSize.max,
              mainAxisAlignment:
                  widget.display == HyperColorPickerFieldDisplay.swatch
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                HyperColorSwatch(color: widget.value),
                if (widget.display ==
                    HyperColorPickerFieldDisplay.colorAndValue) ...[
                  SizedBox(width: gap),
                  Expanded(
                    child: HyperScrollingText(
                      hex,
                      trigger: HyperTextScrollTrigger.hover,
                    ),
                  ),
                  SizedBox(
                    width: select?.arrowSpacing ?? sizes.select.arrowSpacing,
                  ),
                  Icon(
                    _open ? HyperIcons.chevronUp : HyperIcons.chevronDown,
                    size: select?.arrowSize ?? sizes.select.arrowSize,
                    color: _enabled
                        ? select?.arrowColor ??
                              HyperTheme.of(context).colors.textSecondary
                        : select?.disabledArrowColor ??
                              HyperTheme.of(context).colors.disabled,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      overlayBuilder: (context, close) {
        final sizes = HyperTheme.sizesOf(context);
        final menu = HyperMenuTheme.of(context).style;
        return HyperCard(
          style: resolveHyperMenuSurface(
            context,
            radius: menu?.surfaceRadius ?? sizes.menu.surfaceRadius,
            padding: EdgeInsets.all(menu?.surfacePadding ?? sizes.menu.padding),
            style:
                menu?.surfaceStyle?.merge(widget.panelStyle) ??
                widget.panelStyle,
          ),
          child: SingleChildScrollView(
            child: HyperColorPicker(
              recommendedColors: widget.recommendedColors,
              value: widget.value,
              onChanged: _enabled ? widget.onChanged : null,
              showAlpha: widget.showAlpha,
              style: widget.pickerStyle,
            ),
          ),
        );
      },
    );
  }
}
