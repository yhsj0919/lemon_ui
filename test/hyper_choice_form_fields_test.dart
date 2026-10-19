import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  testWidgets('choice adapters update values and reset together', (t) async {
    final c = HyperFormController();
    await t.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: Scaffold(
            body: HyperForm(
              controller: c,
              child: HyperFormSection(
                children: [
                  HyperSelectFormField<String>(
                    name: 'select',
                    initialValue: 'a',
                    options: const [
                      HyperSelectOption(value: 'a', label: 'A'),
                      HyperSelectOption(value: 'b', label: 'B'),
                    ],
                  ),
                  HyperCheckboxFormField(name: 'check'),
                  HyperSwitchFormField(name: 'switch'),
                  HyperRadioFormField<String>(
                    name: 'radio',
                    initialValue: 'a',
                    options: const [
                      HyperSelectOption(value: 'a', label: '选项甲'),
                      HyperSelectOption(value: 'b', label: '选项乙'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await t.pumpAndSettle();
    await t.tap(find.byType(HyperCheckbox));
    await t.tap(find.byType(HyperSwitch));
    await t.tap(find.text('选项乙'));
    t.widget<HyperSelect<String>>(find.byType(HyperSelect<String>)).onChanged!(
      'b',
    );
    await t.pumpAndSettle();
    expect(c.values, {
      'select': 'b',
      'check': true,
      'switch': true,
      'radio': 'b',
    });
    expect(c.dirtyFields.length, 4);
    c.reset();
    await t.pumpAndSettle();
    expect(c.values, {
      'select': 'a',
      'check': false,
      'switch': false,
      'radio': 'a',
    });
    expect(t.widget<HyperCheckbox>(find.byType(HyperCheckbox)).value, false);
    expect(t.widget<HyperSwitch>(find.byType(HyperSwitch)).value, false);
    expect(c.isDirty, false);
    expect(t.takeException(), isNull);
  });

  testWidgets('disabled adapters cannot change and skip validation', (t) async {
    final c = HyperFormController();
    String? reject(bool? value) => '不应校验';
    await t.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: Scaffold(
            body: HyperForm(
              controller: c,
              child: HyperFormSection(
                children: [
                  HyperCheckboxFormField(
                    name: 'check',
                    enabled: false,
                    validator: reject,
                  ),
                  HyperSwitchFormField(
                    name: 'switch',
                    enabled: false,
                    validator: reject,
                  ),
                  HyperSelectFormField<String>(
                    enabled: false,
                    options: const [],
                  ),
                  HyperRadioFormField<String>(
                    enabled: false,
                    options: const [
                      HyperSelectOption(value: 'a', label: '禁用单选'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await t.pumpAndSettle();
    expect(
      t.widget<HyperCheckbox>(find.byType(HyperCheckbox)).onChanged,
      isNull,
    );
    expect(t.widget<HyperSwitch>(find.byType(HyperSwitch)).onChanged, isNull);
    expect(
      t.widget<HyperSelect<String>>(find.byType(HyperSelect<String>)).enabled,
      false,
    );
    expect(
      t.widget<HyperRadio<String>>(find.byType(HyperRadio<String>)).onChanged,
      isNull,
    );
    expect(await c.validate(), true);
    expect(t.takeException(), isNull);
  });
}
