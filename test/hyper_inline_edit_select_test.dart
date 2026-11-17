import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  for (final searchable in [false, true]) {
    for (final commitOnChanged in [false, true]) {
      testWidgets(
        'inline select searchable=$searchable commitOnChanged=$commitOnChanged',
        (tester) async {
          final saves = <String>[];
          await tester.pumpWidget(
            HyperTheme(
              data: HyperThemeData.light(),
              child: MaterialApp(
                home: Scaffold(
                  body: Align(
                    alignment: Alignment.topLeft,
                    child: SizedBox(
                      width: 300,
                      child: HyperInlineEdit<String>(
                        value: 'old',
                        activation: HyperInlineEditActivation.tap,
                        commitOnChanged: commitOnChanged,
                        onSaved: saves.add,
                        displayBuilder: (_, value) => Text('display:$value'),
                        editorBuilder: (_, details) => HyperSelect<String>(
                          value: details.value,
                          onChanged: (value) {
                            if (value != null) details.onChanged(value);
                          },
                          searchable: searchable,
                          presentation: HyperSelectPresentation.anchored,
                          options: const [
                            HyperSelectOption(
                              value: 'old',
                              label: 'Old option',
                            ),
                            HyperSelectOption(
                              value: 'new',
                              label: 'New option',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
          await tester.tap(find.text('display:old'));
          await tester.pumpAndSettle();
          await tester.tap(find.byType(HyperSelect<String>));
          await tester.pumpAndSettle();
          if (searchable) {
            final search = find.byType(EditableText);
            await tester.tap(search);
            await tester.pumpAndSettle();
            expect(find.byType(HyperSelect<String>), findsOneWidget);
            expect(saves, isEmpty);
            await tester.enterText(search, 'New');
            await tester.pumpAndSettle();
          }
          await tester.tap(find.text('New option'));
          await tester.pumpAndSettle();
          if (!commitOnChanged && saves.isEmpty) {
            expect(find.text('New option'), findsOneWidget);
            await tester.tapAt(const Offset(700, 500));
            await tester.pumpAndSettle();
          }
          expect(saves, ['new']);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}
