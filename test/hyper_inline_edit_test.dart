import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

Widget host(Widget child, {double scale = 1, HyperThemeData? theme}) =>
    MaterialApp(
      home: HyperTheme(
        data: theme ?? HyperThemeData.light(),
        child: Scaffold(
          body: MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(scale)),
            child: SingleChildScrollView(
              child: SizedBox(width: 240, child: child),
            ),
          ),
        ),
      ),
    );
Future<void> open(WidgetTester t, String value) async {
  await t.tap(find.text(value));
  await t.pump(const Duration(milliseconds: 50));
  await t.tap(find.text(value));
  await t.pumpAndSettle();
}

void main() {
  testWidgets(
    'bounded multiline surface scrolls text inside its 32 pixel border',
    (t) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      await t.pumpWidget(
        host(
          SizedBox(
            height: 32,
            child: HyperTextField(
              controller: controller,
              expands: true,
              maxLines: null,
              style: const HyperTextFieldStyle(
                minimumHeight: 32,
                padding: EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          ),
        ),
      );
      final text = List.generate(8, (i) => '第 $i 行').join('\n');
      await t.enterText(find.byType(EditableText), text);
      await t.pumpAndSettle();
      expect(t.getSize(find.byType(HyperTextField)).height, 32);
      expect(controller.text, text);
      expect(
        t
            .state<EditableTextState>(find.byType(EditableText))
            .renderEditable
            .offset
            .pixels,
        greaterThan(0),
      );
      expect(t.takeException(), isNull);
    },
  );
  testWidgets('compact input surface including border fits a 32 pixel row', (
    t,
  ) async {
    for (final multiline in [false, true]) {
      await t.pumpWidget(
        host(
          HyperInlineEdit.text(
            value: 'old',
            onSaved: (_) {},
            multiline: multiline,
            showActions: false,
            style: const HyperInlineEditStyle(
              inputStyle: HyperTextFieldStyle(
                minimumHeight: 32,
                padding: EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          ),
        ),
      );
      await open(t, 'old');
      expect(t.getSize(find.byType(HyperTextField)).height, 32);
      await t.pumpWidget(const SizedBox());
    }
  });
  testWidgets('changing motion settings preserves draft selection and focus', (
    t,
  ) async {
    late StateSetter update;
    var instant = false;
    await t.pumpWidget(
      host(
        StatefulBuilder(
          builder: (_, set) {
            update = set;
            return HyperInlineEdit.text(
              value: 'old',
              onSaved: (_) {},
              style: HyperInlineEditStyle(
                transitionDuration: instant
                    ? Duration.zero
                    : const Duration(milliseconds: 120),
              ),
            );
          },
        ),
      ),
    );
    await open(t, 'old');
    await t.enterText(find.byType(EditableText), 'draft');
    final editable = t.widget<EditableText>(find.byType(EditableText));
    editable.controller.selection = const TextSelection.collapsed(offset: 2);
    for (final value in [true, false, true]) {
      update(() => instant = value);
      await t.pumpAndSettle();
      final current = t.widget<EditableText>(find.byType(EditableText));
      expect(current.controller, same(editable.controller));
      expect(current.controller.text, 'draft');
      expect(current.controller.selection.baseOffset, 2);
      expect(current.focusNode.hasFocus, isTrue);
      expect(t.takeException(), isNull);
    }
  });
  testWidgets('zero duration survives reassemble and editor size changes', (
    t,
  ) async {
    await t.pumpWidget(
      host(
        HyperInlineEdit.text(
          value: 'old',
          onSaved: (_) {},
          style: const HyperInlineEditStyle(transitionDuration: Duration.zero),
        ),
      ),
    );
    t.binding.buildOwner!.reassemble(t.binding.rootElement!);
    await t.pump();
    await open(t, 'old');
    expect(find.byType(EditableText), findsOneWidget);
    await t.enterText(find.byType(EditableText), 'draft');
    t.binding.buildOwner!.reassemble(t.binding.rootElement!);
    await t.pumpAndSettle();
    expect(
      t.widget<EditableText>(find.byType(EditableText)).controller.text,
      'draft',
    );
    await t.sendKeyEvent(LogicalKeyboardKey.escape);
    await t.pumpAndSettle();
    expect(t.takeException(), isNull);
  });
  testWidgets(
    'compact multiline editor centers short text and grows with scaling',
    (t) async {
      for (final scale in [1.0, 1.3, 2.0]) {
        await t.pumpWidget(
          host(
            HyperInlineEdit.text(
              value: '描述',
              multiline: true,
              showActions: false,
              onSaved: (_) {},
            ),
            scale: scale,
          ),
        );
        await open(t, '描述');
        final field = find.byType(TextField);
        expect(
          t.widget<TextField>(field).textAlignVertical,
          TextAlignVertical.center,
        );
        final editable = t.getRect(find.byType(EditableText));
        final surface = t.getRect(find.byType(HyperTextField));
        expect(editable.center.dy, closeTo(surface.center.dy, 1));
        final height = surface.height;
        await t.enterText(find.byType(EditableText), '第一行\n第二行\n第三行');
        await t.pumpAndSettle();
        expect(
          t.getSize(find.byType(HyperTextField)).height,
          greaterThan(height),
        );
        expect(t.takeException(), isNull);
        await t.pumpWidget(const SizedBox());
      }
      await t.pumpWidget(
        host(
          HyperInlineEdit.text(
            value: '描述',
            multiline: true,
            style: const HyperInlineEditStyle(
              inputStyle: HyperTextFieldStyle(
                textAlignVertical: TextAlignVertical.top,
              ),
            ),
            onSaved: (_) {},
          ),
        ),
      );
      await open(t, '描述');
      expect(
        t.widget<TextField>(find.byType(TextField)).textAlignVertical,
        TextAlignVertical.top,
      );
    },
  );
  testWidgets(
    'clicking non-focusable background saves without action buttons',
    (t) async {
      var value = 'old';
      var saves = 0;
      await t.pumpWidget(
        host(
          StatefulBuilder(
            builder: (_, set) => Column(
              children: [
                HyperInlineEdit.text(
                  value: value,
                  showActions: false,
                  onSaved: (v) => set(() {
                    value = v;
                    saves++;
                  }),
                ),
                const SizedBox(
                  key: ValueKey('background'),
                  width: 240,
                  height: 100,
                ),
              ],
            ),
          ),
        ),
      );
      await open(t, 'old');
      expect(find.text('保存'), findsNothing);
      await t.enterText(find.byType(EditableText), 'new');
      await t.tapAt(t.getCenter(find.byKey(const ValueKey('background'))));
      await t.pumpAndSettle();
      expect(value, 'new');
      expect(saves, 1);
      await open(t, 'new');
      await t.enterText(find.byType(EditableText), 'cancelled');
      await t.sendKeyEvent(LogicalKeyboardKey.escape);
      await t.pumpAndSettle();
      await t.tapAt(t.getCenter(find.byKey(const ValueKey('background'))));
      await t.pumpAndSettle();
      expect(value, 'new');
      expect(saves, 1);
    },
  );

  testWidgets('display cursor is clickable and supports style override', (
    t,
  ) async {
    await t.pumpWidget(
      host(HyperInlineEdit.text(value: 'old', onSaved: (_) {})),
    );
    expect(
      t.widget<HyperPressable>(find.byType(HyperPressable)).mouseCursor,
      SystemMouseCursors.click,
    );
    await t.pumpWidget(
      host(
        HyperInlineEdit.text(
          value: 'old',
          onSaved: (_) {},
          style: const HyperInlineEditStyle(
            mouseCursor: SystemMouseCursors.text,
          ),
        ),
      ),
    );
    expect(
      t.widget<HyperPressable>(find.byType(HyperPressable)).mouseCursor,
      SystemMouseCursors.text,
    );
    const a = HyperInlineEditStyle(mouseCursor: SystemMouseCursors.click);
    const b = HyperInlineEditStyle(mouseCursor: SystemMouseCursors.text);
    expect(a.copyWith(mouseCursor: b.mouseCursor), b);
    expect(HyperInlineEditStyle.lerp(a, b, 1), b);
  });

  testWidgets(
    'dialog mode keeps display layout, null cancels and result saves',
    (t) async {
      var value = 'old', saves = 0, opens = 0;
      late Completer<String?> result;
      await t.pumpWidget(
        host(
          StatefulBuilder(
            builder: (_, set) => HyperInlineEdit<String>.dialog(
              value: value,
              displayBuilder: (_, v) => Text(v),
              dialogBuilder: (_, v) {
                opens++;
                result = Completer<String?>();
                return result.future;
              },
              onSaved: (v) => set(() {
                value = v;
                saves++;
              }),
            ),
          ),
        ),
      );
      final height = t.getSize(find.byType(HyperInlineEdit<String>)).height;
      await open(t, 'old');
      expect(find.byType(EditableText), findsNothing);
      expect(t.getSize(find.byType(HyperInlineEdit<String>)).height, height);
      await open(t, 'old');
      expect(opens, 1);
      result.complete(null);
      await t.pumpAndSettle();
      expect(saves, 0);
      await open(t, 'old');
      result.complete('new');
      await t.pumpAndSettle();
      expect(value, 'new');
      expect(saves, 1);
    },
  );

  testWidgets(
    'dialog validation and save failures surface errors; stale result is ignored',
    (t) async {
      var value = 'old';
      late StateSetter update;
      late Completer<String?> result;
      var saves = 0;
      await t.pumpWidget(
        host(
          StatefulBuilder(
            builder: (_, set) {
              update = set;
              return HyperInlineEdit<String>.dialog(
                value: value,
                displayBuilder: (_, v) => Text(v),
                dialogBuilder: (_, v) {
                  result = Completer<String?>();
                  return result.future;
                },
                validator: (v) => v.isEmpty ? 'required' : null,
                onSaved: (_) {
                  saves++;
                  throw StateError('offline');
                },
              );
            },
          ),
        ),
      );
      await open(t, 'old');
      result.complete('');
      await t.pumpAndSettle();
      expect(find.text('required'), findsOneWidget);
      expect(saves, 0);
      await open(t, 'old');
      result.complete('new');
      await t.pumpAndSettle();
      expect(find.text('保存失败，请重试'), findsOneWidget);
      expect(saves, 1);
      await open(t, 'old');
      update(() => value = 'server');
      await t.pump();
      result.complete('stale');
      await t.pumpAndSettle();
      expect(find.text('server'), findsOneWidget);
      expect(saves, 1);
    },
  );
  testWidgets(
    'dialog picker returns a draft without saving on route focus loss',
    (t) async {
      var saves = 0;
      await t.pumpWidget(
        host(
          HyperInlineEdit<String>(
            value: 'old',
            displayBuilder: (_, value) => Text(value),
            onSaved: (_) => saves++,
            editorBuilder: (context, details) => HyperButton.text(
              label: Text('选择 ${details.value}'),
              onPressed: () => details.runOverlay(() async {
                final value = await showHyperDialog<String>(
                  context: context,
                  builder: (context) => HyperDialog(
                    content: HyperButton.text(
                      label: const Text('新值'),
                      onPressed: () => Navigator.of(context).pop('new'),
                    ),
                  ),
                );
                if (value != null) details.onChanged(value);
              }),
            ),
          ),
        ),
      );
      await open(t, 'old');
      await t.tap(find.text('选择 old'));
      // Trigger button remains busy for the lifetime of the modal operation.
      await t.pump();
      await t.pump(const Duration(milliseconds: 500));
      expect(saves, 0);
      await t.tap(find.text('新值'));
      await t.pumpAndSettle();
      expect(find.text('选择 new'), findsOneWidget);
      expect(saves, 0);
      await t.tap(find.text('保存'));
      await t.pumpAndSettle();
      expect(saves, 1);
    },
  );
  testWidgets('unchanged drafts skip saver; composing Enter does not submit', (
    t,
  ) async {
    var saves = 0;
    await t.pumpWidget(
      host(HyperInlineEdit.text(value: 'old', onSaved: (_) => saves++)),
    );
    await open(t, 'old');
    await t.tap(find.text('保存'));
    await t.pumpAndSettle();
    expect(saves, 0);
    await open(t, 'old');
    t.testTextInput.updateEditingValue(
      const TextEditingValue(
        text: '中文',
        selection: TextSelection.collapsed(offset: 2),
        composing: TextRange(start: 0, end: 2),
      ),
    );
    await t.pump();
    await t.sendKeyEvent(LogicalKeyboardKey.enter);
    await t.pump();
    expect(saves, 0);
    expect(find.byType(EditableText), findsOneWidget);
    t.testTextInput.updateEditingValue(
      const TextEditingValue(
        text: '中文',
        selection: TextSelection.collapsed(offset: 2),
      ),
    );
    await t.pump();
    await t.testTextInput.receiveAction(TextInputAction.done);
    await t.pumpAndSettle();
    expect(saves, 1);
  });

  testWidgets(
    'invalid blur policy can cancel; save failure after disposal is ignored',
    (t) async {
      var saves = 0;
      final outside = FocusNode();
      addTearDown(outside.dispose);
      await t.pumpWidget(
        host(
          Column(
            children: [
              HyperInlineEdit<String>(
                value: 'old',
                displayBuilder: (_, v) => Text(v),
                invalidBlurBehavior: HyperInlineEditInvalidBlurBehavior.cancel,
                validator: (_) => 'invalid',
                onSaved: (_) => saves++,
                editorBuilder: (_, d) => HyperTextField(
                  initialValue: d.value,
                  focusNode: d.focusNode,
                  onChanged: d.onChanged,
                ),
              ),
              TextButton(
                focusNode: outside,
                onPressed: () {},
                child: const Text('outside'),
              ),
            ],
          ),
        ),
      );
      await open(t, 'old');
      outside.requestFocus();
      await t.pumpAndSettle();
      expect(find.byType(EditableText), findsNothing);
      expect(saves, 0);
      final pending = Completer<void>();
      await t.pumpWidget(
        host(
          HyperInlineEdit.text(value: 'old', onSaved: (_) => pending.future),
        ),
      );
      await open(t, 'old');
      await t.enterText(find.byType(EditableText), 'new');
      await t.tap(find.text('保存'));
      await t.pump();
      await t.pumpWidget(const SizedBox());
      pending.completeError(StateError('offline'));
      await t.pump();
      expect(t.takeException(), isNull);
    },
  );

  testWidgets('replacement transition observes reduced motion', (t) async {
    Duration? duration;
    await t.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: HyperInlineEdit<bool>(
              value: false,
              onSaved: (_) {},
              displayBuilder: (_, v) => Text('$v'),
              editorBuilder: (_, d) => const Text('edit'),
              style: const HyperInlineEditStyle(
                transitionDuration: Duration(seconds: 1),
              ),
              transitionBuilder: (_, child, value, curve) {
                duration = value;
                return child;
              },
            ),
          ),
        ),
      ),
    );
    expect(duration, Duration.zero);
  });

  testWidgets('draft is isolated; Escape cancels, Enter saves', (t) async {
    var value = 'old';
    var saves = 0;
    await t.pumpWidget(
      host(
        StatefulBuilder(
          builder: (_, set) => HyperInlineEdit.text(
            value: value,
            onSaved: (v) => set(() {
              value = v;
              saves++;
            }),
          ),
        ),
      ),
    );
    await open(t, 'old');
    await t.enterText(find.byType(EditableText), 'draft');
    expect(value, 'old');
    await t.sendKeyEvent(LogicalKeyboardKey.escape);
    await t.pumpAndSettle();
    expect(find.text('old'), findsOneWidget);
    expect(saves, 0);
    await open(t, 'old');
    await t.enterText(find.byType(EditableText), 'new');
    await t.testTextInput.receiveAction(TextInputAction.done);
    await t.pumpAndSettle();
    expect(value, 'new');
    expect(saves, 1);
    expect(find.byType(EditableText), findsNothing);
  });

  testWidgets(
    'validation retains draft; async failure is retryable and deduplicated',
    (t) async {
      var calls = 0;
      Completer<void>? pending;
      await t.pumpWidget(
        host(
          HyperInlineEdit.text(
            value: 'old',
            saveOnBlur: false,
            validator: (v) => v.isEmpty ? 'required' : null,
            onSaved: (_) {
              calls++;
              pending = Completer<void>();
              return pending!.future;
            },
          ),
        ),
      );
      await open(t, 'old');
      await t.enterText(find.byType(EditableText), '');
      await t.tap(find.text('保存'));
      await t.pumpAndSettle();
      expect(find.text('required'), findsOneWidget);
      expect(calls, 0);
      await t.enterText(find.byType(EditableText), 'draft');
      await t.tap(find.text('保存'));
      await t.pump();
      await t.sendKeyEvent(LogicalKeyboardKey.enter);
      await t.sendKeyEvent(LogicalKeyboardKey.escape);
      await t.pump();
      expect(calls, 1);
      pending!.completeError(StateError('offline'));
      await t.pumpAndSettle();
      expect(find.text('保存失败，请重试'), findsOneWidget);
      expect(
        t.widget<EditableText>(find.byType(EditableText)).controller.text,
        'draft',
      );
      await t.tap(find.text('保存'));
      await t.pump();
      expect(calls, 2);
      pending!.complete();
      await t.pumpAndSettle();
      expect(find.byType(EditableText), findsNothing);
      expect(t.takeException(), isNull);
    },
  );

  testWidgets(
    'external value invalidates pending completion; disposal is safe',
    (t) async {
      var value = 'old';
      late StateSetter update;
      final pending = Completer<void>();
      await t.pumpWidget(
        host(
          StatefulBuilder(
            builder: (_, set) {
              update = set;
              return HyperInlineEdit.text(
                value: value,
                onSaved: (_) => pending.future,
              );
            },
          ),
        ),
      );
      await open(t, 'old');
      await t.enterText(find.byType(EditableText), 'draft');
      await t.tap(find.text('保存'));
      await t.pump();
      update(() => value = 'server');
      await t.pumpAndSettle();
      expect(find.text('server'), findsOneWidget);
      await open(t, 'server');
      pending.complete();
      await t.pumpAndSettle();
      expect(find.byType(EditableText), findsOneWidget);
      await t.pumpWidget(const SizedBox());
      expect(t.takeException(), isNull);
    },
  );

  testWidgets('focus within actions does not save; Tab outside saves', (
    t,
  ) async {
    var saves = 0;
    final outside = FocusNode();
    addTearDown(outside.dispose);
    await t.pumpWidget(
      host(
        Column(
          children: [
            HyperInlineEdit.text(value: 'old', onSaved: (_) => saves++),
            TextButton(
              focusNode: outside,
              onPressed: () {},
              child: const Text('outside'),
            ),
          ],
        ),
      ),
    );
    await open(t, 'old');
    await t.enterText(find.byType(EditableText), 'draft');
    await t.sendKeyEvent(LogicalKeyboardKey.tab);
    await t.pumpAndSettle();
    expect(saves, 0);
    outside.requestFocus();
    await t.pumpAndSettle();
    expect(saves, 1);
  });

  testWidgets('F2 activation, disabled and multiline text scaling', (t) async {
    for (final scale in [1.0, 1.3, 2.0]) {
      await t.pumpWidget(
        host(
          HyperInlineEdit.text(
            value: 'long value 长文字',
            multiline: true,
            onSaved: (_) {},
            saveOnBlur: false,
          ),
          scale: scale,
        ),
      );
      await t.sendKeyEvent(LogicalKeyboardKey.tab);
      await t.sendKeyEvent(LogicalKeyboardKey.f2);
      await t.pumpAndSettle();
      expect(find.byType(EditableText), findsOneWidget);
      await t.enterText(find.byType(EditableText), 'first\nsecond\n第三行');
      await t.sendKeyEvent(LogicalKeyboardKey.enter);
      await t.pumpAndSettle();
      expect(find.byType(EditableText), findsOneWidget);
      expect(t.takeException(), isNull);
      await t.pumpWidget(const SizedBox());
    }
    await t.pumpWidget(
      host(
        HyperInlineEdit.text(
          value: 'disabled',
          enabled: false,
          onSaved: (_) {},
        ),
      ),
    );
    await open(t, 'disabled');
    expect(find.byType(EditableText), findsNothing);
  });

  testWidgets('custom control overlay can take focus without premature save', (
    t,
  ) async {
    late HyperInlineEditDetails<bool> details;
    final outside = FocusNode();
    addTearDown(outside.dispose);
    var saves = 0;
    await t.pumpWidget(
      host(
        Column(
          children: [
            HyperInlineEdit<bool>(
              value: false,
              displayBuilder: (_, v) => Text('$v'),
              editorBuilder: (_, d) {
                details = d;
                return HyperSwitch(value: d.value, onChanged: d.onChanged);
              },
              onSaved: (_) => saves++,
            ),
            TextButton(
              focusNode: outside,
              onPressed: () {},
              child: const Text('outside'),
            ),
          ],
        ),
      ),
    );
    await open(t, 'false');
    final pending = Completer<void>();
    final operation = details.runOverlay(() async {
      await pending.future;
      details.onChanged(true);
    });
    outside.requestFocus();
    await t.pumpAndSettle();
    expect(saves, 0);
    pending.complete();
    await operation;
    await t.pumpAndSettle();
    expect(details.value, true);
    await t.tap(find.text('保存'));
    await t.pumpAndSettle();
    expect(saves, 1);
  });

  test('global theme copy lerp equality and style merge', () {
    const a = HyperInlineEditStyle(
      displayStyle: TextStyle(color: Colors.red),
      transitionDuration: Duration(milliseconds: 100),
    );
    const b = HyperInlineEditStyle(
      inputStyle: HyperTextFieldStyle(cursorColor: Colors.blue),
      transitionDuration: Duration(milliseconds: 300),
    );
    final data = HyperThemeData.light().copyWith(
      inlineEditTheme: HyperInlineEditThemeData(style: a),
    );
    expect(data.inlineEditTheme.style, a);
    expect(data, data.copyWith());
    expect(data.hashCode, data.copyWith().hashCode);
    expect(
      HyperInlineEditStyle.lerp(a, b, .5).transitionDuration,
      const Duration(milliseconds: 200),
    );
    expect(a.merge(b).displayStyle?.color, Colors.red);
    expect(a.merge(b).inputStyle?.cursorColor, Colors.blue);
    expect(
      data
          .lerp(
            data.copyWith(inlineEditTheme: HyperInlineEditThemeData(style: b)),
            1,
          )
          .inlineEditTheme
          .style,
      b,
    );
  });

  testWidgets('global local instance styles compose', (t) async {
    late HyperInlineEditDetails<String> details;
    final theme = HyperThemeData.light().copyWith(
      inlineEditTheme: const HyperInlineEditThemeData(
        style: HyperInlineEditStyle(
          inputStyle: HyperTextFieldStyle(cursorColor: Colors.red),
        ),
      ),
    );
    await t.pumpWidget(
      host(
        HyperInlineEditTheme(
          data: HyperInlineEditThemeData(
            style: HyperInlineEditStyle(
              actionStyle: HyperButtonStyle(foregroundColor: Colors.green),
            ),
          ),
          child: HyperInlineEdit<String>(
            value: 'old',
            displayBuilder: (_, v) => Text(v),
            style: const HyperInlineEditStyle(
              inputStyle: HyperTextFieldStyle(cursorColor: Colors.blue),
            ),
            editorBuilder: (_, d) {
              details = d;
              return const Text('editor');
            },
            onSaved: (_) {},
          ),
        ),
        theme: theme,
      ),
    );
    await open(t, 'old');
    expect(details.style.inputStyle?.cursorColor, Colors.blue);
    expect(details.style.actionStyle?.foregroundColor, Colors.green);
  });
}
