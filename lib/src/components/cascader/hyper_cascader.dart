import '../../foundation/hyper_icons.dart';

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/core/hyper_theme.dart';
import '../../theme/color/hyper_contrast_theme.dart';
import '../../foundation/hyper_device_type.dart';
import '../button/hyper_button.dart';
import '../button/hyper_button_style.dart';
import '../card/hyper_card_style.dart';
import '../menu/hyper_menu.dart';
import '../menu/hyper_menu_model.dart';
import '../menu/hyper_menu_style.dart';
import '../select/hyper_dropdown.dart';
import '../select/hyper_select_model.dart';
import '../select/hyper_select_style.dart';
import '../select/hyper_select_theme.dart';
import '../select/hyper_selection_theme.dart';
import '../text/hyper_scrolling_text.dart';
import 'hyper_cascader_model.dart';
import 'hyper_cascader_style.dart';
import 'hyper_cascader_theme.dart';
import 'hyper_cascader_wheel_panel.dart';

/// A controlled single selection represented by its complete root-to-leaf path.
///
/// Browsing and dismissal never change [value]. Only leaves commit a selection.
class HyperCascader<T> extends StatefulWidget {
  const HyperCascader({
    super.key,
    required this.nodes,
    required this.value,
    required this.onChanged,
    this.loadChildren,
    this.enabled = true,
    this.allowClear = true,
    this.placeholder = '请选择',
    this.rootLabel = '全部',
    this.backLabel = '返回上一级',
    this.pathSeparator = ' / ',
    this.labelBuilder,
    this.presentation,
    this.style,
    this.surfaceStyle,
  });

  /// The roots of an immutable tree with globally unique node values.
  final List<HyperCascaderNode<T>> nodes;

  /// The selected root-to-leaf values, or an empty list for no selection.
  final List<T> value;

  /// The callback receiving an immutable complete path or an empty list.
  ///
  /// A `null` callback disables the control.
  final ValueChanged<List<T>>? onChanged;

  /// The loader for branches marked with [HyperCascaderNode.hasChildren].
  ///
  /// Replacing this callback clears the branch cache. Use a stable method
  /// reference when retaining the same remote data source across builds.
  final HyperCascaderChildrenLoader<T>? loadChildren;

  /// Whether navigation and selection are enabled.
  final bool enabled;

  /// Whether the panel offers an action to clear the selection.
  final bool allowClear;
  final String placeholder, rootLabel, backLabel, pathSeparator;

  /// Labels for selected remote nodes before their ancestors have been loaded.
  final String Function(T)? labelBuilder;

  /// The presentation override, otherwise resolved by the real device type.
  final HyperSelectPresentation? presentation;

  /// The explicit visual overrides applied after global and local themes.
  final HyperCascaderStyle? style;

  /// The final panel surface overrides, including explicit empty shadows.
  final HyperCardStyle? surfaceStyle;

  @override
  State<HyperCascader<T>> createState() => _HyperCascaderState<T>();
}

class _HyperCascaderState<T> extends State<HyperCascader<T>> {
  late HyperCascaderController<T> _controller;
  final _updates = ValueNotifier<int>(0);
  bool _open = false;
  bool get _enabled => widget.enabled && widget.onChanged != null;

  @override
  void initState() {
    super.initState();
    _createController();
  }

  void _createController() {
    _controller = HyperCascaderController<T>(
      nodes: widget.nodes,
      loadChildren: widget.loadChildren,
    )..addListener(_refresh);
  }

  void _refresh() {
    if (!mounted) return;
    setState(() {});
    _updates.value++;
  }

