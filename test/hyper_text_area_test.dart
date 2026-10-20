import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  testWidgets('defaults to growing multiline text and forwards edits', (
    t,
  ) async {
    String? changed;
    await t.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: Scaffold(
            body: HyperTextArea(
              initialValue: '已有说明',
              onChanged: (value) => changed = value,
            ),
          ),
        ),
      ),
    );
    final input = t.widget<TextField>(find.byType(TextField));
    expect(input.minLines, 3);
    expect(input.maxLines, isNull);
    expect(input.keyboardType, TextInputType.multiline);
    await t.enterText(find.byType(TextField), '第一行\n第二行');
    expect(changed, '第一行\n第二行');
    expect(t.takeException(), isNull);
  });

  testWidgets('keeps multiline content usable at larger text scales', (
    t,
  ) async {
    for (final scale in [1.0, 1.3, 2.0]) {
      await t.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: HyperThemeData.light(),
            child: MediaQuery(
              data: MediaQueryData(textScaler: TextScaler.linear(scale)),
              child: const Scaffold(
                body: Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    width: 220,
                    child: HyperTextArea(
                      label: '补充说明',
                      hintText: '请描述具体情况',
                      initialValue: '第一行内容\n第二行内容',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await t.pumpAndSettle();
      expect(t.takeException(), isNull, reason: 'text scale $scale');
      expect(t.widget<TextField>(find.byType(TextField)).minLines, 3);
    }
  });

  testWidgets('Form field validates, submits values and resets', (t) async {
    final form = HyperFormController();
    await t.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: Scaffold(
            body: HyperForm(
              controller: form,
              child: HyperFormSection(
                children: [
                  HyperTextAreaFormField(
                    name: 'reason',
                    initialValue: '初始原因',
                    minLines: 2,
                    maxLines: 5,
                    validator: (value) =>
                        value == null || value.isEmpty ? '请填写原因' : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await t.pumpAndSettle();
    expect(form.value<String>('reason'), '初始原因');
    await t.enterText(find.byType(TextField), '更新后的原因');
    expect(form.value<String>('reason'), '更新后的原因');
    expect(await form.validate(), isTrue);
    form.reset();
    await t.pumpAndSettle();
    expect(form.value<String>('reason'), '初始原因');
    expect(
      t.widget<TextField>(find.byType(TextField)).controller!.text,
      '初始原因',
    );
    expect(t.takeException(), isNull);
  });
}
