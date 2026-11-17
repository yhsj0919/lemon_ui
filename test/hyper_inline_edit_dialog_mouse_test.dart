import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  testWidgets('description values support constraint-based child layout', (
    tester,
  ) async {
    await tester.pumpWidget(
      HyperTheme(
        data: HyperThemeData.light(),
        child: MaterialApp(
          home: Scaffold(
            body: HyperDescriptionList(
              items: [
                HyperDescriptionItem(
                  id: 'layout',
                  label: const Text('名称'),
                  value: LayoutBuilder(
                    builder: (_, constraints) =>
                        const SizedBox(height: 48, child: Text('内容')),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
  });
  for (final movable in [false, true]) {
    testWidgets(
      'mouse double click populated inline editor in dialog movable=$movable',
      (tester) async {
        late BuildContext source;
        await tester.pumpWidget(
          HyperTheme(
            data: HyperThemeData.light(),
            child: MaterialApp(
              home: Builder(
                builder: (context) {
                  source = context;
                  return const Scaffold();
                },
              ),
            ),
          ),
        );
        final editor = HyperDescriptionList(
          items: [
            HyperDescriptionItem(
              id: 'value',
              label: const Text('名称'),
              value: HyperInlineEdit.text(value: '已有内容', onSaved: (_) {}),
            ),
          ],
        );
        showHyperDialog<void>(
          context: source,
          builder: (_) => movable
              ? HyperMovableDialog(title: const Text('编辑'), content: editor)
              : HyperDialog(title: const Text('编辑'), content: editor),
        );
        await tester.pumpAndSettle();
        final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
        await mouse.addPointer(location: const Offset(1, 1));
        final point = tester.getCenter(find.text('已有内容'));
        await mouse.moveTo(point);
        await tester.pumpAndSettle();
        await tester.tapAt(point, kind: PointerDeviceKind.mouse);

        await tester.pump(const Duration(milliseconds: 50));
        await tester.tapAt(point, kind: PointerDeviceKind.mouse);

        await tester.pumpAndSettle();
        expect(find.byType(EditableText), findsOneWidget);
        expect(tester.takeException(), isNull);
        await mouse.moveTo(point + const Offset(2, 2));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await mouse.removePointer();
        await tester.pumpWidget(const SizedBox());
      },
    );
  }
}
