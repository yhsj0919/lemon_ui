import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../foundation/hyper_control_state.dart';
import '../../interaction/hyper_pressable.dart';
import '../../theme/core/hyper_theme.dart';
import '../../theme/motion/hyper_motion_theme.dart';
import '../card/hyper_card.dart';
import '../card/hyper_card_style.dart';
import '../card/hyper_card_theme.dart';
import '../list_tile/hyper_list_tile.dart';
import '../list_tile/hyper_list_tile_style.dart';
import '../overlay/hyper_anchored_overlay.dart';
import '../overlay/hyper_overlay_material.dart';
import '../tooltip/hyper_tooltip.dart';
import '../../theme/material/hyper_material_theme.dart';
import 'hyper_sidebar_model.dart';
import 'hyper_sidebar_style.dart';
import 'hyper_sidebar_theme.dart';

Widget _defaultWidthTransition(
  BuildContext context,
  double width,
  Widget child,
) => SizedBox(width: width, child: child);

Widget _defaultContentTransition(
  BuildContext context,
  double visibility,
  Widget child,
) => Opacity(opacity: visibility, child: child);

Widget _defaultChildrenTransition(
  BuildContext context,
  Animation<double> animation,
  Widget child,
) => ClipRect(
  child: SizeTransition(
    sizeFactor: animation,
    alignment: AlignmentDirectional.topStart,
    child: FadeTransition(opacity: animation, child: child),
  ),
);

/// 带分组与树形子项的侧栏菜单。头尾固定，中间菜单独立滚动。
class HyperSidebar extends StatefulWidget {
  const HyperSidebar({
    super.key,
    this.items = const [],
    this.groups = const [],
    this.selectedId,
    this.onSelected,
    this.expandedIds,
    this.onExpandedIdsChanged,
    this.collapsed = false,
    this.selectParentWhenChildSelected = false,
    this.header,
    this.footer,
    this.style,
  });

  final List<HyperSidebarItem> items;
  final List<HyperSidebarGroup> groups;
  final String? selectedId;
  final ValueChanged<String>? onSelected;

  /// 非 null 时展开状态由外部控制。
  final Set<String>? expandedIds;
  final ValueChanged<Set<String>>? onExpandedIdsChanged;
  final bool collapsed;
  final bool selectParentWhenChildSelected;
  final Widget? header;
  final Widget? footer;
  final HyperSidebarStyle? style;

  @override
  State<HyperSidebar> createState() => _HyperSidebarState();
}

class _HyperSidebarState extends State<HyperSidebar> {
  final Set<String> _internalExpanded = {};

  List<HyperSidebarGroup> get _groups => [
    if (widget.items.isNotEmpty) HyperSidebarGroup(items: widget.items),
    ...widget.groups,
  ];

  Set<String> get _expanded => widget.expandedIds ?? _internalExpanded;

  @override
  void initState() {
    super.initState();
    _expandSelectedBranch();
  }

