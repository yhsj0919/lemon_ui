import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  testWidgets(
    'maximize button responds immediately outside title drag region',
    (t) async {
      final position = HyperMovableDialogController();
      addTearDown(position.dispose);
      await t.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: HyperThemeData.light(),
            child: Scaffold(
              body: HyperMovableDialog(
                controller: position,
                title: const Text('Title'),
                content: const Text('Body'),
              ),
            ),
          ),
        ),
      );
      await t.pumpAndSettle();
      final button = find.widgetWithIcon(HyperIconButton, Icons.crop_square);
      expect(
        find.ancestor(
          of: button,
          matching: find.byKey(const ValueKey('hyper-movable-dialog-handle')),
        ),
        findsNothing,
      );
      await t.tap(button);
      expect(position.maximized, isTrue);
      await t.pumpAndSettle();
      await t.tap(find.widgetWithIcon(HyperIconButton, Icons.filter_none));
      expect(position.maximized, isFalse);
      await t.pumpAndSettle();
      expect(t.takeException(), isNull);
    },
  );
  testWidgets('maximize defers advanced backdrop until geometry completes', (
    t,
  ) async {
    final position = HyperMovableDialogController();
    addTearDown(position.dispose);
    final theme = HyperThemeData.light().copyWith(
      materialTheme: const HyperMaterialThemeData(
        quality: HyperMaterialQuality.advanced,
        material: HyperSurfaceMaterial.frostedGlass(),
      ),
    );
    await t.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: theme,
          child: Scaffold(
            body: HyperMovableDialog(
              controller: position,
              title: const Text('Title'),
              content: const HyperTextField(initialValue: 'draft'),
            ),
          ),
        ),
      ),
    );
    await t.pumpAndSettle();
    final dialog = find.byType(HyperMovableDialog);
    final filters = find.descendant(
      of: dialog,
      matching: find.byType(BackdropFilter),
    );
    expect(filters, findsWidgets);
    final editable = t.widget<EditableText>(find.byType(EditableText));
    for (final maximized in [true, false]) {
      position.setMaximized(maximized);
      await t.pump();
      await t.pump(const Duration(milliseconds: 80));
      expect(
        t.widgetList<BackdropFilter>(filters).every((f) => !f.enabled),
        isTrue,
      );
      expect(
        t.widget<EditableText>(find.byType(EditableText)).controller,
        same(editable.controller),
      );
      await t.pump(const Duration(milliseconds: 180));
      await t.pump();
      await t.pump(const Duration(milliseconds: 50));
      final progress = HyperMaterialTheme.of(
        t.element(find.byType(HyperDialog)),
      ).transitionProgress!;
      expect(progress, greaterThan(0));
      expect(progress, lessThan(1));
      await t.pumpAndSettle();
      expect(filters, findsWidgets);
      expect(
        t.widget<EditableText>(find.byType(EditableText)).controller.text,
        'draft',
      );
      expect(t.takeException(), isNull);
    }
  });
  testWidgets('maximize fills host and restore preserves position and editor', (
    t,
  ) async {
    final position = HyperMovableDialogController();
    addTearDown(position.dispose);
    await t.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: Scaffold(
            body: HyperMovableDialog(
              controller: position,
              title: const Text('Title'),
              content: const HyperTextField(initialValue: 'old'),
              style: const HyperMovableDialogStyle(
                dialogStyle: HyperDialogStyle(width: 300, maxWidth: 300),
              ),
            ),
          ),
        ),
      ),
    );
    await t.pumpAndSettle();
    await t.drag(
      find.byKey(const ValueKey('hyper-movable-dialog-handle')),
      const Offset(40, 20),
    );
    await t.pumpAndSettle();
    final offset = position.offset;
    final editable = find.byType(EditableText);
    await t.enterText(editable, 'draft');
    position.setMaximized(true);
    await t.pump();
    final maximizedWidth = t.getSize(find.byType(HyperTextField)).width;
    await t.pump(const Duration(milliseconds: 40));
    expect(
      t.getSize(find.byType(HyperTextField)).width,
      greaterThan(maximizedWidth),
    );
    expect(
      t.widget<HyperDialog>(find.byType(HyperDialog)).animateInsets,
      isFalse,
    );
    await t.pumpAndSettle();
    expect(position.maximized, isTrue);
    expect(t.getSize(find.byType(HyperTextField)).width, greaterThan(500));
    expect(t.widget<EditableText>(editable).controller.text, 'draft');
    await t.drag(
      find.byKey(const ValueKey('hyper-movable-dialog-handle')),
      const Offset(50, 30),
    );
    await t.pumpAndSettle();
    expect(position.offset, offset);
    position.setMaximized(false);
    await t.pump();
    final restoredWidth = t.getSize(find.byType(HyperTextField)).width;
    await t.pump(const Duration(milliseconds: 40));
    expect(
      t.getSize(find.byType(HyperTextField)).width,
      lessThan(restoredWidth),
    );
    await t.pumpAndSettle();
    expect(position.offset, offset);
    expect(t.getSize(find.byType(HyperTextField)).width, lessThan(300));
    expect(t.widget<EditableText>(editable).controller.text, 'draft');
    expect(t.takeException(), isNull);
  });
  testWidgets(
    'moved dialog can be reopened and edited outside original bounds',
    (t) async {
      final position = HyperMovableDialogController();
      addTearDown(position.dispose);
      await t.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: HyperThemeData.light(),
            child: Scaffold(
              body: Builder(
                builder: (context) => HyperButton.text(
                  label: const Text('Open'),
                  onPressed: () => showHyperMovableDialog<void>(
                    context: context,
                    builder: (context) => HyperMovableDialog(
                      controller: position,
                      title: const Text('Move'),
                      content: const HyperTextField(initialValue: 'old'),
                      style: const HyperMovableDialogStyle(
                        dialogStyle: HyperDialogStyle(
                          width: 240,
                          maxWidth: 240,
                        ),
                      ),
                      actions: [
                        HyperButton.text(
                          label: const Text('Close'),
                          onPressed: () => Navigator.of(context).pop(),
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
      Future<void> open() async {
        await t.tap(find.text('Open'));
        await t.pump();
        await t.pump(const Duration(milliseconds: 400));
      }

      await open();
      await t.drag(
        find.byKey(const ValueKey('hyper-movable-dialog-handle')),
        const Offset(230, 80),
      );
      await t.pump();
      await t.pump(const Duration(milliseconds: 400));
      await t.tap(find.text('Close'));
      await t.pump();
      await t.pump(const Duration(milliseconds: 400));
      await open();
      final editable = find.byType(EditableText);
      await t.tap(editable);
      await t.pump();
      expect(t.widget<EditableText>(editable).focusNode.hasFocus, isTrue);
      await t.enterText(editable, 'edited');
      await t.pump();
      expect(t.widget<EditableText>(editable).controller.text, 'edited');
      expect(t.takeException(), isNull);
    },
  );
}
