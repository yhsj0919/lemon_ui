import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../theme/core/hyper_theme.dart';
import '../button/hyper_button.dart';
import '../select/hyper_selection_style.dart';
import '../wheel_picker/hyper_wheel_picker.dart';
import 'hyper_cascader_model.dart';
import 'hyper_cascader_style.dart';

/// Internal draft editor; only explicit confirmation commits a complete path.
class HyperCascaderWheelPanel<T> extends StatefulWidget {
  const HyperCascaderWheelPanel({
    super.key,
    required this.controller,
    required this.value,
    required this.onConfirm,
    required this.onCancel,
    required this.enabled,
    required this.style,
    required this.selection,
  });
  final HyperCascaderController<T> controller;
  final List<T> value;
  final ValueChanged<List<T>> onConfirm;
  final VoidCallback onCancel;
  final bool enabled;
  final HyperCascaderStyle style;
  final HyperSelectionStyle selection;

  @override
  State<HyperCascaderWheelPanel<T>> createState() => _WheelPanelState<T>();
}

class _WheelPanelState<T> extends State<HyperCascaderWheelPanel<T>> {
  List<HyperCascaderNode<T>> _draft = const [];
  bool _resolving = true;
  int _ticket = 0;

  @override
  void initState() {
    super.initState();
    _schedule();
  }

  void _schedule() {
    ++_ticket;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(_populate(widget.value));
    });
  }

  @override
  void didUpdateWidget(HyperCascaderWheelPanel<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller ||
        !listEquals(oldWidget.value, widget.value)) {
      _draft = const [];
      _resolving = true;
      _schedule();
    }
  }

  Future<void> _populate(List<T> preferred) async {
    final ticket = ++_ticket;
    final model = widget.controller;
    bool current() => mounted && ticket == _ticket && widget.enabled;
    if (!current()) return;
    setState(() {
      _draft = const [];
      _resolving = true;
    });
    var options = model.nodes;
    final path = <HyperCascaderNode<T>>[];
    try {
      while (current()) {
        final enabled = options.where((node) => node.enabled).toList();
        if (enabled.isEmpty) break;
        final depth = path.length;
        final node = depth < preferred.length
            ? enabled
                      .where((node) => node.value == preferred[depth])
                      .firstOrNull ??
                  enabled.first
            : enabled.first;
        path.add(node);
        setState(() => _draft = List.unmodifiable(path));
        if (!model.isBranch(node)) break;
        await model.loadBranch(List.unmodifiable(path));
        if (!current() || model.errorFor(node.value) != null) return;
        options = model.childrenOf(node);
      }
    } finally {
      if (mounted && ticket == _ticket) setState(() => _resolving = false);
    }
  }

  @override
  void dispose() {
    ++_ticket;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.controller;
    final metrics = HyperTheme.sizesOf(context);
    final selection = widget.selection;
    final theme = HyperTheme.of(context);
    final error = _draft.isEmpty ? null : model.errorFor(_draft.last.value);
    final complete =
        !_resolving && _draft.isNotEmpty && !model.isBranch(_draft.last);
    final columns = <List<HyperCascaderNode<T>>>[];
    var options = model.nodes;
    for (final node in _draft) {
      columns.add(options.where((node) => node.enabled).toList());
      options = model.childrenOf(node);
    }
    Widget? feedback;
    if (_resolving) {
      feedback = Semantics(
        liveRegion: true,
        child: Text(selection.loadingText ?? '正在加载…'),
      );
    } else if (error != null) {
      feedback = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Semantics(
            liveRegion: true,
            child: Text(selection.errorText ?? '加载失败'),
          ),
          HyperButton.text(
            style: widget.style.navigationStyle,
            onPressed: widget.enabled
                ? () => unawaited(
                    _populate(_draft.map((node) => node.value).toList()),
                  )
                : null,
            label: Text(selection.retryText ?? '重试'),
          ),
        ],
      );
    } else if (!complete) {
      feedback = Semantics(
        liveRegion: true,
        child: Text(selection.emptyText ?? '暂无可选项'),
      );
    }
    // An unresolved branch owns the next column, just like loaded children.
    // Keep feedback beside its parent rather than changing the footer layout.
    final columnCount = columns.length + (feedback == null ? 0 : 1);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AnimatedSize(
          duration: MediaQuery.disableAnimationsOf(context)
              ? Duration.zero
              : selection.duration ?? theme.motion.fastDuration,
          curve: selection.curve ?? theme.motion.fastCurve,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final gap = metrics.menu.padding;
              final width = math.max(
                metrics.minimumInteractiveDimension,
                (constraints.maxWidth - gap * math.max(0, columnCount - 1)) /
                    math.max(1, columnCount),
              );
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    for (final (depth, items) in columns.indexed) ...[
                      if (depth > 0) SizedBox(width: gap),
                      SizedBox(
                        width: width,
                        child: HyperWheelPicker<T>(
                          key: ValueKey(depth),
                          items: items.map((node) => node.value).toList(),
                          value: _draft[depth].value,
                          labelBuilder: (value) => items
                              .firstWhere((node) => node.value == value)
                              .label,
                          style: widget.style.wheelStyle,
                          semanticLabel: '第 ${depth + 1} 级',
                          enabled: widget.enabled,
                          onChanged: widget.enabled
                              ? (value) => unawaited(
                                  _populate([
                                    ..._draft
                                        .take(depth)
                                        .map((node) => node.value),
                                    value,
                                  ]),
                                )
                              : null,
                        ),
                      ),
                    ],
                    if (feedback != null) ...[
                      if (columns.isNotEmpty) SizedBox(width: gap),
                      SizedBox(
                        width: width,
                        child: Center(child: feedback),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
        SizedBox(height: metrics.menu.padding),
        Wrap(
          alignment: WrapAlignment.end,
          spacing: metrics.menu.padding,
          runSpacing: metrics.menu.padding,
          children: [
            HyperButton.outlined(
              onPressed: widget.onCancel,
              label: const Text('取消'),
            ),
            HyperButton.filled(
              onPressed: widget.enabled && complete
                  ? () => widget.onConfirm(
                      List<T>.unmodifiable(_draft.map((node) => node.value)),
                    )
                  : null,
              label: Text(selection.doneText ?? '确定'),
            ),
          ],
        ),
      ],
    );
  }
}
