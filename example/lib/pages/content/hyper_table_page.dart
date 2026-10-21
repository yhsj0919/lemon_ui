import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

class HyperTableDemoPage extends StatefulWidget {
  const HyperTableDemoPage({super.key});
  @override
  State<HyperTableDemoPage> createState() => _HyperTablePageState();
}

class _TreeRecord {
  const _TreeRecord(this.id, this.name, this.depth, {this.children = const []});
  final String id, name;
  final int depth;
  final List<_TreeRecord> children;
}

enum _TablePreviewState { normal, empty, loading, error, filtered }

class _Record {
  const _Record(this.id, this.name, this.department, this.amount);
  final int id, amount;
  final String name, department;
}

class _HyperTablePageState extends State<HyperTableDemoPage> {
  _TablePreviewState _previewState = _TablePreviewState.normal;
  Completer<void>? _pendingPreview;
  bool _previewFailNext = false;

  void _setPreviewState(_TablePreviewState state) {
    _pendingPreview?.complete();
    _pendingPreview = state == _TablePreviewState.loading
        ? Completer<void>()
        : null;
    setState(() {
      _previewState = state;
      _previewFailNext = state == _TablePreviewState.error;
      _selected = {};
    });
  }

  Future<HyperTablePage<_Record>> _loadPreview(HyperTableQuery query) async {
    if (_previewState == _TablePreviewState.loading) {
      await _pendingPreview!.future;
      return const HyperTablePage(items: [], total: 0);
    }
    if (_previewFailNext) {
      _previewFailNext = false;
      throw StateError('演示加载失败');
    }
    return _load(query);
  }

  @override
  void dispose() {
    _pendingPreview?.complete();
    super.dispose();
  }

  final _controller = HyperTableController();
  final _asyncTreeController = HyperTableController();
  bool _failChild = false;
  int _childFetches = 0;
  Set<Object> _treeSelection = {};
  late final _treeColumns = <HyperTableColumn<_TreeRecord>>[
    HyperTableColumn(id: 'name', title: '名称', value: (r) => r.name),
    HyperTableColumn(id: 'id', title: '标识', value: (r) => r.id),
    HyperTableColumn(
      id: 'depth',
      title: '深度',
      value: (r) => r.depth,
      type: HyperTableColumnType.number,
    ),
  ];
  static const _syncRoots = [
    _TreeRecord(
      'design',
      '设计',
      0,
      children: [
        _TreeRecord(
          'icons',
          '图标',
          1,
          children: [
            _TreeRecord('arrows', '箭头', 2),
            _TreeRecord('actions', '操作', 2),
          ],
        ),
        _TreeRecord('colors', '颜色', 1),
      ],
    ),
    _TreeRecord(
      'code',
      '研发',
      0,
      children: [
        _TreeRecord('components', '组件', 1),
        _TreeRecord('themes', '主题', 1),
      ],
    ),
  ];
  static const _asyncRoots = [
    _TreeRecord('remote-a', '异步目录 A', 0),
    _TreeRecord('remote-b', '异步目录 B', 0),
  ];
  Future<List<_TreeRecord>> _loadChildren(_TreeRecord row) async {
    setState(() => _childFetches++);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (_failChild) {
      _failChild = false;
      throw StateError('演示子级加载失败');
    }
    return List.generate(
      3,
      (i) => _TreeRecord(
        '${row.id}/$i',
        '${row.name} · 子项 ${i + 1}',
        row.depth + 1,
      ),
    );
  }

