import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:trina_grid/trina_grid.dart' as trina;

void main() {
  for (final direction in TextDirection.values) {
    testWidgets(
      'resize handle paints and drags at the column edge: $direction',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: HyperTheme(
              data: HyperThemeData.light(),
              duration: Duration.zero,
              child: Directionality(
                textDirection: direction,
                child: Scaffold(
                  body: SizedBox(
                    width: 480,
                    height: 240,
                    child: HyperTable<int>(
                      embedded: true,
                      rows: const [1],
                      rowKey: (row) => row,
                      showColumnResizeHandles: true,
                      columns: [
                        HyperTableColumn(
                          id: 'amount',
                          title: '数量',
                          value: (row) => row,
                          width: 200,
                        ),
                      ],
                      style: const HyperTableStyle(
                        horizontalPadding: 8,
                        iconSize: 16,
                        borderWidth: 2,
                        borderColor: Colors.purple,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final handle = find.byWidgetPredicate(
          (w) =>
              w is MouseRegion && w.cursor == SystemMouseCursors.resizeColumn,
        );
        final hit = tester.getRect(handle);
        final line = tester.getRect(
          find.descendant(of: handle, matching: find.byType(ColoredBox)),
        );
        final grid = tester.getRect(find.byType(trina.TrinaGrid));
        if (direction == TextDirection.ltr) {
          expect(hit.right, closeTo(grid.left + 200, .01));
          expect(line.right, hit.right);
        } else {
          expect(hit.left, closeTo(grid.right - 200, .01));
          expect(line.left, hit.left);
        }
        expect(hit.width, 24);
        final start = Offset(
          direction == TextDirection.ltr ? hit.right - 1 : hit.left + 1,
          hit.center.dy,
        );
        final gesture = await tester.startGesture(start);
        final delta = Offset(direction == TextDirection.ltr ? 24 : -24, 0);
        await gesture.moveBy(delta);
        await tester.pump();
        await gesture.moveBy(delta);
        await gesture.up();
        await tester.pumpAndSettle();
        final m = tester
            .state<trina.TrinaGridState>(find.byType(trina.TrinaGrid))
            .stateManager;
        expect(m.columns.single.width, greaterThan(200));
        expect(tester.takeException(), isNull);
      },
    );
  }
  testWidgets('explicit single-line headers retain ellipsis without growing', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          duration: Duration.zero,
          child: Scaffold(
            body: SizedBox(
              width: 400,
              height: 240,
              child: HyperTable<int>(
                rows: const [1],
                rowKey: (row) => row,
                columns: [
                  HyperTableColumn(
                    id: 'name',
                    title: '明确限制为单行的较长表头',
                    value: (row) => row,
                    width: 112,
                    headerMaxLines: 1,
                  ),
                ],
                style: const HyperTableStyle(
                  headerHeight: 36,
                  verticalPadding: 4,
                  headerTextStyle: TextStyle(fontSize: 14, height: 1.5),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      tester
          .renderObject<RenderParagraph>(find.text('明确限制为单行的较长表头'))
          .didExceedMaxLines,
      isTrue,
    );
    final m = tester
        .state<trina.TrinaGridState>(find.byType(trina.TrinaGrid))
        .stateManager;
    expect(m.configuration.style.columnHeight, 36);
    expect(tester.takeException(), isNull);
  });

  for (final scale in [1.0, 1.3, 2.0]) {
    testWidgets('narrow sorted header shows complete title at scale $scale', (
      tester,
    ) async {
      final controller = HyperTableController();
      await tester.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: HyperThemeData.light(),
            duration: Duration.zero,
            child: MediaQuery(
              data: MediaQueryData(textScaler: TextScaler.linear(scale)),
              child: Scaffold(
                body: SizedBox(
                  width: 480,
                  height: 400,
                  child: HyperTable<int>(
                    embedded: true,
                    controller: controller,
                    rows: const [1],
                    rowKey: (row) => row,
                    columns: [
                      HyperTableColumn(
                        id: 'amount',
                        title: '数量 · 可编辑',
                        value: (row) => row,
                        width: 112,
                        pin: HyperTableColumnPin.start,
                      ),
                      HyperTableColumn(
                        id: 'name',
                        title: '名称',
                        value: (row) => '项目 $row',
                        widthMode: HyperTableColumnWidthMode.flex,
                      ),
                    ],
                    style: const HyperTableStyle(
                      headerHeight: 36,
                      horizontalPadding: 8,
                      verticalPadding: 4,
                      iconSize: 16,
                      headerTextStyle: TextStyle(fontSize: 14, height: 1.5),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final grid = tester
          .state<trina.TrinaGridState>(find.byType(trina.TrinaGrid))
          .stateManager;
      final unsortedHeight = grid.configuration.style.columnHeight;
      controller.sort(
        const HyperTableSort('amount', HyperTableSortDirection.ascending),
      );
      await tester.pumpAndSettle();
      final title = find.text('数量 · 可编辑');
      final paragraph = tester.renderObject<RenderParagraph>(title);
      expect(paragraph.didExceedMaxLines, isFalse);
      final m = tester
          .state<trina.TrinaGridState>(find.byType(trina.TrinaGrid))
          .stateManager;
      final narrowHeight = m.configuration.style.columnHeight;
      expect(narrowHeight, unsortedHeight);
      expect(narrowHeight, greaterThan(36));
      expect(paragraph.size.height + 8, lessThanOrEqualTo(narrowHeight + .01));
      controller.setColumnWidth('amount', 220);
      await tester.pumpAndSettle();
      expect(m.configuration.style.columnHeight, lessThan(narrowHeight));
      expect(tester.takeException(), isNull);
    });
  }
}
