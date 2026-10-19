import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  for (final sheet in [false, true]) {
    testWidgets('form modal sheet=$sheet validates before closing', (t) async {
      Map<String, Object?>? result;
      await t.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: HyperThemeData.light(),
            child: Scaffold(
              body: Builder(
                builder: (context) => TextButton(
                  onPressed: () async {
                    final show = sheet
                        ? showHyperFormBottomSheet
                        : showHyperFormDialog;
                    result = await show(
                      context: context,
                      builder: (_) => HyperTextFormField(
                        name: 'name',
                        label: '姓名',
                        validator: (v) => v == null || v.isEmpty ? '必填' : null,
                      ),
                    );
                  },
                  child: const Text('打开'),
                ),
              ),
            ),
          ),
        ),
      );
      await t.tap(find.text('打开'));
      await t.pumpAndSettle();
      await t.tap(find.text('确定'));
      await t.pumpAndSettle();
      expect(find.text('必填'), findsWidgets);
      expect(find.text('确定'), findsOneWidget);
      expect(result, isNull);
      await t.enterText(find.byType(EditableText), '小米');
      await t.tap(find.text('确定'));
      await t.pumpAndSettle();
      expect(find.text('确定'), findsNothing);
      expect(result, {'name': '小米'});
      expect(t.takeException(), isNull);
    });
  }

  testWidgets('submission failure stays open and retry is not duplicated', (
    t,
  ) async {
    var calls = 0;
    final pending = Completer<void>();
    await t.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => showHyperFormDialog(
                  context: context,
                  onSubmit: (_) {
                    calls++;
                    return pending.future;
                  },
                  builder: (_) =>
                      HyperTextFormField(name: 'name', initialValue: '保留内容'),
                ),
                child: const Text('打开'),
              ),
            ),
          ),
        ),
      ),
    );
    await t.tap(find.text('打开'));
    await t.pumpAndSettle();
    await t.tap(find.text('确定'));
    await t.pump();
    await t.tap(find.text('确定'));
    await t.pump();
    expect(calls, 1);
    pending.completeError(StateError('保存失败'));
    await t.pumpAndSettle();
    expect(find.textContaining('保存失败'), findsOneWidget);
    expect(find.text('确定'), findsOneWidget);
    expect(
      t.widget<EditableText>(find.byType(EditableText)).controller.text,
      '保留内容',
    );
    await t.tap(find.text('取消'));
    await t.pumpAndSettle();
    expect(find.text('确定'), findsNothing);
    expect(t.takeException(), isNull);
  });
}