  List<_Record> _records = List.generate(
    120,
    (i) => _Record(i + 1, '项目 ${i + 1}', i.isEven ? '设计' : '研发', (i + 1) * 10),
  );
  Set<Object> _selected = {};
  HyperTableDataMode _mode = HyperTableDataMode.local;
  bool _paginate = false,
      _striped = true,
      _hoverLift = false,
      _showDepartment = true,
      _failNext = false;
  String _message = '表头可拖动、点击排序、右键打开列菜单；名称与数量使用输入框，部门使用自定义下拉编辑器。';
  late final List<HyperTableColumn<_Record>> _columns = [
    HyperTableColumn(
      id: 'id',
      title: '编号',
      value: (r) => r.id,
      type: HyperTableColumnType.number,
      pin: HyperTableColumnPin.start,
      width: 96,
      minWidth: 64,
    ),
    HyperTableColumn(
      id: 'name',
      title: '项目名称 · 可编辑',
      widthMode: HyperTableColumnWidthMode.flex,
      minWidth: 144,
      value: (r) => r.name,
      editable: true,
    ),
    HyperTableColumn(
      id: 'department',
      title: '部门 · 下拉编辑',
      widthMode: HyperTableColumnWidthMode.content,
      value: (r) => r.department,
      editable: true,
      editorBuilder: (context, edit) => Center(
        child: HyperSelect<String>(
          value: edit.value as String?,
          options: const [
            HyperSelectOption(value: '设计', label: '设计'),
            HyperSelectOption(value: '研发', label: '研发'),
            HyperSelectOption(value: '产品', label: '产品'),
          ],
          onChanged: (value) {
            if (value != null) edit.commit(value);
          },
        ),
      ),
    ),
    HyperTableColumn(
      id: 'amount',
      title: '数量 · 可编辑',
      width: 112,
      minWidth: 80,
      value: (r) => r.amount,
      type: HyperTableColumnType.number,
      editable: true,
      textAlign: TextAlign.end,
    ),
    HyperTableColumn(
      id: 'summary',
      title: '说明',
      widthMode: HyperTableColumnWidthMode.flex,
      flex: 2,
      minWidth: 160,
      value: (r) => '记录 ${r.id} 的附加说明',
    ),
  ];

