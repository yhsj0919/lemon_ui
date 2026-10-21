import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';

import 'package:flutter/material.dart';
import 'package:trina_grid/trina_grid.dart' as trina;

import '../../foundation/hyper_fill.dart';
import '../../theme/core/hyper_theme.dart';
import '../button/hyper_button.dart';
import '../checkbox/hyper_checkbox.dart';
import '../checkbox/hyper_checkbox_style.dart';
import '../icon_button/hyper_icon_button.dart';
import '../menu/hyper_context_menu.dart';
import '../menu/hyper_menu_model.dart';
import '../menu/hyper_menu_surface.dart';
import '../pagination/hyper_pagination.dart';
import '../progress/hyper_progress.dart';
import '../icon_button/hyper_icon_button_style.dart';
import '../result/hyper_result.dart';
import '../result/hyper_result_model.dart';
import '../surface/hyper_material_surface.dart';
import '../text_field/hyper_text_field.dart';
import '../text_field/hyper_text_field_style.dart';
import 'hyper_table_defaults.dart';
import 'hyper_table_style.dart';
import 'hyper_table_theme.dart';
part 'hyper_table_model.dart';

/// A data grid with controlled selection and local or remote data loading.
///
/// The parent provides bounded width and height. Remote pagination and infinite
/// loading use [loader]; local pagination is enabled with [paginateLocalRows].
class HyperTable<T> extends StatefulWidget {
  const HyperTable({
    super.key,
    required this.columns,
    required this.rowKey,
    this.rows = const [],
    this.loader,
    this.onPageChanged,
    this.onRefreshRequested,
    this.dataMode = HyperTableDataMode.local,
    this.pageSize = 20,
    this.paginateLocalRows = false,
    this.showPagination = true,
    this.controller,
    this.selectionMode = HyperTableSelectionMode.none,
    this.selectedKeys = const {},
    this.onSelectionChanged,
    this.reorderableRows = false,
    this.onRowsReordered,
    this.onColumnsReordered,
    this.onColumnWidthChanged,
    this.onColumnVisibilityChanged,
    this.onSortChanged,
    this.onCellChanged,
    this.onRowDoubleTap,
    this.rowContextMenuBuilder,
    this.childrenBuilder,
    this.hasChildren,
    this.childrenLoader,
    this.treeColumnId,
    this.expandedKeys,
    this.onExpandedChanged,
    this.striped = true,
    this.hoverLift = false,
    this.style,
    this.empty,
  }) : assert(pageSize > 0),
       assert(dataMode == HyperTableDataMode.local || loader != null);
  final List<HyperTableColumn<T>> columns;
  final List<T> rows;
  final Object Function(T row) rowKey;
  final HyperTableLoader<T>? loader;

  /// Notifies external pagers of an accepted page change (one-based).
  final ValueChanged<int>? onPageChanged;

  /// Notifies refresh observers. Remote loading still runs through [loader].
  final VoidCallback? onRefreshRequested;
  final HyperTableDataMode dataMode;
  final int pageSize;
  final bool paginateLocalRows, striped, reorderableRows;

  /// Whether to show the built-in pager; pagination and controller commands
  /// remain available when an external pager is used.
  final bool showPagination;

  /// Gives hovered rows the same lifted surface treatment as drag feedback.
  final bool hoverLift;
  final HyperTableController? controller;
  final HyperTableSelectionMode selectionMode;
  final Set<Object> selectedKeys;
  final ValueChanged<Set<Object>>? onSelectionChanged;
  final ValueChanged<List<T>>? onRowsReordered;
  final ValueChanged<List<String>>? onColumnsReordered;
  final void Function(String id, double width)? onColumnWidthChanged;
  final void Function(String id, bool visible)? onColumnVisibilityChanged;
  final ValueChanged<HyperTableSort?>? onSortChanged;
  final ValueChanged<HyperTableCellChange<T>>? onCellChanged;
  final ValueChanged<T>? onRowDoubleTap;
  final HyperTableContextMenuBuilder<T>? rowContextMenuBuilder;

  /// Synchronous children; remote children are cached separately by row key.
  final List<T> Function(T row)? childrenBuilder;
  final bool Function(T row)? hasChildren;
  final Future<List<T>> Function(T row)? childrenLoader;
  final String? treeColumnId;

  /// Expanded row identities; null enables internally managed expansion.
  final Set<Object>? expandedKeys;
  final ValueChanged<Set<Object>>? onExpandedChanged;
  final HyperTableStyle? style;
  final Widget? empty;
  @override
  State<HyperTable<T>> createState() => _HyperTableState<T>();
}