  @override
  void didUpdateWidget(HyperCascader<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final changed =
        !listEquals(oldWidget.nodes, widget.nodes) ||
        oldWidget.loadChildren != widget.loadChildren;
    if (changed) {
      _controller.dispose();
      _createController();
    }
    if (!_enabled) _open = false;
    // Modal routes retain their builder. Publish every new configuration after
    // this build, including labels and clear availability, without notifying
    // descendants during an ancestor's build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_open &&
          !_usesSubmenus(context) &&
          !_usesWheels(context) &&
          (changed || !listEquals(oldWidget.value, widget.value))) {
        unawaited(_controller.browse(widget.value));
      }
      _updates.value++;
    });
  }

  HyperCascaderStyle _visual(BuildContext context) =>
      HyperCascaderTheme.of(context).style.merge(widget.style);

  HyperSelectStyle _select(BuildContext context) =>
      (HyperSelectTheme.of(context).style ?? const HyperSelectStyle()).merge(
        _visual(context).selectStyle,
      );

  bool _usesSubmenus(BuildContext context) {
    final presentation = hyperResolveSelectPresentation(
      widget.presentation ??
          _select(context).selectionStyle?.presentation ??
          HyperSelectPresentation.adaptive,
      HyperTheme.sizesOf(context).deviceType,
    );
    return presentation == HyperSelectPresentation.anchored ||
        presentation == HyperSelectPresentation.trailing;
  }

  bool _usesWheels(BuildContext context) =>
      HyperTheme.sizesOf(context).deviceType == HyperDeviceType.phone &&
      !_usesSubmenus(context);

  HyperButtonStyle _clearStyle(BuildContext context) =>
      HyperButtonStyle(
            foregroundColor: HyperTheme.of(context).colors.primary,
            contrastMode: HyperContrastMode.standard,
          )
          .merge(_visual(context).navigationStyle)
          .merge(_visual(context).clearButtonStyle);

  Widget _modalTitle() => ListenableBuilder(
    listenable: _updates,
    builder: (context, _) {
      if (!_usesWheels(context)) return Text(widget.placeholder);
      final selection = HyperSelectionTheme.of(context).style
          .merge(_select(context).selectionStyle);
      return Row(
        children: [
          Expanded(child: Text(widget.placeholder)),
          if (widget.allowClear)
            HyperButton.text(
              style: _clearStyle(context),
              onPressed: _enabled && widget.value.isNotEmpty
                  ? () => _commit([], () => _openChanged(false))
                  : null,
              label: Text(selection.clearText ?? '清空'),
            ),
        ],
      );
    },
  );

  void _openChanged(bool open) {
    if (!mounted) return;
    setState(() => _open = open && _enabled);
    if (_open && !_usesSubmenus(context) && !_usesWheels(context)) {
      unawaited(_controller.browse(widget.value));
    } else {
      _controller.cancelNavigation();
    }
  }

  void _commit(List<T> value, VoidCallback close) {
    if (!_enabled) return;
    widget.onChanged?.call(List.unmodifiable(value));
    close();
  }

  Widget _submenuPanel(BuildContext context, VoidCallback close) {
    final sizes = HyperTheme.sizesOf(context);
    final visual = _visual(context);
    final selection = HyperSelectionTheme.of(context).style
        .merge(_select(context).selectionStyle);
    final selected = <String>{};
    final leaves = <String, List<T>>{};
    late HyperMenuItem Function(
      HyperCascaderNode<T>,
      List<HyperCascaderNode<T>>,
      String,
    )
    item;
    List<HyperMenuItem> items(
      List<HyperCascaderNode<T>> nodes,
      List<HyperCascaderNode<T>> ancestors,
      String prefix,
    ) => [
      for (final (index, node) in nodes.indexed)
        item(node, ancestors, '$prefix$index'),
    ];
    // All levels share Menu's overlay, hover, keyboard and surface resolver.
    // Only the data adapter knows about cascader paths and asynchronous branches.
    item = (node, ancestors, id) {
      final path = [...ancestors, node];
      final values = path.map((node) => node.value).toList();
      if (widget.value.length >= path.length &&
          listEquals(widget.value.take(path.length).toList(), values)) {
        selected.add(id);
      }
      final branch = _controller.isBranch(node);
      final children = _controller.childrenOf(node);
      final error = _controller.errorFor(node.value);
      if (!branch) leaves[id] = values;
      return HyperMenuItem(
        id: id,
        label: node.label,
        leading: node.leading,
        enabled: _enabled && node.enabled,
        wrapLabel: true,
        submenuIcon: visual.branchIcon,
        onSubmenuOpened: branch
            ? () => unawaited(_controller.loadBranch(path))
            : null,
        children: !branch
            ? const []
            : children.isNotEmpty
            ? items(children, path, '$id/')
            : error != null
            ? [
                HyperMenuItem(
                  id: '$id/error',
                  label: selection.errorText ?? '加载失败',
                  enabled: false,
                  wrapLabel: true,
                ),
                HyperMenuItem(
                  id: '$id/retry',
                  label: selection.retryText ?? '重试',
                  dismissOnPressed: false,
                  onPressed: () => unawaited(_controller.loadBranch(path)),
                ),
              ]
            : [
                HyperMenuItem(
                  id: '$id/status',
                  enabled: false,
                  wrapLabel: true,
                  label:
                      node.hasChildren &&
                          (children.isEmpty &&
                              !_controller.hasLoaded(node.value))
                      ? selection.loadingText ?? '正在加载…'
                      : selection.emptyText ?? '暂无选项',
                ),
              ],
      );
    };
    final rootItems = items(_controller.nodes, const [], '');
    final menu = selection.menuStyle;
    final surface =
        menu?.surfaceStyle?.merge(selection.surfaceStyle) ??
        selection.surfaceStyle;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HyperMenu(
          key: ValueKey(_controller),
          showSurface: false,
          items: rootItems,
          selectedIds: selected,
          style:
              HyperMenuStyle(
                    width:
                        menu?.width ??
                        selection.width ??
                        _select(context).width ??
                        sizes.select.width,
                    maxHeight:
                        selection.maxPanelHeight ??
                        sizes.selection.maxPanelHeight,
                    submenuTransitionBuilder: selection.transitionBuilder,
                  )
                  .merge(menu)
                  .copyWith(
                    surfaceStyle:
                        surface?.merge(widget.surfaceStyle) ??
                        widget.surfaceStyle,
                  ),
          onSelected: (id) {
            final values = leaves[id];
            if (values != null) _commit(values, close);
          },
        ),
        if (widget.allowClear)
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: HyperButton.text(
              style: _clearStyle(context),
              onPressed: _enabled && widget.value.isNotEmpty
                  ? () => _commit([], close)
                  : null,
              label: Text(selection.clearText ?? '清空'),
            ),
          ),
      ],
    );
  }

  Widget _panel(BuildContext context, VoidCallback close) => ListenableBuilder(
    listenable: _updates,
    builder: (context, _) {
      if (_usesSubmenus(context)) return _submenuPanel(context, close);
      if (_usesWheels(context)) {
        return HyperCascaderWheelPanel<T>(
          controller: _controller,
          value: widget.value,
          enabled: _enabled,
          style: _visual(context),
          selection: HyperSelectionTheme.of(context).style
              .merge(_select(context).selectionStyle),
          onConfirm: (value) => _commit(value, close),
          onCancel: close,
        );
      }
      final theme = HyperTheme.of(context);
      final sizes = HyperTheme.sizesOf(context);
      final visual = _visual(context);
      final select = _select(context);
      final selection = HyperSelectionTheme.of(context).style
          .merge(select.selectionStyle);
      final path = _controller.path;
      final options = _controller.options;
      final menuStyle = const HyperMenuStyle(maxHeight: double.infinity)
          .merge(selection.menuStyle);
      final duration = MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : selection.duration ?? theme.motion.fastDuration;
      final curve = selection.curve ?? theme.motion.fastCurve;
      Widget content;
      if (_controller.loading) {
        content = Semantics(
          liveRegion: true,
          child: Text(selection.loadingText ?? '正在加载…'),
        );
      } else if (_controller.error != null) {
        content = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              liveRegion: true,
              child: Text(selection.errorText ?? '加载失败'),
            ),
            HyperButton.text(
              style: visual.navigationStyle,
              onPressed: _enabled ? () => unawaited(_controller.retry()) : null,
              label: Text(selection.retryText ?? '重试'),
            ),
          ],
        );
      } else if (options.isEmpty) {
        content = Semantics(
          liveRegion: true,
          child: Text(selection.emptyText ?? '暂无选项'),
        );
      } else {
        content = HyperMenu(
          // A fresh level receives keyboard focus; surface and scrolling belong
          // to the shared Dropdown, never to the embedded menu.
          key: ValueKey(Object.hashAll(path.map((node) => node.value))),
          showSurface: false,
          style: menuStyle,
          selectedIds: {
            for (final (index, node) in options.indexed)
              if (widget.value.length > path.length &&
                  listEquals(
                    widget.value.take(path.length).toList(),
                    path.map((node) => node.value).toList(),
                  ) &&
                  widget.value[path.length] == node.value)
                '$index',
          },
          items: [
            for (final (index, node) in options.indexed)
              HyperMenuItem(
                id: '$index',
                label: node.label,
                leading: node.leading,
                enabled: _enabled && node.enabled,
                trailing: _controller.isBranch(node)
                    ? Icon(
                        visual.branchIcon ?? HyperIcons.chevronRight,
                        textDirection: Directionality.of(context),
                        size: menuStyle.iconSize ?? sizes.menu.iconSize,
                      )
                    : null,
              ),
          ],
          onSelected: (id) {
            final node = options[int.parse(id)];
            if (_controller.isBranch(node)) {
              unawaited(_controller.enter(node));
            } else {
              _commit([...path.map((node) => node.value), node.value], close);
            }
          },
        );
      }
      return Focus(
        onKeyEvent: (_, event) {
          final back = Directionality.of(context) == TextDirection.rtl
              ? LogicalKeyboardKey.arrowRight
              : LogicalKeyboardKey.arrowLeft;
          if (event is KeyDownEvent &&
              event.logicalKey == back &&
              _controller.path.isNotEmpty) {
            _controller.goTo(_controller.path.length - 1);
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (path.isEmpty) Text(widget.rootLabel),
            if (path.isNotEmpty)
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: HyperButton.text(
                  style: visual.navigationStyle,
                  onPressed: _enabled
                      ? () => _controller.goTo(path.length - 1)
                      : null,
                  icon: Icon(
                    visual.backIcon ?? HyperIcons.arrowLeft,
                    size: menuStyle.iconSize ?? sizes.menu.iconSize,
                  ),
                  label: Text('${widget.backLabel} · ${path.last.label}'),
                ),
              ),
            SizedBox(height: sizes.navigationItemSpacing),
            AnimatedSize(
              duration: duration,
              curve: curve,
              alignment: AlignmentDirectional.topStart,
              child: AnimatedSwitcher(
                duration: duration,
                switchInCurve: curve,
                transitionBuilder:
                    selection.feedbackTransitionBuilder ??
                    AnimatedSwitcher.defaultTransitionBuilder,
                child: KeyedSubtree(
                  key: ValueKey((
                    Object.hashAll(path.map((node) => node.value)),
                    _controller.loading,
                    _controller.error != null,
                    options.isEmpty,
                  )),
                  child: content,
                ),
              ),
            ),
            if (widget.allowClear)
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: HyperButton.text(
                  style: _clearStyle(context),
                  onPressed: _enabled && widget.value.isNotEmpty
                      ? () => _commit([], close)
                      : null,
                  label: Text(selection.clearText ?? '清空'),
                ),
              ),
          ],
        ),
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    final known = _controller.resolvePath(widget.value);
    final label = [
      for (final (index, value) in widget.value.indexed)
        index < known.length
            ? known[index].label
            : widget.labelBuilder?.call(value) ?? '$value',
    ].join(widget.pathSeparator);
    return HyperDropdown(
      isOpen: _open,
      onOpenChanged: _openChanged,
      enabled: _enabled,
      presentation: widget.presentation,
      style: _visual(context).selectStyle,
      surfaceStyle: widget.surfaceStyle,
      modalTitle: _modalTitle(),
      label: HyperScrollingText(
        label.isEmpty ? widget.placeholder : label,
        trigger: HyperTextScrollTrigger.hover,
      ),
      panelBuilder: _panel,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _updates.dispose();
    super.dispose();
  }
}
