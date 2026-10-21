part of 'hyper_table.dart';

enum HyperTableColumnType { text, number }

/// Fixed width, measured loaded content, or a share of available space.
enum HyperTableColumnWidthMode { fixed, content, flex }

enum HyperTableColumnPin { none, start, end }

enum HyperTableDataMode { local, paginated, infinite }

enum HyperTableSelectionMode { none, single, multiple }

enum HyperTableSortDirection { ascending, descending }

/// A column with stable identity, a value reader and optional custom content.
@immutable
final class HyperTableColumn<T> {
  const HyperTableColumn({
    required this.id,
    required this.title,
    required this.value,
    this.type = HyperTableColumnType.text,
    this.width,
    this.minWidth,
    this.widthMode = HyperTableColumnWidthMode.fixed,
    this.flex = 1,
    this.pin = HyperTableColumnPin.none,
    this.hidden = false,
    this.sortable = true,
    this.resizable = true,
    this.reorderable = true,
    this.editable = false,
    this.textAlign = TextAlign.center,
    this.headerTextAlign = TextAlign.center,
    this.cellBuilder,
    this.editorBuilder,
  }) : assert(width == null || width > 0),
       assert(minWidth == null || minWidth > 0),
       assert(flex > 0);
  final String id, title;
  final Object? Function(T row) value;
  final HyperTableColumnType type;
  final double? width, minWidth;
  final HyperTableColumnWidthMode widthMode;

  /// Relative share of remaining space in flex mode; equal values split evenly.
  final double flex;
  final HyperTableColumnPin pin;
  final bool hidden, sortable, resizable, reorderable, editable;
  final TextAlign textAlign;

  /// Header alignment, independent of cell content alignment.
  final TextAlign headerTextAlign;
  final Widget Function(BuildContext context, T row, Object? value)?
  cellBuilder;

  /// Builds the editor used after this editable column enters edit mode.
  final Widget Function(BuildContext context, HyperTableEditContext<T> edit)?
  editorBuilder;
}

/// The current cell editing session. Controllers are owned by the table.
///
/// Custom editors must not dispose [controller] or [focusNode]. Values follow
/// the column's text or number conversion when committed.
@immutable
final class HyperTableEditContext<T> {
  const HyperTableEditContext({
    required this.row,
    required this.rowKey,
    required this.columnId,
    required this.value,
    required this.controller,
    required this.focusNode,
    required this.commit,
    required this.cancel,
  });

  final T row;
  final Object rowKey;
  final String columnId;
  final Object? value;
  final TextEditingController controller;
  final FocusNode focusNode;

  /// Commits a value through the table's normal cell change callback.
  final ValueChanged<Object?> commit;

  /// Restores the value captured when the editor was built and exits editing.
  final VoidCallback cancel;
}

@immutable
final class HyperTableSort {
  const HyperTableSort(this.columnId, this.direction);
  final String columnId;
  final HyperTableSortDirection direction;
}

/// A page request; sorting is delegated to the loader for remote data.
@immutable
final class HyperTableQuery {
  const HyperTableQuery({
    required this.page,
    required this.pageSize,
    this.cursor,
    this.sort,
    this.refresh = false,
  });

  /// Reloads from the first page instead of appending another page.
  final bool refresh;
  final int page, pageSize;
  final String? cursor;
  final HyperTableSort? sort;
}

@immutable
final class HyperTablePage<T> {
  const HyperTablePage({
    required this.items,
    this.total,
    this.nextCursor,
    this.hasMore = false,
  });
  final List<T> items;
  final int? total;
  final String? nextCursor;
  final bool hasMore;
}

typedef HyperTableLoader<T> = Future<HyperTablePage<T>> Function(
  HyperTableQuery query,
);
typedef HyperTableContextMenuBuilder<T> = List<HyperMenuItem> Function(
  BuildContext context,
  T row,
);

/// A committed cell change; the caller persists it in the source model.
@immutable
final class HyperTableCellChange<T> {
  const HyperTableCellChange({
    required this.row,
    required this.rowKey,
    required this.columnId,
    required this.value,
    required this.oldValue,
  });
  final T row;
  final Object rowKey;
  final String columnId;
  final Object? value, oldValue;
}

/// Commands for one mounted table; no third-party types cross this boundary.
final class HyperTableController {
  _HyperTableCommands? _commands;
  bool get attached => _commands != null;
  Future<void> reload() async => await _commands?.reload();
  void goToPage(int page) => _commands?.goToPage(page);
  void setColumnVisible(String id, bool visible) =>
      _commands?.setColumnVisible(id, visible);
  void setColumnWidth(String id, double width) =>
      _commands?.setColumnWidth(id, width);
  void pinColumn(String id, HyperTableColumnPin pin) =>
      _commands?.pinColumn(id, pin);
  void moveColumn(String id, int index) => _commands?.moveColumn(id, index);
  void sort(HyperTableSort? sort) => _commands?.sort(sort);
  void _attach(_HyperTableCommands commands) {
    if (_commands != null && !identical(_commands, commands)) {
      throw StateError('A HyperTableController can attach to only one table.');
    }
    _commands = commands;
  }

  void _detach(_HyperTableCommands commands) {
    if (identical(_commands, commands)) _commands = null;
  }
}

/// Internal adapter protocol used by the table controller.
abstract interface class _HyperTableCommands {
  Future<void> reload();
  void goToPage(int page);
  void setColumnVisible(String id, bool visible);
  void setColumnWidth(String id, double width);
  void pinColumn(String id, HyperTableColumnPin pin);
  void moveColumn(String id, int index);
  void sort(HyperTableSort? sort);
}
