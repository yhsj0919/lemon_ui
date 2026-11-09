import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:trina_grid/trina_grid.dart' as trina;
// ignore: implementation_imports
import 'package:trina_grid/src/ui/trina_base_row.dart' as trina_ui;

Widget host(Widget child, {double scale = 1}) => MaterialApp(
  home: HyperTheme(
    data: HyperThemeData.light(),
    duration: Duration.zero,
    child: MediaQuery(
      data: MediaQueryData(textScaler: TextScaler.linear(scale)),
      child: Scaffold(body: SizedBox(width: 640, height: 400, child: child)),
    ),
  ),
);

trina.TrinaGridStateManager manager(WidgetTester tester) => tester
    .state<trina.TrinaGridState>(find.byType(trina.TrinaGrid))
    .stateManager;

const style = HyperTableStyle(
  rowHeight: 36,
  horizontalPadding: 8,
  verticalPadding: 4,
  textStyle: TextStyle(fontSize: 14, height: 1.5),
);

void main() {
  for (final scale in [1.0, 1.3, 2.0]) {
    testWidgets('default body wraps complete text and grows the row: $scale', (
      tester,
    ) async {
      const text = '客户详细地址需要根据列宽自动换行并完整显示内容';
      final controller = HyperTableController();
      await tester.pumpWidget(
        host(
          HyperTable<String>(
            controller: controller,
            rows: const [text],
            rowKey: (row) => row,
            columns: [
              HyperTableColumn(
                id: 'name',
                title: '地址',
                value: (row) => row,
                width: 120,
              ),
            ],
            style: style,
          ),
          scale: scale,
        ),
      );
      await tester.pumpAndSettle();
      final paragraph = tester.renderObject<RenderParagraph>(find.text(text));
      expect(paragraph.didExceedMaxLines, isFalse);
      final narrowHeight = manager(tester).getRowHeight(0);
      expect(narrowHeight, greaterThan(36));
      expect(paragraph.size.height + 8, lessThanOrEqualTo(narrowHeight));
      controller.setColumnWidth('name', 450);
      await tester.pumpAndSettle();
      expect(manager(tester).getRowHeight(0), lessThan(narrowHeight));
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets(
    'stateful custom cell grows and shrinks without rebuilding the table',
    (tester) async {
      final height = ValueNotifier(50.0);
      addTearDown(height.dispose);
      await tester.pumpWidget(
        host(
          HyperTable<String>(
            rows: const ['a'],
            rowKey: (row) => row,
            rowHeightMode: HyperTableRowHeightMode.content,
            columns: [
              HyperTableColumn(
                id: 'name',
                title: '名称',
                value: (row) => row,
                cellBuilder: (_, row, value) => ValueListenableBuilder<double>(
                  valueListenable: height,
                  builder: (_, value, child) =>
                      SizedBox(height: value, child: const Text('关联主体')),
                ),
              ),
            ],
            style: style,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(manager(tester).getRowHeight(0), 58);
      height.value = 130;
      await tester.pumpAndSettle();
      expect(manager(tester).getRowHeight(0), 138);
      height.value = 20;
      await tester.pumpAndSettle();
      expect(manager(tester).getRowHeight(0), 36);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'offscreen custom columns contribute before horizontal scrolling',
    (tester) async {
      await tester.pumpWidget(
        host(
          HyperTable<String>(
            rows: const ['a'],
            rowKey: (row) => row,
            rowHeightMode: HyperTableRowHeightMode.content,
            columns: [
              HyperTableColumn(
                id: 'name',
                title: '名称',
                value: (row) => row,
                width: 900,
              ),
              HyperTableColumn(
                id: 'custom',
                title: '横向视口外',
                value: (row) => row,
                width: 200,
                cellBuilder: (_, row, value) => const SizedBox(height: 120),
              ),
            ],
            style: style,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(manager(tester).getRowHeight(0), 128);
      expect(manager(tester).scroll.horizontalOffset, 0);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'page navigation sums variable heights and arrows keep target visible',
    (tester) async {
      await tester.pumpWidget(
        host(
          HyperTable<int>(
            rows: List.generate(30, (index) => index),
            rowKey: (row) => row,
            rowHeightBuilder: (row) => 120,
            columns: [
              HyperTableColumn(
                id: 'name',
                title: '名称',
                value: (row) => '客户 $row',
              ),
            ],
            style: style,
          ),
        ),
      );
      await tester.pumpAndSettle();
      final m = manager(tester);
      await tester.tap(find.text('客户 0'));
      await tester.sendKeyEvent(LogicalKeyboardKey.pageDown);
      await tester.pumpAndSettle();
      expect(m.currentRowIdx, inInclusiveRange(2, 4));
      final pageRow = m.currentRowIdx!;
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      expect(m.currentRowIdx, pageRow + 1);
      expect(m.scroll.verticalOffset, greaterThan(0));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('infinite tail follows the actual final row height', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        HyperTable<String>(
          dataMode: HyperTableDataMode.infinite,
          loader: (_) async => const HyperTablePage(items: ['a'], total: 1),
          rowKey: (row) => row,
          rowHeightBuilder: (_) => 110,
          columns: [
            HyperTableColumn(id: 'name', title: '名称', value: (row) => '客户 a'),
          ],
          style: style,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(manager(tester).getRowHeight(0), 110);
    expect(
      tester.getTopLeft(find.text('没有更多数据了')).dy,
      greaterThan(tester.getTopLeft(find.text('客户 a')).dy + 50),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('individual heights retain stable identities after sorting', (
    tester,
  ) async {
    final controller = HyperTableController();
    await tester.pumpWidget(
      host(
        HyperTable<String>(
          controller: controller,
          rows: const ['b', 'a'],
          rowKey: (row) => row,
          rowHeightBuilder: (row) => row == 'b' ? 100 : null,
          columns: [
            HyperTableColumn(id: 'name', title: '名称', value: (row) => row),
          ],
          style: style,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(manager(tester).getRowHeight(0), 100);
    expect(manager(tester).getRowHeight(1), 36);
    controller.sort(
      const HyperTableSort('name', HyperTableSortDirection.ascending),
    );
    await tester.pumpAndSettle();
    expect(manager(tester).rows.first.data, 'a');
    expect(manager(tester).getRowHeight(0), 36);
    expect(manager(tester).getRowHeight(1), 100);
    expect(tester.takeException(), isNull);
  });

  for (final scale in [1.0, 1.3, 2.0]) {
    testWidgets(
      'text wraps, respects line limits and recomputes on resize: $scale',
      (tester) async {
        final controller = HyperTableController();
        Widget table({
          int? maxLines,
          HyperTableRowHeightMode mode = HyperTableRowHeightMode.content,
        }) => host(
          HyperTable<String>(
            controller: controller,
            rows: const ['一段需要根据列宽自动换行的很长的客户详细地址用于验证内容自适应高度'],
            rowKey: (row) => row,
            rowHeightMode: mode,
            columns: [
              HyperTableColumn(
                id: 'name',
                title: '地址',
                value: (row) => row,
                width: 120,
                maxLines: maxLines,
              ),
            ],
            style: style,
          ),
          scale: scale,
        );
        await tester.pumpWidget(table());
        await tester.pumpAndSettle();
        final narrow = manager(tester).getRowHeight(0);
        expect(narrow, greaterThan(36));
        controller.setColumnWidth('name', 450);
        await tester.pumpAndSettle();
        expect(manager(tester).getRowHeight(0), lessThan(narrow));
        await tester.pumpWidget(table(maxLines: 1));
        await tester.pumpAndSettle();
        expect(manager(tester).getRowHeight(0), lessThan(narrow));
        await tester.pumpWidget(table(mode: HyperTableRowHeightMode.uniform));
        await tester.pumpAndSettle();
        expect(
          manager(tester).getRowHeight(0),
          closeTo((36.0 > 21 * scale + 8 ? 36.0 : 21 * scale + 8), .01),
        );
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'custom content measures once in place and fixed columns share height',
    (tester) async {
      final controller = HyperTableController();
      final cellKey = GlobalKey();
      Widget table({double contentHeight = 110, double? explicit}) => host(
        HyperTable<String>(
          controller: controller,
          rowHeightMode: HyperTableRowHeightMode.content,
          rowHeightBuilder: (row) => explicit,
          rows: const ['a', 'b'],
          rowKey: (row) => row,
          columns: [
            HyperTableColumn(
              id: 'name',
              title: '客户',
              value: (row) => row,
              width: 160,
              pin: HyperTableColumnPin.start,
            ),
            HyperTableColumn(
              id: 'custom',
              title: '关联主体',
              value: (row) => row,
              width: 240,
              cellBuilder: (context, row, value) => row == 'a'
                  ? SizedBox(
                      key: cellKey,
                      height: contentHeight,
                      child: const Text('多条关联主体'),
                    )
                  : const Text('单条'),
            ),
          ],
          style: style,
        ),
      );
      await tester.pumpWidget(table());
      await tester.pumpAndSettle();
      expect(manager(tester).getRowHeight(0), 118);
      expect(manager(tester).getRowHeight(1), 36);
      final segments = find.byWidgetPredicate(
        (widget) => widget is trina_ui.TrinaBaseRow && widget.row.data == 'a',
      );
      expect(segments, findsNWidgets(2));
      for (final element in segments.evaluate()) {
        expect((element.renderObject as RenderBox).size.height, 118);
      }
      expect(find.byKey(cellKey), findsOneWidget);
      expect(tester.getSize(find.byKey(cellKey)).height, 110);
      await tester.pumpWidget(table(contentHeight: 50));
      await tester.pumpAndSettle();
      expect(manager(tester).getRowHeight(0), 58);
      controller.setColumnVisible('custom', false);
      await tester.pumpAndSettle();
      expect(manager(tester).getRowHeight(0), 36);
      controller.setColumnVisible('custom', true);
      await tester.pumpAndSettle();
      expect(manager(tester).getRowHeight(0), 58);
      await tester.pumpWidget(table(contentHeight: 50, explicit: 80));
      await tester.pumpAndSettle();
      expect(manager(tester).getRowHeight(0), 80);
      expect(tester.takeException(), isNull);
    },
  );
}
