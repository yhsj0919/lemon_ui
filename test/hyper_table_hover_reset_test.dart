import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  testWidgets('removing hovered rows clears lifted row surface', (
    tester,
  ) async {
    var rows = ['row'];
    late StateSetter update;
    final columns = [
      HyperTableColumn<String>(id: 'name', title: '名称', value: (row) => row),
    ];
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: Scaffold(
            body: SizedBox(
              width: 600,
              height: 400,
              child: StatefulBuilder(
                builder: (_, setState) {
                  update = setState;
                  return HyperTable<String>(
                    columns: columns,
                    rows: rows,
                    rowKey: (row) => row,
                    hoverLift: true,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: const Offset(700, 500));
    await mouse.moveTo(tester.getCenter(find.text('row').first));
    await tester.pumpAndSettle();
    bool lifted() => tester
        .widgetList<CustomPaint>(find.byType(CustomPaint))
        .any(
          (paint) =>
              paint.painter.runtimeType.toString() == '_HyperTableLiftPainter',
        );
    expect(lifted(), isTrue);
    update(() => rows = []);
    await tester.pumpAndSettle();
    expect(lifted(), isFalse);
    expect(tester.takeException(), isNull);
    await mouse.removePointer();
  });
}
