import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  testWidgets('password defaults, visibility toggle and Form lifecycle', (
    tester,
  ) async {
    final form = GlobalKey<FormState>();
    String? saved;
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: Material(
            child: Form(
              key: form,
              child: HyperTextFormField.password(
                name: 'password',
                label: '密码',
                initialValue: 'secret',
                validator: HyperValidators.required(message: '请输入密码'),
                onSaved: (value) => saved = value,
              ),
            ),
          ),
        ),
      ),
    );
    HyperTextField input() => tester.widget(find.byType(HyperTextField));
    EditableText editor() => tester.widget(find.byType(EditableText));
    expect(input().obscureText, isTrue);
    expect(input().showPasswordToggle, isTrue);
    expect(input().autocorrect, isFalse);
    expect(input().enableSuggestions, isFalse);
    expect(input().keyboardType, TextInputType.visiblePassword);
    expect(input().autofillHints, [AutofillHints.password]);
    expect(editor().obscureText, isTrue);
    await tester.tap(find.byIcon(HyperIcons.eye));
    await tester.pumpAndSettle();
    expect(editor().obscureText, isFalse);
    expect(editor().controller.text, 'secret');
    await tester.enterText(find.byType(EditableText), 'new secret');
    form.currentState!.save();
    expect(saved, 'new secret');
    await tester.enterText(find.byType(EditableText), '');
    expect(form.currentState!.validate(), isFalse);
    form.currentState!.reset();
    await tester.pumpAndSettle();
    expect(editor().controller.text, 'secret');
  });

  testWidgets('password allows disabling toggle and changing autofill', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: Material(
            child: HyperTextFormField.password(
              showPasswordToggle: false,
              enabled: false,
              autofillHints: const [AutofillHints.newPassword],
            ),
          ),
        ),
      ),
    );
    final input = tester.widget<HyperTextField>(find.byType(HyperTextField));
    expect(input.autofillHints, [AutofillHints.newPassword]);
    expect(input.enabled, isFalse);
    expect(find.byIcon(HyperIcons.eye), findsNothing);
  });
}