  Future<HyperTablePage<_Record>> _load(HyperTableQuery q) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    if (_failNext) {
      _failNext = false;
      throw StateError('演示加载失败');
    }
    final data = List<_Record>.of(_records);
    if (q.sort != null) {
      final c = _columns.firstWhere((c) => c.id == q.sort!.columnId);
      data.sort((a, b) {
        final x = c.value(a), y = c.value(b);
        final result = x is num && y is num
            ? x.compareTo(y)
            : x.toString().compareTo(y.toString());
        return q.sort!.direction == HyperTableSortDirection.ascending
            ? result
            : -result;
      });
    }
    final start = int.tryParse(q.cursor ?? '') ?? (q.page - 1) * q.pageSize;
    final end = math.min(data.length, start + q.pageSize);
    return HyperTablePage(
      items: data.sublist(math.min(start, data.length), end),
      total: data.length,
      hasMore: end < data.length,
      nextCursor: end < data.length ? '$end' : null,
    );
  }

  void _edit(HyperTableCellChange<_Record> e) {
    setState(() {
      _records = [
        for (final r in _records)
          if (r.id == e.rowKey)
            _Record(
              r.id,
              e.columnId == 'name' ? '${e.value}' : r.name,
              e.columnId == 'department' ? '${e.value}' : r.department,
              e.columnId == 'amount' ? (e.value as num).round() : r.amount,
            )
          else
            r,
      ];
      _message = '记录 ${e.rowKey} 的 ${e.columnId} 已提交：${e.value}';
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = HyperTheme.sizesOf(context);
    return ListView(
      padding: EdgeInsets.all(s.pageHorizontalPadding),
      children: [
        const HyperText(
          'HyperTable · 未确认',
          variant: HyperTextVariant.pageTitle,
        ),
        const HyperText('默认主题审核：本页不覆盖实例样式。旧版只作功能对照，新版没有复制旧封装或补丁。'),
        SizedBox(height: s.compactSectionSpacing),
        Wrap(
          spacing: s.compactSectionSpacing,
          runSpacing: s.compactSectionSpacing,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              width: 220,
              child: HyperSelect<_TablePreviewState>(
                value: _previewState,
                onChanged: (value) {
                  if (value != null) _setPreviewState(value);
                },
                options: const [
                  HyperSelectOption(
                    value: _TablePreviewState.normal,
                    label: '状态：正常数据',
                  ),
                  HyperSelectOption(
                    value: _TablePreviewState.empty,
                    label: '状态：暂无数据',
                  ),
                  HyperSelectOption(
                    value: _TablePreviewState.loading,
                    label: '状态：加载中',
                  ),
                  HyperSelectOption(
                    value: _TablePreviewState.error,
                    label: '状态：加载失败 / 重试',
                  ),
                  HyperSelectOption(
                    value: _TablePreviewState.filtered,
                    label: '状态：业务自定义空态',
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 220,
              child: HyperSelect<HyperTableDataMode>(
                value: _mode,
                onChanged: (v) {
                  if (v != null) {
                    setState(() {
                      _mode = v;
                      _selected = {};
                    });
                  }
                },
                options: const [
                  HyperSelectOption(
                    value: HyperTableDataMode.local,
                    label: '本地数据',
                  ),
                  HyperSelectOption(
                    value: HyperTableDataMode.paginated,
                    label: '服务端分页',
                  ),
                  HyperSelectOption(
                    value: HyperTableDataMode.infinite,
                    label: '无限加载',
                  ),
                ],
              ),
            ),
            HyperButton.tonal(
              onPressed: () => setState(() => _paginate = !_paginate),
              child: Text(_paginate ? '关闭本地分页' : '开启本地分页'),
            ),
            HyperButton.tonal(
              onPressed: () => setState(() => _striped = !_striped),
              child: Text(_striped ? '关闭斑马色' : '开启斑马色'),
            ),
            HyperButton.tonal(
              onPressed: () => setState(() => _hoverLift = !_hoverLift),
              child: Text(_hoverLift ? '关闭悬停浮起' : '开启悬停浮起'),
            ),
            HyperButton.tonal(
              onPressed: () =>
                  _controller.setColumnVisible('department', !_showDepartment),
              child: Text(_showDepartment ? '隐藏部门列' : '显示部门列'),
            ),
            HyperButton.tonal(
              onPressed: () {
                _controller.sort(null);
                setState(() => _message = '已清除排序。本地且未分页时可拖动行。');
              },
              child: const Text('清除排序'),
            ),
            HyperButton.tonal(
              onPressed: () => _controller.reload(),
              child: const Text('刷新数据'),
            ),
            if (_mode != HyperTableDataMode.local)
              HyperButton.tonal(
                onPressed: () {
                  _failNext = true;
                  _controller.reload();
                },
                child: const Text('模拟失败与重试'),
              ),
          ],
        ),
        SizedBox(height: s.compactSectionSpacing),
        const HyperText('状态预览独立于数据模式；加载中保持等待，切换状态结束等待；加载失败可点击表格的重试入口恢复。'),
        HyperText('已选择 ${_selected.length} 条（切页保留）；$_message'),
        const HyperText('行拖动仅用于本地、未分页且未排序的数据。表头右键菜单可固定、取消固定、隐藏及恢复列；拖动列边界调整宽度。'),
        SizedBox(height: s.compactSectionSpacing),
        SizedBox(
          height: 540,
          child: HyperTable<_Record>(
            key: ValueKey((_mode, _paginate, _previewState)),
            columns: _columns,
            rows:
                _previewState == _TablePreviewState.empty ||
                    _previewState == _TablePreviewState.filtered
                ? const []
                : _records,
            empty: _previewState == _TablePreviewState.filtered
                ? HyperResult.empty(
                    title: '没有符合条件的记录',
                    description: '这是业务通过 empty 参数提供的内容。',
                    actions: [
                      HyperButton.tonal(
                        onPressed: () =>
                            _setPreviewState(_TablePreviewState.normal),
                        child: const Text('清除筛选'),
                      ),
                    ],
                  )
                : null,
            rowKey: (r) => r.id,
            controller: _controller,
            dataMode:
                _previewState == _TablePreviewState.loading ||
                    _previewState == _TablePreviewState.error
                ? HyperTableDataMode.paginated
                : _previewState != _TablePreviewState.normal
                ? HyperTableDataMode.local
                : _mode,
            loader:
                _previewState == _TablePreviewState.loading ||
                    _previewState == _TablePreviewState.error
                ? _loadPreview
                : _mode == HyperTableDataMode.local
                ? null
                : _load,
            paginateLocalRows:
                _previewState == _TablePreviewState.normal &&
                _mode == HyperTableDataMode.local &&
                _paginate,
            selectionMode: HyperTableSelectionMode.multiple,
            selectedKeys: _selected,
            onSelectionChanged: (keys) => setState(() => _selected = keys),
            striped: _striped,
            hoverLift: _hoverLift,
            reorderableRows: true,
            onRowsReordered: (rows) => setState(() {
              _records = rows;
              _message = '行顺序已更新';
            }),
            onColumnsReordered: (ids) =>
                setState(() => _message = '列顺序：${ids.join('、')}'),
            onColumnVisibilityChanged: (id, visible) {
              if (id == 'department') setState(() => _showDepartment = visible);
            },
            onCellChanged: _edit,
            rowContextMenuBuilder: (context, row) => [
              HyperMenuItem(
                id: 'inspect',
                label: '查看 ${row.name}',
                onPressed: () => setState(() => _message = '查看记录 ${row.id}'),
              ),
              HyperMenuItem(
                id: 'delete',
                label: '删除此行',
                onPressed: () {
                  setState(
                    () => _records = _records
                        .where((r) => r.id != row.id)
                        .toList(),
                  );
                  if (_mode != HyperTableDataMode.local) _controller.reload();
                },
              ),
            ],
          ),
        ),
        SizedBox(height: s.sectionSpacing),
        const HyperText('同步树形审核', variant: HyperTextVariant.subsectionTitle),
        const HyperText('按名称或深度排序时只调整同级顺序；选择子行不隐式选择父行。'),
        SizedBox(
          height: 400,
          child: HyperTable<_TreeRecord>(
            columns: _treeColumns,
            rows: _syncRoots,
            rowKey: (r) => r.id,
            treeColumnId: 'name',
            childrenBuilder: (r) => r.children,
            selectionMode: HyperTableSelectionMode.multiple,
            selectedKeys: _treeSelection,
            onSelectionChanged: (keys) => setState(() => _treeSelection = keys),
          ),
        ),
        SizedBox(height: s.sectionSpacing),
        const HyperText('异步子级审核', variant: HyperTextVariant.subsectionTitle),
        HyperText('已请求 $_childFetches 次。展开后缓存子级，收起再展开不重复请求；刷新清除缓存。'),
        Wrap(
          spacing: s.compactSectionSpacing,
          children: [
            HyperButton.tonal(
              onPressed: () => _failChild = true,
              child: const Text('下一次子级请求失败'),
            ),
            HyperButton.tonal(
              onPressed: () => _asyncTreeController.reload(),
              child: const Text('清空子级缓存'),
            ),
          ],
        ),
        SizedBox(
          height: 400,
          child: HyperTable<_TreeRecord>(
            columns: _treeColumns,
            rows: _asyncRoots,
            rowKey: (r) => r.id,
            controller: _asyncTreeController,
            treeColumnId: 'name',
            hasChildren: (r) => r.depth < 2,
            childrenLoader: _loadChildren,
          ),
        ),
        SizedBox(height: s.sectionSpacing),
        const HyperText('空内容审核', variant: HyperTextVariant.subsectionTitle),
        SizedBox(
          height: 240,
          child: HyperTable<_Record>(
            columns: _columns,
            rows: const [],
            rowKey: (r) => r.id,
          ),
        ),
      ],
    );
  }
}
