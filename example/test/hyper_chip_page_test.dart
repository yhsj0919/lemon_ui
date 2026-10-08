import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/pages/selection/hyper_chip_page.dart';

void main() {
  testWidgets('静态 Tag 与 Chip 按垂直中心对齐', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1000, 1400);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const MaterialApp(home: HyperChipPage()));
    final tag = find.byWidgetPredicate(
      (widget) => widget is HyperTag && widget.label == '静态标签',
    );
    await tester.ensureVisible(tag);
    await tester.pumpAndSettle();
    for (final label in ['可点击', '可选择']) {
      final chip = find.byWidgetPredicate(
        (widget) => widget is HyperChip && widget.label == label,
      );
      expect(tester.getCenter(chip).dy, tester.getCenter(tag).dy);
    }
    expect(tester.takeException(), isNull);
  });
}
