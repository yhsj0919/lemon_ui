import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  testWidgets('multi choice count limits immutable values and reset', (
    t,
  ) async {
    final c = HyperFormController();
    final initial = <String>{'a'};
    const options = [
      HyperSelectOption(value: 'a', label: '甲'),
      HyperSelectOption(value: 'b', label: '乙'),
      HyperSelectOption(value: 'c', label: '丙'),
    ];
    await t.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: Scaffold(
            body: HyperForm(
              controller: c,
              child: HyperFormSection(
                children: [
                  HyperMultiSelectFormField<String>(
                    name: 'select',
                    options: options,
                    minimumSelection: 1,
                    maximumSelection: 2,
                    initialValue: initial,
                  ),
                  HyperCheckboxGroupFormField<String>(
                    name: 'group',
                    options: options,
                    minimumSelection: 1,
                    maximumSelection: 2,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    initial.add('c');
    await t.pumpAndSettle();
    expect(c.value<Set<String>>('select'), {'a'});
    expect(await c.validate(), false);
    await t.pumpAndSettle();
    expect(find.byTooltip('至少选择 1 项'), findsOneWidget);
    await t.tap(find.byType(HyperCheckbox).at(0));
    await t.pumpAndSettle();
    await t.tap(find.byType(HyperCheckbox).at(1));
    await t.pumpAndSettle();
    expect(
      t.widget<HyperCheckbox>(find.byType(HyperCheckbox).at(2)).onChanged,
      isNull,
    );
    expect(c.value<Set<String>>('group'), {'a', 'b'});
    expect(await c.validate(), true);
    final select = t.widget<HyperSelect<String>>(
      find.byType(HyperSelect<String>),
    );
    select.onSelectionChanged!({});
    await t.pumpAndSettle();
    expect(await c.validate(), false);
    expect(
      () => c.value<Set<String>>('group')!.add('c'),
      throwsUnsupportedError,
    );
    c.reset();
    await t.pumpAndSettle();
    expect(c.value<Set<String>>('select'), {'a'});
    expect(c.value<Set<String>>('group'), isEmpty);
    expect(c.isDirty, false);
    expect(t.takeException(), isNull);
  });

  test('invalid count bounds reject', () {
    expect(
      () => HyperCheckboxGroupFormField<String>(
        options: const [],
        minimumSelection: 3,
        maximumSelection: 2,
      ),
      throwsArgumentError,
    );
  });
}
