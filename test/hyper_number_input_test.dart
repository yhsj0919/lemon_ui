import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

Widget host(Widget child) => MaterialApp(
  home: HyperTheme(
    data: HyperThemeData.light(),
    child: Scaffold(body: child),
  ),
);
void main() {
  testWidgets(
    'stepper end inset is stable across clear error and disabled states',
    (t) async {
      double? inset;
      for (final state in [0, 1, 2, 3]) {
        await t.pumpWidget(
          host(
            SizedBox(
              width: 300,
              child: HyperNumberInput(
                value: 10,
                onChanged: state == 2 ? null : (_) {},
                readOnly: state == 3,
                showClearButton: state == 0,
                errorText: state == 0 ? '错误' : null,
              ),
            ),
          ),
        );
        await t.pumpAndSettle();
        final right = t.getRect(find.byType(HyperTextField)).right;
        final arrow = t.getCenter(find.byIcon(Icons.keyboard_arrow_up)).dx;
        inset ??= right - arrow;
        expect(right - arrow, closeTo(inset, .01));
        expect(t.takeException(), isNull);
      }
    },
  );
  testWidgets('clear action precedes outermost step controls', (t) async {
    await t.pumpWidget(
      host(
        HyperNumberInput(
          value: 10,
          onChanged: (_) {},
          showClearButton: true,
          errorText: '错误',
        ),
      ),
    );
    await t.pumpAndSettle();
    final clear = find.byIcon(Icons.close);
    final up = find.byIcon(Icons.keyboard_arrow_up);
    final down = find.byIcon(Icons.keyboard_arrow_down);
    expect(t.getCenter(clear).dx, lessThan(t.getCenter(up).dx));
    expect(t.getCenter(up).dx, closeTo(t.getCenter(down).dx, .01));
    expect(
      t.getCenter(find.byIcon(Icons.error_outline)).dx,
      lessThan(t.getCenter(up).dx),
    );
    expect(t.takeException(), isNull);
  });
  testWidgets('decimal steps keyboard and clamp', (t) async {
    double? value = .1;
    await t.pumpWidget(
      host(
        StatefulBuilder(
          builder: (_, setState) => HyperNumberInput(
            value: value,
            minimum: 0,
            maximum: .3,
            step: .1,
            precision: 2,
            onChanged: (v) => setState(() => value = v),
          ),
        ),
      ),
    );
    await t.pumpAndSettle();
    await t.tap(find.byIcon(Icons.keyboard_arrow_up));
    await t.pumpAndSettle();
    expect(value, .2);
    await t.tap(find.byType(EditableText));
    await t.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await t.pumpAndSettle();
    expect(value, .3);
    await t.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await t.pumpAndSettle();
    expect(value, .3);
    expect(
      t.widget<EditableText>(find.byType(EditableText)).controller.text,
      '0.30',
    );
    expect(t.takeException(), isNull);
  });

  testWidgets('form clear validation and reset refresh visible text', (
    t,
  ) async {
    final c = HyperFormController();
    await t.pumpWidget(
      host(
        HyperForm(
          controller: c,
          layout: HyperFieldLayout.labelHidden,
          child: HyperNumberFormField(
            name: 'amount',
            initialValue: 5,
            validator: (v) => v == null ? '请填写' : null,
          ),
        ),
      ),
    );
    await t.pumpAndSettle();
    await t.enterText(find.byType(EditableText), '');
    await t.pumpAndSettle();
    expect(c.value<double>('amount'), isNull);
    expect(await c.validate(), false);
    await t.pumpAndSettle();
    expect(
      t.widget<HyperTextField>(find.byType(HyperTextField)).errorText,
      '请填写',
    );
    c.reset();
    await t.pumpAndSettle();
    expect(c.value<double>('amount'), 5);
    expect(
      t.widget<EditableText>(find.byType(EditableText)).controller.text,
      '5',
    );
    expect(c.isDirty, false);
    expect(t.takeException(), isNull);
  });

  for (final scale in [1.0, 1.3, 2.0]) {
    testWidgets('number input narrow layout scale $scale', (t) async {
      await t.pumpWidget(
        host(
          MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(scale)),
            child: SizedBox(
              width: 180,
              child: HyperNumberInput(value: 12, onChanged: (_) {}),
            ),
          ),
        ),
      );
      await t.pumpAndSettle();
      expect(t.takeException(), isNull);
    });
  }

  test('invalid numeric configuration rejects', () {
    expect(
      () => HyperNumberInput(value: 0, onChanged: null, step: 0),
      throwsArgumentError,
    );
    expect(
      () => HyperNumberInput(value: 0, onChanged: null, minimum: 2, maximum: 1),
      throwsArgumentError,
    );
  });
}
