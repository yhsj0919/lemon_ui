import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  testWidgets(
    'mobile selection has one bottom-sheet surface without nested card',
    (t) async {
      await t.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: HyperThemeData.light(),
            child: Scaffold(
              body: HyperSelect<String>.multiple(
                values: const {},
                onSelectionChanged: (_) {},
                presentation: HyperSelectPresentation.bottomSheet,
                options: const [HyperSelectOption(value: 'a', label: '甲')],
              ),
            ),
          ),
        ),
      );
      await t.tap(find.text('请选择'));
      await t.pump();
      await t.pump(const Duration(seconds: 1));
      expect(find.byType(HyperBottomSheet), findsOneWidget);
      expect(find.byType(HyperCard), findsNothing);
      expect(find.text('完成'), findsOneWidget);
      expect(t.takeException(), isNull);
      await t.tap(find.text('完成'));
      await t.pump();
      await t.pump(const Duration(seconds: 1));
    },
  );
  testWidgets('multi-select uses editing inset and primary completion action', (
    t,
  ) async {
    Set<String> values = {};
    await t.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) => HyperSelect<String>.multiple(
                values: values,
                onSelectionChanged: (v) => setState(() => values = v),
                presentation: HyperSelectPresentation.anchored,
                options: const [
                  HyperSelectOption(value: 'design', label: '设计'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await t.pumpAndSettle();
    await t.tap(find.text('请选择'));
    await t.pumpAndSettle();
    final done = t.widget<HyperButton>(
      find
          .ancestor(of: find.text('完成'), matching: find.byType(HyperButton))
          .first,
    );
    expect(done.variant, HyperButtonVariant.filled);
    final card = t.widget<HyperCard>(find.byType(HyperCard));
    final context = t.element(find.byType(HyperCard));
    final sizes = HyperTheme.sizesOf(context);
    final padding = card.style!.padding!.resolve(Directionality.of(context));
    expect(padding.left, sizes.menu.padding);
    expect(padding.right, sizes.menu.padding);
    expect(
      padding.top,
      sizes.dialog.padding.resolve(Directionality.of(context)).top,
    );
    await t.tap(find.text('设计'));
    await t.pumpAndSettle();
    expect(values, {'design'});
    await t.tap(find.text('完成'));
    await t.pumpAndSettle();
    expect(find.text('完成'), findsNothing);
    expect(t.takeException(), isNull);
  });
}
