import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';

import '../../theme/core/hyper_theme.dart';
import '../../theme/motion/hyper_motion_theme.dart';
import '../menu/hyper_dropdown_menu.dart';
import '../menu/hyper_menu.dart';
import '../menu/hyper_menu_model.dart';
import '../menu/hyper_menu_style.dart';
import '../menu/hyper_menu_theme.dart';
import '../overlay/hyper_anchored_overlay.dart';
import 'hyper_list_tile.dart';
import 'hyper_list_tile_style.dart';

/// 点击整行后在浮层中单选的列表项；值由调用方控制。
///
/// 行的布局交给 [HyperListTile]，选项与焦点导航交给 [HyperMenu]。
class HyperPopupListTile<T> extends StatefulWidget {
  const HyperPopupListTile({
    super.key,
    required this.title,
    required this.options,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.leading,
    this.placeholder = '请选择',
    this.density = HyperListTileDensity.standard,
    this.enabled = true,
    this.autofocus = false,
    this.focusNode,
    this.semanticLabel,
    this.style,
    this.menuStyle,
    this.minPopupWidth,
    this.maxPopupWidth,
    this.transitionBuilder,
  }) : assert(minPopupWidth == null || minPopupWidth > 0),
       assert(maxPopupWidth == null || maxPopupWidth > 0),
       assert(
         minPopupWidth == null ||
             maxPopupWidth == null ||
             minPopupWidth <= maxPopupWidth,
       );

  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final List<HyperDropdownOption<T>> options;
  final T? value;
  final ValueChanged<T>? onChanged;
  final String placeholder;
  final HyperListTileDensity density;
  final bool enabled;
  final bool autofocus;
  final FocusNode? focusNode;
  final String? semanticLabel;
  final HyperListTileStyle? style;
  final HyperMenuStyle? menuStyle;

  /// 自适应宽度的下限和上限；空值取当前端尺寸主题。
  final double? minPopupWidth;
  final double? maxPopupWidth;
  final HyperOverlayTransitionBuilder? transitionBuilder;

  @override
  State<HyperPopupListTile<T>> createState() => _HyperPopupListTileState<T>();
}

class _HyperPopupListTileState<T> extends State<HyperPopupListTile<T>> {
  final GlobalKey _anchorKey = GlobalKey(
    debugLabel: 'HyperPopupListTileArrowAnchor',
  );
  final FocusNode _internalFocusNode = FocusNode(
    debugLabel: 'HyperPopupListTile',
  );
  bool _open = false;

  FocusNode get _focusNode => widget.focusNode ?? _internalFocusNode;
  bool get _enabled => widget.enabled && widget.onChanged != null;

