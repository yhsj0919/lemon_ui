import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../foundation/hyper_device_type.dart';
import '../../theme/color/hyper_contrast_theme.dart';
import '../../theme/core/hyper_theme.dart';
import '../../foundation/hyper_fill.dart';
import '../button/hyper_button.dart';
import '../button/hyper_button_style.dart';
import '../card/hyper_card_style.dart';
import '../select/hyper_dropdown.dart';
import '../select/hyper_select_model.dart';
import '../select/hyper_select_style.dart';
import '../select/hyper_select_theme.dart';
import '../select/hyper_selection_theme.dart';
import '../text/hyper_scrolling_text.dart';
import '../tree/hyper_tree_model.dart';
import '../tree/hyper_tree_view.dart';
import '../tree/hyper_tree_view_style.dart';
import '../tree/hyper_tree_view_theme.dart';
import 'hyper_tree_select_model.dart';
import 'hyper_tree_select_style.dart';
import 'hyper_tree_select_theme.dart';

export 'hyper_tree_select_model.dart';

/// A controlled single-value selector presented as a navigable tree.
class HyperTreeSelect<T extends Object> extends StatefulWidget {
  const HyperTreeSelect({
    super.key,
    required this.nodes,
    required this.value,
    required this.onChanged,
    this.loadChildren,
    this.enabled = true,
    this.allowClear = true,
    this.leafOnly = false,
    this.placeholder = '请选择',
    this.labelBuilder,
    this.presentation,
    this.style,
    this.surfaceStyle,
  });

  final List<HyperTreeSelectNode<T>> nodes;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final HyperTreeSelectChildrenLoader<T>? loadChildren;
  final bool enabled;
  final bool allowClear;
  final bool leafOnly;
  final String placeholder;
  final String Function(T)? labelBuilder;
  final HyperSelectPresentation? presentation;
  final HyperTreeSelectStyle? style;
  final HyperCardStyle? surfaceStyle;

  @override
  State<HyperTreeSelect<T>> createState() => _HyperTreeSelectState<T>();
}

