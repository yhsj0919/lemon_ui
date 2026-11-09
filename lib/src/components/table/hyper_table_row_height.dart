part of 'hyper_table.dart';

typedef _HyperTableTextMeasureKey = ({
  String text,
  double width,
  TextStyle style,
  TextScaler scaler,
  TextDirection direction,
  int? maxLines,
});

final _hyperTableRowHeightShortcuts = {
  for (final entry in trina.TrinaGridShortcut.defaultActions.entries)
    entry.key: switch (entry.value) {
      trina.TrinaGridActionMoveCellFocusByPage(:final direction)
          when direction.vertical =>
        _HyperTablePageAction(up: direction.isUp, selecting: false),
      trina.TrinaGridActionMoveSelectedCellFocusByPage(:final direction)
          when direction.vertical =>
        _HyperTablePageAction(up: direction.isUp, selecting: true),
      _ => entry.value,
    },
};

extension _HyperTableRowHeights<T> on _HyperTableState<T> {
  double get _minimumRowHeight {
    final s = _resolved!;
    final font = s.textStyle!.fontSize!;
    return math.max(
      s.rowHeight!,
      MediaQuery.textScalerOf(context).scale(font) *
              (s.textStyle!.height ?? 1.5) +
          2 * s.verticalPadding!,
    );
  }

  double? _explicitRowHeight(T row) {
    final height = widget.rowHeightBuilder?.call(row);
    if (height != null && (!height.isFinite || height <= 0)) {
      throw ArgumentError.value(
        height,
        'rowHeightBuilder',
        'Must be finite and positive',
      );
    }
    return height;
  }

  bool _contentHeight(T row) =>
      widget.rowHeightMode == HyperTableRowHeightMode.content &&
      _explicitRowHeight(row) == null;

  double _initialRowHeight(T data, {trina.TrinaRow? row}) {
    final explicit = _explicitRowHeight(data);
    var height = math.max(_minimumRowHeight, explicit ?? 0);
    if (explicit != null ||
        widget.rowHeightMode != HyperTableRowHeightMode.content) {
      return height;
    }
    final s = _resolved!;
    final columns = _manager?.columns ?? _columns;
    final cached = _cellHeights[widget.rowKey(data)];
    for (final column in columns.where(
      (c) => !c.hide && !c.field.startsWith('__hyper_'),
    )) {
      final definition = widget.columns.firstWhere((c) => c.id == column.field);
      if (definition.cellBuilder == null) {
        var width = column.width - 2 * s.horizontalPadding!;
        if (_tree &&
            definition.id == (widget.treeColumnId ?? widget.columns.first.id)) {
          final depth = _depth[widget.rowKey(data)] ?? 0;
          width -= depth * s.treeIndent! + s.controlColumnWidth!;
        }
        final key = (
          text:
              '${row?.cells[column.field]?.value ?? definition.value(data) ?? ''}',
          width: math.max(0.0, width),
          style: s.textStyle!,
          scaler: MediaQuery.textScalerOf(context),
          direction: Directionality.of(context),
          maxLines: definition.maxLines,
        );
        final textHeight = _textHeights.putIfAbsent(key, () {
          final text = TextPainter(
            text: TextSpan(text: key.text, style: key.style),
            textDirection: Directionality.of(context),
            textScaler: MediaQuery.textScalerOf(context),
            maxLines: definition.maxLines,
            ellipsis: definition.maxLines == null ? null : '\u2026',
          )..layout(maxWidth: key.width);
          final result = text.height;
          text.dispose();
          return result;
        });
        height = math.max(height, textHeight + 2 * s.verticalPadding!);
      }
      height = math.max(height, cached?[column.field] ?? 0);
    }
    return height.ceilToDouble();
  }

  double _rowExtent(trina.TrinaRow row) {
    // Cell renderers can be retained while the native manager replaces the
    // immutable row object to change its height. Resolve by stable key.
    final current = _manager?.rows.where((r) => r.key == row.key).firstOrNull;
    return (current ?? row).height ?? _minimumRowHeight;
  }

  void _recordCellHeight(T data, String column, double height) {
    if (!mounted || !_contentHeight(data)) return;
    final heights = _cellHeights.putIfAbsent(widget.rowKey(data), () => {});
    final padded = (height + 2 * _resolved!.verticalPadding!).ceilToDouble();
    if (heights[column] == padded) return;
    heights[column] = padded;
    _scheduleRowHeights();
  }

  void _scheduleRowHeights() {
    if (_rowHeightsScheduled || !mounted) return;
    _rowHeightsScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _rowHeightsScheduled = false;
      if (!mounted) return;
      final manager = _manager;
      if (manager == null) return;
      for (var index = 0; index < manager.rows.length; index++) {
        final row = manager.rows[index];
        final height = _initialRowHeight(row.data as T, row: row);
        if ((manager.getRowHeight(index) - height).abs() > .01) {
          manager.setRowHeight(index, height);
        }
      }
    });
    WidgetsBinding.instance.scheduleFrame();
  }
}

/// Measures the actual cell subtree at its assigned width, with free height.
/// The same subtree is painted and interacted with; no offstage duplicate is
/// created, so stateful builders and GlobalKeys retain their identity.
class _HyperTableMeasureCell extends SingleChildRenderObjectWidget {
  const _HyperTableMeasureCell({required this.onHeight, required super.child});
  final ValueChanged<double> onHeight;

  @override
  _RenderHyperTableMeasureCell createRenderObject(BuildContext context) =>
      _RenderHyperTableMeasureCell(onHeight);

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderHyperTableMeasureCell renderObject,
  ) {
    renderObject.onHeight = onHeight;
    renderObject.markNeedsLayout();
  }
}

class _RenderHyperTableMeasureCell extends RenderProxyBox {
  _RenderHyperTableMeasureCell(this.onHeight);
  ValueChanged<double> onHeight;

  @override
  void performLayout() {
    child!.layout(
      BoxConstraints.tightFor(width: constraints.maxWidth),
      parentUsesSize: true,
    );
    size = constraints.constrain(child!.size);
    final height = child!.size.height;
    final callback = onHeight;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (attached) callback(height);
    });
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    context.pushClipRect(
      needsCompositing,
      offset,
      Offset.zero & size,
      super.paint,
    );
  }
}

/// Native page navigation counts equal-height rows. Resolve the target from
/// actual row extents through the public shortcut API instead.
class _HyperTablePageAction extends trina.TrinaGridShortcutAction {
  const _HyperTablePageAction({required this.up, required this.selecting});
  final bool up, selecting;

  @override
  void execute({
    required trina.TrinaKeyManagerEvent keyEvent,
    required trina.TrinaGridStateManager stateManager,
  }) {
    if (stateManager.rows.isEmpty || stateManager.currentRowIdx == null) return;
    var index = selecting
        ? stateManager.currentSelectingPosition?.rowIdx ??
              stateManager.currentRowIdx!
        : stateManager.currentRowIdx!;
    var distance = 0.0;
    final direction = up
        ? trina.TrinaMoveDirection.up
        : trina.TrinaMoveDirection.down;
    final viewport = stateManager.rowContainerHeight;
    do {
      final next = index + (up ? -1 : 1);
      if (next < 0 || next >= stateManager.rows.length) break;
      distance +=
          stateManager.getRowHeight(up ? next : index) +
          stateManager.configuration.style.cellHorizontalBorderWidth;
      index = next;
    } while (distance < viewport);
    if (selecting) {
      stateManager.moveSelectingCellByRowIdx(index, direction);
    } else {
      stateManager.moveCurrentCellByRowIdx(index, direction);
    }
  }
}
