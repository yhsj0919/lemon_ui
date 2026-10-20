import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  testWidgets(
    'submit validates and saves values; reset restores initial state',
    (t) async {
      final form = HyperFormController();
      Map<String, Object?>? submitted;
      await t.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: HyperThemeData.light(),
            child: Scaffold(
              body: HyperForm(
                controller: form,
                child: HyperFormSection(
                  children: [
                    HyperTextFormField(
                      name: 'title',
                      initialValue: '',
                      validator: (value) =>
                          value == null || value.isEmpty ? '必填' : null,
                    ),
                    HyperFormActions(
                      controller: form,
                      onSubmit: (values) => submitted = values,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      await t.pumpAndSettle();
      await t.tap(find.text('提交'));
      await t.pumpAndSettle();
      expect(submitted, isNull);
      await t.enterText(find.byType(TextField), '新值');
      await t.tap(find.text('提交'));
      await t.pumpAndSettle();
      expect(submitted, {'title': '新值'});
      expect(form.dirtyFields, {'title'});
      await t.tap(find.text('重置'));
      await t.pumpAndSettle();
      expect(form.value<String>('title'), '');
      expect(form.isDirty, isFalse);
      expect(t.widget<TextField>(find.byType(TextField)).controller!.text, '');
      expect(t.takeException(), isNull);
    },
  );

  testWidgets('keeps actions disabled during asynchronous submission', (
    t,
  ) async {
    final form = HyperFormController();
    final gate = Completer<void>();
    await t.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: Scaffold(
            body: HyperForm(
              controller: form,
              child: HyperFormSection(
                children: [
                  HyperTextFormField(name: 'title', initialValue: '有效值'),
                  HyperFormActions(
                    controller: form,
                    onSubmit: (_) => gate.future,
                    onCancel: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await t.pumpAndSettle();
    await t.tap(find.text('提交'));
    await t.pump();
    expect(form.isSubmitting, isTrue);
    expect(
      t.widget<HyperButton>(find.widgetWithText(HyperButton, '取消')).onPressed,
      isNull,
    );
    expect(
      t.widget<HyperButton>(find.widgetWithText(HyperButton, '重置')).onPressed,
      isNull,
    );
    gate.complete();
    await t.pumpAndSettle();
    expect(form.isSubmitting, isFalse);
    expect(t.takeException(), isNull);
  });

  testWidgets('wraps action buttons within a narrow form width', (t) async {
    final form = HyperFormController();
    await t.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(2)),
            child: Scaffold(
              body: SizedBox(
                width: 240,
                child: HyperForm(
                  controller: form,
                  child: HyperFormSection(
                    children: [
                      HyperTextFormField(name: 'title'),
                      HyperFormActions(
                        controller: form,
                        onSubmit: (_) {},
                        onCancel: () {},
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
    await t.pumpAndSettle();
    expect(t.takeException(), isNull);
  });
}
