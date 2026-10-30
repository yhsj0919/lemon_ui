import '../../foundation/hyper_icons.dart';
import '../../painting/hyper_box_decoration.dart';

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../foundation/hyper_fill.dart';
import '../../foundation/hyper_control_state.dart';
import '../../interaction/hyper_pressable.dart';
import '../../theme/core/hyper_theme.dart';
import '../../theme/material/hyper_material_theme.dart';
import '../surface/hyper_material_surface.dart';
import '../progress/hyper_circular_progress.dart';
import '../button/hyper_button.dart';
import 'hyper_tree_model.dart';
import 'hyper_tree_view_style.dart';
import 'hyper_tree_view_theme.dart';

typedef HyperTreeItemBuilder<T> = Widget Function(
  BuildContext context,
  HyperTreeEntry<T> entry,
  Widget defaultItem,
);
typedef HyperTreeErrorBuilder<T> = Widget Function(
  BuildContext context,
  HyperTreeNode<T> node,
  Object error,
  VoidCallback retry,
);

/// 通用树内容，不承担页面导航或网络协议。无控制器时管理自身展开和选择。
class HyperTreeView<T> extends StatefulWidget {
  const HyperTreeView({
    super.key,
    this.nodes = const [],
    this.loadChildren,
    this.controller,
    this.onNodeTap,
    this.onSelectionChanged,
    this.onExpandedChanged,
    this.itemBuilder,
    this.errorBuilder,
    this.empty,
    this.style,
    this.separateExpansion = false,
    this.selectOnTap = true,
    this.showSurface = true,
  }) : assert(
         controller == null || (nodes.length == 0 && loadChildren == null),
       );
  final List<HyperTreeNode<T>> nodes;
  final HyperTreeChildrenLoader<T>? loadChildren;
  final HyperTreeController<T>? controller;
  final ValueChanged<HyperTreeNode<T>>? onNodeTap, onSelectionChanged;
  final void Function(HyperTreeNode<T> node, bool expanded)? onExpandedChanged;
  final HyperTreeItemBuilder<T>? itemBuilder;
  final HyperTreeErrorBuilder<T>? errorBuilder;
  final Widget? empty;
  final HyperTreeViewStyle? style;

  /// Whether branches have a distinct expand control, separate from selection.
  ///
  /// Nonselectable branches still expand when their label is activated.
  final bool separateExpansion;

  /// Whether row activation updates the controller's selected node.
  ///
  /// Set false when selection is managed by the host, while keeping row tap
  /// callbacks and expansion behavior available.
  final bool selectOnTap;

  /// Whether to paint the outer surface; embedded trees use their host surface.
  final bool showSurface;
  @override
  State<HyperTreeView<T>> createState() => _TreeState<T>();
}