  @override
  void didUpdateWidget(HyperPopupListTile<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_enabled && _open) _open = false;
  }

  @override
  void dispose() {
    _internalFocusNode.dispose();
    super.dispose();
  }

  KeyEventResult _onAnchorKey(FocusNode node, KeyEvent event) {
    if (!_enabled || _open || event is! KeyDownEvent) {
      return KeyEventResult.ignored;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowDown ||
        event.logicalKey == LogicalKeyboardKey.arrowUp) {
      _showOptions();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void _restoreFocus() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _enabled) _focusNode.requestFocus();
    });
  }

  Future<void> _showOptions() async {
    if (!_enabled || _open) return;
    final anchorBox = _anchorKey.currentContext?.findRenderObject();
    final overlayBox = Navigator.of(
      context,
      rootNavigator: true,
    ).overlay?.context.findRenderObject();
    if (anchorBox is! RenderBox || overlayBox is! RenderBox) return;
    final origin = anchorBox.localToGlobal(Offset.zero, ancestor: overlayBox);
    final anchor = origin & anchorBox.size;
    setState(() => _open = true);
    final theme = HyperTheme.of(context);
    final sizes = HyperTheme.sizesOf(context);
    final menuTheme = HyperMenuTheme.of(context).style;
    final selectedIndex = widget.options.indexWhere(
      (option) => option.value == widget.value,
    );
    final entries = [
      for (final (index, option) in widget.options.indexed)
        HyperMenuItem(
          id: '$index',
          label: option.label,
          leading: option.leading,
          enabled: option.enabled,
        ),
    ];
    final itemPadding =
        widget.menuStyle?.padding ??
        menuTheme?.padding ??
        sizes.popupListTile.itemHorizontalPadding;
    final iconSize =
        widget.menuStyle?.iconSize ??
        menuTheme?.iconSize ??
        sizes.menu.iconSize;
    final iconSpacing =
        widget.menuStyle?.iconSpacing ??
        menuTheme?.iconSpacing ??
        sizes.menu.iconSpacing;
    final surfacePadding =
        widget.menuStyle?.surfacePadding ?? menuTheme?.surfacePadding ?? 0.0;
    final textStyle =
        widget.menuStyle?.itemTextStyle ??
        menuTheme?.itemTextStyle ??
        theme.textTheme.titleMedium?.copyWith(
          fontSize: theme.typography.listTitle,
          height: theme.typography.listTitleLineHeight,
        ) ??
        const TextStyle();
    final direction = Directionality.of(context);
    final textScaler = MediaQuery.textScalerOf(context);
    var contentWidth = 0.0;
    for (final option in widget.options) {
      final painter = TextPainter(
        text: TextSpan(text: option.label, style: textStyle),
        textDirection: direction,
        textScaler: textScaler,
        maxLines: 1,
      )..layout();
      contentWidth = math.max(
        contentWidth,
        painter.width + (option.leading == null ? 0 : iconSize + iconSpacing),
      );
      painter.dispose();
    }
    // 两侧文字内边距与选中对勾占位都计入弹窗的自然宽度。
    final naturalWidth =
        contentWidth +
        2 * itemPadding +
        2 * surfacePadding +
        iconSize +
        iconSpacing;
    final minWidth = widget.minPopupWidth ?? sizes.popupListTile.minWidth;
    final maxWidth = math.max(
      minWidth,
      widget.maxPopupWidth ?? sizes.popupListTile.maxWidth,
    );
    final popupWidth =
        widget.menuStyle?.width ??
        menuTheme?.width ??
        naturalWidth.clamp(minWidth, maxWidth).toDouble();
    final menuStyle = HyperMenuStyle(
      width: popupWidth,
      padding: itemPadding,
      itemHeight: widget.density == HyperListTileDensity.compact
          ? sizes.listTile.compactMinHeight
          : sizes.listTile.minHeight,
      surfacePadding: menuTheme?.surfacePadding ?? 0,
      itemRadius: menuTheme?.itemRadius ?? 0,
      selectedBackgroundColor:
          menuTheme?.selectedBackgroundColor ?? Colors.transparent,
      selectedForegroundColor:
          menuTheme?.selectedForegroundColor ?? theme.colors.primary,
    ).merge(widget.menuStyle);
    final duration = theme.motion.durationFor(
      HyperMotionSpeed.standard,
      disableAnimations:
          MediaQuery.maybeOf(context)?.disableAnimations ?? false,
    );
    final media = MediaQuery.of(context);
    final bounds = Rect.fromLTRB(
      media.padding.left,
      media.padding.top,
      math.max(media.padding.left, media.size.width - media.padding.right),
      math.max(
        media.padding.top,
        media.size.height -
            math.max(media.padding.bottom, media.viewInsets.bottom),
      ),
    );
    final below = math.max(
      0,
      bounds.bottom - anchor.bottom - sizes.overlaySpacing,
    );
    final above = math.max(0, anchor.top - bounds.top - sizes.overlaySpacing);
    final desiredHeight = math.min(
      entries.length * menuStyle.itemHeight! + 2 * menuStyle.surfacePadding!,
      menuStyle.maxHeight ?? double.infinity,
    );
    final showBelow = below >= desiredHeight || below >= above;
    final index = await showGeneralDialog<int>(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: theme.colors.scrim,
      transitionDuration: duration,
      pageBuilder: (dialogContext, animation, secondaryAnimation) => Material(
        type: MaterialType.transparency,
        child: HyperMenu(
          items: entries,
          selectedId: selectedIndex < 0 ? null : '$selectedIndex',
          style: menuStyle,
          onSelected: (id) => Navigator.of(dialogContext).pop(int.parse(id)),
        ),
      ),
      transitionBuilder: (dialogContext, animation, secondaryAnimation, child) {
        final custom = widget.transitionBuilder;
        final popup = custom != null
            ? custom(dialogContext, animation, child)
            : _PopupListTileReveal(
                animation: animation,
                curve: theme.motion.standardCurve,
                spring: theme.motion.spring,
                duration: duration,
                showBelow: showBelow,
                radius: menuStyle.surfaceRadius ?? sizes.menu.surfaceRadius,
                child: child,
              );
        return CustomSingleChildLayout(
          delegate: _PopupListTileLayout(
            anchor: anchor,
            bounds: bounds,
            spacing: sizes.overlaySpacing,
            showBelow: showBelow,
          ),
          child: popup,
        );
      },
    );
    if (!mounted) return;
    setState(() => _open = false);
    if (index != null && index >= 0 && index < widget.options.length) {
      final option = widget.options[index];
      if (option.enabled) widget.onChanged?.call(option.value);
    }
    _restoreFocus();
  }

  @override
  Widget build(BuildContext context) {
    final metrics = HyperTheme.sizesOf(context).listTile;
    final selectedIndex = widget.options.indexWhere(
      (option) => option.value == widget.value,
    );
    final selected = selectedIndex < 0 ? null : widget.options[selectedIndex];
    return Focus(
      skipTraversal: true,
      onKeyEvent: _onAnchorKey,
      child: Semantics(
        value: selected?.label ?? widget.placeholder,
        expanded: _open,
        child: LayoutBuilder(
          builder: (context, constraints) => HyperListTile(
            title: widget.title,
            subtitle: widget.subtitle,
            leading: widget.leading,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ConstrainedBox(
                  // 当前值最多占半行，给标题和首部内容保留空间。
                  constraints: BoxConstraints(
                    maxWidth: constraints.maxWidth.isFinite
                        ? constraints.maxWidth / 2
                        : HyperTheme.sizesOf(context).menu.width,
                  ),
                  child: Text(
                    selected?.label ?? widget.placeholder,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: metrics.trailingSpacing),
                Icon(
                  Icons.unfold_more,
                  key: _anchorKey,
                  size: metrics.trailingIconSize,
                ),
              ],
            ),
            density: widget.density,
            onTap: _enabled ? _showOptions : null,
            enabled: widget.enabled,
            autofocus: widget.autofocus,
            focusNode: _focusNode,
            semanticLabel: widget.semanticLabel,
            style: widget.style,
          ),
        ),
      ),
    );
  }
}

