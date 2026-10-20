import 'package:flutter/material.dart';

import '../../theme/core/hyper_theme.dart';
import '../button/hyper_button.dart';
import '../text/hyper_scrolling_text.dart';
import '../button/hyper_button_style.dart';
import '../card/hyper_card.dart';
import '../card/hyper_card_style.dart';
import '../menu/hyper_menu_surface.dart';
import '../overlay/hyper_anchored_overlay.dart';
import 'hyper_select_model.dart';
import 'hyper_select_presenter.dart';
import 'hyper_select_style.dart';
import 'hyper_select_theme.dart';
import 'hyper_selection_theme.dart';

/// 自定义内容下拉容器；选择值、筛选和多级内容由调用方管理。
class HyperDropdown extends StatefulWidget {
  const HyperDropdown({
    super.key,
    required this.panelBuilder,
    this.modalTitle,
    this.label = const HyperScrollingText(
      '请选择',
      trigger: HyperTextScrollTrigger.hover,
    ),
    this.enabled = true,
    this.isOpen,
    this.onOpenChanged,
    this.presentation,
    this.placement = HyperOverlayPlacement.bottomStart,
    this.style,
    this.buttonStyle,
    this.surfaceStyle,
    this.anchorBuilder,
  });
  final Widget Function(BuildContext context, VoidCallback close) panelBuilder;
  final Widget label;
  final Widget? modalTitle;
  final bool enabled;
  final bool? isOpen;
  final ValueChanged<bool>? onOpenChanged;
  final HyperSelectPresentation? presentation;
  final HyperOverlayPlacement placement;
  final HyperSelectStyle? style;
  final HyperButtonStyle? buttonStyle;
  final HyperCardStyle? surfaceStyle;
  final HyperOverlayAnchorBuilder? anchorBuilder;
  @override
  State<HyperDropdown> createState() => _HyperDropdownState();
}

class _HyperDropdownState extends State<HyperDropdown> {
  bool _open = false;
  VoidCallback? _closeModal;
  bool get open => widget.enabled && (widget.isOpen ?? _open);
  @override
  void didUpdateWidget(HyperDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!open) _closeModal?.call();
    if (open && !(oldWidget.isOpen ?? _open)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && open) _present();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.isOpen == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && open) _present();
      });
    }
  }

  void _setOpen(bool value) {
    if (!mounted || (value && !widget.enabled)) return;
    if (widget.isOpen == null) setState(() => _open = value);
    widget.onOpenChanged?.call(value);
    if (!value) _closeModal?.call();
  }

  void _toggle() {
    if (open) {
      _setOpen(false);
    } else {
      _setOpen(true);
      if (widget.isOpen == null) _present();
    }
  }

  HyperSelectStyle get style =>
      (HyperSelectTheme.of(context).style ?? const HyperSelectStyle()).merge(
        widget.style,
      );
  HyperSelectPresentation get presentation => hyperResolveSelectPresentation(
    widget.presentation ??
        style.selectionStyle?.presentation ??
        HyperSelectPresentation.adaptive,
    HyperTheme.sizesOf(context).deviceType,
  );
  bool get modal =>
      presentation == HyperSelectPresentation.bottomSheet ||
      presentation == HyperSelectPresentation.fullScreen;
  Future<void> _present() async {
    if (!modal || _closeModal != null) return;
    await showHyperSelectModal(
      context: context,
      presentation: presentation,
      title: '选择',
      titleWidget: widget.modalTitle,
      style: style.selectionStyle,
      surfaceStyle:
          (style.selectionStyle?.surfaceStyle)?.merge(widget.surfaceStyle) ??
          widget.surfaceStyle,
      builder: (routeContext) {
        final route = ModalRoute.of(routeContext)!;
        final navigator = Navigator.of(routeContext);
        _closeModal = () {
          if (route.isCurrent) navigator.pop();
        };
        return _panel(routeContext, constrained: false);
      },
    );
    _closeModal = null;
    if (mounted && open) _setOpen(false);
  }

  Widget _panel(BuildContext context, {bool constrained = true}) {
    final sizes = HyperTheme.sizesOf(context);
    final selection = HyperSelectionTheme.of(context).style
        .merge(style.selectionStyle);
    final menu = selection.menuStyle;
    if (!constrained) {
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: selection.maxPanelHeight ?? double.infinity,
        ),
        child: SingleChildScrollView(
          child: widget.panelBuilder(context, () => _setOpen(false)),
        ),
      );
    }
    return HyperCard(
      style: resolveHyperMenuSurface(
        context,
        radius:
            menu?.surfaceRadius ??
            sizes.select.surfaceRadius ??
            sizes.menu.surfaceRadius,
        padding: EdgeInsets.all(menu?.surfacePadding ?? sizes.menu.padding),
        style:
            (menu?.surfaceStyle?.merge(selection.surfaceStyle) ??
                    selection.surfaceStyle)
                ?.merge(widget.surfaceStyle) ??
            widget.surfaceStyle,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: selection.maxPanelHeight ?? sizes.selection.maxPanelHeight,
        ),
        child: SingleChildScrollView(
          child: SizedBox(
            width: constrained
                ? menu?.width ??
                      selection.width ??
                      style.width ??
                      sizes.select.width
                : null,
            child: widget.panelBuilder(context, () => _setOpen(false)),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    final close = _closeModal;
    if (close != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => close());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizes = HyperTheme.sizesOf(context), visual = style;
    return HyperAnchoredOverlay.builder(
      isOpen: open && !modal,
      onOpenChanged: (value) {
        if (!value && !modal) _setOpen(false);
      },
      placement: presentation == HyperSelectPresentation.trailing
          ? HyperOverlayPlacement.bottomEnd
          : widget.placement,
      spacing:
          visual.popupSpacing ??
          sizes.select.popupSpacing ??
          sizes.overlaySpacing,
      transitionBuilder: visual.selectionStyle?.transitionBuilder,
      anchorBuilder: (context, toggle, isOpen) =>
          widget.anchorBuilder?.call(context, _toggle, open) ??
          HyperButton.outlined(
            onPressed: widget.enabled ? _toggle : null,
            focusHighlight: open ? true : null,
            style: HyperButtonStyle(
              width: visual.width ?? sizes.select.width,
              minimumSize: Size(
                0,
                sizes.select.minimumHeight ?? sizes.textField.minimumHeight,
              ),
              borderRadius: sizes.select.radius == null
                  ? null
                  : BorderRadius.circular(sizes.select.radius!),
              foregroundColor: visual.foregroundColor,
            ).merge(visual.buttonStyle).merge(widget.buttonStyle),
            child: Row(
              children: [
                Expanded(child: widget.label),
                SizedBox(
                  width: visual.arrowSpacing ?? sizes.select.arrowSpacing,
                ),
                Icon(
                  open ? Icons.expand_less : Icons.expand_more,
                  size: visual.arrowSize ?? sizes.select.arrowSize,
                  color: widget.enabled
                      ? visual.arrowColor ??
                            HyperTheme.of(context).colors.textSecondary
                      : visual.disabledArrowColor ??
                            HyperTheme.of(context).colors.disabled,
                ),
              ],
            ),
          ),
      overlayBuilder: (context, close) => _panel(context),
    );
  }
}