  @override
  void didUpdateWidget(HyperSidebar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedId != widget.selectedId ||
        oldWidget.items != widget.items ||
        oldWidget.groups != widget.groups) {
      _expandSelectedBranch();
    }
  }

  void _expandSelectedBranch() {
    if (widget.expandedIds != null || widget.selectedId == null) return;
    for (final group in _groups) {
      for (final item in group.items) {
        _expandAncestors(item);
      }
    }
  }

  bool _expandAncestors(HyperSidebarItem item) {
    if (item.id == widget.selectedId) return true;
    final containsSelected = item.children.any(_expandAncestors);
    if (containsSelected) _internalExpanded.add(item.id);
    return containsSelected;
  }

  bool _containsSelected(HyperSidebarItem item) => item.children.any(
    (child) => child.id == widget.selectedId || _containsSelected(child),
  );

  void _toggleExpanded(String id) {
    final next = {..._expanded};
    if (!next.remove(id)) {
      next.add(id);
    }
    if (widget.expandedIds == null) {
      setState(
        () => _internalExpanded
          ..clear()
          ..addAll(next),
      );
    }
    widget.onExpandedIdsChanged?.call(Set.unmodifiable(next));
  }

  void _activate(HyperSidebarItem item, VoidCallback? closePopup) {
    if (!item.enabled) return;
    if (item.children.isNotEmpty) {
      _toggleExpanded(item.id);
      if (!item.selectableParent) return;
    }
    closePopup?.call();
    widget.onSelected?.call(item.id);
  }

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final metrics = HyperTheme.sizesOf(context).sidebar;
    final themedStyle = HyperSidebarTheme.of(context).style;
    final selectionStyle =
        widget.style?.selectionStyle ??
        themedStyle?.selectionStyle ??
        HyperSidebarSelectionStyle.text;
    final resolved = HyperSidebarStyle(
      width: metrics.width,
      collapsedWidth: metrics.collapsedWidth,
      itemHeight: metrics.itemHeight,
      iconSize: metrics.iconSize,
      itemSpacing: metrics.itemSpacing,
      rowGap: metrics.rowGap,
      indent: metrics.indent,
      sectionSpacing: metrics.sectionSpacing,
      horizontalPadding: metrics.horizontalPadding,
      popupWidth: metrics.popupWidth,
      itemRadius: metrics.itemRadius,
      backgroundColor: theme.colors.surface,
      borderColor: theme.colors.outline.withValues(alpha: .55),
      foregroundColor: theme.colors.textPrimary,
      selectedForegroundColor: selectionStyle == HyperSidebarSelectionStyle.fill
          ? theme.colors.onPrimary
          : theme.colors.primary,
      selectedBackgroundColor: selectionStyle == HyperSidebarSelectionStyle.fill
          ? theme.colors.primary
          : theme.colors.primary.withValues(alpha: .08),
      ancestorSelectedForegroundColor: theme.colors.primary,
      ancestorSelectedBackgroundColor: theme.colors.primary.withValues(
        alpha: .05,
      ),
      disabledColor: theme.colors.disabled,
      groupTitleStyle: theme.textTheme.labelMedium?.copyWith(
        color: theme.colors.textSecondary,
      ),
      itemTextStyle: theme.textTheme.titleMedium?.copyWith(
        fontSize: theme.typography.listTitle,
        height: theme.typography.listTitleLineHeight,
      ),
      descriptionTextStyle: theme.textTheme.bodySmall?.copyWith(
        fontSize: theme.typography.listSubtitle,
        height: theme.typography.listSubtitleLineHeight,
      ),
      selectionStyle: selectionStyle,
    ).merge(themedStyle).merge(widget.style);
    final duration = theme.motion.durationFor(
      HyperMotionSpeed.standard,
      disableAnimations:
          MediaQuery.maybeOf(context)?.disableAnimations ?? false,
    );
    final targetWidth = widget.collapsed
        ? resolved.collapsedWidth!
        : resolved.width!;
    return TweenAnimationBuilder<double>(
      duration: duration,
      curve: theme.motion.standardCurve,
      tween: Tween(end: targetWidth),
      builder: (context, width, _) {
        final midpoint = (resolved.width! + resolved.collapsedWidth!) / 2;
        final halfRange =
            (resolved.width! - resolved.collapsedWidth!).abs() / 2;
        // 在内容切换点淡出，避免展开文字被窄容器挤压时突然跳变。
        final compact = width < midpoint;
        final contentOpacity = halfRange == 0
            ? 1.0
            : ((width - midpoint).abs() / halfRange).clamp(0.0, 1.0);
        return (resolved.widthTransitionBuilder ?? _defaultWidthTransition)(
          context,
          width,
          DecoratedBox(
            decoration: BoxDecoration(
              color: resolved.backgroundColor,
              border: BorderDirectional(
                end: BorderSide(color: resolved.borderColor!),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (widget.header != null) widget.header!,
                Expanded(
                  child:
                      (resolved.contentTransitionBuilder ??
                      _defaultContentTransition)(
                        context,
                        contentOpacity,
                        ListView(
                          padding: EdgeInsets.symmetric(
                            horizontal: resolved.horizontalPadding!,
                          ),
                          children: [
                            for (final (index, group) in _groups.indexed) ...[
                              if (index > 0)
                                SizedBox(height: resolved.sectionSpacing),
                              if (compact && index > 0)
                                Divider(color: theme.colors.outline),
                              if (!compact && group.title != null)
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                    resolved.itemSpacing!,
                                    resolved.sectionSpacing! / 2,
                                    0,
                                    resolved.sectionSpacing! / 2,
                                  ),
                                  child: Text(
                                    group.title!,
                                    style: resolved.groupTitleStyle,
                                  ),
                                ),
                              for (final item in group.items)
                                _buildNode(
                                  context,
                                  item,
                                  resolved,
                                  compact,
                                  0,
                                  true,
                                ),
                            ],
                          ],
                        ),
                      ),
                ),
                if (widget.footer != null) widget.footer!,
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNode(
    BuildContext context,
    HyperSidebarItem item,
    HyperSidebarStyle style,
    bool compact,
    int depth,
    bool parentEnabled, [
    VoidCallback? closePopup,
  ]) {
    final enabled = parentEnabled && item.enabled;
    final hasChildren = item.children.isNotEmpty;
    final ancestorSelected = _containsSelected(item);
    final exactSelected = item.id == widget.selectedId;
    final selected =
        exactSelected ||
        (widget.selectParentWhenChildSelected && ancestorSelected);
    final expanded = _expanded.contains(item.id);
    final itemState = HyperSidebarItemState(
      selected: selected,
      ancestorSelected: ancestorSelected,
      expanded: expanded,
      collapsed: compact,
      enabled: enabled,
    );
    final theme = HyperTheme.of(context);
    final listMetrics = HyperTheme.sizesOf(context).listTile;
    final expandDuration = theme.motion.durationFor(
      HyperMotionSpeed.fast,
      disableAnimations:
          MediaQuery.maybeOf(context)?.disableAnimations ?? false,
    );
    final foreground = !enabled
        ? style.disabledColor!
        : exactSelected
        ? style.selectedForegroundColor!
        : selected
        ? style.ancestorSelectedForegroundColor!
        : style.foregroundColor!;
    final background = exactSelected
        ? style.selectedBackgroundColor!
        : selected
        ? style.ancestorSelectedBackgroundColor!
        : Colors.transparent;

    final row = HyperPressable(
      enabled: enabled,
      onTap: compact && hasChildren && !item.selectableParent
          ? null
          : () => _activate(item, closePopup),
      semanticLabel: item.label,
      builder: (context, states, child) {
        final hovering =
            states.contains(HyperControlState.hovered) ||
            states.contains(HyperControlState.focused);
        final pressed = states.contains(HyperControlState.pressed);
        return Semantics(
          selected: selected,
          expanded: hasChildren ? expanded : null,
          child: Center(
            child: AnimatedContainer(
              key: ValueKey('hyper-sidebar-item-${item.id}'),
              duration: theme.motion.durationFor(
                HyperMotionSpeed.fast,
                disableAnimations:
                    MediaQuery.maybeOf(context)?.disableAnimations ?? false,
              ),
              width: compact ? style.itemHeight : null,
              constraints: BoxConstraints(minHeight: style.itemHeight!),
              decoration: BoxDecoration(
                color: selected
                    ? background
                    : pressed || hovering
                    ? theme.colors.stateLayer.withValues(
                        alpha: pressed ? .10 : .06,
                      )
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(style.itemRadius!),
              ),
              padding: EdgeInsets.zero,
              child: IconTheme(
                data: IconThemeData(color: foreground, size: style.iconSize),
                child: DefaultTextStyle.merge(
                  style: style.itemTextStyle!.copyWith(color: foreground),
                  child: compact
                      ? Center(
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                            children: [
                              item.icon ??
                                  Text(
                                    item.label.isEmpty
                                        ? ''
                                        : item.label.characters.first,
                                  ),
                              if (item.badge != null)
                                PositionedDirectional(
                                  top: 0,
                                  end: 0,
                                  child: item.badge!,
                                ),
                            ],
                          ),
                        )
                      : HyperListTile(
                          title: Text(
                            item.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: item.description == null
                              ? null
                              : Text(
                                  item.description!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                          leading: item.icon,
                          trailing: item.badge == null && !hasChildren
                              ? null
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (item.badge != null) item.badge!,
                                    if (hasChildren) ...[
                                      if (item.badge != null)
                                        SizedBox(width: style.itemSpacing),
                                      AnimatedRotation(
                                        turns: expanded ? .25 : 0,
                                        duration: expandDuration,
                                        curve: theme.motion.fastCurve,
                                        child: const Icon(Icons.chevron_right),
                                      ),
                                    ],
                                  ],
                                ),
                          enabled: enabled,
                          style: HyperListTileStyle(
                            foregroundColor: foreground,
                            subtitleColor: enabled
                                ? theme.colors.textSecondary
                                : style.disabledColor,
                            trailingColor: foreground,
                            overlayColor: Colors.transparent,
                            titleStyle: style.itemTextStyle,
                            subtitleStyle: style.descriptionTextStyle,
                            padding: EdgeInsetsDirectional.symmetric(
                              horizontal: style.itemSpacing!,
                            ),
                            minHeight: item.description == null
                                ? style.itemHeight
                                : math.max(
                                    style.itemHeight!,
                                    listMetrics.subtitleMinHeight,
                                  ),
                            leadingSize: style.iconSize,
                            leadingSpacing: style.itemSpacing,
                            trailingSpacing: style.itemSpacing,
                            trailingIconSize: style.iconSize,
                          ),
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );

    Widget built = item.builder?.call(context, itemState, row) ?? row;
    if (compact && !hasChildren && enabled) {
      built = HyperTooltip(message: item.label, child: built);
    }
    if (compact && hasChildren && enabled) {
      built = HyperAnchoredOverlay(
        trigger: HyperOverlayTrigger.hover,
        placement: HyperOverlayPlacement.sideEnd,
        transitionBuilder: style.popupTransitionBuilder,
        anchor: built,
        overlayBuilder: (overlayContext, close) {
          final cardStyle = HyperCardTheme.of(overlayContext).style;
          final defaultMaterial = HyperOverlayMaterial.fallback(
            overlayContext,
            componentMaterial: cardStyle?.material,
            instanceMaterial: style.popupCardStyle?.material,
            hasExplicitBackground:
                cardStyle?.background != null ||
                style.popupCardStyle?.background != null,
          );
          final hasMaterial =
              HyperMaterialTheme.of(overlayContext).material != null ||
              cardStyle?.material != null ||
              style.popupCardStyle?.material != null ||
              defaultMaterial != null;
          // 使用方的 Card 主题或完整材质配方优先；普通表面补默认浮层阴影。
          final defaultPopupStyle = HyperCardStyle(
            material: defaultMaterial,
            boxShadow: hasMaterial || cardStyle?.boxShadow != null
                ? null
                : [
                    BoxShadow(
                      color: HyperTheme.of(overlayContext).colors.scrim
                          .withValues(alpha: .16),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
          );
          final popupStyle = defaultPopupStyle.merge(style.popupCardStyle);
          return HyperCard(
            width: style.popupWidth,
            style: popupStyle,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(overlayContext).height,
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(style.horizontalPadding!),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                        style.itemSpacing!,
                        style.rowGap!,
                        style.itemSpacing!,
                        style.sectionSpacing! / 2,
                      ),
                      child: Text(item.label, style: style.groupTitleStyle),
                    ),
                    for (final child in item.children)
                      _buildNode(
                        overlayContext,
                        child,
                        style,
                        false,
                        0,
                        enabled,
                        close,
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: compact ? 0 : depth * style.indent!,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 行距属于当前菜单行，父项与展开的第一个子项也需要保留它。
          Padding(
            padding: EdgeInsetsDirectional.only(bottom: style.rowGap!),
            child: built,
          ),
          if (!compact && hasChildren)
            AnimatedSwitcher(
              duration: expandDuration,
              switchInCurve: theme.motion.fastCurve,
              switchOutCurve: theme.motion.fastCurve,
              layoutBuilder: (currentChild, previousChildren) => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [...previousChildren, ?currentChild],
              ),
              transitionBuilder: (child, animation) =>
                  (style.childrenTransitionBuilder ??
                  _defaultChildrenTransition)(context, animation, child),
              child: expanded
                  ? Column(
                      key: ValueKey('hyper-sidebar-children-${item.id}'),
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (final child in item.children)
                          _buildNode(
                            context,
                            child,
                            style,
                            false,
                            depth + 1,
                            enabled,
                            closePopup,
                          ),
                      ],
                    )
                  : SizedBox.shrink(
                      key: ValueKey('hyper-sidebar-closed-${item.id}'),
                    ),
            ),
        ],
      ),
    );
  }
}
