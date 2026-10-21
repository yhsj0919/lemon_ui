import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:trina_grid/trina_grid.dart' as trina;

Widget _host(
  Widget child, {
  HyperThemeData? theme,
  double scale = 1,
  double width = 640,
}) => MaterialApp(
  home: HyperTheme(
    data: theme ?? HyperThemeData.light(),
    duration: Duration.zero,
    child: MediaQuery(
      data: MediaQueryData(textScaler: TextScaler.linear(scale)),
      child: Scaffold(
        body: Center(
          child: SizedBox(width: width, height: 420, child: child),
        ),
      ),
    ),
  ),
);
List<HyperTableColumn<String>> _columns() => [
  HyperTableColumn(
    id: 'name',
    title: '名称',
    value: (row) => row,
    editable: true,
  ),
  HyperTableColumn(id: 'detail', title: '详情', value: (row) => '$row detail'),
];

void main() {
  test('table themes and four-device dimensions support copy, merge and interpolation', () {
    final base = HyperThemeData.light();
    const style = HyperTableStyle(
      rowHeight: 50,
      treeIndent: 20,
      textStyle: TextStyle(fontSize: 18),
      boxShadow: [],
    );
    final theme = base.copyWith(
      tableTheme: const HyperTableThemeData(style: style),
    );
    expect(theme.copyWith(), theme);
    expect(theme.copyWith().hashCode, theme.hashCode);
    expect(base.lerp(theme, 1), theme);
    final end = style.copyWith(rowHeight: 70, treeIndent: 40);
    expect(HyperTableStyle.lerp(style, end, .5).rowHeight, 60);
    expect(HyperTableStyle.lerp(style, end, .5).treeIndent, 30);
    expect(
      style
          .merge(const HyperTableStyle(textStyle: TextStyle(color: Colors.red)))
          .textStyle!
          .fontSize,
      18,
    );
    for (final device in HyperDeviceType.values) {
      final s = base.sizes.resolve(device);
      final changed = s.copyWith(
        table: s.table.copyWith(rowHeight: s.table.rowHeight + 8),
      );
      expect(
        HyperSizeScheme.lerp(s, changed, .5).table.rowHeight,
        s.table.rowHeight + 4,
      );
      expect(changed.copyWith(), changed);
      expect(changed.copyWith().hashCode, changed.hashCode);
    }
  });

  testWidgets('global, local and instance styles merge without losing fields', (
    tester,
  ) async {
    final theme = HyperThemeData.light().copyWith(
      tableTheme: const HyperTableThemeData(
        style: HyperTableStyle(
          textStyle: TextStyle(fontSize: 19),
          rowHeight: 53,
        ),
      ),
    );
    await tester.pumpWidget(
      _host(
        HyperTableTheme(
          data: const HyperTableThemeData(
            style: HyperTableStyle(textStyle: TextStyle(color: Colors.red)),
          ),
          child: HyperTable<String>(
            columns: _columns(),
            rows: const ['Alpha'],
            rowKey: (r) => r,
            style: const HyperTableStyle(
              textStyle: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ),
        theme: theme,
      ),
    );
    await tester.pumpAndSettle();
    final text = tester.widget<Text>(find.text('Alpha'));
    expect(text.style!.fontSize, 19);
    expect(text.style!.color, Colors.red);
    expect(text.style!.fontWeight, FontWeight.w700);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'controlled multi-selection and column layout survive new descriptors',
    (tester) async {
      final controller = HyperTableController();
      Set<Object> selected = {};
      late StateSetter update;
      await tester.pumpWidget(
        _host(
          StatefulBuilder(
            builder: (context, set) {
              update = set;
              return HyperTable<String>(
                columns: _columns(),
                rows: const ['Alpha', 'Beta'],
                rowKey: (r) => r,
                controller: controller,
                selectionMode: HyperTableSelectionMode.multiple,
                selectedKeys: selected,
                onSelectionChanged: (keys) => set(() => selected = keys),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      controller.setColumnWidth('name', 250);
      controller.setColumnVisible('detail', false);
      controller.pinColumn('name', HyperTableColumnPin.start);
      await tester.pumpAndSettle();
      final checkbox = find.byWidgetPredicate(
        (w) => w is HyperCheckbox && w.semanticLabel == '选择行 Alpha',
      );
      await tester.tap(checkbox);
      await tester.pumpAndSettle();
      expect(selected, {'Alpha'});
      update(() {});
      await tester.pumpAndSettle();
      final grid = tester.widget<trina.TrinaGrid>(find.byType(trina.TrinaGrid));
      expect(grid.columns.firstWhere((c) => c.field == 'name').width, 250);
      expect(
        grid.columns.firstWhere((c) => c.field == 'name').frozen,
        trina.TrinaColumnFrozen.start,
      );
      expect(grid.columns.firstWhere((c) => c.field == 'detail').hide, isTrue);
      expect(controller.attached, isTrue);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('async children retry, retain cached rows and reload safely', (
    tester,
  ) async {
    var calls = 0;
    final controller = HyperTableController();
    await tester.pumpWidget(
      _host(
        HyperTable<String>(
          columns: _columns(),
          rows: const ['Root'],
          rowKey: (r) => r,
          controller: controller,
          hasChildren: (r) => r == 'Root',
          childrenLoader: (r) async {
            calls++;
            if (calls == 1) throw StateError('expected load failure');
            return ['Child'];
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.chevron_right));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.refresh), findsOneWidget);
    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pumpAndSettle();
    expect(find.text('Child'), findsOneWidget);
    expect(calls, 2);
    await tester.tap(find.byIcon(Icons.chevron_right));
    await tester.pumpAndSettle();
    expect(find.text('Child'), findsNothing);
    await tester.tap(find.byIcon(Icons.chevron_right));
    await tester.pumpAndSettle();
    expect(find.text('Child'), findsOneWidget);
    expect(calls, 2);
    await controller.reload();
    await tester.pumpAndSettle();
    expect(calls, 3);
    expect(find.text('Child'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('old remote responses cannot replace a refreshed page', (
    tester,
  ) async {
    final requests = <Completer<HyperTablePage<String>>>[];
    final controller = HyperTableController();
    await tester.pumpWidget(
      _host(
        HyperTable<String>(
          columns: _columns(),
          rowKey: (r) => r,
          controller: controller,
          dataMode: HyperTableDataMode.paginated,
          loader: (query) {
            final c = Completer<HyperTablePage<String>>();
            requests.add(c);
            return c.future;
          },
        ),
      ),
    );
    await tester.pump();
    expect(requests.length, 1);
    unawaited(controller.reload());
    await tester.pump();
    expect(requests.length, 2);
    requests[1].complete(const HyperTablePage(items: ['Latest'], total: 1));
    await tester.pumpAndSettle();
    requests[0].complete(const HyperTablePage(items: ['Stale'], total: 1));
    await tester.pumpAndSettle();
    expect(find.text('Latest'), findsOneWidget);
    expect(find.text('Stale'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  for (final scale in [1.0, 1.3, 2.0]) {
    testWidgets('narrow table preserves system text scaling $scale', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          HyperTable<String>(
            columns: _columns(),
            rows: const ['Root'],
            rowKey: (r) => r,
            selectionMode: HyperTableSelectionMode.multiple,
            childrenBuilder: (r) => r == 'Root' ? ['Child'] : [],
          ),
          scale: scale,
          width: 180,
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets(
    'column resize handle and inline text editing commit through Hyper APIs',
    (tester) async {
      HyperTableCellChange<String>? change;
      await tester.pumpWidget(
        _host(
          HyperTable<String>(
            columns: _columns(),
            rows: const ['Alpha'],
            rowKey: (r) => r,
            onCellChanged: (e) => change = e,
          ),
        ),
      );
      await tester.pumpAndSettle();
      final initial = tester
          .widget<trina.TrinaGrid>(find.byType(trina.TrinaGrid))
          .columns
          .first
          .width;
      await tester.drag(
        find.byIcon(Icons.drag_indicator).first,
        const Offset(40, 0),
      );
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<trina.TrinaGrid>(find.byType(trina.TrinaGrid))
            .columns
            .first
            .width,
        greaterThan(initial),
      );
      await tester.tap(find.text('Alpha'));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tap(find.text('Alpha'));
      await tester.pumpAndSettle();
      expect(find.byType(HyperTextField), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'Edited');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(change?.value, 'Edited');
      expect(change?.rowKey, 'Alpha');
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'tree sorting retains parent adjacency and pagination counts roots',
    (tester) async {
      final controller = HyperTableController();
      await tester.pumpWidget(
        _host(
          HyperTable<String>(
            columns: _columns(),
            rows: const ['RootB', 'RootA'],
            rowKey: (r) => r,
            controller: controller,
            childrenBuilder: (r) => r == 'RootA' ? ['z', 'a'] : [],
            expandedKeys: const {'RootA'},
            paginateLocalRows: true,
            pageSize: 1,
          ),
        ),
      );
      await tester.pumpAndSettle();
      controller.sort(
        const HyperTableSort('name', HyperTableSortDirection.ascending),
      );
      await tester.pumpAndSettle();
      expect(find.text('RootA'), findsOneWidget);
      expect(find.text('RootB'), findsNothing);
      expect(
        tester.getTopLeft(find.text('a')).dy,
        lessThan(tester.getTopLeft(find.text('z')).dy),
      );
      expect(
        tester.widget<HyperPagination>(find.byType(HyperPagination)).pageCount,
        2,
      );
      controller.goToPage(2);
      await tester.pumpAndSettle();
      expect(find.text('RootB'), findsOneWidget);
      expect(find.text('a'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'infinite loading fills a short viewport without duplicate requests',
    (tester) async {
      final pages = <int>[];
      await tester.pumpWidget(
        _host(
          HyperTable<String>(
            columns: _columns(),
            rowKey: (r) => r,
            dataMode: HyperTableDataMode.infinite,
            pageSize: 1,
            loader: (q) async {
              pages.add(q.page);
              return HyperTablePage(
                items: ['Row ${q.page}'],
                hasMore: q.page < 2,
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(pages, [1, 2]);
      expect(find.text('Row 1'), findsOneWidget);
      expect(find.text('Row 2'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'collapsing a pending branch keeps late children cached but hidden',
    (tester) async {
      final request = Completer<List<String>>();
      await tester.pumpWidget(
        _host(
          HyperTable<String>(
            columns: _columns(),
            rows: const ['Root'],
            rowKey: (r) => r,
            hasChildren: (r) => r == 'Root',
            childrenLoader: (r) => request.future,
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pump();
      await tester.pump();
      final expand = find.byWidgetPredicate(
        (w) => w is HyperIconButton && w.tooltip == '收起子级',
      );
      await tester.tap(expand);
      await tester.pump();
      request.complete(['Late child']);
      await tester.pumpAndSettle();
      expect(find.text('Late child'), findsNothing);
      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pumpAndSettle();
      expect(find.text('Late child'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
