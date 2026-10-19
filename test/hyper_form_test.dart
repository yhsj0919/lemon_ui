import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

Widget host(Widget child, {double width = 500, double scale = 1}) =>
    MaterialApp(
      home: HyperTheme(
        data: HyperThemeData.light(),
        child: MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(scale)),
          child: Scaffold(
            body: SingleChildScrollView(
              child: SizedBox(width: width, child: child),
            ),
          ),
        ),
      ),
    );
HyperFormField<String> field({
  String name = 'name',
  String initial = 'hello',
  HyperAsyncFieldValidator<String>? async,
  FormFieldValidator<String>? validator,
  bool enabled = true,
  ValueChanged<String?>? saved,
}) => HyperFormField<String>(
  name: name,
  label: '名称',
  initialValue: initial,
  validator: validator,
  asyncValidator: async,
  enabled: enabled,
  onSaved: saved,
  fieldBuilder: (f) =>
      TextField(focusNode: f.focusNode, onChanged: f.didChange),
);
void main() {
  for (final layout in [
    HyperFieldLayout.horizontal,
    HyperFieldLayout.labelHidden,
  ]) {
    testWidgets(
      '$layout errors use input trailing indicator without extra height',
      (t) async {
        final controller = HyperFormController();
        await t.pumpWidget(
          host(
            HyperForm(
              controller: controller,
              layout: layout,
              child: HyperTextFormField(label: '名称', validator: (_) => '请填写名称'),
            ),
          ),
        );
        await t.pumpAndSettle();
        final before = t.getSize(find.byType(HyperField)).height;
        controller.validateSync();
        await t.pumpAndSettle();
        expect(
          t.widget<HyperTextField>(find.byType(HyperTextField)).errorText,
          '请填写名称',
        );
        expect(t.getSize(find.byType(HyperField)).height, before);
        expect(t.takeException(), isNull);
      },
    );
  }
  testWidgets('fixed width field anchors align with their visible trigger', (
    t,
  ) async {
    await t.pumpWidget(
      host(
        const HyperField(
          label: '角色',
          child: HyperDropdown(
            presentation: HyperSelectPresentation.anchored,
            label: Text('成员'),
            panelBuilder: _rolePanel,
          ),
        ),
        width: 700,
      ),
    );
    await t.pumpAndSettle();
    final labelLeft = t.getTopLeft(find.text('角色')).dx;
    final anchor = t.getRect(find.byType(HyperAnchoredOverlay));
    expect(anchor.left, closeTo(labelLeft, .01));
    expect(anchor.width, lessThan(700));
    await t.tap(find.text('成员'));
    await t.pumpAndSettle();
    expect(t.getTopLeft(find.byType(HyperCard)).dx, closeTo(anchor.left, .01));
    expect(t.takeException(), isNull);
  });
  testWidgets(
    'reset during submission does not attach stale server error to new values',
    (t) async {
      final c = HyperFormController(), server = Completer<void>();
      await t.pumpWidget(host(HyperForm(controller: c, child: field())));
      await t.pumpAndSettle();
      final submit = c.submit((_) => server.future);
      await t.pump();
      c.reset();
      await t.pumpAndSettle();
      final expectation = expectLater(submit, throwsStateError);
      server.completeError(StateError('旧提交错误'));
      await expectation;
      await t.pumpAndSettle();
      expect(c.submitError, isNull);
      expect(c.value<String>('name'), 'hello');
    },
  );
  testWidgets('editing another field retains current async error', (t) async {
    final c = HyperFormController();
    await t.pumpWidget(
      host(
        HyperForm(
          controller: c,
          child: Column(
            children: [
              field(name: 'first', async: (_) async => '名称已被使用'),
              field(name: 'second'),
            ],
          ),
        ),
      ),
    );
    await t.pumpAndSettle();
    expect(await c.validate(), false);
    await t.pumpAndSettle();
    expect(find.text('名称已被使用'), findsOneWidget);
    await t.enterText(find.byType(TextField).last, 'other');
    await t.pumpAndSettle();
    expect(find.text('名称已被使用'), findsOneWidget);
    await t.enterText(find.byType(TextField).first, 'new');
    await t.pumpAndSettle();
    expect(find.text('名称已被使用'), findsNothing);
  });
  testWidgets(
    'text adapter resets its visible controller and routes native error once',
    (t) async {
      final c = HyperFormController();
      await t.pumpWidget(
        host(
          HyperForm(
            controller: c,
            child: HyperTextFormField(
              name: 'text',
              label: '文本',
              initialValue: '初始',
              errorDisplay: HyperFieldErrorDisplay.trailingIcon,
              validator: (v) => v == '通过' ? null : '错误',
              hintText: '请输入',
            ),
          ),
        ),
      );
      await t.pumpAndSettle();
      await t.enterText(find.byType(TextField), '修改');
      await t.pumpAndSettle();
      expect(await c.validate(), false);
      await t.pumpAndSettle();
      expect(
        t.widget<HyperTextField>(find.byType(HyperTextField)).errorText,
        '错误',
      );
      c.reset();
      await t.pumpAndSettle();
      expect(
        t.widget<TextField>(find.byType(TextField)).controller!.text,
        '初始',
      );
      expect(
        t.widget<HyperTextField>(find.byType(HyperTextField)).errorText,
        isNull,
      );
    },
  );
  testWidgets('cross validation snapshot becomes stale on edit', (t) async {
    final pending = Completer<Map<String, String>>();
    final c = HyperFormController(crossValidators: [(_) => pending.future]);
    await t.pumpWidget(host(HyperForm(controller: c, child: field())));
    await t.pumpAndSettle();
    final validation = c.validate();
    await t.pump();
    await t.enterText(find.byType(TextField), 'new');
    await t.pump();
    pending.complete({'name': '过期联动错误'});
    expect(await validation, false);
    await t.pumpAndSettle();
    expect(find.text('过期联动错误'), findsNothing);
  });
  testWidgets('custom value equality and snapshot preserve dirty baseline', (
    t,
  ) async {
    final c = HyperFormController();
    final value = _MutableValue(1);
    await t.pumpWidget(
      host(
        HyperForm(
          controller: c,
          child: HyperFormField<_MutableValue>(
            name: 'custom',
            initialValue: value,
            valueSnapshot: (v) => v == null ? null : _MutableValue(v.number),
            valueEquals: (a, b) => a?.number == b?.number,
            fieldBuilder: (f) => const Text('自定义'),
          ),
        ),
      ),
    );
    await t.pumpAndSettle();
    expect(identical(c.value<_MutableValue>('custom'), value), true);
    value.number = 2;
    expect(c.isDirty, true);
    expect((c.values['custom'] as _MutableValue).number, 2);
    c.markClean();
    expect(c.isDirty, false);
  });
  testWidgets(
    'section columns reflow and local style preserves form instance overrides',
    (t) async {
      final c = HyperFormController();
      Widget build(double width) => host(
        HyperFieldTheme(
          data: const HyperFieldThemeData(
            style: HyperFieldStyle(labelStyle: TextStyle(color: Colors.red)),
          ),
          child: HyperForm(
            controller: c,
            layout: HyperFieldLayout.horizontal,
            style: const HyperFieldStyle(gap: 20),
            child: const HyperFormSection(
              columns: 2,
              children: [
                HyperField(label: '字段 A', child: Text('A')),
                HyperField(label: '字段 B', child: Text('B')),
              ],
            ),
          ),
        ),
        width: width,
      );
      await t.pumpWidget(build(700));
      await t.pumpAndSettle();
      expect(
        t.getTopLeft(find.text('B')).dx,
        greaterThan(t.getTopLeft(find.text('A')).dx),
      );
      await t.pumpWidget(build(180));
      await t.pumpAndSettle();
      expect(
        t.getTopLeft(find.text('B')).dy,
        greaterThan(t.getTopLeft(find.text('A')).dy),
      );
      expect(t.takeException(), isNull);
    },
  );
  testWidgets('submit snapshot is deeply immutable for collection values', (
    t,
  ) async {
    final c = HyperFormController();
    await t.pumpWidget(
      host(
        HyperForm(
          controller: c,
          child: HyperFormField<List<String>>(
            name: 'items',
            initialValue: const ['one'],
            fieldBuilder: (f) => const Text('列表'),
          ),
        ),
      ),
    );
    await t.pumpAndSettle();
    expect(c.value<List<String>>('items'), ['one']);
    await c.submit((values) {
      expect(() => values['extra'] = 1, throwsUnsupportedError);
      expect(
        () => (values['items'] as List).add('two'),
        throwsUnsupportedError,
      );
    });
  });
  testWidgets('native save/reset, dirty and touched lifecycle', (t) async {
    final c = HyperFormController();
    String? saved;
    await t.pumpWidget(
      host(
        HyperForm(
          controller: c,
          child: field(saved: (v) => saved = v),
        ),
      ),
    );
    await t.pumpAndSettle();
    expect(c.values, {'name': 'hello'});
    expect(c.isDirty, false);
    await t.enterText(find.byType(TextField), 'changed');
    await t.pumpAndSettle();
    expect(c.dirtyFields, {'name'});
    expect(c.touchedFields, {'name'});
    c.save();
    expect(saved, 'changed');
    c.markClean();
    expect(c.isDirty, false);
    c.reset();
    await t.pumpAndSettle();
    expect(c.value<String>('name'), 'hello');
    expect(c.touchedFields, isEmpty);
    expect(c.isDirty, false);
    await t.pumpWidget(const SizedBox());
    c.dispose();
  });
  testWidgets('sync error shown and invalid form not submitted', (t) async {
    final c = HyperFormController();
    var submitted = false;
    await t.pumpWidget(
      host(
        HyperForm(
          controller: c,
          child: field(validator: (v) => v == 'valid' ? null : '请输入有效名称'),
        ),
      ),
    );
    await t.pumpAndSettle();
    expect(await c.submit((_) => submitted = true), false);
    await t.pumpAndSettle();
    expect(submitted, false);
    expect(find.text('请输入有效名称'), findsOneWidget);
    await t.enterText(find.byType(TextField), 'valid');
    await t.pumpAndSettle();
    expect(await c.submit((_) => submitted = true), true);
    await t.pumpAndSettle();
    expect(submitted, true);
  });
  testWidgets(
    'stale asynchronous validation is rejected after edit and reset',
    (t) async {
      final requests = <Completer<String?>>[];
      final c = HyperFormController();
      await t.pumpWidget(
        host(
          HyperForm(
            controller: c,
            child: field(
              async: (_) {
                final request = Completer<String?>();
                requests.add(request);
                return request.future;
              },
            ),
          ),
        ),
      );
      await t.pumpAndSettle();
      final old = c.validate();
      await t.pump();
      await t.enterText(find.byType(TextField), 'new');
      await t.pump();
      final current = c.validate();
      await t.pump();
      requests[1].complete(null);
      expect(await current, true);
      requests[0].complete('旧错误');
      expect(await old, false);
      await t.pumpAndSettle();
      expect(find.text('旧错误'), findsNothing);
      final reset = c.validate();
      await t.pump();
      c.reset();
      requests[2].complete('重置前错误');
      expect(await reset, false);
      await t.pumpAndSettle();
      expect(find.text('重置前错误'), findsNothing);
      expect(c.isValidating, false);
    },
  );
  testWidgets(
    'cross-field errors clear on edit and duplicate submit shares operation',
    (t) async {
      final c = HyperFormController(
        crossValidators: [
          (v) => v['name'] == 'okay' ? {} : {'name': '不匹配'},
        ],
      );
      final done = Completer<void>();
      var count = 0;
      await t.pumpWidget(host(HyperForm(controller: c, child: field())));
      await t.pumpAndSettle();
      expect(await c.validate(), false);
      await t.pumpAndSettle();
      expect(find.text('不匹配'), findsOneWidget);
      await t.enterText(find.byType(TextField), 'okay');
      await t.pumpAndSettle();
      expect(find.text('不匹配'), findsNothing);
      final first = c.submit((_) {
        count++;
        return done.future;
      });
      final second = c.submit((_) {
        count++;
      });
      expect(identical(first, second), true);
      await t.pump();
      expect(count, 1);
      expect(c.isSubmitting, true);
      done.complete();
      expect(await first, true);
      await t.pumpAndSettle();
      expect(c.isSubmitting, false);
    },
  );
  testWidgets('disabled values retained and skipped by validators', (t) async {
    final c = HyperFormController();
    await t.pumpWidget(
      host(
        HyperForm(
          controller: c,
          child: field(
            enabled: false,
            validator: (_) => '错误',
            async: (_) async => '异步错误',
          ),
        ),
      ),
    );
    await t.pumpAndSettle();
    expect(await c.validate(), true);
    expect(c.values, {'name': 'hello'});
  });
  testWidgets('submission exception preserves input and summary', (t) async {
    final c = HyperFormController();
    await t.pumpWidget(
      host(
        HyperForm(
          controller: c,
          child: Column(
            children: [
              field(),
              HyperFormErrorSummary(controller: c),
            ],
          ),
        ),
      ),
    );
    await t.pumpAndSettle();
    await expectLater(
      c.submit((_) => throw StateError('提交失败')),
      throwsStateError,
    );
    await t.pumpAndSettle();
    expect(c.values, {'name': 'hello'});
    expect(find.textContaining('提交失败'), findsOneWidget);
  });
  for (final scale in [1.0, 1.3, 2.0]) {
    for (final layout in HyperFieldLayout.values) {
      testWidgets('$layout at scale $scale wraps without overflow', (t) async {
        await t.pumpWidget(
          host(
            HyperField(
              layout: layout,
              label: '很长的字段标题',
              description: '字段说明可以换行',
              errorText: '错误说明也需要完整展示',
              child: const Text('输入内容'),
            ),
            width: 200,
            scale: scale,
          ),
        );
        await t.pumpAndSettle();
        expect(t.takeException(), isNull);
        if (layout == HyperFieldLayout.vertical) {
          expect(find.text('错误说明也需要完整展示'), findsOneWidget);
        } else {
          expect(find.byTooltip('错误说明也需要完整展示'), findsOneWidget);
        }
      });
    }
  }
  testWidgets('dynamic fields unregister and duplicate names reject', (
    t,
  ) async {
    final c = HyperFormController();
    var visible = true;
    late StateSetter update;
    await t.pumpWidget(
      host(
        StatefulBuilder(
          builder: (context, setState) {
            update = setState;
            return HyperForm(
              controller: c,
              child: visible ? field() : const SizedBox(),
            );
          },
        ),
      ),
    );
    await t.pumpAndSettle();
    update(() => visible = false);
    await t.pumpAndSettle();
    expect(c.values, isEmpty);
    await t.pumpWidget(
      host(
        HyperForm(
          controller: c,
          child: Column(children: [field(), field()]),
        ),
      ),
    );
    await t.pump();
    expect(t.takeException(), isFlutterError);
  });
  test('field and form themes and four-end geometry copy and interpolate', () {
    final a = HyperThemeData.light();
    final b = a.copyWith(
      fieldTheme: const HyperFieldThemeData(style: HyperFieldStyle(gap: 20)),
      formTheme: const HyperFormThemeData(
        style: HyperFieldStyle(fieldSpacing: 30),
      ),
    );
    expect(a.lerp(b, 1), b);
    expect(b.fieldTheme.style.gap, 20);
    for (final type in HyperDeviceType.values) {
      final s = a.sizes.resolve(type);
      final changed = s.copyWith(form: s.form.copyWith(labelWidth: 144));
      expect(changed.form.labelWidth, 144);
      expect(
        HyperSizeScheme.lerp(s, changed, .5).form.labelWidth,
        (s.form.labelWidth + 144) / 2,
      );
      expect(changed, s.copyWith(form: s.form.copyWith(labelWidth: 144)));
    }
  });
}

Widget _rolePanel(BuildContext context, VoidCallback close) =>
    const Text('管理员');

class _MutableValue {
  _MutableValue(this.number);
  int number;
}
