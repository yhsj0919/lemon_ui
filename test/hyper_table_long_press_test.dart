import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:trina_grid/trina_grid.dart' as trina;

Widget host(Widget child) => MaterialApp(
  home: HyperTheme(
    data: HyperThemeData.light(),
    duration: Duration.zero,
    child: Scaffold(body: SizedBox(width: 640, height: 400, child: child)),
  ),
);

void main() {
  testWidgets(
    'column reorder waits for a long press and leaves resize immediate',
    (tester) async {
      var moves = 0;
      await tester.pumpWidget(
        host(
          HyperTable<String>(
            rows: const ['a'],
            rowKey: (row) => row,
            columns: [
              HyperTableColumn(
                id: 'first',
                title: '第一列',
                value: (row) => row,
                width: 220,
              ),
              HyperTableColumn(
                id: 'second',
                title: '第二列',
                value: (row) => row,
                width: 220,
              ),
            ],
            onColumnsReordered: (_) => moves++,
          ),
        ),
      );
      await tester.pumpAndSettle();
      final start = tester.getCenter(find.text('第一列'));
      final end = tester.getCenter(find.text('第二列'));
      await tester.dragFrom(start, end - start);
      await tester.pumpAndSettle();
      expect(moves, 0);
      expect(find.text('固定到起始侧'), findsNothing);

      final gesture = await tester.startGesture(start);
      await tester.pump(kLongPressTimeout + const Duration(milliseconds: 100));
      expect(find.text('固定到起始侧'), findsNothing);
      await gesture.moveTo(end);
      await tester.pump();
      await gesture.up();
      await tester.pumpAndSettle();
      expect(moves, 1);
      final m = tester
          .state<trina.TrinaGridState>(find.byType(trina.TrinaGrid))
          .stateManager;
      expect(m.columns.first.field, 'second');
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'table header and row menus ignore long press and retain secondary click',
    (tester) async {
      await tester.pumpWidget(
        host(
          HyperTable<String>(
            rows: const ['客户'],
            rowKey: (row) => row,
            columns: [
              HyperTableColumn(
                id: 'name',
                title: '名称',
                value: (row) => row,
                width: 240,
                reorderable: false,
              ),
            ],
            rowContextMenuBuilder: (_, row) => const [
              HyperMenuItem(id: 'edit', label: '编辑客户'),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.longPress(find.text('名称'));
      await tester.pumpAndSettle();
      expect(find.text('固定到起始侧'), findsNothing);
      await tester.longPress(find.text('客户'));
      await tester.pumpAndSettle();
      expect(find.text('编辑客户'), findsNothing);
      await tester.tap(find.text('客户'), buttons: kSecondaryMouseButton);
      await tester.pumpAndSettle();
      expect(find.text('编辑客户'), findsOneWidget);
      await tester.tapAt(const Offset(620, 380));
      await tester.pumpAndSettle();
      await tester.tap(find.text('名称'), buttons: kSecondaryMouseButton);
      await tester.pumpAndSettle();
      expect(find.text('固定到起始侧'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('standalone context menu keeps long press by default', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        const HyperContextMenu(
          items: [HyperMenuItem(id: 'edit', label: '编辑')],
          child: Text('长按此处'),
        ),
      ),
    );
    await tester.longPress(find.text('长按此处'));
    await tester.pumpAndSettle();
    expect(find.text('编辑'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