class _HyperTreeSelectState<T extends Object>
    extends State<HyperTreeSelect<T>> {
  late HyperTreeController<HyperTreeSelectNode<T>> _controller;
  final _updates = ValueNotifier<int>(0);
  bool _open = false;
  bool _deferSelectionSync = false;
  bool get _enabled => widget.enabled && widget.onChanged != null;

  @override
  void initState() {
    super.initState();
    _createController();
    _syncSelection();
  }

  bool _isBranch(HyperTreeSelectNode<T> node) =>
      node.children.isNotEmpty || node.hasChildren;

  bool _selectable(HyperTreeSelectNode<T> node) =>
      node.selectable && (!widget.leafOnly || !_isBranch(node));

  List<HyperTreeNode<HyperTreeSelectNode<T>>> _adapt(
    List<HyperTreeSelectNode<T>> source,
  ) {
    final seen = <T>{};
    final visiting = <HyperTreeSelectNode<T>>{};
    void validate(HyperTreeSelectNode<T> node) {
      if (!visiting.add(node)) {
        throw ArgumentError('树节点不能形成循环。');
      }
      if (!seen.add(node.value)) {
        throw ArgumentError('树节点 value 必须全局唯一。');
      }
      for (final child in node.children) {
        validate(child);
      }
      visiting.remove(node);
    }

    for (final node in source) {
      validate(node);
    }
    HyperTreeNode<HyperTreeSelectNode<T>> convert(
      HyperTreeSelectNode<T> node,
    ) => HyperTreeNode<HyperTreeSelectNode<T>>(
      id: node.value,
      data: node,
      label: Text(node.label),
      children: node.children.map(convert).toList(growable: false),
      hasChildren: node.hasChildren,
      enabled: node.enabled,
      selectable: _selectable(node),
      leading: node.leading,
      trailing: node.trailing,
    );

    return source.map(convert).toList(growable: false);
  }

  void _createController() {
    final roots = _adapt(widget.nodes);
    _controller = HyperTreeController<HyperTreeSelectNode<T>>(
      nodes: roots,
      loadChildren: (node) async {
        final loader = widget.loadChildren;
        if (loader == null) throw StateError('未提供子节点加载器。');
        final children = await loader(node.data!);
        return _adapt(children);
      },
    )..addListener(_refresh);
  }

  void _refresh() {
    if (!mounted) return;
    setState(() {});
    _updates.value++;
  }

  @override
  void didUpdateWidget(covariant HyperTreeSelect<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(oldWidget.nodes, widget.nodes) ||
        oldWidget.loadChildren != widget.loadChildren ||
        oldWidget.leafOnly != widget.leafOnly) {
      _controller.dispose();
      _createController();
    }
    if (!_enabled) _open = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (!_deferSelectionSync &&
          (oldWidget.value != widget.value ||
              !listEquals(oldWidget.nodes, widget.nodes) ||
              oldWidget.loadChildren != widget.loadChildren ||
              oldWidget.leafOnly != widget.leafOnly)) {
        _syncSelection();
      }
      _updates.value++;
    });
  }

  void _syncSelection() {
    final id = widget.value;
    if (id == null) {
      _controller.select(null);
      return;
    }
    final node = _controller.nodeFor(id);
    if (node != null && node.enabled && node.selectable) {
      _controller.select(id);
    } else {
      _controller.select(null);
    }
  }

  HyperTreeSelectStyle _visual(BuildContext context) =>
      HyperTreeSelectTheme.of(context).style.merge(widget.style);

  HyperSelectStyle _selectStyle(BuildContext context) =>
      (HyperSelectTheme.of(context).style ?? const HyperSelectStyle()).merge(
        _visual(context).selectStyle,
      );

  void _openChanged(bool open) {
    if (!mounted) return;
    setState(() => _open = open && _enabled);
    if (_open) {
      _deferSelectionSync = false;
      _syncSelection();
    }
  }

  void _commit(T? value, VoidCallback close) {
    if (!_enabled) return;
    _deferSelectionSync = true;
    close();
    widget.onChanged?.call(value);
  }

  HyperButtonStyle _clearStyle(BuildContext context) => HyperButtonStyle(
    foregroundColor: HyperTheme.of(context).colors.primary,
    contrastMode: HyperContrastMode.standard,
  ).merge(_visual(context).clearButtonStyle);

  Widget _title(BuildContext context) {
    final selection = HyperSelectionTheme.of(context).style
        .merge(_selectStyle(context).selectionStyle);
    return ListenableBuilder(
      listenable: _updates,
      builder: (context, _) => Row(
        children: [
          Expanded(child: Text(widget.placeholder)),
          if (widget.allowClear)
            HyperButton.text(
              style: _clearStyle(context),
              onPressed: _enabled && widget.value != null
                  ? () => _commit(null, () => _openChanged(false))
                  : null,
              label: Text(selection.clearText ?? '清空'),
            ),
        ],
      ),
    );
  }

  Widget _panel(BuildContext context, VoidCallback close) {
    final visual = _visual(context);
    final select = _selectStyle(context);
    final sizes = HyperTheme.sizesOf(context);
    final mobile =
        sizes.deviceType == HyperDeviceType.phone ||
        sizes.deviceType == HyperDeviceType.tablet ||
        sizes.deviceType == HyperDeviceType.watch;
    final treeOverrides = HyperTreeViewTheme.of(context).style
        .merge(visual.treeStyle);
    final iconSize = treeOverrides.iconSize ?? sizes.treeView.iconSize;
    final rowHeight = treeOverrides.rowHeight ?? sizes.treeView.rowHeight;
    // The expansion hit target already supplies half of its spare width
    // between the chevron and label. Match the menu's visible icon gap.
    final expansionInset = (math.max(iconSize, rowHeight) - iconSize) / 2;
    final treeStyle = HyperTreeViewStyle(
      rowPadding: EdgeInsets.zero,
      contentSpacing: math.max(0, sizes.menu.iconSpacing - expansionInset),
      background: const HyperFill.none(),
      material: null,
      border: null,
      borderRadius: BorderRadius.zero,
      padding: EdgeInsets.zero,
    ).merge(visual.treeStyle);
    final tree = HyperTreeView<HyperTreeSelectNode<T>>(
      key: ValueKey(_controller),
      controller: _controller,
      separateExpansion: true,
      selectOnTap: false,
      showSurface: false,
      style: treeStyle,
      onNodeTap: (node) {
        final data = node.data!;
        if (_enabled &&
            node.enabled &&
            node.selectable &&
            (!widget.leafOnly || !_isBranch(data))) {
          _commit(data.value, close);
        }
      },
      empty: Center(
        child: Text(HyperSelectionTheme.of(context).style.emptyText ?? '暂无选项'),
      ),
    );

    final content = LayoutBuilder(
      builder: (context, constraints) => ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: mobile
              ? MediaQuery.sizeOf(context).height * .62
              : select.selectionStyle?.maxPanelHeight ??
                    sizes.selection.maxPanelHeight,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [tree],
          ),
        ),
      ),
    );
    final menu = select.selectionStyle?.menuStyle;
    final width = menu?.width ?? select.width ?? sizes.select.width;
    return SizedBox(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          content,
          if (widget.allowClear && !mobile)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: HyperButton.text(
                style: _clearStyle(context),
                onPressed: _enabled && widget.value != null
                    ? () => _commit(null, close)
                    : null,
                label: Text(
                  HyperSelectionTheme.of(context).style.clearText ?? '清空',
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _label() {
    final value = widget.value;
    if (value == null) return widget.placeholder;
    return _controller.nodeFor(value)?.data?.label ??
        widget.labelBuilder?.call(value) ??
        '$value';
  }

  @override
  Widget build(BuildContext context) => HyperDropdown(
    isOpen: _open,
    onOpenChanged: _openChanged,
    enabled: _enabled,
    presentation: widget.presentation,
    style: _visual(context).selectStyle,
    surfaceStyle: widget.surfaceStyle,
    modalTitle: _title(context),
    label: HyperScrollingText(_label(), trigger: HyperTextScrollTrigger.hover),
    panelBuilder: _panel,
  );

  @override
  void dispose() {
    _controller.dispose();
    _updates.dispose();
    super.dispose();
  }
}