/// 模态遮罩覆盖整页，菜单按尾部箭头定位并在屏幕边缘翻转。
class _PopupListTileLayout extends SingleChildLayoutDelegate {
  const _PopupListTileLayout({
    required this.anchor,
    required this.bounds,
    required this.spacing,
    required this.showBelow,
  });

  final Rect anchor;
  final Rect bounds;
  final double spacing;
  final bool showBelow;

  double get _below => math.max(0, bounds.bottom - anchor.bottom - spacing);
  double get _above => math.max(0, anchor.top - bounds.top - spacing);

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      BoxConstraints.loose(Size(bounds.width, math.max(_below, _above)));

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final x = (anchor.right - childSize.width).clamp(
      bounds.left,
      math.max(bounds.left, bounds.right - childSize.width),
    );
    final preferredY = showBelow
        ? anchor.bottom + spacing
        : anchor.top - spacing - childSize.height;
    final y = preferredY.clamp(
      bounds.top,
      math.max(bounds.top, bounds.bottom - childSize.height),
    );
    return Offset(x.toDouble(), y.toDouble());
  }

  @override
  bool shouldRelayout(_PopupListTileLayout oldDelegate) =>
      anchor != oldDelegate.anchor ||
      bounds != oldDelegate.bounds ||
      spacing != oldDelegate.spacing ||
      showBelow != oldDelegate.showBelow;
}

/// 从靠近列表项的一侧缩放并逐步揭示内容，尺寸始终保持最终布局尺寸。
class _PopupListTileReveal extends StatelessWidget {
  const _PopupListTileReveal({
    required this.animation,
    required this.curve,
    required this.spring,
    required this.duration,
    required this.showBelow,
    required this.radius,
    required this.child,
  });

  final Animation<double> animation;
  final Curve curve;
  final SpringDescription spring;
  final Duration duration;
  final bool showBelow;
  final double radius;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (duration == Duration.zero) return child;
    final simulation = SpringSimulation(spring, 0, 1, 0);
    final totalSeconds =
        duration.inMicroseconds / Duration.microsecondsPerSecond;
    final settled = simulation.x(totalSeconds);
    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, child) {
        final alpha = curve.transform(animation.value).clamp(0.0, 1.0);
        final springProgress =
            simulation.x(animation.value * totalSeconds) / settled;
        final reveal = springProgress.clamp(0.0, 1.0);
        return Opacity(
          opacity: alpha,
          child: Transform.scale(
            scale: .15 + .85 * springProgress,
            alignment: Alignment(1, showBelow ? -1 : 1),
            child: ClipPath(
              clipper: _PopupListTileRevealClipper(reveal, showBelow, radius),
              child: child,
            ),
          ),
        );
      },
    );
  }
}

class _PopupListTileRevealClipper extends CustomClipper<Path> {
  const _PopupListTileRevealClipper(this.progress, this.showBelow, this.radius);

  final double progress;
  final bool showBelow;
  final double radius;

  @override
  Path getClip(Size size) {
    final height = size.height * progress;
    final rect = Rect.fromLTWH(
      0,
      showBelow ? 0 : size.height - height,
      size.width,
      height,
    );
    return Path()
      ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)));
  }

  @override
  bool shouldReclip(_PopupListTileRevealClipper oldClipper) =>
      progress != oldClipper.progress ||
      showBelow != oldClipper.showBelow ||
      radius != oldClipper.radius;
}
