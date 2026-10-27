import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  for (final direction in TextDirection.values) {
    for (final scale in [1.0, 1.3, 2.0]) {
      testWidgets(
        'leading trailing $direction scale $scale steps within bounds',
        (t) async {
          double? value = 1;
          await t.pumpWidget(
            MaterialApp(
              home: Directionality(
                textDirection: direction,
                child: HyperTheme(
                  data: HyperThemeData.light(),
                  child: MediaQuery(
                    data: MediaQueryData(textScaler: TextScaler.linear(scale)),
                    child: Scaffold(
                      body: Center(
                        child: SizedBox(
                          width: 240,
                          child: StatefulBuilder(
                            builder: (context, update) => HyperNumberInput(
                              layout: HyperNumberInputLayout.leadingTrailing,
                              value: value,
                              minimum: 0,
                              maximum: 2,
                              showClearButton: true,
                              onChanged: (next) => update(() => value = next),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
          await t.pumpAndSettle();
          final minus = find.byIcon(Icons.remove),
              plus = find.byIcon(Icons.add);
          expect(
            t.widget<HyperWidgetGroup>(find.byType(HyperWidgetGroup)).connected,
            isTrue,
          );
          final minusButton = t.widget<HyperIconButton>(
            find.ancestor(of: minus, matching: find.byType(HyperIconButton)),
          );
          expect(minusButton.style!.borderRadius, BorderRadius.zero);
          final text = find.byType(EditableText);
          final buttonSize = t.getSize(
            find.ancestor(of: minus, matching: find.byType(HyperIconButton)),
          );
          expect(buttonSize.width, closeTo(buttonSize.height, .01));
          await t.tap(text);
          await t.pumpAndSettle();
          final groupStyle = t
              .widget<HyperWidgetGroup>(find.byType(HyperWidgetGroup))
              .style!;
          expect(
            (groupStyle.border! as Border).top.color,
            HyperThemeData.light().colors.primary,
          );
          expect(
            t
                .widget<HyperTextField>(find.byType(HyperTextField))
                .style!
                .border!
                .dimensions,
            EdgeInsets.zero,
          );
          if (direction == TextDirection.ltr) {
            expect(t.getCenter(minus).dx, lessThan(t.getCenter(text).dx));
            expect(t.getCenter(plus).dx, greaterThan(t.getCenter(text).dx));
          } else {
            expect(t.getCenter(minus).dx, greaterThan(t.getCenter(text).dx));
            expect(t.getCenter(plus).dx, lessThan(t.getCenter(text).dx));
          }
          expect(t.getCenter(minus).dy, closeTo(t.getCenter(plus).dy, .01));
          await t.tap(plus);
          await t.pumpAndSettle();
          expect(value, 2);
          await t.tap(plus);
          await t.pumpAndSettle();
          expect(value, 2);
          await t.tap(minus);
          await t.pumpAndSettle();
          expect(value, 1);
          await t.tap(find.byIcon(Icons.close));
          await t.pumpAndSettle();
          expect(value, isNull);
          expect(t.takeException(), isNull);
        },
      );
    }
  }
  testWidgets(
    'layout theme inherits and instance layout overrides without changing input',
    (t) async {
      var layout = HyperNumberInputLayout.leadingTrailing;
      late StateSetter update;
      final theme = HyperThemeData.light().copyWith(
        numberInputTheme: const HyperNumberInputThemeData(
          layout: HyperNumberInputLayout.leadingTrailing,
        ),
      );
      await t.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: theme,
            child: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  update = setState;
                  return HyperNumberInput(
                    value: 1,
                    onChanged: (_) {},
                    layout: layout,
                  );
                },
              ),
            ),
          ),
        ),
      );
      await t.pumpAndSettle();
      final input = t.element(find.byType(EditableText));
      expect(find.byIcon(Icons.remove), findsOneWidget);
      update(() => layout = HyperNumberInputLayout.trailingVertical);
      await t.pumpAndSettle();
      expect(find.byIcon(Icons.keyboard_arrow_up), findsOneWidget);
      expect(t.element(find.byType(EditableText)), same(input));
      expect(theme.copyWith(), theme);
      expect(theme.numberInputTheme, isNot(const HyperNumberInputThemeData()));
    },
  );
}
