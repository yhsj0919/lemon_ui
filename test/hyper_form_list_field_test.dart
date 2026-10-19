import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  testWidgets(
    'remove preserves remaining input state and reset restores list',
    (t) async {
      final c = HyperFormController();
      await t.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: HyperThemeData.light(),
            child: Scaffold(
              body: HyperForm(
                controller: c,
                child: HyperFormListField<String>(
                  name: 'rows',
                  initialValue: const ['甲', '乙'],
                  maximumItems: 3,
                  createItem: () => '',
                  itemValidator: (v, _) => v.isEmpty ? '必填' : null,
                  itemBuilder: (_, row) => Row(
                    children: [
                      Expanded(
                        child: HyperTextField(
                          initialValue: row.value,
                          onChanged: row.onChanged,
                          errorText: row.errorText,
                        ),
                      ),
                      TextButton(
                        onPressed: row.remove,
                        child: Text('删除${row.index}'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await t.pumpAndSettle();
      await t.enterText(find.byType(EditableText).last, '保留输入');
      await t.pumpAndSettle();
      final remaining = t.state(find.byType(EditableText).last);
      await t.tap(find.text('删除0'));
      await t.pumpAndSettle();
      expect(t.state(find.byType(EditableText)), same(remaining));
      expect(c.value<List<String>>('rows'), ['保留输入']);
      await t.tap(find.text('添加一项'));
      await t.pumpAndSettle();
      expect(await c.validate(), false);
      await t.pumpAndSettle();
      expect(
        t
            .widgetList<HyperTextField>(find.byType(HyperTextField))
            .last
            .errorText,
        '必填',
      );
      c.reset();
      await t.pumpAndSettle();
      expect(c.value<List<String>>('rows'), ['甲', '乙']);
      expect(
        t
            .widgetList<EditableText>(find.byType(EditableText))
            .map((e) => e.controller.text),
        ['甲', '乙'],
      );
      expect(c.isDirty, false);
      expect(t.takeException(), isNull);
    },
  );

  testWidgets('autocomplete adapters use typed values and reset', (t) async {
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
                  HyperAutocompleteFormField<String>(
                    name: 'one',
                    initialValue: 'a',
                    options: const [HyperSelectOption(value: 'a', label: '甲')],
                  ),
                  HyperMultiAutocompleteFormField<String>(
                    name: 'many',
                    options: const [],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await t.pumpAndSettle();
    final fields = t
        .widgetList<HyperAutocomplete<String>>(
          find.byType(HyperAutocomplete<String>),
        )
        .toList();
    fields.first.onChanged!('b');
    fields.last.onSelectionChanged!({'a', 'b'});
    await t.pumpAndSettle();
    expect(c.value<String>('one'), 'b');
    expect(c.value<Set<String>>('many'), {'a', 'b'});
    c.reset();
    await t.pumpAndSettle();
    expect(c.value<String>('one'), 'a');
    expect(c.value<Set<String>>('many'), isEmpty);
    expect(t.takeException(), isNull);
  });
}
