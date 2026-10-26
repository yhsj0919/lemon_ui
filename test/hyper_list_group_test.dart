import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  testWidgets('titleless group has no header or extra spacing', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          duration: Duration.zero,
          child: const Center(
            child: SizedBox(
              width: 300,
              child: HyperListGroup(
                children: [SizedBox(key: Key('plain-row'), height: 48)],
              ),
            ),
          ),
        ),
      ),
    );
    expect(find.byType(HyperTitledCard), findsNothing);
    expect(
      tester.getRect(find.byType(HyperCard)),
      tester.getRect(find.byKey(const Key('plain-row'))),
    );
    expect(tester.takeException(), isNull);
  });
  for (final position in HyperCardTitlePosition.values) {
    testWidgets('list group content reaches edges $position', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: HyperThemeData.light(),
            duration: Duration.zero,
            child: Center(
              child: SizedBox(
                width: 300,
                child: HyperListGroup(
                  title: const Text('Group'),
                  titlePosition: position,
                  children: const [SizedBox(key: Key('row'), height: 48)],
                ),
              ),
            ),
          ),
        ),
      );
      final card = tester.getRect(find.byType(HyperCard));
      final row = tester.getRect(find.byKey(const Key('row')));
      if (position == HyperCardTitlePosition.inside) {
        final title = tester.getRect(find.text('Group'));
        expect(title.left - card.left, 16);
        expect(title.top - card.top, 16);
      }
      expect(row.left, card.left);
      expect(row.right, card.right);
      expect(row.bottom, card.bottom);
      expect(tester.takeException(), isNull);
    });
  }
}
