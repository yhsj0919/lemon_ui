import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  for (final axis in Axis.values) {
    testWidgets('$axis shrinking host never overflows during pane animation', (t) async {
      late StateSetter update;
      double extent = 600;
      final controller = HyperResizableController();
      addTearDown(controller.dispose);
      await t.pumpWidget(MaterialApp(home: HyperTheme(data: HyperThemeData.light(),
        child: Scaffold(body: StatefulBuilder(builder: (_, set) {
          update = set;
          return SizedBox(width: axis == Axis.horizontal ? extent : 300,
            height: axis == Axis.vertical ? extent : 200,
            child: HyperResizable(controller: controller, direction: axis, panes: [
              HyperResizablePane(collapsible: true, child: const Text('first')),
              HyperResizablePane(child: const Text('second')),
            ]));
        })))));
      await t.pumpAndSettle();
      update(() => extent = 192);
      await t.pump();
      expect(t.takeException(), isNull);
      await t.pump(const Duration(milliseconds: 40));
      expect(t.takeException(), isNull);
      await t.pumpAndSettle();
      controller.setCollapsed(0, true);
      await t.pump();
      await t.pump(const Duration(milliseconds: 30));
      update(() => extent = 100);
      await t.pump();
      expect(t.takeException(), isNull);
      await t.pumpAndSettle();
      expect(t.takeException(), isNull);
    });
  }
}
