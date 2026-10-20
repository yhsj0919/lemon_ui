import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

const _nodes = [
  HyperCascaderNode(
    value: 1,
    label: '浙江省',
    children: [
      HyperCascaderNode(
        value: 2,
        label: '杭州市',
        children: [HyperCascaderNode(value: 3, label: '西湖区')],
      ),
    ],
  ),
];

Widget _app(HyperFormController controller, Widget child) => MaterialApp(
  home: HyperDeviceDetector(
    deviceType: HyperDeviceType.desktop,
    builder: (context, device, child) =>
        HyperTheme(data: HyperThemeData.light(), child: child!),
    child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: HyperForm(
          controller: controller,
          child: HyperFormSection(children: [child]),
        ),
      ),
    ),
  ),
);

HyperCascader<int> _picker(WidgetTester tester) =>
    tester.widget<HyperCascader<int>>(find.byType(HyperCascader<int>));

void main() {
  testWidgets(
    'required path validates, branches do not touch form, leaf saves and clear fails validation',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(1100, 700));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final controller = HyperFormController();
      addTearDown(controller.dispose);
      List<int>? saved;
      Map<String, Object?>? submitted;
      final changes = <List<int>?>[];
      await tester.pumpWidget(
        _app(
          controller,
          HyperCascaderFormField<int>(
            name: 'region',
            label: '地区',
            nodes: _nodes,
            requiredIndicator: true,
            errorDisplay: HyperFieldErrorDisplay.below,
            validator: (path) => path == null || path.isEmpty ? '请选择地区' : null,
            onChanged: changes.add,
            onSaved: (path) => saved = path,
          ),
        ),
      );
      expect(await controller.submit((values) => submitted = values), isFalse);
      await tester.pumpAndSettle();
      expect(find.text('请选择地区'), findsOneWidget);
      expect(submitted, isNull);
      await tester.tap(find.byType(HyperDropdown));
      await tester.pumpAndSettle();
      await tester.tap(find.text('浙江省'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('杭州市'));
      await tester.pumpAndSettle();
      expect(controller.value<List<int>>('region'), isEmpty);
      expect(controller.isDirty, isFalse);
      expect(changes, isEmpty);
      await tester.tap(find.text('西湖区'));
      await tester.pumpAndSettle();
      expect(controller.value<List<int>>('region'), [1, 2, 3]);
      expect(controller.dirtyFields, contains('region'));
      expect(changes, [
        [1, 2, 3],
      ]);
      expect(await controller.submit((values) => submitted = values), isTrue);
      await tester.pumpAndSettle();
      expect(saved, [1, 2, 3]);
      expect(submitted!['region'], isA<List<int>>());
      expect(
        () => (submitted!['region'] as List<int>).add(4),
        throwsUnsupportedError,
      );
      await tester.tap(find.byType(HyperDropdown));
      await tester.pumpAndSettle();
      await tester.tap(find.text('清空'));
      await tester.pumpAndSettle();
      expect(controller.value<List<int>>('region'), isEmpty);
      expect(await controller.validate(), isFalse);
      controller.reset();
      await tester.pumpAndSettle();
      expect(find.text('请选择地区'), findsNothing);
      expect(controller.isDirty, isFalse);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'initial and changed paths snapshot lists and reset restores the original path',
    (tester) async {
      final controller = HyperFormController();
      addTearDown(controller.dispose);
      final initial = [1, 2, 3];
      var resets = 0;
      await tester.pumpWidget(
        _app(
          controller,
          HyperCascaderFormField<int>(
            name: 'region',
            nodes: _nodes,
            initialValue: initial,
            onReset: () => resets++,
          ),
        ),
      );
      initial.clear();
      await tester.pumpAndSettle();
      expect(controller.value<List<int>>('region'), [1, 2, 3]);
      final changed = <int>[];
      _picker(tester).onChanged!(changed);
      changed.add(9);
      await tester.pumpAndSettle();
      expect(controller.value<List<int>>('region'), isEmpty);
      expect(
        () => controller.value<List<int>>('region')!.add(9),
        throwsUnsupportedError,
      );
      controller.reset();
      await tester.pumpAndSettle();
      expect(controller.value<List<int>>('region'), [1, 2, 3]);
      expect(_picker(tester).value, [1, 2, 3]);
      expect(controller.isDirty, isFalse);
      expect(resets, 1);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'disabled field closes open overlays and skips synchronous and async validation',
    (tester) async {
      final controller = HyperFormController();
      addTearDown(controller.dispose);
      var enabled = true, validated = 0, changed = 0;
      late StateSetter update;
      await tester.pumpWidget(
        _app(
          controller,
          StatefulBuilder(
            builder: (_, setState) {
              update = setState;
              return HyperCascaderFormField<int>(
                name: 'region',
                nodes: _nodes,
                enabled: enabled,
                validator: (_) {
                  validated++;
                  return '不应校验';
                },
                asyncValidator: (_) async {
                  validated++;
                  return '不应校验';
                },
                onChanged: (_) => changed++,
              );
            },
          ),
        ),
      );
      await tester.tap(find.byType(HyperDropdown));
      await tester.pumpAndSettle();
      expect(find.byType(HyperMenu), findsOneWidget);
      update(() => enabled = false);
      await tester.pumpAndSettle();
      expect(find.byType(HyperMenu), findsNothing);
      expect(_picker(tester).onChanged, isNull);
      expect(_picker(tester).enabled, isFalse);
      expect(await controller.validate(), isTrue);
      expect(validated, 0);
      expect(changed, 0);
      expect(controller.value<List<int>>('region'), isEmpty);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'reset invalidates a pending async validation and later submission can succeed',
    (tester) async {
      final controller = HyperFormController();
      addTearDown(controller.dispose);
      final pending = Completer<String?>();
      var calls = 0;
      await tester.pumpWidget(
        _app(
          controller,
          HyperCascaderFormField<int>(
            name: 'region',
            label: '地区',
            nodes: _nodes,
            initialValue: const [1, 2, 3],
            errorDisplay: HyperFieldErrorDisplay.below,
            asyncValidator: (_) =>
                ++calls == 1 ? pending.future : Future.value(null),
          ),
        ),
      );
      final validation = controller.validate();
      await tester.pump();
      controller.reset();
      pending.complete('过期错误');
      expect(await validation, isFalse);
      await tester.pumpAndSettle();
      expect(find.text('过期错误'), findsNothing);
      expect(controller.value<List<int>>('region'), [1, 2, 3]);
      expect(
        await controller.submit((values) {
          expect(values['region'], [1, 2, 3]);
        }),
        isTrue,
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'asynchronous branch values submit through the same field and preserve surface overrides',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(1100, 700));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final controller = HyperFormController();
      addTearDown(controller.dispose);
      final loaded = Completer<List<HyperCascaderNode<int>>>();
      await tester.pumpWidget(
        _app(
          controller,
          HyperCascaderFormField<int>(
            name: 'team',
            nodes: const [
              HyperCascaderNode(value: 1, label: '产品部', hasChildren: true),
            ],
            loadChildren: (_) => loaded.future,
            presentation: HyperSelectPresentation.anchored,
            surfaceStyle: HyperCardStyle(
              boxShadow: [],
              border: Border.all(color: Colors.blue),
            ),
          ),
        ),
      );
      await tester.tap(find.byType(HyperDropdown));
      await tester.pumpAndSettle();
      await tester.tap(find.text('产品部'));
      await tester.pumpAndSettle();
      expect(find.text('正在加载…'), findsOneWidget);
      expect(controller.isDirty, isFalse);
      loaded.complete(const [HyperCascaderNode(value: 2, label: '设计组')]);
      await tester.pumpAndSettle();
      for (final surface in tester.widgetList<HyperCard>(
        find.byType(HyperCard),
      )) {
        expect(surface.style!.boxShadow, isEmpty);
        expect(surface.style!.border, Border.all(color: Colors.blue));
      }
      await tester.tap(find.text('设计组'));
      await tester.pumpAndSettle();
      expect(
        await controller.submit((values) {
          expect(values['team'], [1, 2]);
          expect(values['team'], isA<List<int>>());
        }),
        isTrue,
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );
}
