import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../foundation/hyper_control_state.dart';
import '../../interaction/hyper_pressable.dart';
import '../../theme/core/hyper_theme.dart';
import '../../theme/motion/hyper_motion_theme.dart';
import '../card/hyper_card.dart';
import '../overlay/hyper_anchored_overlay.dart';
import 'hyper_menu_surface.dart';
import 'hyper_menu_model.dart';
import 'hyper_menu_style.dart';
import 'hyper_menu_theme.dart';

/// 将菜单键盘导航交给外部编辑器，同时保留编辑器焦点。
class HyperMenuNavigationController {
  KeyEventResult Function(KeyEvent)? _handle;
  KeyEventResult handleKeyEvent(KeyEvent event) =>
      _handle?.call(event) ?? KeyEventResult.ignored;
}

/// 弹出菜单内容；可放入 [HyperAnchoredOverlay] 等浮层中。
///
/// 菜单只负责内容、状态和键盘导航，锚点定位与关闭由使用方控制。
class HyperMenu extends StatefulWidget {
  const HyperMenu({
    super.key,
    this.items = const [],
    this.groups = const [],
    this.selectedId,
    this.selectedIds = const {},
    this.onSelected,
    this.style,
    this.requestFocusOnOpen = true,
    this.navigationController,
    this.showSurface = true,
  }) : _onBack = null;

  const HyperMenu._submenu(
    this._onBack,
    this.requestFocusOnOpen, {
    required this.items,
    required this.selectedId,
    required this.onSelected,
    required this.style,
  }) : groups = const [],
       selectedIds = const {},
       showSurface = true,
       navigationController = null;

  final List<HyperMenuItem> items;
  final List<HyperMenuGroup> groups;
  final String? selectedId;
  final Set<String> selectedIds;
  final ValueChanged<String>? onSelected;
  final HyperMenuStyle? style;
  final VoidCallback? _onBack;
  final bool requestFocusOnOpen;
  final HyperMenuNavigationController? navigationController;

  /// 嵌入已有面板时只绘制菜单内容，由父级负责表面和外层内边距。
  final bool showSurface;

  @override
  State<HyperMenu> createState() => _HyperMenuState();
}

class _HyperMenuState extends State<HyperMenu> {
  final Map<String, GlobalKey> _itemKeys = {};
  final Map<String, FocusNode> _itemFocusNodes = {};
  final FocusNode _focusNode = FocusNode();
  String? _activeId;
  String? _openSubmenuId;
  bool _keyboardActive = false;

  List<HyperMenuGroup> get _groups => [
    if (widget.items.isNotEmpty) HyperMenuGroup(items: widget.items),
    ...widget.groups,
  ];

  List<HyperMenuItem> get _enabledItems => [
    for (final group in _groups)
      for (final item in group.items)
        if (item.enabled) item,
  ];

  @override
  void initState() {
    super.initState();
    widget.navigationController?._handle = _forwardKey;
    _activeId = _initialActiveId();
    if (widget.requestFocusOnOpen) _requestMenuFocus();
  }

