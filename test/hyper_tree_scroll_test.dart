import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

Widget host(Widget child, {double textScale = 1, bool reduced = false}) =>
    MaterialApp(
      home: HyperTheme(
        data: HyperThemeData.light(),
        child: MediaQuery(
          data: MediaQueryData(
            textScaler: TextScaler.linear(textScale),
            disableAnimations: reduced,
          ),
          child: Scaffold(body: Center(child: child)),
        ),
      ),
    );

final nodes = List.generate(
  30,
  (index) => HyperTreeNode<int>(id: index, label: Text('节点 $index')),
);

void main() {
  for (final bounded in [false, true]) {
    testWidgets('branch rows animate continuously with bounded=$bounded', (
      tester,
    ) async {
      final controller = HyperTreeController<int>(
        nodes: [
          HyperTreeNode<int>(
            id: -1,
            label: const Text('分支'),
            children: nodes.take(3).toList(),
          ),
          const HyperTreeNode<int>(id: -2, label: Text('后续节点')),
        ],
      );
      await tester.pumpWidget(
        host(
          SizedBox(
            width: 220,
            height: bounded ? 160 : null,
            child: HyperTreeView<int>(
              controller: controller,
              style: const HyperTreeViewStyle(
                duration: Duration(milliseconds: 240),
                curve: Curves.linear,
              ),
            ),
          ),
        ),
      );
      double y() => tester.getTopLeft(find.text('后续节点')).dy;
      // Measure relative to the tree because the host centers short content.
      double relativeY() =>
          y() - tester.getTopLeft(find.byType(HyperTreeView<int>)).dy;
      final start = relativeY();
      controller.setExpanded(-1, true);
      await tester.pump();
      expect(relativeY(), closeTo(start, .01));
      await tester.pump(const Duration(milliseconds: 120));
      final middle = relativeY();
      expect(middle, greaterThan(start));
      await tester.pumpAndSettle();
      final end = relativeY();
      expect(end, greaterThan(middle));
      controller.setExpanded(-1, false);
      await tester.pump();
      expect(relativeY(), closeTo(end, .01));
      expect(find.text('节点 0'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 120));
      expect(relativeY(), inExclusiveRange(start, end));
      final reversing = relativeY();
      controller.setExpanded(-1, true);
      await tester.pump();
      expect(relativeY(), closeTo(reversing, .01));
      await tester.pumpAndSettle();
      expect(relativeY(), closeTo(end, .01));
      controller.setExpanded(-1, false);
      await tester.pumpAndSettle();
      expect(find.text('节点 0'), findsNothing);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      controller.dispose();
    });
  }
  testWidgets('reduced motion expands and collapses immediately', (
    tester,
  ) async {
    final controller = HyperTreeController<int>(
      nodes: [
        HyperTreeNode<int>(id: -1, label: const Text('分支'), children: nodes),
      ],
    );
    await tester.pumpWidget(
      host(
        SizedBox(
          width: 220,
          height: 160,
          child: HyperTreeView<int>(controller: controller),
        ),
        reduced: true,
      ),
    );
    controller.setExpanded(-1, true);
    await tester.pump();
    expect(find.text('节点 0').hitTestable(), findsOneWidget);
    controller.setExpanded(-1, false);
    await tester.pump();
    expect(find.text('节点 0'), findsNothing);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    controller.dispose();
  });
  testWidgets('expanding a short tree respects its maximum height', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        SizedBox(
          width: 220,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 160),
            child: HyperTreeView<int>(
              nodes: [
                HyperTreeNode<int>(
                  id: -1,
                  label: const Text('展开节点'),
                  children: nodes,
                ),
              ],
            ),
          ),
        ),
      ),
    );
    expect(
      tester.getSize(find.byType(HyperTreeView<int>)).height,
      lessThan(160),
    );
    await tester.tap(find.text('展开节点'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(HyperTreeView<int>)).height, 160);
    await tester.scrollUntilVisible(find.text('节点 29'), 120);
    await tester.pumpAndSettle();
    expect(find.text('节点 29').hitTestable(), findsOneWidget);
  });

  for (final textScale in [1.0, 1.3, 2.0]) {
    testWidgets(
      'bounded tree scrolls without overflow at text scale $textScale',
      (tester) async {
        await tester.pumpWidget(
          host(
            SizedBox(
              width: 160,
              height: 160,
              child: HyperTreeView<int>(nodes: nodes),
            ),
            textScale: textScale,
          ),
        );
        expect(tester.takeException(), isNull);
        expect(find.text('节点 29').hitTestable(), findsNothing);
        await tester.scrollUntilVisible(find.text('节点 29'), 120);
        await tester.pumpAndSettle();
        expect(find.text('节点 29').hitTestable(), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('tree inside a page scroll view keeps the parent scroll owner', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        SizedBox(
          width: 220,
          height: 200,
          child: ListView(children: [HyperTreeView<int>(nodes: nodes)]),
        ),
      ),
    );
    expect(find.byType(Scrollable), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.scrollUntilVisible(find.text('节点 29'), 120);
    await tester.pumpAndSettle();
    expect(find.text('节点 29').hitTestable(), findsOneWidget);
  });
}