class _HyperTableState<T> extends State<HyperTable<T>>
    implements _HyperTableCommands {
  final Map<Object, List<T>> _children = {};
  final Set<Object> _expanded = {}, _childLoading = {};
  final Map<Object, Object> _childErrors = {};
  final Map<Object, int> _depth = {};
  int _childrenEpoch = 0;
  bool get _tree =>
      widget.childrenBuilder != null || widget.childrenLoader != null;
  Set<Object> get _expandedKeys => widget.expandedKeys ?? _expanded;
  trina.TrinaGridStateManager? _manager;
  List<trina.TrinaColumn> _columns = [];
  List<trina.TrinaRow> _gridRows = [];
  List<T> _remote = [];
  final ValueNotifier<Object?> _hoveredRow = ValueNotifier(null);
  final Map<String, double> _knownWidths = {};
  final Set<String> _userSized = {};
  bool _applyingMetrics = false, _metricsScheduled = false;
  HyperTableSort? _sort;
  Object? _selectionAnchor;
  int _page = 1, _request = 0, _gridVersion = 0;
  int? _total;
  String? _cursor;
  bool _loading = false, _hasMore = false;
  Object? _error;
  bool _failedReset = false;
  HyperTableStyle? _resolved;
  final _captureKey = GlobalKey();
  final _rowsStackKey = GlobalKey();
  final _hoverLiftRect = ValueNotifier<Rect?>(null);
  Rect? _lastHoverLiftRect;

  double? _columnViewportWidth;
  bool _columnLayoutScheduled = false;
  bool _horizontalOverflow = true;

  void _scheduleColumnLayout(double width) {
    _columnViewportWidth = width;
    if (_manager == null || _columnLayoutScheduled || !width.isFinite) return;
    _columnLayoutScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _columnLayoutScheduled = false;
      if (!mounted || _manager == null) return;
      _layoutColumnWidths();
    });
  }

  void _layoutColumnWidths() {
    final manager = _manager!, s = _resolved!;
    final available = _columnViewportWidth!;
    // Trina reserves thickness + 4 logical pixels after body columns for
    // the overlaid vertical scrollbar; match that layout footprint.
    final scrollbarFootprint = manager.configuration.scrollbar.showVertical
        ? manager.configuration.scrollbar.thickness + 4
        : 0.0;
    var remaining = math.max(
      0.0,
      available - s.borderWidth! * 2 - scrollbarFootprint,
    );
    final targets = <trina.TrinaColumn, double>{};
    final flexible = <trina.TrinaColumn, HyperTableColumn<T>>{};
    double measure(String text, TextStyle style) {
      final painter = TextPainter(
        text: TextSpan(text: text, style: style),
        textDirection: Directionality.of(context),
        textScaler: MediaQuery.textScalerOf(context),
      )..layout();
      final width = painter.width;
      painter.dispose();
      return width;
    }

    for (final column in manager.columns.where((c) => !c.hide)) {
      if (column.field.startsWith('__hyper_')) {
        remaining -= column.width;
        continue;
      }
      final definition = widget.columns.firstWhere((c) => c.id == column.field);
      if (_userSized.contains(column.field) ||
          definition.widthMode == HyperTableColumnWidthMode.fixed) {
        remaining -= column.width;
      } else if (definition.widthMode == HyperTableColumnWidthMode.flex) {
        flexible[column] = definition;
      } else {
        var width =
            measure(definition.title, s.headerTextStyle!) +
            s.horizontalPadding! * 2 +
            (definition.resizable ? s.iconSize! : 0) +
            (definition.sortable ? s.iconSize! : 0);
        for (final row in manager.rows) {
          final value = row.cells[column.field]?.value;
          width = math.max(
            width,
            measure('${value ?? ''}', s.textStyle!) + s.horizontalPadding! * 2,
          );
        }
        width = math.max(column.minWidth, width.ceilToDouble());
        targets[column] = width;
        remaining -= width;
      }
    }
    // Reserve minimum widths first when a proportional share would be too small.
    final pending = Map.of(flexible);
    while (pending.isNotEmpty) {
      final weight = pending.values.fold<double>(0, (sum, c) => sum + c.flex);
      final constrained = pending.keys
          .where((c) => remaining * pending[c]!.flex / weight < c.minWidth)
          .toList();
      if (constrained.isEmpty) {
        for (final entry in pending.entries) {
          targets[entry.key] = math.max(
            entry.key.minWidth,
            remaining * entry.value.flex / weight,
          );
        }
        break;
      }
      for (final column in constrained) {
        targets[column] = column.minWidth;
        remaining -= column.minWidth;
        pending.remove(column);
      }
    }
    var changed = false;
    _applyingMetrics = true;
    for (final entry in targets.entries) {
      if ((entry.key.width - entry.value).abs() > .01) {
        entry.key.width = entry.value;
        _knownWidths[entry.key.field] = entry.value;
        changed = true;
      }
    }
    if (changed) {
      _hoverLiftRect.value = null;
      manager.notifyResizingListeners();
      manager.notifyListeners();
    }
    _applyingMetrics = false;
    final width = manager.columns
        .where((c) => !c.hide)
        .fold<double>(0, (sum, column) => sum + column.width);
    final overflow =
        width + scrollbarFootprint > available - s.borderWidth! * 2 + .5;
    if (_horizontalOverflow != overflow) {
      setState(() => _horizontalOverflow = overflow);
    }
  }

  double _visibleRowWidth(double availableWidth) => math.min(
    availableWidth,
    _manager!.columns
        .where((column) => !column.hide)
        .fold<double>(0, (width, column) => width + column.width),
  );

  double _rowLeadingInset(double availableWidth) =>
      Directionality.of(context) == TextDirection.rtl
      ? availableWidth - _visibleRowWidth(availableWidth)
      : 0;

  void _showHoverLift(BuildContext rowContext) {
    if (!widget.hoverLift || _draggingRow) return;
    final stack =
        _rowsStackKey.currentContext?.findRenderObject() as RenderBox?;
    final rowBox = rowContext.findRenderObject() as RenderBox?;
    if (stack == null || rowBox == null) return;
    final origin = stack.globalToLocal(rowBox.localToGlobal(Offset.zero));
    final width = _visibleRowWidth(stack.size.width);
    _lastHoverLiftRect = Rect.fromLTWH(
      _rowLeadingInset(stack.size.width),
      origin.dy,
      width,
      rowBox.size.height,
    );
    _hoverLiftRect.value = _lastHoverLiftRect;
  }

  final _dragSnapshot = ValueNotifier<ui.Image?>(null);
  int _captureEpoch = 0;
  bool _draggingRow = false;

  void _clearDragSnapshot() {
    _captureEpoch++;
    final previous = _dragSnapshot.value;
    _dragSnapshot.value = null;
    if (previous != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => previous.dispose());
    }
  }

  Future<void> _captureDragRow(BuildContext handleContext) async {
    _clearDragSnapshot();
    final epoch = _captureEpoch;
    final boundary =
        _captureKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final handle = handleContext.findRenderObject() as RenderBox;
    final center = boundary.globalToLocal(
      handle.localToGlobal(handle.size.center(Offset.zero)),
    );
    final height = _manager!.rowTotalHeight;
    final source = Rect.fromLTWH(
      _rowLeadingInset(boundary.size.width),
      center.dy - height / 2,
      _visibleRowWidth(boundary.size.width),
      height,
    );
    final ratio = MediaQuery.devicePixelRatioOf(context);
    final full = await boundary.toImage(pixelRatio: ratio);
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.drawImageRect(
      full,
      Rect.fromLTWH(
        source.left * ratio,
        source.top * ratio,
        source.width * ratio,
        source.height * ratio,
      ),
      Rect.fromLTWH(0, 0, source.width * ratio, source.height * ratio),
      Paint(),
    );
    final picture = recorder.endRecording();
    final image = await picture.toImage(
      (source.width * ratio).ceil(),
      (source.height * ratio).ceil(),
    );
    picture.dispose();
    full.dispose();
    if (!mounted || epoch != _captureEpoch) {
      image.dispose();
      return;
    }
    _dragSnapshot.value = image;
  }

  bool get _canReorderRows =>
      widget.reorderableRows &&
      widget.onRowsReordered != null &&
      !_remoteMode &&
      !_paged &&
      _sort == null &&
      !_tree;
  bool get _remoteMode => widget.dataMode != HyperTableDataMode.local;
  bool get _paged =>
      widget.dataMode == HyperTableDataMode.paginated ||
      widget.paginateLocalRows;
  List<T> get _data => _remoteMode ? _remote : widget.rows;
  @override
  void initState() {
    super.initState();
    if (_remoteMode) scheduleMicrotask(reload);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resolve();
    if (_columns.isEmpty) _createGrid();
  }

  @override
  void didUpdateWidget(HyperTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._detach(this);
      if (_manager != null) widget.controller?._attach(this);
    }
    _resolve();
    if (!identical(oldWidget.columns, widget.columns) ||
        oldWidget.selectionMode != widget.selectionMode ||
        oldWidget.reorderableRows != widget.reorderableRows ||
        oldWidget.treeColumnId != widget.treeColumnId ||
        (oldWidget.childrenBuilder != null ||
                oldWidget.childrenLoader != null) !=
            _tree) {
      _rebuildGrid(oldWidget);
    } else if (!identical(oldWidget.rows, widget.rows) ||
        oldWidget.pageSize != widget.pageSize ||
        oldWidget.paginateLocalRows != widget.paginateLocalRows ||
        oldWidget.expandedKeys != widget.expandedKeys ||
        oldWidget.dataMode != widget.dataMode ||
        oldWidget.childrenBuilder != widget.childrenBuilder ||
        oldWidget.childrenLoader != widget.childrenLoader) {
      _replaceRows();
    }
    if (oldWidget.dataMode != widget.dataMode ||
        oldWidget.loader != widget.loader ||
        oldWidget.pageSize != widget.pageSize) {
      _request++;
      _loading = false;
      if (_remoteMode) scheduleMicrotask(reload);
    }
    for (final c in _columns.where((c) => c.field == '__hyper_drag')) {
      c.enableRowDrag = false;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _syncSelection();
    });
  }

  void _resolve() {
    final previous = _resolved;
    final t = HyperTheme.of(context), m = HyperTheme.sizesOf(context).table;
    _resolved = HyperTableStyle(
      scrollbarTheme: ScrollbarTheme.of(context),
      footerPadding: EdgeInsets.all(m.horizontalPadding),
      rowBoxShadow:
          resolveHyperMenuSurfaceStyle(
                colors: t.colors,
                radius: m.liftRadius,
                padding: EdgeInsets.zero,
              ).boxShadow
              ?.map((shadow) => shadow.copyWith(offset: Offset.zero))
              .toList(),
      liftRadius: m.liftRadius,
      liftBorder: BorderSide.none,
      rowHeight: m.rowHeight,
      headerHeight: m.headerHeight,
      columnWidth: m.columnWidth,
      minimumColumnWidth: m.minimumColumnWidth,
      controlColumnWidth: m.controlColumnWidth,
      horizontalPadding: m.horizontalPadding,
      verticalPadding: m.verticalPadding,
      iconSize: m.iconSize,
      borderWidth: m.borderWidth,
      radius: m.radius,
      treeIndent: m.treeIndent,
      textStyle: t.textTheme.bodyMedium?.copyWith(color: t.colors.textPrimary),
      headerTextStyle: t.textTheme.titleSmall?.copyWith(
        fontSize: m.headerFontSize,
        color: t.colors.textPrimary,
      ),
      background: t.colors.surface,
      headerBackground: t.colors.surfaceMuted,
      stripeBackground: tableStripeBackground(t.colors),
      hoverBackground: tableHoverBackground(
        t.colors,
        t.toMaterialThemeData().hoverColor,
      ),
      selectedBackground: t.colors.primaryContainer,
      editingBackground: t.colors.surface,
      borderColor: t.colors.outline,
      focusColor: t.colors.primary,
      duration: t.motion.fastDuration,
      liftDuration: t.motion.standardDuration,
      curve: t.motion.standardCurve,
    ).merge(HyperTableTheme.of(context).style).merge(widget.style);
    if (previous != null &&
        _manager != null &&
        !_metricsScheduled &&
        (previous.columnWidth != _resolved!.columnWidth ||
            previous.minimumColumnWidth != _resolved!.minimumColumnWidth ||
            previous.controlColumnWidth != _resolved!.controlColumnWidth ||
            previous.iconSize != _resolved!.iconSize ||
            previous.horizontalPadding != _resolved!.horizontalPadding)) {
      _metricsScheduled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _metricsScheduled = false;
        if (!mounted || _manager == null) return;
        _applyingMetrics = true;
        for (final c in _columns) {
          if (c.field == '__hyper_drag') {
            c.cellPadding = _dragPadding(_resolved!);
          }
          final control = c.field.startsWith('__hyper_');
          final def = control
              ? null
              : widget.columns.firstWhere((d) => d.id == c.field);
          c.minWidth = control
              ? _resolved!.controlColumnWidth!
              : _minimumWidth(def!);
          if (control ||
              !_userSized.contains(c.field) ||
              c.width < c.minWidth) {
            // Theme updates must also resize columns whose interactive
            // resize handle is disabled (selection and drag controls).
            c.width = math.max(
              c.minWidth,
              !control && _userSized.contains(c.field)
                  ? c.width
                  : control
                  ? _resolved!.controlColumnWidth!
                  : def!.width ?? _resolved!.columnWidth!,
            );
          }
        }
        _manager!.notifyResizingListeners();
        _manager!.notifyListeners();
        _applyingMetrics = false;
      });
    }
  }

  List<T> _visibleData() {
    var data = List<T>.of(_data);
    if (!_remoteMode && _sort != null) {
      final c = widget.columns.firstWhere((c) => c.id == _sort!.columnId);
      data.sort((a, b) {
        final x = c.value(a), y = c.value(b);
        final result = x == null
            ? (y == null ? 0 : -1)
            : y == null
            ? 1
            : x is num && y is num
            ? x.compareTo(y)
            : x.toString().compareTo(y.toString());
        return _sort!.direction == HyperTableSortDirection.ascending
            ? result
            : -result;
      });
    }
    if (!_remoteMode && widget.paginateLocalRows) {
      _page = _page.clamp(
        1,
        math.max(1, (data.length / widget.pageSize).ceil()),
      );
      data = data
          .skip((_page - 1) * widget.pageSize)
          .take(widget.pageSize)
          .toList();
    }
    if (!_tree) return data;
    _depth.clear();
    final visible = <T>[], visiting = <Object>{};
    void visit(List<T> siblings, int depth) {
      final ordered = List<T>.of(siblings);
      if (_sort != null && depth > 0) {
        final c = widget.columns.firstWhere((c) => c.id == _sort!.columnId);
        ordered.sort((a, b) {
          final x = c.value(a), y = c.value(b);
          final result = x is num && y is num
              ? x.compareTo(y)
              : (x?.toString() ?? '').compareTo(y?.toString() ?? '');
          return _sort!.direction == HyperTableSortDirection.ascending
              ? result
              : -result;
        });
      }
      for (final row in ordered) {
        final key = widget.rowKey(row);
        if (!visiting.add(key)) {
          throw ArgumentError('Duplicate or cyclic tree row key: $key');
        }
        if (_expandedKeys.contains(key) &&
            widget.childrenLoader != null &&
            !_children.containsKey(key) &&
            !_childLoading.contains(key) &&
            !_childErrors.containsKey(key)) {
          final epoch = _childrenEpoch;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted &&
                epoch == _childrenEpoch &&
                _expandedKeys.contains(key) &&
                !_children.containsKey(key) &&
                !_childLoading.contains(key) &&
                !_childErrors.containsKey(key)) {
              unawaited(_fetchChildren(row));
            }
          });
        }
        visible.add(row);
        _depth[key] = depth;
        if (_expandedKeys.contains(key)) {
          visit(
            _children[key] ?? widget.childrenBuilder?.call(row) ?? [],
            depth + 1,
          );
        }
      }
    }

    visit(data, 0);
    return visible;
  }

  bool _expandable(T row) =>
      widget.hasChildren?.call(row) ??
      (_children[widget.rowKey(row)]?.isNotEmpty ??
          widget.childrenBuilder?.call(row).isNotEmpty ??
          widget.childrenLoader != null);
  Future<void> _fetchChildren(T row) async {
    final key = widget.rowKey(row);
    if (widget.childrenLoader == null || _childLoading.contains(key)) return;
    final epoch = _childrenEpoch;
    setState(() {
      _childLoading.add(key);
      _childErrors.remove(key);
    });
    try {
      final children = await widget.childrenLoader!(row);
      if (!mounted || epoch != _childrenEpoch) return;
      final ids = <Object>{key};
      for (final child in children) {
        if (!ids.add(widget.rowKey(child))) {
          throw StateError('Duplicate or cyclic child keys.');
        }
      }
      setState(() {
        _children[key] = List.of(children);
        _childLoading.remove(key);
        _replaceRows();
      });
    } catch (error) {
      if (mounted && epoch == _childrenEpoch) {
        setState(() {
          _childLoading.remove(key);
          _childErrors[key] = error;
          _manager?.notifyListeners();
        });
      }
    }
  }

  void _toggleTree(T row) {
    final key = widget.rowKey(row);
    if (_childErrors.containsKey(key)) {
      unawaited(_fetchChildren(row));
      return;
    }
    final next = Set<Object>.of(_expandedKeys);
    next.contains(key) ? next.remove(key) : next.add(key);
    if (widget.expandedKeys == null) {
      setState(() {
        _expanded
          ..clear()
          ..addAll(next);
        _replaceRows();
      });
    }
    widget.onExpandedChanged?.call(Set.unmodifiable(next));
  }

  Widget _treeCell(BuildContext context, T row, Widget child) {
    final key = widget.rowKey(row),
        s = _resolved!,
        depth = _depth[widget.rowKey(row)] ?? 0;
    final expanded = _expandedKeys.contains(key), expandable = _expandable(row);
    return LayoutBuilder(
      builder: (context, constraints) => Row(
        children: [
          SizedBox(
            width: math.min(
              depth * s.treeIndent!,
              math.max(
                0,
                constraints.maxWidth - s.controlColumnWidth! - s.iconSize!,
              ),
            ),
          ),
          SizedBox(
            width: math.min(s.controlColumnWidth!, constraints.maxWidth),
            child: expandable
                ? HyperIconButton.ghost(
                    style: HyperIconButtonStyle(
                      size: s.controlColumnWidth,
                      minimumTapTargetSize: s.controlColumnWidth,
                      iconSize: s.iconSize,
                    ),
                    tooltip: _childErrors.containsKey(key)
                        ? '子级加载失败，点击重试'
                        : expanded
                        ? '收起子级'
                        : '展开子级',
                    icon: _childLoading.contains(key)
                        ? HyperProgress.circular(size: s.iconSize)
                        : AnimatedRotation(
                            turns: expanded ? .25 : 0,
                            duration: MediaQuery.of(context).disableAnimations
                                ? Duration.zero
                                : s.duration!,
                            curve: s.curve!,
                            child: Icon(
                              _childErrors.containsKey(key)
                                  ? Icons.refresh
                                  : Icons.chevron_right,
                              size: s.iconSize,
                            ),
                          ),
                    onPressed: () => _toggleTree(row),
                  )
                : null,
          ),
          Expanded(child: child),
        ],
      ),
    );
  }

  List<trina.TrinaRow> _rows() {
    final keys = <Object>{};
    return _visibleData().map((r) {
      final key = widget.rowKey(r);
      if (!keys.add(key)) throw ArgumentError('Duplicate table row key: $key');
      return trina.TrinaRow(
        data: r,
        key: ValueKey(key),
        cells: {
          for (final c in widget.columns)
            c.id: trina.TrinaCell(value: c.value(r)),
          if (widget.selectionMode != HyperTableSelectionMode.none)
            '__hyper_select': trina.TrinaCell(),
          if (widget.reorderableRows)
            '__hyper_drag': trina.TrinaCell(value: ''),
        },
      );
    }).toList();
  }

  EdgeInsets _dragPadding(HyperTableStyle s) => EdgeInsets.symmetric(
    horizontal: math.max(0, (s.controlColumnWidth! - s.iconSize!) / 2),
  );

  trina.TrinaColumnTextAlign _align(TextAlign a) => switch (a) {
    TextAlign.center => trina.TrinaColumnTextAlign.center,
    TextAlign.right || TextAlign.end => trina.TrinaColumnTextAlign.end,
    _ => trina.TrinaColumnTextAlign.start,
  };
  double _minimumWidth(HyperTableColumn<T> c) {
    final s = _resolved!;
    return math.max(
      c.minWidth ?? s.minimumColumnWidth!,
      _tree && c.id == (widget.treeColumnId ?? widget.columns.first.id)
          ? s.controlColumnWidth! + 2 * s.horizontalPadding! + s.iconSize!
          : 0,
    );
  }

  void _rebuildGrid(HyperTable<T> previous) {
    final old = List<trina.TrinaColumn>.of(
      _manager?.refColumns.originalList ?? _columns,
    );
    final descriptors = {for (final c in previous.columns) c.id: c};
    final sameOrder =
        previous.columns.length == widget.columns.length &&
        previous.columns.indexed.every(
          (e) => e.$2.id == widget.columns[e.$1].id,
        );
    if (_sort != null && !widget.columns.any((c) => c.id == _sort!.columnId)) {
      _sort = null;
    }
    _releaseManager();
    _gridVersion++;
    _createGrid();
    for (final c in _columns.where((c) => !c.field.startsWith('__hyper_'))) {
      final existing = old.where((x) => x.field == c.field).firstOrNull;
      final descriptor = widget.columns.firstWhere((x) => x.id == c.field);
      final before = descriptors[c.field];
      if (existing == null || before == null) continue;
      if (before.width == descriptor.width) {
        c.width = math.max(c.minWidth, existing.width);
      } else {
        _userSized.remove(c.field);
      }
      if (before.hidden == descriptor.hidden) c.hide = existing.hide;
      if (before.pin == descriptor.pin) c.frozen = existing.frozen;
      c.sort = existing.sort;
    }
    if (sameOrder) {
      final rank = {for (final e in old.indexed) e.$2.field: e.$1};
      _columns.sort(
        (a, b) => (rank[a.field] ?? old.length).compareTo(
          rank[b.field] ?? old.length,
        ),
      );
    }
    _knownWidths
      ..clear()
      ..addEntries(_columns.map((c) => MapEntry(c.field, c.width)));
  }

  void _createGrid() {
    final ids = <String>{};
    for (final c in widget.columns) {
      if (c.id.startsWith('__hyper_') || !ids.add(c.id)) {
        throw ArgumentError('Invalid or duplicate table column id: ${c.id}');
      }
    }
    if (widget.treeColumnId != null && !ids.contains(widget.treeColumnId)) {
      throw ArgumentError('Unknown tree column id.');
    }
    if (widget.columns.isEmpty) {
      throw ArgumentError('A table requires at least one column.');
    }
    final s = _resolved!;
    _columns = [
      if (widget.selectionMode != HyperTableSelectionMode.none)
        trina.TrinaColumn(
          title: '选择',
          field: '__hyper_select',
          type: trina.TrinaColumnType.text(),
          width: s.controlColumnWidth!,
          minWidth: s.controlColumnWidth!,
          frozen: trina.TrinaColumnFrozen.start,
          cellPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          enableSorting: false,
          enableColumnDrag: false,
          enableContextMenu: false,
          enableDropToResize: false,
          readOnly: true,
          backgroundColor: Colors.transparent,
          titleRenderer: (_) => _selectionHeader(),
          renderer: (c) => _selectionCell(c.row.data as T),
        ),
      if (widget.reorderableRows)
        trina.TrinaColumn(
          title: '',
          field: '__hyper_drag',
          frozen: trina.TrinaColumnFrozen.start,
          cellPadding: _dragPadding(s),
          titlePadding: EdgeInsets.zero,
          enableDropToResize: false,
          backgroundColor: Colors.transparent,
          type: trina.TrinaColumnType.text(),
          width: s.controlColumnWidth!,
          minWidth: s.controlColumnWidth!,
          enableRowDrag: false,
          renderer: (r) => _rowDragHandle(r.row),
          enableSorting: false,
          enableColumnDrag: false,
          enableContextMenu: false,
          readOnly: true,
        ),
      for (final c in widget.columns)
        trina.TrinaColumn(
          title: c.title,
          field: c.id,
          type: c.type == HyperTableColumnType.number
              ? trina.TrinaColumnType.number()
              : trina.TrinaColumnType.text(),
          width: math.max(_minimumWidth(c), c.width ?? s.columnWidth!),
          minWidth: _minimumWidth(c),
          frozen: _pin(c.pin),
          backgroundColor: Colors.transparent,
          hide: c.hidden,
          readOnly: !c.editable || widget.onCellChanged == null,
          enableSorting: c.sortable,
          enableColumnDrag: c.reorderable,
          enableContextMenu: false,
          enableDropToResize: c.resizable,
          textAlign: _align(c.textAlign),
          titleTextAlign: _align(c.headerTextAlign),
          titleRenderer: (r) => _header(r.column),
          renderer: (r) {
            final row = r.row.data as T;
            final content =
                c.cellBuilder?.call(context, row, r.cell.value) ??
                Text(
                  '${r.cell.value ?? ''}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: c.textAlign,
                  style: _resolved!.textStyle,
                );
            return _tree &&
                    c.id == (widget.treeColumnId ?? widget.columns.first.id)
                ? _treeCell(context, row, content)
                : content;
          },
        ),
    ];
    _gridRows = _rows();
    _knownWidths
      ..clear()
      ..addEntries(_columns.map((c) => MapEntry(c.field, c.width)));
  }

  trina.TrinaColumnFrozen _pin(HyperTableColumnPin p) => switch (p) {
    HyperTableColumnPin.none => trina.TrinaColumnFrozen.none,
    HyperTableColumnPin.start => trina.TrinaColumnFrozen.start,
    HyperTableColumnPin.end => trina.TrinaColumnFrozen.end,
  };
  Widget _rowDragHandle(trina.TrinaRow row) {
    final s = _resolved!;
    final icon = Icon(
      Icons.drag_indicator,
      size: s.iconSize,
      color: _canReorderRows ? s.textStyle!.color : s.borderColor,
    );
    if (!_canReorderRows) return icon;
    return Builder(
      builder: (handleContext) => Listener(
        onPointerDown: (_) => unawaited(_captureDragRow(handleContext)),
        child: Draggable<trina.TrinaRow>(
          data: row,
          onDragStarted: () {
            _draggingRow = true;
            _hoverLiftRect.value = null;
            _hoveredRow.value = null;
          },
          onDragEnd: (_) {
            _draggingRow = false;
            _hoveredRow.value = null;
            _clearDragSnapshot();
          },
          axis: Axis.vertical,
          dragAnchorStrategy: (draggable, context, position) => Offset(
            position.dx -
                (this.context.findRenderObject() as RenderBox)
                    .localToGlobal(Offset.zero)
                    .dx -
                _rowLeadingInset(
                  (this.context.findRenderObject() as RenderBox).size.width,
                ),
            _manager!.rowTotalHeight / 2,
          ),
          feedback: Builder(builder: (_) => _rowDragFeedback(row)),
          childWhenDragging: Icon(
            Icons.drag_indicator,
            size: s.iconSize,
            color: s.borderColor,
          ),
          child: MouseRegion(cursor: SystemMouseCursors.grab, child: icon),
        ),
      ),
    );
  }

  Widget _rowDragFeedback(trina.TrinaRow row) {
    final s = _resolved!;
    final height = _manager!.rowTotalHeight;
    final width = _visibleRowWidth(
      (context.findRenderObject() as RenderBox).size.width,
    );
    return IgnorePointer(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: MediaQuery.of(context).disableAnimations
            ? Duration.zero
            : s.liftDuration!,
        curve: s.curve!,
        builder: (context, value, child) => DecoratedBox(
          decoration: BoxDecoration(
            color: s.background,
            borderRadius: BorderRadius.circular(s.liftRadius!),
            boxShadow: BoxShadow.lerpList(const [], s.rowBoxShadow, value),
          ),
          child: DecoratedBox(
            position: DecorationPosition.foreground,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(s.liftRadius!),
              border: Border.fromBorderSide(
                BorderSide.lerp(BorderSide.none, s.liftBorder!, value),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(s.liftRadius!),
              child: child,
            ),
          ),
        ),
        child: SizedBox(
          width: width,
          height: height,
          child: ValueListenableBuilder<ui.Image?>(
            valueListenable: _dragSnapshot,
            builder: (context, image, _) => image == null
                ? const SizedBox.shrink()
                : RawImage(
                    image: image,
                    fit: BoxFit.fill,
                    filterQuality: FilterQuality.none,
                  ),
          ),
        ),
      ),
    );
  }

  HyperCheckboxStyle _selectionStyle() {
    final s = _resolved!;
    final checkbox = HyperTheme.sizesOf(context).checkbox;
    final size = math.min(s.iconSize!, s.controlColumnWidth!);
    final ratio = size / checkbox.size;
    return HyperCheckboxStyle(
      size: size,
      markSize: checkbox.markSize == null ? null : checkbox.markSize! * ratio,
      markStrokeWidth: checkbox.markStrokeWidth * ratio,
      borderRadius: BorderRadius.circular(checkbox.roundedRadius * ratio),
      minimumTapTargetSize: s.controlColumnWidth,
    );
  }

  Widget _selectionCell(T row) => Center(
    child: HyperCheckbox.rounded(
      style: _selectionStyle(),
      value: widget.selectedKeys.contains(widget.rowKey(row)),
      semanticLabel: '选择行 ${widget.rowKey(row)}',
      onChanged: widget.onSelectionChanged == null
          ? null
          : (checked) {
              final selected =
                  widget.selectionMode == HyperTableSelectionMode.single
                  ? <Object>{}
                  : Set<Object>.of(widget.selectedKeys);
              checked == true
                  ? selected.add(widget.rowKey(row))
                  : selected.remove(widget.rowKey(row));
              widget.onSelectionChanged!(Set.unmodifiable(selected));
            },
    ),
  );
  Widget _selectionHeader() {
    final keys = _visibleData().map(widget.rowKey).toSet();
    final count = keys.intersection(widget.selectedKeys).length;
    return widget.selectionMode == HyperTableSelectionMode.single
        ? const Center(child: Text('选择'))
        : Center(
            child: HyperCheckbox.rounded(
              style: _selectionStyle(),
              value: count == 0
                  ? false
                  : count == keys.length
                  ? true
                  : null,
              tristate: true,
              semanticLabel: '选择当前页全部行',
              onChanged: widget.onSelectionChanged == null || keys.isEmpty
                  ? null
                  : (_) {
                      final selected = Set<Object>.of(widget.selectedKeys);
                      count == keys.length
                          ? selected.removeAll(keys)
                          : selected.addAll(keys);
                      widget.onSelectionChanged!(Set.unmodifiable(selected));
                    },
            ),
          );
  }

  void _selectRow(trina.TrinaGridOnSelectedEvent event) {
    final row = event.row;
    if (row == null ||
        widget.selectionMode == HyperTableSelectionMode.none ||
        widget.onSelectionChanged == null ||
        event.cell?.column.field.startsWith('__hyper_') == true) {
      return;
    }
    final key = widget.rowKey(row.data as T);
    final multiple = widget.selectionMode == HyperTableSelectionMode.multiple;
    final manager = _manager!;
    final selected =
        multiple && (manager.keyPressed.ctrl || manager.keyPressed.shift)
        ? Set<Object>.of(widget.selectedKeys)
        : <Object>{};
    if (multiple && manager.keyPressed.shift && _selectionAnchor != null) {
      final rows = manager.rows;
      final start = rows.indexWhere(
        (r) => widget.rowKey(r.data as T) == _selectionAnchor,
      );
      final end = rows.indexOf(row);
      if (start >= 0 && end >= 0) {
        for (var i = math.min(start, end); i <= math.max(start, end); i++) {
          selected.add(widget.rowKey(rows[i].data as T));
        }
      } else {
        selected.add(key);
      }
    } else {
      if (multiple && manager.keyPressed.ctrl && selected.contains(key)) {
        selected.remove(key);
      } else {
        selected.add(key);
      }
      _selectionAnchor = key;
    }
    widget.onSelectionChanged!(Set.unmodifiable(selected));
  }

  void _syncSelection() {
    final m = _manager;
    if (m == null) return;
    for (final r in m.refRows.originalList) {
      m.setRowChecked(
        r,
        widget.selectedKeys.contains(widget.rowKey(r.data as T)),
        notify: false,
      );
    }
    m.notifyListeners();
  }

  Widget _header(trina.TrinaColumn c) => HyperContextMenu(
    items: [
      if (c.enableSorting) const HyperMenuItem(id: 'asc', label: '升序'),
      if (c.enableSorting) const HyperMenuItem(id: 'desc', label: '降序'),
      const HyperMenuItem(id: 'clear', label: '清除排序'),
      const HyperMenuItem(id: 'start', label: '固定到起始侧'),
      const HyperMenuItem(id: 'end', label: '固定到末尾侧'),
      const HyperMenuItem(id: 'unpin', label: '取消固定'),
      HyperMenuItem(
        id: 'hide',
        label: '隐藏此列',
        enabled:
            _columns
                .where((c) => !c.hide && !c.field.startsWith('__hyper_'))
                .length >
            1,
      ),
      HyperMenuItem(
        id: 'show',
        label: '显示隐藏列',
        children: [
          for (final x in _columns.where((c) => c.hide))
            HyperMenuItem(id: 'show:${x.field}', label: x.title),
        ],
      ),
    ],
    onSelected: (id) {
      switch (id) {
        case 'asc':
          sort(HyperTableSort(c.field, HyperTableSortDirection.ascending));
        case 'desc':
          sort(HyperTableSort(c.field, HyperTableSortDirection.descending));
        case 'clear':
          sort(null);
        case 'start':
          pinColumn(c.field, HyperTableColumnPin.start);
        case 'end':
          pinColumn(c.field, HyperTableColumnPin.end);
        case 'unpin':
          pinColumn(c.field, HyperTableColumnPin.none);
        case 'hide':
          setColumnVisible(c.field, false);
        default:
          if (id.startsWith('show:')) setColumnVisible(id.substring(5), true);
      }
    },
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: _resolved!.horizontalPadding!),
      child: Row(
        children: [
          Expanded(
            child: Align(
              alignment: switch (c.titleTextAlign) {
                trina.TrinaColumnTextAlign.left => Alignment.centerLeft,
                trina.TrinaColumnTextAlign.right => Alignment.centerRight,
                trina.TrinaColumnTextAlign.center => Alignment.center,
                trina.TrinaColumnTextAlign.end =>
                  AlignmentDirectional.centerEnd,
                trina.TrinaColumnTextAlign.start =>
                  AlignmentDirectional.centerStart,
              },
              child: Text(
                c.title,
                style: _resolved!.headerTextStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          if (c.sort != trina.TrinaColumnSort.none)
            Icon(
              c.sort == trina.TrinaColumnSort.ascending
                  ? Icons.arrow_upward
                  : Icons.arrow_downward,
              size: _resolved!.iconSize,
            ),
          if (c.enableDropToResize)
            MouseRegion(
              cursor: SystemMouseCursors.resizeColumn,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onHorizontalDragUpdate: (details) => _manager?.resizeColumn(
                  c,
                  details.delta.dx *
                      (Directionality.of(context) == TextDirection.rtl
                          ? -1
                          : 1),
                ),
                child: SizedBox(
                  width: _resolved!.iconSize,
                  height: double.infinity,
                  child: Icon(
                    Icons.drag_indicator,
                    size: _resolved!.iconSize,
                    color: _resolved!.borderColor,
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
  );
  BorderRadius _liftSegmentRadius(BuildContext segmentContext) {
    final stack =
        _rowsStackKey.currentContext?.findRenderObject() as RenderBox?;
    final segment = segmentContext.findRenderObject() as RenderBox?;
    if (stack == null || segment == null || !segment.hasSize) {
      return BorderRadius.zero;
    }
    final left = stack.globalToLocal(segment.localToGlobal(Offset.zero)).dx;
    final contentLeft = _rowLeadingInset(stack.size.width);
    final contentRight = contentLeft + _visibleRowWidth(stack.size.width);
    final radius = Radius.circular(_resolved!.liftRadius!);
    return BorderRadius.only(
      topLeft: left <= contentLeft + .5 ? radius : Radius.zero,
      bottomLeft: left <= contentLeft + .5 ? radius : Radius.zero,
      topRight: left + segment.size.width >= contentRight - .5
          ? radius
          : Radius.zero,
      bottomRight: left + segment.size.width >= contentRight - .5
          ? radius
          : Radius.zero,
    );
  }

  Widget _rowSurface(
    BuildContext context,
    Widget child,
    trina.TrinaRow row,
    trina.TrinaGridStateManager manager,
  ) {
    final data = row.data as T, key = widget.rowKey(data);
    final surface = ValueListenableBuilder<Object?>(
      key: ValueKey(key),
      valueListenable: _hoveredRow,
      builder: (context, hovered, _) {
        final s = _resolved!, index = manager.rows.indexOf(row);
        // Each separator belongs to the preceding row. Hide both edges of
        // the lifted row, including the separator painted by its neighbour.
        final hideSeparator =
            widget.hoverLift &&
            !_draggingRow &&
            hovered != null &&
            (hovered == key ||
                (index + 1 < manager.rows.length &&
                    widget.rowKey(manager.rows[index + 1].data as T) ==
                        hovered));
        return MouseRegion(
          onEnter: (_) {
            if (!_draggingRow) {
              _hoveredRow.value = key;
              _showHoverLift(context);
            }
          },
          onExit: (_) {
            if (_hoveredRow.value == key) {
              _hoveredRow.value = null;
              _hoverLiftRect.value = null;
            }
          },
          child: AnimatedContainer(
            duration: MediaQuery.of(context).disableAnimations
                ? Duration.zero
                : (widget.hoverLift ? s.liftDuration! : s.duration!),
            curve: s.curve!,
            decoration: BoxDecoration(color: s.background),
            child: ColoredBox(
              color: widget.striped && index.isOdd
                  ? s.stripeBackground!
                  : Colors.transparent,
              child: AnimatedContainer(
                duration: MediaQuery.of(context).disableAnimations
                    ? Duration.zero
                    : (widget.hoverLift ? s.liftDuration! : s.duration!),
                curve: s.curve!,
                foregroundDecoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: hideSeparator
                          ? s.borderColor!.withValues(alpha: 0)
                          : s.borderColor!,
                      width: s.borderWidth!,
                    ),
                  ),
                ),
                // A missing decoration fades the state color's alpha without
                // interpolating its RGB channels from transparent black.
                decoration: widget.selectedKeys.contains(key)
                    ? BoxDecoration(
                        color: widget.hoverLift && hovered == key
                            ? s.liftBackground ?? s.selectedBackground
                            : s.selectedBackground,
                        borderRadius: widget.hoverLift && hovered == key
                            ? _liftSegmentRadius(context)
                            : null,
                      )
                    : hovered == key
                    ? BoxDecoration(
                        color: widget.hoverLift
                            ? s.liftBackground
                            : s.hoverBackground,
                        borderRadius: widget.hoverLift
                            ? _liftSegmentRadius(context)
                            : null,
                      )
                    : null,
                child: child,
              ),
            ),
          ),
        );
      },
    );
    final content = _canReorderRows
        ? DragTarget<trina.TrinaRow>(
            onWillAcceptWithDetails: (details) => details.data.key != row.key,
            onAcceptWithDetails: (details) {
              final index = manager.rows.indexOf(row);
              if (index >= 0) manager.moveRowsByIndex([details.data], index);
            },
            builder: (context, candidates, rejected) => AnimatedContainer(
              duration: MediaQuery.of(context).disableAnimations
                  ? Duration.zero
                  : _resolved!.duration!,
              curve: _resolved!.curve!,
              foregroundDecoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: candidates.isEmpty
                        ? Colors.transparent
                        : _resolved!.focusColor!,
                    width: _resolved!.borderWidth!,
                  ),
                ),
              ),
              child: surface,
            ),
          )
        : surface;
    return widget.rowContextMenuBuilder == null
        ? content
        : HyperContextMenu(
            key: ValueKey(key),
            items: widget.rowContextMenuBuilder!(context, data),
            child: content,
          );
  }

  void _releaseManager() {
    widget.controller?._detach(this);
    _manager?.removeListener(_managerChanged);
    _manager = null;
  }

  void _managerChanged() {
    if (_columnViewportWidth != null && !_applyingMetrics) {
      _scheduleColumnLayout(_columnViewportWidth!);
    }
    final m = _manager;
    if (m == null) return;
    for (final c in m.refColumns.originalList) {
      if (_knownWidths[c.field] != c.width) {
        _knownWidths[c.field] = c.width;
        if (!_applyingMetrics) _userSized.add(c.field);
        if (!c.field.startsWith('__hyper_')) {
          widget.onColumnWidthChanged?.call(c.field, c.width);
        }
      }
    }
  }

  void _replaceRows() {
    _gridRows = _rows();
    final m = _manager;
    if (m != null) {
      m.removeAllRows(notify: false);
      m.appendRows(_gridRows);
      _syncSelection();
    }
  }

  @override
  Future<void> reload() {
    widget.onRefreshRequested?.call();
    return _load(reset: true);
  }

  Future<void> _load({bool reset = false}) async {
    if (!_remoteMode || widget.loader == null) {
      if (mounted) {
        setState(() {
          _childrenEpoch++;
          _children.clear();
          _childLoading.clear();
          _childErrors.clear();
          _replaceRows();
        });
      }
      return;
    }
    if (_loading && !reset) return;
    final epoch = ++_request;
    if (reset) {
      final pageChanged = _page != 1;
      _page = 1;
      if (pageChanged) widget.onPageChanged?.call(_page);
      _cursor = null;
      _childrenEpoch++;
      _children.clear();
      _childLoading.clear();
      _childErrors.clear();
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await widget.loader!(
        HyperTableQuery(
          page: _page,
          pageSize: widget.pageSize,
          cursor: _cursor,
          sort: _sort,
          refresh: reset,
        ),
      );
      if (!mounted || epoch != _request) return;
      final rows = reset || widget.dataMode == HyperTableDataMode.paginated
          ? result.items
          : [..._remote, ...result.items];
      final keys = <Object>{};
      for (final row in rows) {
        if (!keys.add(widget.rowKey(row))) {
          throw StateError('Loader returned duplicate row keys.');
        }
      }
      if (widget.dataMode == HyperTableDataMode.paginated &&
          result.total == null) {
        throw StateError('Paginated loaders must return total.');
      }
      if (result.total != null && result.total! < 0) {
        throw StateError('Page totals must be non-negative.');
      }
      if (widget.dataMode == HyperTableDataMode.infinite &&
          result.hasMore &&
          result.items.isEmpty) {
        throw StateError('An unfinished page must contain rows.');
      }
      if (widget.dataMode == HyperTableDataMode.paginated) {
        final lastPage = math.max(1, (result.total! / widget.pageSize).ceil());
        if (_page > lastPage) {
          _page = lastPage;
          widget.onPageChanged?.call(_page);
          _loading = false;
          await _load();
          return;
        }
      }
      setState(() {
        _remote = List.of(rows);
        _total = result.total;
        _cursor = result.nextCursor;
        _hasMore = result.hasMore;
        _loading = false;
        _replaceRows();
      });
      if (widget.dataMode == HyperTableDataMode.infinite && _hasMore) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted || _loading || _error != null) return;
          final scroll = _manager?.scroll.bodyRowsVertical;
          if (scroll != null &&
              scroll.hasClients &&
              scroll.position.maxScrollExtent <= 0) {
            _requestMore();
          }
        });
      }
    } catch (error) {
      if (mounted && epoch == _request) {
        setState(() {
          _error = error;
          _failedReset = reset;
          _loading = false;
        });
      }
    }
  }

  @override
  void goToPage(int page) {
    if (page < 1 || _loading || page == _page) return;
    final count = math.max(
      1,
      ((_remoteMode ? _total ?? 0 : widget.rows.length) / widget.pageSize)
          .ceil(),
    );
    if (page > count) return;
    setState(() {
      _page = page;
      _cursor = null;
    });
    widget.onPageChanged?.call(_page);
    if (_remoteMode) {
      unawaited(_load());
    } else {
      setState(_replaceRows);
    }
  }

  trina.TrinaColumn _column(String id) =>
      _columns.firstWhere((c) => c.field == id);
  @override
  void setColumnVisible(String id, bool visible) {
    final c = _column(id);
    if (!visible &&
        _columns
                .where((c) => !c.hide && !c.field.startsWith('__hyper_'))
                .length <=
            1) {
      return;
    }
    _manager?.hideColumn(c, !visible);
    widget.onColumnVisibilityChanged?.call(id, visible);
  }

  @override
  void setColumnWidth(String id, double width) {
    if (!width.isFinite || width <= 0) {
      throw ArgumentError.value(width, 'width');
    }
    final c = _column(id);
    _manager?.resizeColumn(c, math.max(c.minWidth, width) - c.width);
  }

  @override
  void pinColumn(String id, HyperTableColumnPin pin) =>
      _manager?.toggleFrozenColumn(_column(id), _pin(pin));
  @override
  void moveColumn(String id, int index) {
    final m = _manager;
    if (m == null) return;
    final cols = m.columns
        .where((c) => !c.field.startsWith('__hyper_'))
        .toList();
    if (index < 0 || index >= cols.length) throw RangeError.index(index, cols);
    m.moveColumn(column: _column(id), targetColumn: cols[index]);
  }

  @override
  void sort(HyperTableSort? sort) {
    if (sort != null) _column(sort.columnId);
    _sort = sort;
    for (final c in _columns.where((c) => c.field == '__hyper_drag')) {
      c.enableRowDrag = false;
    }
    widget.onSortChanged?.call(sort);
    if (_remoteMode) {
      unawaited(reload());
    } else {
      setState(_replaceRows);
    }
    final m = _manager;
    if (m != null) {
      for (final c in _columns) {
        c.sort = trina.TrinaColumnSort.none;
      }
      if (sort != null) {
        _column(sort.columnId)
            .sort = sort.direction == HyperTableSortDirection.ascending
            ? trina.TrinaColumnSort.ascending
            : trina.TrinaColumnSort.descending;
      }
      m.notifyListeners();
    }
  }

  void _requestMore() {
    if (_loading || !_hasMore) return;
    _page++;
    widget.onPageChanged?.call(_page);
    unawaited(_load());
  }

  bool _scroll(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification &&
        _hoverLiftRect.value != null) {
      _hoverLiftRect.value = null;
    }
    if (widget.dataMode == HyperTableDataMode.infinite &&
        notification.metrics.axis == Axis.vertical &&
        notification.metrics.extentAfter <=
            notification.metrics.viewportDimension &&
        _hasMore &&
        !_loading &&
        _error == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _requestMore();
      });
    }
    return false;
  }

  @override
  void deactivate() {
    widget.controller?._detach(this);
    super.deactivate();
  }

  @override
  void activate() {
    super.activate();
    if (_manager != null) widget.controller?._attach(this);
  }

  @override
  void dispose() {
    _request++;
    _childrenEpoch++;
    _captureEpoch++;
    _dragSnapshot.value?.dispose();
    _dragSnapshot.dispose();
    _hoverLiftRect.dispose();
    _hoveredRow.dispose();
    widget.controller?._detach(this);
    _releaseManager();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _resolve();
    final s = _resolved!;
    final scaler = MediaQuery.textScalerOf(context);
    final font =
        s.textStyle?.fontSize ?? DefaultTextStyle.of(context).style.fontSize!;
    final headerFont = s.headerTextStyle?.fontSize ?? font;
    final rowHeight = math.max(
      s.rowHeight!,
      scaler.scale(font) * (s.textStyle?.height ?? 1.5) +
          2 * s.verticalPadding!,
    );
    final headerHeight = math.max(
      s.headerHeight!,
      scaler.scale(headerFont) * (s.headerTextStyle?.height ?? 1.5) +
          2 * s.verticalPadding!,
    );
    final radius = BorderRadius.circular(s.radius!);
    return LayoutBuilder(
      builder: (context, constraints) {
        _scheduleColumnLayout(constraints.maxWidth);
        return RepaintBoundary(
          key: _captureKey,
          child: HyperMaterialSurface(
            material: s.material,
            quality: s.materialQuality,
            reduceTransparency: s.reduceTransparency,
            semanticBackground: HyperFill.color(s.background!),
            border: Border.all(color: s.borderColor!, width: s.borderWidth!),
            borderRadius: radius,
            boxShadow: s.boxShadow,
            child: ClipRRect(
              borderRadius: radius,
              child: Column(
                children: [
                  Expanded(
                    child: ClipRect(
                      child: Stack(
                        key: _rowsStackKey,
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            height: headerHeight,
                            child: ColoredBox(color: s.headerBackground!),
                          ),
                          Positioned.fill(
                            child: NotificationListener<ScrollNotification>(
                              onNotification: _scroll,
                              child: trina.TrinaGrid(
                                key: ValueKey(_gridVersion),
                                columns: _columns,
                                rows: _gridRows,
                                configuration: trina.TrinaGridConfiguration(
                                  rowWrapperIsConstantHeight: true,
                                  enableAutoSelectFirstRow: false,
                                  selectingMode:
                                      trina.TrinaGridSelectingMode.row,
                                  localeText:
                                      const trina.TrinaGridLocaleText.china(),
                                  scrollbar: trina.TrinaGridScrollbarConfig(
                                    showHorizontal: _horizontalOverflow,
                                    thickness:
                                        s.scrollbarTheme?.thickness?.resolve(
                                          {},
                                        ) ??
                                        const trina.TrinaGridScrollbarConfig()
                                            .thickness,
                                    minThumbLength:
                                        s.scrollbarTheme?.minThumbLength ??
                                        const trina.TrinaGridScrollbarConfig()
                                            .minThumbLength,
                                    radius: s.scrollbarTheme?.radius?.x,
                                    thumbColor:
                                        s.scrollbarTheme?.thumbColor?.resolve(
                                          {},
                                        ) ??
                                        s.borderColor,
                                    thumbHoverColor:
                                        s.scrollbarTheme?.thumbColor?.resolve({
                                          WidgetState.hovered,
                                        }) ??
                                        s.focusColor,
                                    trackColor:
                                        s.scrollbarTheme?.trackColor?.resolve(
                                          {},
                                        ) ??
                                        Colors.transparent,
                                  ),
                                  style: trina.TrinaGridStyleConfig(
                                    enableGridBorderShadow: false,
                                    gridPadding: 0,
                                    enableColumnBorderVertical: false,
                                    enableColumnBorderHorizontal: false,
                                    enableRowHoverColor: false,
                                    gridBackgroundColor: Colors.transparent,
                                    rowColor: Colors.transparent,
                                    oddRowColor: Colors.transparent,
                                    evenRowColor: Colors.transparent,
                                    rowHoveredColor: Colors.transparent,
                                    rowCheckedColor: Colors.transparent,
                                    activatedColor: Colors.transparent,
                                    gridBorderWidth: 0,
                                    gridBorderColor: s.borderColor!,
                                    borderColor: s.borderColor!,
                                    activatedBorderColor:
                                        widget.selectionMode ==
                                            HyperTableSelectionMode.none
                                        ? s.focusColor!
                                        : Colors.transparent,
                                    inactivatedBorderColor:
                                        widget.selectionMode ==
                                            HyperTableSelectionMode.none
                                        ? s.borderColor!
                                        : Colors.transparent,
                                    enableCellBorderVertical: false,
                                    enableCellBorderHorizontal: false,
                                    // Row separators are painted inside _rowSurface. Do not
                                    // reserve an additional native separator slot.
                                    cellHorizontalBorderWidth: 0,
                                    rowHeight: rowHeight,
                                    columnHeight: headerHeight,
                                    defaultCellPadding: EdgeInsets.symmetric(
                                      horizontal: s.horizontalPadding!,
                                    ),
                                    defaultColumnTitlePadding:
                                        EdgeInsets.symmetric(
                                          horizontal: s.horizontalPadding!,
                                        ),
                                    columnTextStyle: s.headerTextStyle!,
                                    cellTextStyle: s.textStyle!,
                                    iconSize: s.iconSize!,
                                    iconColor: s.textStyle!.color!,
                                    cellColorInEditState: Colors.transparent,
                                    cellColorInReadOnlyState:
                                        Colors.transparent,
                                    cellReadonlyColor: null,
                                    cellDefaultColor: null,
                                    filterHeaderColor: s.headerBackground,
                                  ),
                                ),
                                onLoaded: (e) {
                                  _releaseManager();
                                  _manager = e.stateManager;
                                  widget.controller?._attach(this);
                                  _manager!.setSortOnlyEvent(true);
                                  _manager!.addListener(_managerChanged);
                                  _syncSelection();
                                  if (_columnViewportWidth != null) {
                                    _scheduleColumnLayout(
                                      _columnViewportWidth!,
                                    );
                                  }
                                },
                                onSelected: _selectRow,
                                onSorted: (e) => sort(
                                  e.column.sort == trina.TrinaColumnSort.none
                                      ? null
                                      : HyperTableSort(
                                          e.column.field,
                                          e.column.sort ==
                                                  trina
                                                      .TrinaColumnSort
                                                      .ascending
                                              ? HyperTableSortDirection
                                                    .ascending
                                              : HyperTableSortDirection
                                                    .descending,
                                        ),
                                ),
                                onChanged: (e) => widget.onCellChanged?.call(
                                  HyperTableCellChange(
                                    row: e.row.data as T,
                                    rowKey: widget.rowKey(e.row.data as T),
                                    columnId: e.column.field,
                                    value: e.value,
                                    oldValue: e.oldValue,
                                  ),
                                ),
                                onColumnsMoved: (_) =>
                                    widget.onColumnsReordered?.call(
                                      _manager!.columns
                                          .where(
                                            (c) =>
                                                !c.field.startsWith('__hyper_'),
                                          )
                                          .map((c) => c.field)
                                          .toList(),
                                    ),
                                onRowsMoved: (_) {
                                  if (_sort != null || _paged || _remoteMode) {
                                    return;
                                  }
                                  widget.onRowsReordered?.call(
                                    _manager!.rows
                                        .map((r) => r.data as T)
                                        .toList(),
                                  );
                                },
                                onRowDoubleTap: widget.onRowDoubleTap == null
                                    ? null
                                    : (e) => widget.onRowDoubleTap!(
                                        e.row.data as T,
                                      ),
                                rowWrapper: _rowSurface,
                                editCellRenderer:
                                    (
                                      defaultEditor,
                                      cell,
                                      controller,
                                      focusNode,
                                      handleSelected,
                                    ) {
                                      final column = widget.columns.firstWhere(
                                        (c) => c.id == cell.column.field,
                                      );
                                      final original = cell.value;
                                      if (column.editorBuilder != null) {
                                        var finished = false;
                                        void finish(
                                          Object? value, {
                                          bool cancelled = false,
                                        }) {
                                          if (finished ||
                                              !mounted ||
                                              _manager?.currentCell != cell ||
                                              _manager?.isEditing != true) {
                                            return;
                                          }
                                          finished = true;
                                          controller.text = '${value ?? ''}';
                                          if (!cancelled) {
                                            _manager!.changeCellValue(
                                              cell,
                                              value,
                                            );
                                          }
                                          _manager!.setEditing(false);
                                        }

                                        return column.editorBuilder!(
                                          context,
                                          HyperTableEditContext<T>(
                                            row: cell.row.data as T,
                                            rowKey: widget.rowKey(
                                              cell.row.data as T,
                                            ),
                                            columnId: column.id,
                                            value: original,
                                            controller: controller,
                                            focusNode: focusNode,
                                            commit: (value) => finish(value),
                                            cancel: () => finish(
                                              original,
                                              cancelled: true,
                                            ),
                                          ),
                                        );
                                      }
                                      final inputMetrics = HyperTheme.sizesOf(
                                        context,
                                      ).textField;
                                      final editorHeight = math.min(
                                        rowHeight,
                                        math.max(
                                          inputMetrics.minimumHeight,
                                          scaler.scale(font) *
                                              (s.textStyle?.height ?? 1.5),
                                        ),
                                      );
                                      return TapRegion(
                                        onTapOutside: (_) =>
                                            focusNode.unfocus(),
                                        child: Focus(
                                          onFocusChange: (focused) {
                                            if (focused) return;
                                            WidgetsBinding.instance
                                                .addPostFrameCallback((_) {
                                                  if (!mounted ||
                                                      focusNode.hasFocus ||
                                                      _manager?.currentCell !=
                                                          cell ||
                                                      _manager?.isEditing !=
                                                          true) {
                                                    return;
                                                  }
                                                  _manager!.setEditing(false);
                                                });
                                          },
                                          child: Center(
                                            child: SizedBox(
                                              height: editorHeight,
                                              child: HyperTextField(
                                                controller: controller,
                                                focusNode: focusNode,
                                                textAlign: widget.columns
                                                    .firstWhere(
                                                      (c) =>
                                                          c.id ==
                                                          cell.column.field,
                                                    )
                                                    .textAlign,
                                                style: HyperTextFieldStyle(
                                                  minimumHeight: editorHeight,
                                                  height: editorHeight,
                                                  textAlignVertical:
                                                      TextAlignVertical.center,
                                                ).merge(s.editorStyle),
                                                onSubmitted: (_) =>
                                                    _manager?.setEditing(false),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: IgnorePointer(
                              child: ValueListenableBuilder<Rect?>(
                                valueListenable: _hoverLiftRect,
                                builder: (context, rect, _) => AnimatedSwitcher(
                                  duration:
                                      MediaQuery.of(context).disableAnimations
                                      ? Duration.zero
                                      : s.liftDuration!,
                                  switchInCurve: s.curve!,
                                  switchOutCurve: s.curve!,
                                  // Interpolate paint parameters directly. Opacity
                                  // compositing of blurred shadows can trigger an
                                  // unsupported inherited-opacity path in Impeller.
                                  transitionBuilder: (child, animation) {
                                    if (child is! CustomPaint ||
                                        child.painter
                                            is! _HyperTableLiftPainter) {
                                      // Keep the child's identity inside an unkeyed
                                      // transition root. AnimatedSwitcher supplies
                                      // a unique key for each concurrent entry.
                                      return SizedBox.expand(child: child);
                                    }
                                    final shadow =
                                        child.painter!
                                            as _HyperTableLiftPainter;
                                    return AnimatedBuilder(
                                      animation: Listenable.merge([
                                        animation,
                                        _hoverLiftRect,
                                      ]),
                                      builder: (context, _) => CustomPaint(
                                        painter: _HyperTableLiftPainter(
                                          rect: shadow.rect,
                                          protectedRect: _hoverLiftRect.value,
                                          shadows:
                                              BoxShadow.lerpList(
                                                const [],
                                                shadow.shadows,
                                                animation.value,
                                              ) ??
                                              const [],
                                          headerHeight: shadow.headerHeight,
                                          radius: shadow.radius,
                                          border: BorderSide.lerp(
                                            BorderSide.none,
                                            shadow.border,
                                            animation.value,
                                          ),
                                        ),
                                        child: const SizedBox.expand(),
                                      ),
                                    );
                                  },
                                  child:
                                      rect != null &&
                                          widget.hoverLift &&
                                          !_draggingRow
                                      ? CustomPaint(
                                          key: ValueKey(rect),
                                          painter: _HyperTableLiftPainter(
                                            rect: rect,
                                            shadows: s.rowBoxShadow ?? const [],
                                            radius: s.liftRadius!,
                                            border: s.liftBorder!,
                                            headerHeight: headerHeight,
                                          ),
                                          child: const SizedBox.expand(),
                                        )
                                      : const SizedBox.expand(
                                          key: ValueKey('no-row-lift'),
                                        ),
                                ),
                              ),
                            ),
                          ),
                          if (_loading)
                            Positioned(
                              top: headerHeight,
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: IgnorePointer(
                                child: _data.isEmpty
                                    ? Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const HyperProgress.infinite(
                                              semanticsLabel: '加载中',
                                            ),
                                            SizedBox(
                                              height: s.verticalPadding! * 2,
                                            ),
                                            Text('加载中…', style: s.textStyle),
                                          ],
                                        ),
                                      )
                                    : Align(
                                        alignment: AlignmentDirectional.topEnd,
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                            s.horizontalPadding!,
                                          ),
                                          child: const HyperProgress.infinite(
                                            semanticsLabel: '加载中',
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                          if (_data.isEmpty && !_loading && _error != null)
                            Positioned(
                              top: headerHeight,
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: Center(
                                child: HyperResult(
                                  status: HyperResultStatus.error,
                                  title: '加载失败',
                                  description: '请重试加载数据',
                                  actions: [
                                    HyperButton.tonal(
                                      onPressed: () =>
                                          _load(reset: _failedReset),
                                      child: const Text('重新加载'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          if (_data.isEmpty && !_loading && _error == null)
                            Positioned(
                              top: headerHeight,
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: Center(
                                child:
                                    widget.empty ??
                                    const HyperResult.empty(title: '暂无数据'),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  if (_error != null && _data.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: s.horizontalPadding!,
                        vertical: s.verticalPadding!,
                      ),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: s.horizontalPadding!,
                        children: [
                          Text('加载失败，已保留当前数据', style: s.textStyle),
                          HyperButton.text(
                            onPressed: () => _load(reset: _failedReset),
                            child: const Text('重试'),
                          ),
                        ],
                      ),
                    ),
                  if (widget.showPagination &&
                      _paged &&
                      (_data.isNotEmpty || (_total ?? 0) > 0))
                    SizedBox(
                      width: double.infinity,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: s.background,
                          border: Border(
                            top: BorderSide(
                              color: s.borderColor!,
                              width: s.borderWidth!,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: s.footerPadding!,
                          child: Center(
                            child: HyperPagination(
                              pageCount: math.max(
                                1,
                                ((_remoteMode
                                            ? _total ?? 0
                                            : widget.rows.length) /
                                        widget.pageSize)
                                    .ceil(),
                              ),
                              currentPage: _page,
                              onPageChanged: goToPage,
                              enabled: !_loading,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (widget.dataMode == HyperTableDataMode.infinite &&
                      _hasMore &&
                      !_loading &&
                      _error == null)
                    HyperButton.text(
                      onPressed: () {
                        _requestMore();
                      },
                      child: const Text('加载更多'),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Paint above all grid segments so later rows cannot cover the lifted shadow.
// Excluding the row interior keeps its live controls and colors untouched.
class _HyperTableLiftPainter extends CustomPainter {
  const _HyperTableLiftPainter({
    required this.rect,
    required this.shadows,
    required this.headerHeight,
    required this.radius,
    required this.border,
    this.protectedRect,
  });
  final Rect? rect;
  final Rect? protectedRect;
  final List<BoxShadow> shadows;
  final double headerHeight;
  final double radius;
  final BorderSide border;
  @override
  void paint(Canvas canvas, Size size) {
    final row = rect;
    if (row == null) return;
    final bounds = Rect.fromLTWH(
      0,
      headerHeight,
      size.width,
      math.max(0, size.height - headerHeight),
    );
    canvas.save();
    canvas.clipPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(bounds),
        Path()..addRRect(RRect.fromRectAndRadius(row, Radius.circular(radius))),
      ),
    );
    // An outgoing row's shadow must not tint the newly lifted surface.
    if (protectedRect case final active? when active != row) {
      canvas.clipPath(
        Path.combine(
          PathOperation.difference,
          Path()..addRect(bounds),
          Path()..addRRect(
            RRect.fromRectAndRadius(active, Radius.circular(radius)),
          ),
        ),
      );
    }
    final painter = BoxDecoration(
      boxShadow: shadows,
      borderRadius: BorderRadius.circular(radius),
    ).createBoxPainter();
    painter.paint(canvas, row.topLeft, ImageConfiguration(size: row.size));
    painter.dispose();
    canvas.restore();
    if (border.style != BorderStyle.none && border.width > 0) {
      canvas.save();
      canvas.clipRect(bounds);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          row.deflate(border.width / 2),
          Radius.circular(math.max(0, radius - border.width / 2)),
        ),
        border.toPaint(),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_HyperTableLiftPainter oldDelegate) =>
      oldDelegate.rect != rect ||
      oldDelegate.protectedRect != protectedRect ||
      oldDelegate.shadows != shadows ||
      oldDelegate.headerHeight != headerHeight ||
      oldDelegate.radius != radius ||
      oldDelegate.border != border;
}