  @override
  void didUpdateWidget(HyperMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.navigationController != widget.navigationController) {
      oldWidget.navigationController?._handle = null;
      widget.navigationController?._handle = _forwardKey;
    }
    if (!oldWidget.requestFocusOnOpen && widget.requestFocusOnOpen) {
      _requestMenuFocus();
    }
    if (!_enabledItems.any((item) => item.id == _activeId)) {
      _activeId = _initialActiveId();
    }
  }

  void _requestMenuFocus() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.requestFocusOnOpen) _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    if (widget.navigationController?._handle == _forwardKey) {
      widget.navigationController?._handle = null;
    }
    for (final node in _itemFocusNodes.values) {
      node.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }

  bool _containsSelected(HyperMenuItem item) =>
      item.id == widget.selectedId ||
      widget.selectedIds.contains(item.id) ||
      item.children.any(_containsSelected);

  FocusNode _focusNodeFor(String id) => _itemFocusNodes.putIfAbsent(id, () {
    final node = FocusNode(debugLabel: 'HyperMenuItem $id');
    node.addListener(() {
      if (!mounted || !node.hasPrimaryFocus) return;
      setState(() {
        _activeId = id;
        _keyboardActive = true;
      });
    });
    return node;
  });

  String? _initialActiveId() {
    final enabled = _enabledItems;
    for (final item in enabled) {
      if (_containsSelected(item)) return item.id;
    }
    return enabled.isEmpty ? null : enabled.first.id;
  }

  void _setActive(String id) {
    setState(() {
      _activeId = id;
      _openSubmenuId = null;
      _keyboardActive = true;
    });
    if (widget.navigationController == null) {
      _itemFocusNodes[id]?.requestFocus();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final itemContext = _itemKeys[_activeId]?.currentContext;
      if (itemContext != null) {
        Scrollable.ensureVisible(itemContext, alignment: .5);
      }
    });
  }

  void _move(int direction) {
    final enabled = _enabledItems;
    if (enabled.isEmpty) return;
    if (!_keyboardActive &&
        widget.selectedId == null &&
        widget.selectedIds.isEmpty) {
      _setActive(direction > 0 ? enabled.first.id : enabled.last.id);
      return;
    }
    final current = enabled.indexWhere((item) => item.id == _activeId);
    final next = (current + direction + enabled.length) % enabled.length;
    _setActive(enabled[next].id);
  }

  void _openSubmenu(String id) {
    setState(() {
      _activeId = id;
      _openSubmenuId = id;
      _keyboardActive = true;
    });
  }

  void _closeSubmenu() {
    setState(() => _openSubmenuId = null);
    (_itemFocusNodes[_activeId] ?? _focusNode).requestFocus();
  }

  void _activate(HyperMenuItem item) {
    if (item.children.isNotEmpty) {
      _openSubmenu(item.id);
    } else {
      widget.onSelected?.call(item.id);
    }
  }

  KeyEventResult _forwardKey(KeyEvent event) => _onKeyEvent(_focusNode, event);

  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.arrowDown) {
      _move(1);
    } else if (key == LogicalKeyboardKey.arrowUp) {
      _move(-1);
    } else if (key == LogicalKeyboardKey.home) {
      final enabled = _enabledItems;
      if (enabled.isNotEmpty) _setActive(enabled.first.id);
    } else if (key == LogicalKeyboardKey.end) {
      final enabled = _enabledItems;
      if (enabled.isNotEmpty) _setActive(enabled.last.id);
    } else if (key == LogicalKeyboardKey.arrowRight) {
      final item = _enabledItems
          .where((item) => item.id == _activeId)
          .firstOrNull;
      if (item == null || item.children.isEmpty) return KeyEventResult.ignored;
      _openSubmenu(item.id);
    } else if (key == LogicalKeyboardKey.arrowLeft) {
      if (widget._onBack == null) return KeyEventResult.ignored;
      widget._onBack!();
    } else if (key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.space) {
      final item = _enabledItems
          .where((item) => item.id == _activeId)
          .firstOrNull;
      if (item != null) _activate(item);
    } else {
      return KeyEventResult.ignored;
    }
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final metrics = HyperTheme.sizesOf(context).menu;
    final style = HyperMenuStyle(
      width: metrics.width,
      itemHeight: metrics.itemHeight,
      itemVerticalPadding: metrics.itemVerticalPadding ?? metrics.padding / 2,
      padding: metrics.padding,
      surfacePadding: metrics.padding,
      groupSpacing: metrics.groupSpacing,
      itemSpacing:
          metrics.itemSpacing ??
          HyperTheme.sizesOf(context).navigationItemSpacing,
      itemRadius: metrics.itemRadius,
      surfaceRadius: metrics.surfaceRadius,
      iconSize: metrics.iconSize,
      iconSpacing: metrics.iconSpacing,
      foregroundColor: theme.colors.textPrimary,
      disabledColor: theme.colors.disabled,
      selectedBackgroundColor: theme.colors.primary.withValues(alpha: .08),
      activeBackgroundColor: theme.colors.stateLayer.withValues(alpha: .06),
      itemTextStyle: theme.textTheme.titleMedium?.copyWith(
        fontSize: theme.typography.listTitle,
        height: theme.typography.listTitleLineHeight,
      ),
      descriptionGap: metrics.descriptionGap,
      descriptionStyle: theme.textTheme.bodySmall?.copyWith(
        color: theme.colors.textSecondary,
      ),
      groupTitleStyle: theme.textTheme.labelMedium?.copyWith(
        color: theme.colors.textSecondary,
      ),
    ).merge(HyperMenuTheme.of(context).style).merge(widget.style);
    final surfaceStyle = resolveHyperMenuSurface(
      context,
      radius: style.surfaceRadius!,
      padding: EdgeInsets.all(style.surfacePadding!),
      style: style.surfaceStyle,
    );
    final viewport = MediaQuery.sizeOf(context);
    final content = ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: style.maxHeight ?? viewport.height,
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final (index, group) in _groups.indexed) ...[
              if (index > 0) ...[
                SizedBox(height: style.groupSpacing! / 2),
                Divider(height: 1, color: theme.colors.outline),
                SizedBox(height: style.groupSpacing! / 2),
              ],
              if (group.title != null)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: style.padding!,
                    vertical: style.groupSpacing! / 2,
                  ),
                  child: Text(group.title!, style: style.groupTitleStyle),
                ),
              for (final (itemIndex, item) in group.items.indexed) ...[
                if (itemIndex > 0) SizedBox(height: style.itemSpacing!),
                _buildItem(context, item, style),
              ],
            ],
          ],
        ),
      ),
    );
    return Focus(
      focusNode: _focusNode,
      autofocus: widget.requestFocusOnOpen,
      onKeyEvent: _onKeyEvent,
      child: widget.showSurface
          ? HyperCard(
              width: style.width!.clamp(0.0, viewport.width),
              style: surfaceStyle,
              child: content,
            )
          : SizedBox(
              width: style.width!.clamp(0.0, viewport.width),
              child: content,
            ),
    );
  }

  Widget _buildItem(
    BuildContext context,
    HyperMenuItem item,
    HyperMenuStyle style,
  ) {
    final selected =
        widget.selectedId == item.id || widget.selectedIds.contains(item.id);
    final active = item.enabled && _keyboardActive && _activeId == item.id;
    final foreground = !item.enabled
        ? style.disabledColor!
        : selected
        ? style.selectedForegroundColor ?? style.foregroundColor!
        : style.foregroundColor!;
    final row = KeyedSubtree(
      key: _itemKeys.putIfAbsent(item.id, GlobalKey.new),
      child: HyperPressable(
        enabled: item.enabled,
        focusNode: _focusNodeFor(item.id),
        semanticLabel: [
          item.label,
          if (item.description != null) item.description!,
        ].join('，'),
        onEnter: item.enabled
            ? (_) => setState(() {
                _activeId = item.id;
                _keyboardActive = false;
                _openSubmenuId = item.children.isEmpty ? null : item.id;
              })
            : null,
        onTap: item.children.isEmpty
            ? () => widget.onSelected?.call(item.id)
            : () => _openSubmenu(item.id),
        builder: (context, states, _) => Semantics(
          selected: selected,
          enabled: item.enabled,
          child: AnimatedContainer(
            key: ValueKey('hyper-menu-item-${item.id}'),
            duration: states.contains(HyperControlState.pressed)
                ? Duration.zero
                : HyperTheme.of(context).motion.durationFor(
                    HyperMotionSpeed.fast,
                    disableAnimations:
                        MediaQuery.maybeOf(context)?.disableAnimations ?? false,
                  ),
            constraints: BoxConstraints(minHeight: style.itemHeight!),
            decoration: BoxDecoration(
              color: selected
                  ? style.selectedBackgroundColor
                  : active ||
                        states.contains(HyperControlState.hovered) ||
                        states.contains(HyperControlState.pressed)
                  ? style.activeBackgroundColor
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(style.itemRadius!),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: style.padding!,
              vertical: style.itemVerticalPadding!,
            ),
            child: Row(
              children: [
                if (selected &&
                    (style.showCheckmark ?? true) &&
                    style.checkPlacement ==
                        HyperMenuCheckPlacement.leading) ...[
                  Icon(
                    style.checkIcon ?? Icons.check,
                    size: style.checkSize ?? style.iconSize,
                    color: style.checkColor ?? foreground,
                  ),
                  SizedBox(width: style.checkSpacing ?? style.iconSpacing),
                ],
                if (item.leading != null) ...[
                  IconTheme(
                    data: IconThemeData(
                      size: style.iconSize,
                      color: foreground,
                    ),
                    child: item.leading!,
                  ),
                  SizedBox(width: style.iconSpacing),
                ],
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: style.itemTextStyle!.copyWith(color: foreground),
                      ),
                      if (item.description != null) ...[
                        SizedBox(height: style.descriptionGap),
                        Text(
                          item.description!,
                          style: style.descriptionStyle!.copyWith(
                            color: item.enabled
                                ? style.descriptionStyle!.color
                                : style.disabledColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (item.trailing != null) ...[
                  SizedBox(width: style.iconSpacing),
                  item.trailing!,
                ],
                if (selected &&
                    (style.showCheckmark ?? true) &&
                    style.checkPlacement !=
                        HyperMenuCheckPlacement.leading) ...[
                  SizedBox(width: style.checkSpacing ?? style.iconSpacing),
                  Icon(
                    style.checkIcon ?? Icons.check,
                    size: style.checkSize ?? style.iconSize,
                    color: style.checkColor ?? foreground,
                  ),
                ],
                if (item.children.isNotEmpty) ...[
                  SizedBox(width: style.iconSpacing),
                  Icon(
                    Directionality.of(context) == TextDirection.ltr
                        ? Icons.chevron_right
                        : Icons.chevron_left,
                    size: style.iconSize,
                    color: foreground,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
    if (!item.enabled || item.children.isEmpty) return row;
    return HyperAnchoredOverlay(
      trigger: HyperOverlayTrigger.manual,
      placement: HyperOverlayPlacement.sideEnd,
      isOpen: _openSubmenuId == item.id,
      onOpenChanged: (open) {
        if (!mounted) return;
        if (open) {
          _openSubmenu(item.id);
        } else {
          _closeSubmenu();
        }
      },
      transitionBuilder: style.submenuTransitionBuilder,
      anchor: row,
      overlayBuilder: (context, close) => HyperMenu._submenu(
        _closeSubmenu,
        _keyboardActive,
        items: item.children,
        selectedId: widget.selectedId,
        onSelected: (id) {
          close();
          widget.onSelected?.call(id);
        },
        style: widget.style,
      ),
    );
  }
}
