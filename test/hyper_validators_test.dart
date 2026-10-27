import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  test('required checks empty values without rejecting false or zero', () {
    final rule = HyperValidators.required<Object>(message: 'required');
    for (final value in [null, '', ' \n ', <int>[], <int>{}, <String, int>{}]) {
      expect(rule(value), 'required');
    }
    for (final value in [
      false,
      0,
      '0',
      [0],
      {'a': 0},
      Object(),
    ]) {
      expect(rule(value), isNull);
    }
    expect(HyperValidators.required<String>(trim: false)(' '), isNull);
  });

  test('length uses grapheme clusters and optional values skip', () {
    final min = HyperValidators.minLength(2, message: 'short');
    final max = HyperValidators.maxLength(1, message: 'long');
    for (final value in [null, '']) {
      expect(min(value), isNull);
      expect(max(value), isNull);
    }
    for (final value in ['中', '👨‍👩‍👧‍👦', 'e\u0301']) {
      expect(min(value), 'short');
      expect(max(value), isNull);
    }
    expect(min('中文'), isNull);
    expect(max('中文'), 'long');
    expect(HyperValidators.minLength(2, trim: true)(' x '), isNotNull);
    expect(HyperValidators.minLength(2)(' x '), isNull);
    expect(HyperValidators.minLength(0)('x'), isNull);
    expect(HyperValidators.maxLength(0)('x'), isNotNull);
    expect(() => HyperValidators.minLength(-1), throwsArgumentError);
    expect(() => HyperValidators.maxLength(-1), throwsArgumentError);
  });

  test('compose preserves order, stops at first error and snapshots rules', () {
    var calls = 0;
    final rules = <FormFieldValidator<String>>[
      HyperValidators.required(message: 'required'),
      HyperValidators.minLength(2, message: 'short'),
      (_) {
        calls++;
        return null;
      },
    ];
    final rule = HyperValidators.compose(rules);
    rules.clear();
    expect(rule(''), 'required');
    expect(rule('a'), 'short');
    expect(calls, 0);
    expect(rule('ab'), isNull);
    expect(calls, 1);
    expect(HyperValidators.compose<String>([])(null), isNull);
  });

  testWidgets('required indicator alone does not validate; helper does', (
    tester,
  ) async {
    final form = GlobalKey<FormState>();
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: Material(
            child: Form(
              key: form,
              child: Column(
                children: [
                  HyperTextFormField(
                    name: 'optional',
                    label: '标记',
                    requiredIndicator: true,
                  ),
                  HyperTextFormField(
                    name: 'required',
                    label: '校验',
                    validator: HyperValidators.required(message: '请输入内容'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    expect(form.currentState!.validate(), isFalse);
    await tester.pumpAndSettle();
    expect(find.text('请输入内容'), findsOneWidget);
    await tester.enterText(find.byType(EditableText).last, '完成');
    expect(form.currentState!.validate(), isTrue);
  });
}
