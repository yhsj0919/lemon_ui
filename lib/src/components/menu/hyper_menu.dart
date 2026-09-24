import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../foundation/hyper_control_state.dart';
import '../../interaction/hyper_pressable.dart';
import '../../theme/core/hyper_theme.dart';
import '../../theme/material/hyper_material_theme.dart';
import '../../theme/motion/hyper_motion_theme.dart';
import '../card/hyper_card.dart';
import '../card/hyper_card_style.dart';
import '../card/hyper_card_theme.dart';
import '../overlay/hyper_anchored_overlay.dart';
import '../overlay/hyper_overlay_material.dart';
import 'hyper_menu_model.dart';
import 'hyper_menu_style.dart';
import 'hyper_menu_theme.dart';

/// 弹出菜单内容；可放入 [HyperAnchoredOverlay] 等浮层中。
///
/// 菜单只负责内容、状态和键盘导航，锚点定位与关闭由使用方控制。
class HyperMenu extends StatefulWidget {
  const HyperMenu({
    super.key,
    this.items = const [],
    this.groups = const [],
    this.selectedId,
    this.onSelected,
    this.style,
  }) : _onBack = null,
       _requestFocusOnOpen = true;

  const HyperMenu._submenu(
    this._onBack,
    this._requestFocusOnOpen, {
    required this.items,
    required this.selectedId,
    required this.onSelected,
    required this.style,
  }) : groups = const [];

  final List<HyperMenuItem> items;
  final List<HyperMenuGroup> groups;
  final String? selectedId;
  final ValueChanged<String>? onSelected;
  final HyperMenuStyle? style;
  final VoidCallback? _onBack;
  final bool _requestFocusOnOpen;

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
    _activeId = _initialActiveId();
    if (widget._requestFocusOnOpen) _requestMenuFocus();
  }

  @override
  void didUpdateWidget(HyperMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget._requestFocusOnOpen && widget._requestFocusOnOpen) {
      _requestMenuFocus();
    }
    if (!_enabledItems.any((item) => item.id == _activeId)) {
      _activeId = _initialActiveId();
    }
  }

  void _requestMenuFocus() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget._requestFocusOnOpen) _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    for (final node in _itemFocusNodes.values) {
      node.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }

  bool _containsSelected(HyperMenuItem item) =>
      item.id == widget.selectedId || item.children.any(_containsSelected);

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
    _itemFocusNodes[id]?.requestFocus();
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
    if (!_keyboardActive && widget.selectedId == null) {
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
      padding: metrics.padding,
      surfacePadding: metrics.padding,
      groupSpacing: metrics.groupSpacing,
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
      groupTitleStyle: theme.textTheme.labelMedium?.copyWith(
        color: theme.colors.textSecondary,
      ),
    ).merge(HyperMenuTheme.of(context).style).merge(widget.style);
    final cardThemeStyle = HyperCardTheme.of(context).style;
    final defaultMaterial = HyperOverlayMaterial.fallback(
      context,
      componentMaterial: cardThemeStyle?.material,
      instanceMaterial: style.surfaceStyle?.material,
      hasExplicitBackground:
          cardThemeStyle?.background != null ||
          style.surfaceStyle?.background != null,
    );
    final hasMaterial =
        HyperMaterialTheme.of(context).material != null ||
        cardThemeStyle?.material != null ||
        style.surfaceStyle?.material != null ||
        defaultMaterial != null;
    final shadow =
        hasMaterial ||
            cardThemeStyle?.boxShadow != null ||
            style.surfaceStyle?.boxShadow != null
        ? null
        : [
            BoxShadow(
              color: theme.colors.scrim.withValues(alpha: .10),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ];
    final surfaceStyle = HyperCardStyle(
      material: defaultMaterial,
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(style.surfaceRadius!),
      border: hasMaterial
          ? null
          : Border.all(color: theme.colors.outline.withValues(alpha: .65)),
      boxShadow: shadow,
    ).merge(style.surfaceStyle);
    final viewport = MediaQuery.sizeOf(context);
    return Focus(
      focusNode: _focusNode,
      autofocus: widget._requestFocusOnOpen,
      onKeyEvent: _onKeyEvent,
      child: HyperCard(
        width: style.width!.clamp(0.0, viewport.width),
        style: surfaceStyle,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: style.maxHeight ?? viewport.height,
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(style.surfacePadding!),
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
                  for (final item in group.items)
                    _buildItem(context, item, style),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(
    BuildContext context,
    HyperMenuItem item,
    HyperMenuStyle style,
  ) {
    final selected = widget.selectedId == item.id;
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
        semanticLabel: item.label,
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
            padding: EdgeInsets.symmetric(horizontal: style.padding!),
            child: Row(
              children: [
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
                  child: Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: style.itemTextStyle!.copyWith(color: foreground),
                  ),
                ),
                if (item.trailing != null) ...[
                  SizedBox(width: style.iconSpacing),
                  item.trailing!,
                ],
                if (selected) ...[
                  SizedBox(width: style.iconSpacing),
                  Icon(Icons.check, size: style.iconSize, color: foreground),
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