class _TreeState<T> extends State<HyperTreeView<T>> {
  late HyperTreeController<T> _controller;
  final _focus = <Object, FocusNode>{};
  void _attach() {
    _controller =
        widget.controller ??
        HyperTreeController<T>(
          nodes: widget.nodes,
          loadChildren: widget.loadChildren,
        );
    _controller.addListener(_changed);
    final attached = _controller;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !identical(_controller, attached)) {
        return;
      }
      for (final id in attached.expandedIds) {
        attached.ensureLoaded(id);
      }
    });
  }

  void _detach(HyperTreeController<T>? external) {
    _controller.removeListener(_changed);
    if (external == null) {
      _controller.dispose();
    }
  }

  void _changed() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _attach();
  }

  @override
  void didUpdateWidget(covariant HyperTreeView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller ||
        (widget.controller == null &&
            oldWidget.loadChildren != widget.loadChildren)) {
      _detach(oldWidget.controller);
      _attach();
    } else if (widget.controller == null &&
        !identical(oldWidget.nodes, widget.nodes)) {
      _controller.replaceNodes(widget.nodes);
    }
  }

  @override
  void dispose() {
    _detach(widget.controller);
    for (final node in _focus.values) {
      node.dispose();
    }
    super.dispose();
  }

  void _expand(HyperTreeNode<T> node, bool expanded) {
    _controller.setExpanded(node.id, expanded);
    widget.onExpandedChanged?.call(node, expanded);
  }

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final sizes = HyperTheme.sizesOf(context);
    final size = sizes.treeView;
    final material = HyperMaterialTheme.of(context);
    final s = HyperTreeViewStyle(
      background: const HyperFill.none(),
      material: material.material,
      materialQuality: material.quality,
      reduceTransparency: material.reduceTransparency,
      borderRadius: BorderRadius.zero,
      padding: EdgeInsets.zero,
      rowBackground: const HyperFill.none(),
      selectedBackground: HyperFill.color(
        theme.colors.primary.withValues(alpha: .08),
      ),
      hoverBackground: HyperFill.color(theme.colors.surfaceMuted),
      pressedBackground: HyperFill.color(theme.colors.surfaceMuted),
      foregroundColor: theme.colors.textPrimary,
      selectedForegroundColor: theme.colors.primary,
      disabledColor: theme.colors.textTertiary,
      focusColor: theme.colors.primary,
      errorColor: theme.colors.error,
      textStyle: theme.textTheme.bodyMedium,
      rowHeight: size.rowHeight,
      rowSpacing: size.rowSpacing ?? sizes.navigationItemSpacing,
      indent: size.indent,
      iconSize: size.iconSize,
      contentSpacing: size.contentSpacing,
      rowPadding: size.rowPadding,
      rowRadius: BorderRadius.circular(size.rowRadius),
      expandIcon: HyperIcons.chevronRight,
      errorIcon: HyperIcons.circleAlert,
      loadingLabel: '加载中',
      retryLabel: '加载失败，点击重试',
      emptyLabel: '暂无节点',
      duration: theme.motion.fastDuration,
      curve: theme.motion.fastCurve,
    ).merge(HyperTreeViewTheme.of(context).style).merge(widget.style);
    final duration = (MediaQuery.maybeOf(context)?.disableAnimations ?? false)
        ? Duration.zero
        : s.duration!;
    final entries = _controller.visibleEntries;
    final readingDirection = Directionality.of(context);
    Widget row(HyperTreeEntry<T> entry) {
      final node = entry.node;
      final selected = _controller.selectedId == node.id;
      final expanded = _controller.isExpanded(node.id);
      final branch = _controller.canExpand(node.id);
      final focusedNode = _focus.putIfAbsent(node.id, () => FocusNode());
      void activate() {
        if (!node.enabled) {
          return;
        }
        if (widget.selectOnTap) {
          final before = _controller.selectedId;
          _controller.select(node.id);
          if (before != _controller.selectedId) {
            widget.onSelectionChanged?.call(node);
          }
        }
        if (branch && (!widget.separateExpansion || !node.selectable)) {
          _expand(node, !expanded);
        }
        widget.onNodeTap?.call(node);
      }

      KeyEventResult key(KeyEvent event) {
        if (event is! KeyDownEvent || !node.enabled) {
          return KeyEventResult.ignored;
        }
        final right = readingDirection == TextDirection.ltr
            ? LogicalKeyboardKey.arrowRight
            : LogicalKeyboardKey.arrowLeft;
        final left = readingDirection == TextDirection.ltr
            ? LogicalKeyboardKey.arrowLeft
            : LogicalKeyboardKey.arrowRight;
        final eligible = entries.where((e) => e.node.enabled).toList();
        final position = eligible.indexWhere((e) => e.node.id == node.id);
        Object? target;
        if (event.logicalKey == LogicalKeyboardKey.arrowDown &&
            position < eligible.length - 1) {
          target = eligible[position + 1].node.id;
        } else if (event.logicalKey == LogicalKeyboardKey.arrowUp &&
            position > 0) {
          target = eligible[position - 1].node.id;
        } else if (event.logicalKey == LogicalKeyboardKey.home &&
            eligible.isNotEmpty) {
          target = eligible.first.node.id;
        } else if (event.logicalKey == LogicalKeyboardKey.end &&
            eligible.isNotEmpty) {
          target = eligible.last.node.id;
        } else if (event.logicalKey == right && branch) {
          if (!expanded) {
            _expand(node, true);
          } else if (_controller.childrenOf(node.id).isNotEmpty) {
            target = _controller
                .childrenOf(node.id)
                .firstWhere((n) => n.enabled, orElse: () => node)
                .id;
          }
          if (target == null) {
            return KeyEventResult.handled;
          }
        } else if (event.logicalKey == left) {
          if (expanded) {
            _expand(node, false);
            return KeyEventResult.handled;
          }
          target = entry.parentId;
        } else {
          return KeyEventResult.ignored;
        }
        _focus[target]?.requestFocus();
        return KeyEventResult.handled;
      }

      final expandIcon = ExcludeSemantics(
        child: AnimatedRotation(
          turns: expanded
              ? (readingDirection == TextDirection.rtl ? -.25 : .25)
              : 0,
          duration: duration,
          curve: s.curve!,
          child: Icon(s.expandIcon, textDirection: readingDirection),
        ),
      );
      final expandSize = widget.separateExpansion
          ? math.max(s.iconSize!, s.rowHeight!)
          : s.iconSize!;
      Widget content = Semantics(
        selected: selected,
        expanded: branch ? expanded : null,
        enabled: node.enabled,
        child: Focus(
          onKeyEvent: (_, event) => key(event),
          canRequestFocus: false,
          child: HyperPressable(
            enabled: node.enabled,
            focusNode: focusedNode,
            onTap: activate,
            builder: (context, states, child) {
              final fill = states.contains(HyperControlState.pressed)
                  ? s.pressedBackground!
                  : selected
                  ? s.selectedBackground!
                  : states.contains(HyperControlState.hovered)
                  ? s.hoverBackground!
                  : s.rowBackground!;
              final foreground = !node.enabled
                  ? s.disabledColor!
                  : selected
                  ? s.selectedForegroundColor!
                  : s.foregroundColor!;
              return AnimatedContainer(
                duration: duration,
                curve: s.curve!,
                constraints: BoxConstraints(minHeight: s.rowHeight!),
                padding: s.rowPadding,
                decoration: HyperBoxDecoration(
                  color: fill.color,
                  gradient: fill.gradient,
                  borderRadius: s.rowRadius,
                ),
                foregroundDecoration: HyperBoxDecoration(
                  borderRadius: s.rowRadius,
                  border: states.contains(HyperControlState.focused)
                      ? Border.all(color: s.focusColor!)
                      : null,
                ),
                child: AnimatedDefaultTextStyle(
                  duration: duration,
                  curve: s.curve!,
                  style: s.textStyle!.copyWith(color: foreground),
                  child: IconTheme(
                    data: IconThemeData(color: foreground, size: s.iconSize),
                    child: Row(
                      children: [
                        SizedBox.square(
                          dimension: expandSize,
                          child: branch
                              ? widget.separateExpansion
                                    ? HyperPressable(
                                        enabled: node.enabled,
                                        semanticButton: true,
                                        semanticLabel: expanded
                                            ? '收起子节点'
                                            : '展开子节点',
                                        onTap: () => _expand(node, !expanded),
                                        builder: (context, states, _) =>
                                            DecoratedBox(
                                              decoration: HyperBoxDecoration(
                                                borderRadius: s.rowRadius,
                                                border:
                                                    states.contains(
                                                      HyperControlState.focused,
                                                    )
                                                    ? Border.all(
                                                        color: s.focusColor!,
                                                      )
                                                    : null,
                                              ),
                                              child: Center(child: expandIcon),
                                            ),
                                      )
                                    : expandIcon
                              : null,
                        ),
                        SizedBox(width: s.contentSpacing),
                        if (node.leading != null) ...[
                          node.leading!,
                          SizedBox(width: s.contentSpacing),
                        ],
                        Expanded(child: node.label),
                        if (node.trailing != null) ...[
                          SizedBox(width: s.contentSpacing),
                          node.trailing!,
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
      content = widget.itemBuilder?.call(context, entry, content) ?? content;
      return Padding(
        key: ValueKey(node.id),
        padding: EdgeInsetsDirectional.only(start: entry.depth * s.indent!),
        child: content,
      );
    }

    Widget feedback(HyperTreeEntry<T> entry) {
      final loading =
          _controller.loadState(entry.node.id) == HyperTreeLoadState.loading;
      void retry() {
        _controller.ensureLoaded(entry.node.id);
      }

      final child = loading
          ? Row(
              children: [
                HyperCircularProgress(size: s.iconSize),
                SizedBox(width: s.contentSpacing),
                Text(s.loadingLabel!),
              ],
            )
          : widget.errorBuilder?.call(
                  context,
                  entry.node,
                  _controller.errorFor(entry.node.id)!,
                  retry,
                ) ??
                HyperButton.text(
                  label: Text(s.retryLabel!),
                  icon: Icon(s.errorIcon, color: s.errorColor),
                  onPressed: retry,
                );
      return Padding(
        padding: EdgeInsetsDirectional.only(
          start: (entry.depth + 1) * s.indent!,
        ),
        child: AnimatedDefaultTextStyle(
          duration: duration,
          curve: s.curve!,
          style: s.textStyle!.copyWith(
            color: loading ? s.foregroundColor : s.errorColor,
          ),
          child: AnimatedSwitcher(
            duration: duration,
            transitionBuilder:
                s.transitionBuilder ??
                AnimatedSwitcher.defaultTransitionBuilder,
            child: KeyedSubtree(key: ValueKey(loading), child: child),
          ),
        ),
      );
    }

    Widget column(List<Widget> rows) => Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < rows.length; i++) ...[
          if (i > 0) SizedBox(height: s.rowSpacing),
          rows[i],
        ],
      ],
    );
    bool hasFeedback(HyperTreeEntry<T> entry) =>
        _controller.isExpanded(entry.node.id) &&
        (_controller.loadState(entry.node.id) == HyperTreeLoadState.loading ||
            _controller.loadState(entry.node.id) == HyperTreeLoadState.error);
    var index = 0;
    Widget level(int depth) {
      final groups = <Widget>[];
      while (index < entries.length && entries[index].depth == depth) {
        final entry = entries[index++];
        final children = <Widget>[
          if (hasFeedback(entry)) feedback(entry),
          if (index < entries.length && entries[index].depth > depth)
            level(entries[index].depth),
        ];
        groups.add(
          Column(
            key: ValueKey(entry.node.id),
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              row(entry),
              _TreeBranchTransition(
                expanded: _controller.isExpanded(entry.node.id),
                duration: duration,
                curve: s.curve!,
                child: children.isEmpty
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: EdgeInsets.only(top: s.rowSpacing!),
                        child: column(children),
                      ),
              ),
            ],
          ),
        );
      }
      return column(groups);
    }

    final customTransition = s.expansionTransitionBuilder;
    final rows = customTransition == null
        ? <Widget>[]
        : <Widget>[
            for (final entry in entries) ...[
              row(entry),
              if (_controller.isExpanded(entry.node.id) &&
                  (_controller.loadState(entry.node.id) ==
                          HyperTreeLoadState.loading ||
                      _controller.loadState(entry.node.id) ==
                          HyperTreeLoadState.error))
                feedback(entry),
            ],
          ];
    Widget body = rows.isEmpty
        ? widget.empty ??
              Text(
                s.emptyLabel!,
                style: s.textStyle!.copyWith(color: s.foregroundColor),
              )
        : column(rows);
    body = customTransition != null
        ? customTransition(context, body, duration, s.curve!)
        : entries.isEmpty
        ? body
        : level(entries.first.depth);
    final content = body;
    body = LayoutBuilder(
      builder: (context, constraints) => constraints.hasBoundedHeight
          ? SingleChildScrollView(primary: false, child: content)
          : content,
    );
    if (!widget.showSurface) return body;
    body = AnimatedContainer(
      duration: duration,
      curve: s.curve!,
      padding: s.padding,
      clipBehavior: Clip.antiAlias,
      decoration: HyperBoxDecoration(
        color: s.material == null ? s.background?.color : null,
        gradient: s.material == null ? s.background?.gradient : null,
        borderRadius: s.borderRadius,
      ),
      child: body,
    );
    if (s.material != null) {
      body = HyperMaterialSurface(
        material: s.material,
        semanticBackground: s.background,
        quality: s.materialQuality,
        reduceTransparency: s.reduceTransparency,
        borderRadius: s.borderRadius,
        child: body,
      );
    }
    return DecoratedBox(
      position: DecorationPosition.foreground,
      decoration: HyperBoxDecoration(
        border: s.border,
        borderRadius: s.borderRadius,
      ),
      child: body,
    );
  }
}

class _TreeBranchTransition extends StatefulWidget {
  const _TreeBranchTransition({
    required this.expanded,
    required this.duration,
    required this.curve,
    required this.child,
  });
  final bool expanded;
  final Duration duration;
  final Curve curve;
  final Widget child;

  @override
  State<_TreeBranchTransition> createState() => _TreeBranchTransitionState();
}

class _TreeBranchTransitionState extends State<_TreeBranchTransition>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animation = AnimationController(
    vsync: this,
    duration: widget.duration,
    value: widget.expanded ? 1 : 0,
  );
  Widget? _content;

  @override
  void initState() {
    super.initState();
    if (widget.expanded) _content = widget.child;
    _animation.addStatusListener(_statusChanged);
  }

  void _statusChanged(AnimationStatus status) {
    if (status == AnimationStatus.dismissed && !widget.expanded) {
      setState(() => _content = null);
    }
  }

  @override
  void didUpdateWidget(_TreeBranchTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    _animation.duration = widget.duration;
    if (widget.expanded) _content = widget.child;
    if (widget.duration == Duration.zero) {
      _animation.value = widget.expanded ? 1 : 0;
      if (!widget.expanded) _content = null;
    } else if (widget.expanded != oldWidget.expanded) {
      if (widget.expanded) {
        _animation.forward();
      } else {
        _animation.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ExcludeFocus(
    excluding: !widget.expanded,
    child: ExcludeSemantics(
      excluding: !widget.expanded,
      child: IgnorePointer(
        ignoring: !widget.expanded,
        child: SizeTransition(
          sizeFactor: _animation.drive(CurveTween(curve: widget.curve)),
          alignment: Alignment.topCenter,
          child: _content ?? const SizedBox.shrink(),
        ),
      ),
    ),
  );
}
