import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/pages/content/inline_edit_description_demo.dart';

void main() {
  testWidgets('row height is adjustable in integer pixels with minimum 32', (
    t,
  ) async {
    await t.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: const Scaffold(
            body: SingleChildScrollView(
              child: SizedBox(width: 360, child: InlineEditDescriptionDemo()),
            ),
          ),
        ),
      ),
    );
    final input = find.descendant(
      of: find.byKey(const ValueKey('description-row-height')),
      matching: find.byType(EditableText),
    );
    double? editorHeight;
    for (final height in [32, 48, 33]) {
      await t.enterText(input, '$height');
      await t.testTextInput.receiveAction(TextInputAction.done);
      await t.pumpAndSettle();
      for (final id in [
        'description-name-row',
        'description-note-viewport',
        'description-state-row',
        'description-details-row',
      ]) {
        expect(t.getSize(find.byKey(ValueKey(id))).height, height.toDouble());
      }
      await t.longPress(find.text('示例项目'));
      await t.pumpAndSettle();
      final editor = find.descendant(
        of: find.byKey(const ValueKey('description-edit-name')),
        matching: find.byType(HyperTextField),
      );
      final editorRect = t.getRect(editor);
      editorHeight ??= editorRect.height;
      expect(editorRect.height, editorHeight);
      expect(
        editorRect.center.dy,
        closeTo(
          t
              .getRect(find.byKey(const ValueKey('description-name-row')))
              .center
              .dy,
          .01,
        ),
      );
      await t.sendKeyEvent(LogicalKeyboardKey.escape);
      await t.pumpAndSettle();
      await t.longPress(find.text('已启用'));
      await t.pumpAndSettle();
      expect(
        t.getSize(find.byKey(const ValueKey('description-state-row'))).height,
        height.toDouble(),
      );
      expect(
        t.getSize(find.byType(HyperSwitch)).height,
        lessThanOrEqualTo(height.toDouble()),
      );
      await t.sendKeyEvent(LogicalKeyboardKey.escape);
      await t.pumpAndSettle();
    }
  });
  testWidgets(
    'description values save on blur, cancel with Escape and keep multiline viewport',
    (t) async {
      for (final scale in [1.0, 1.3, 2.0]) {
        await t.pumpWidget(
          MaterialApp(
            home: HyperTheme(
              data: HyperThemeData.light(),
              child: MediaQuery(
                data: MediaQueryData(textScaler: TextScaler.linear(scale)),
                child: const Scaffold(
                  body: SingleChildScrollView(
                    child: SizedBox(
                      width: 240,
                      child: InlineEditDescriptionDemo(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        final firstRow = t.getRect(
          find.byKey(const ValueKey('description-name-row')),
        );
        final noteRow = t.getRect(
          find.byKey(const ValueKey('description-note-viewport')),
        );
        expect(noteRow.top, closeTo(firstRow.bottom, .01));
        expect(noteRow.height, firstRow.height);
        for (final id in ['description-state-row', 'description-details-row']) {
          expect(t.getSize(find.byKey(ValueKey(id))).height, firstRow.height);
        }
        final name = find.byKey(const ValueKey('description-edit-name'));
        await t.ensureVisible(name);
        await t.longPress(
          find.descendant(of: name, matching: find.text('示例项目')),
        );
        await t.pumpAndSettle();
        await t.enterText(
          find.descendant(of: name, matching: find.byType(EditableText)),
          '更新项目',
        );
        await t.tapAt(const Offset(700, 50));
        await t.pumpAndSettle();
        expect(find.text('更新项目'), findsOneWidget);
        final note = find.byKey(const ValueKey('description-edit-note'));
        await t.ensureVisible(note);
        await t.pumpAndSettle();
        final viewport = find.byKey(
          const ValueKey('description-note-viewport'),
        );
        final height = t.getSize(viewport).height;
        await t.longPress(find.text('双击修改项目备注。'));
        await t.pumpAndSettle();
        final fieldRect = t.getRect(
          find.descendant(of: note, matching: find.byType(HyperTextField)),
        );
        final viewportRect = t.getRect(viewport);
        expect(fieldRect.top, greaterThanOrEqualTo(viewportRect.top - .01));
        expect(fieldRect.bottom, lessThanOrEqualTo(viewportRect.bottom + .01));
        await t.enterText(
          find.descendant(of: note, matching: find.byType(EditableText)),
          '一\n二\n三\n四\n五',
        );
        await t.pumpAndSettle();
        expect(t.getSize(viewport).height, height);
        await t.sendKeyEvent(LogicalKeyboardKey.escape);
        await t.pumpAndSettle();
        expect(find.text('双击修改项目备注。'), findsOneWidget);
        final state = find.byKey(const ValueKey('description-state-row'));
        await t.ensureVisible(state);
        await t.pumpAndSettle();
        final stateHeight = t.getSize(state).height;
        final detail = find.byKey(const ValueKey('description-edit-details'));
        final detailTop = t.getTopLeft(detail).dy;
        await t.longPress(find.text('已启用'));
        await t.pumpAndSettle();
        expect(find.byType(HyperSwitch), findsOneWidget);
        expect(t.getSize(state).height, stateHeight);
        expect(t.getTopLeft(detail).dy, closeTo(detailTop, .01));
        await t.tap(find.byType(HyperSwitch));
        await t.pumpAndSettle();
        expect(find.text('已停用'), findsOneWidget);
        expect(t.getSize(state).height, stateHeight);
        expect(t.getTopLeft(detail).dy, closeTo(detailTop, .01));
        expect(t.takeException(), isNull);
        await t.pumpWidget(const SizedBox());
      }
    },
  );
}
