import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:trina_grid/trina_grid.dart' as trina;

void main() {
  testWidgets(
    'outer page scrolling does not shrink the 40 plus ten 52 row table',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: HyperThemeData.light(),
            duration: Duration.zero,
            child: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      width: 800,
                      height: 560,
                      child: HyperTable<int>(
                        showPagination: false,
                        selectionMode: HyperTableSelectionMode.multiple,
                        reorderableRows: true,
                        rows: List.generate(10, (i) => i + 1),
                        rowKey: (row) => row,
                        columns: [
                          HyperTableColumn(
                            id: 'id',
                            title: '次序',
                            value: (row) => row,
                            width: 100,
                          ),
                          HyperTableColumn(
                            id: 'name',
                            title: '节目',
                            value: (row) => '节目 $row',
                            width: 900,
                          ),
                        ],
                        style: const HyperTableStyle(
                          rowHeight: 52,
                          headerHeight: 40,
                        ),
                      ),
                    ),
                    const SizedBox(height: 500),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final m = tester
          .state<trina.TrinaGridState>(find.byType(trina.TrinaGrid))
          .stateManager;
      expect(m.configuration.style.columnHeight, 40);
      expect(m.rows.map((r) => r.height), everyElement(52));
      expect(m.scroll.bodyRowsVertical!.position.viewportDimension, 520);
      expect(m.scroll.bodyRowsVertical!.position.maxScrollExtent, 0);
      final outer = tester.state<ScrollableState>(
        find
            .descendant(
              of: find.byType(SingleChildScrollView).first,
              matching: find.byType(Scrollable),
            )
            .first,
      );
      expect(outer.position.maxScrollExtent, greaterThan(0));
      final last = tester.getRect(find.text('节目 10'));
      final grid = tester.getRect(find.byType(trina.TrinaGrid));
      expect(last.center.dy, closeTo(grid.bottom - 26, .01));
      expect(tester.takeException(), isNull);
    },
  );
  for (final padding in [
    EdgeInsets.zero,
    const EdgeInsets.only(top: 20, bottom: 24),
  ]) {
    for (final horizontal in [false, true]) {
      for (final count in [4, 5]) {
        testWidgets(
          'row extent excludes safe padding $padding, horizontal=$horizontal, rows=$count',
          (tester) async {
            await tester.pumpWidget(
              MaterialApp(
                home: HyperTheme(
                  data: HyperThemeData.light(),
                  duration: Duration.zero,
                  child: MediaQuery(
                    data: MediaQueryData(padding: padding),
                    child: Scaffold(
                      body: SizedBox(
                        width: 400,
                        height: 180,
                        child: HyperTable<int>(
                          embedded: true,
                          columns: [
                            HyperTableColumn(
                              id: 'id',
                              title: '编号',
                              value: (row) => row,
                              width: 80,
                              pin: HyperTableColumnPin.start,
                            ),
                            HyperTableColumn(
                              id: 'name',
                              title: '名称',
                              value: (row) => row,
                              widthMode: horizontal
                                  ? HyperTableColumnWidthMode.fixed
                                  : HyperTableColumnWidthMode.flex,
                              width: horizontal ? 500 : null,
                            ),
                          ],
                          rows: List.generate(count, (i) => i),
                          rowKey: (row) => row,
                          style: const HyperTableStyle(
                            scrollbarTheme: ScrollbarThemeData(
                              thumbVisibility: WidgetStatePropertyAll(true),
                            ),
                            headerHeight: 36,
                            rowHeight: 36,
                            textStyle: TextStyle(fontSize: 12, height: 1),
                            headerTextStyle: TextStyle(fontSize: 12, height: 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
            await tester.pumpAndSettle();
            final m = tester
                .state<trina.TrinaGridState>(find.byType(trina.TrinaGrid))
                .stateManager;
            expect(m.configuration.scrollbar.showHorizontal, isFalse);
            final body = m.scroll.bodyRowsVertical!.position;
            expect(body.viewportDimension, 144);
            expect(
              m.scroll.bodyRowsHorizontal!.position.maxScrollExtent > 0,
              horizontal,
            );
            expect(
              body.maxScrollExtent,
              closeTo(math.max(0, count * 36 - body.viewportDimension), .01),
            );
            final frozenLists = find
                .byType(ListView)
                .evaluate()
                .map((e) => (e.widget as ListView).controller)
                .whereType<ScrollController>()
                .where((c) => c.hasClients && c.position.axis == Axis.vertical);
            for (final controller in frozenLists) {
              expect(
                controller.position.maxScrollExtent,
                closeTo(
                  math.max(
                    0,
                    count * 36 - controller.position.viewportDimension,
                  ),
                  .01,
                ),
              );
            }
            if (horizontal) {
              final grid = tester.getRect(find.byType(trina.TrinaGrid));
              final gesture = await tester.startGesture(
                Offset(grid.left + 160, grid.bottom - 3),
              );
              await gesture.moveBy(const Offset(35, 0));
              await tester.pump();
              await gesture.moveBy(const Offset(35, 0));
              await gesture.up();
              await tester.pumpAndSettle();
              expect(m.scroll.bodyRowsHorizontal!.offset, greaterThan(0));
            }
            expect(tester.takeException(), isNull);
          },
        );
      }
    }
  }
}
