import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
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
  HyperCascaderNode(
    value: 4,
    label: '江苏省',
    children: [
      HyperCascaderNode(
        value: 5,
        label: '南京市',
        children: [HyperCascaderNode(value: 6, label: '鼓楼区')],
      ),
    ],
  ),
  HyperCascaderNode(value: 7, label: '禁用地区', enabled: false),
];

Widget _app(Widget child, {double scale = 1, HyperThemeData? theme}) =>
    RepaintBoundary(
      key: const ValueKey('mobile-review'),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HyperDeviceDetector(
          deviceType: HyperDeviceType.phone,
          builder: (context, device, child) =>
              HyperTheme(data: theme ?? HyperThemeData.light(), child: child!),
          child: Builder(
            builder: (context) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.linear(scale)),
              child: Scaffold(body: child),
            ),
          ),
        ),
      ),
    );

Future<void> _reviewFonts(WidgetTester tester) async {
  const output = String.fromEnvironment('CASCADER_MOBILE_OUTPUT');
  if (output.isEmpty) return;
  await tester.runAsync(() async {
    const font = String.fromEnvironment('CASCADER_REVIEW_FONT');
    const icons = String.fromEnvironment('CASCADER_REVIEW_ICON_FONT');
    for (final (family, path) in [
      ('sans-serif', font),
      ('MaterialIcons', icons),
    ]) {
      if (path.isEmpty) continue;
      final loader = FontLoader(family);
      loader.addFont(File(path).readAsBytes().then(ByteData.sublistView));
      await loader.load();
    }
  });
}

Future<void> _reviewImage(WidgetTester tester, {String? path}) async {
  final output = path ?? const String.fromEnvironment('CASCADER_MOBILE_OUTPUT');
  if (output.isEmpty) return;
  await tester.runAsync(() async {
    final boundary = tester.renderObject<RenderRepaintBoundary>(
      find.byKey(const ValueKey('mobile-review')),
    );
    final image = await boundary.toImage();
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    final file = File(output);
    await file.parent.create(recursive: true);
    await file.writeAsBytes(data!.buffer.asUint8List());
    image.dispose();
  });
}

List<HyperWheelPicker<int>> _wheels(WidgetTester tester) => tester
    .widgetList<HyperWheelPicker<int>>(find.byType(HyperWheelPicker<int>))
    .toList();

void main() {
  testWidgets(
    'phone wheels link levels and commit to Form only on confirmation; header clears',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await _reviewFonts(tester);
      final form = HyperFormController();
      addTearDown(form.dispose);
      await tester.pumpWidget(
        _app(
          HyperForm(
            controller: form,
            child: HyperCascaderFormField<int>(
              name: 'region',
              nodes: _nodes,
              placeholder: '地区',
              label: '地区字段',
            ),
          ),
        ),
      );
      await tester.tap(find.byType(HyperDropdown));
      await tester.pumpAndSettle();
      expect(_wheels(tester).map((wheel) => wheel.value), [1, 2, 3]);
      expect(_wheels(tester).first.items, [1, 4]);
      expect(form.value<List<int>>('region'), isEmpty);
      expect(form.isDirty, isFalse);
      await tester.drag(
        find.byType(HyperWheelPicker<int>).first,
        const Offset(0, -70),
      );
      await tester.pumpAndSettle();
      expect(_wheels(tester).map((wheel) => wheel.value), [4, 5, 6]);
      expect(form.value<List<int>>('region'), isEmpty);
      await tester.tap(find.text('确定'));
      await tester.pumpAndSettle();
      expect(form.value<List<int>>('region'), [4, 5, 6]);
      expect(form.isDirty, isTrue);
      expect(
        await form.submit((values) => expect(values['region'], [4, 5, 6])),
        isTrue,
      );
      await tester.tap(find.byType(HyperDropdown));
      await tester.pumpAndSettle();
      _wheels(tester).first.onChanged!(1);
      await tester.pumpAndSettle();
      await tester.tap(find.text('取消'));
      await tester.pumpAndSettle();
      expect(form.value<List<int>>('region'), [4, 5, 6]);
      await tester.tap(find.byType(HyperDropdown));
      await tester.pumpAndSettle();
      final header = find.descendant(
        of: find.byType(HyperBottomSheet),
        matching: find.text('地区'),
      );
      final clear = find.text('清空');
      expect(
        tester
            .getRect(header)
            .overlaps(
              Rect.fromLTRB(
                0,
                tester.getRect(clear).top,
                390,
                tester.getRect(clear).bottom,
              ),
            ),
        isTrue,
      );
      final button = tester.widget<HyperButton>(
        find.ancestor(of: clear, matching: find.byType(HyperButton)).first,
      );
      final theme = HyperTheme.of(tester.element(clear));
      expect(button.style!.foregroundColor, theme.colors.primary);
      expect(
        DefaultTextStyle.of(tester.element(clear)).style.color,
        theme.colors.primary,
      );
      expect(find.text('清空'), findsOneWidget);
      await _reviewImage(tester);
      await tester.tap(clear);
      await tester.pumpAndSettle();
      expect(form.value<List<int>>('region'), isEmpty);
      expect(form.isDirty, isFalse);
      expect(find.byType(HyperBottomSheet), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'remote wheels retry and stale branch results cannot replace a newer draft',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final pending = Completer<List<HyperCascaderNode<int>>>();
      var calls = 0;
      List<int>? committed;
      await tester.pumpWidget(
        _app(
          HyperCascader<int>(
            nodes: const [
              HyperCascaderNode(value: 9, label: '远程', hasChildren: true),
              ..._nodes,
            ],
            value: const [],
            onChanged: (value) => committed = value,
            loadChildren: (_) async {
              if (++calls == 1) throw StateError('offline');
              return pending.future;
            },
          ),
        ),
      );
      await tester.tap(find.byType(HyperDropdown));
      await tester.pumpAndSettle();
      expect(find.text('加载失败'), findsOneWidget);
      final parent = tester.getRect(find.byType(HyperWheelPicker<int>).first);
      final error = tester.getRect(find.text('加载失败'));
      expect(error.left, greaterThanOrEqualTo(parent.right));
      expect(error.center.dy, inInclusiveRange(parent.top, parent.bottom));
      expect(
        tester.getRect(find.text('重试')).left,
        greaterThanOrEqualTo(parent.right),
      );
      await _reviewImage(
        tester,
        path: const String.fromEnvironment('CASCADER_MOBILE_ERROR_OUTPUT'),
      );
      await tester.tap(find.text('重试'));
      await tester.pumpAndSettle();
      expect(find.text('正在加载…'), findsOneWidget);
      expect(
        tester.getRect(find.text('正在加载…')).left,
        greaterThanOrEqualTo(
          tester.getRect(find.byType(HyperWheelPicker<int>).first).right,
        ),
      );
      expect(
        tester
            .widget<HyperButton>(
              find
                  .ancestor(
                    of: find.text('确定'),
                    matching: find.byType(HyperButton),
                  )
                  .first,
            )
            .onPressed,
        isNull,
      );
      _wheels(tester).first.onChanged!(4);
      await tester.pumpAndSettle();
      pending.complete(const [HyperCascaderNode(value: 10, label: '过期分支末级')]);
      await tester.pumpAndSettle();
      expect(_wheels(tester).map((wheel) => wheel.value), [4, 5, 6]);
      expect(committed, isNull);
      await tester.tap(find.text('确定'));
      await tester.pumpAndSettle();
      expect(committed, [4, 5, 6]);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'empty loaded children occupy the next column and cannot confirm',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        _app(
          HyperCascader<int>(
            nodes: const [
              HyperCascaderNode(value: 1, label: '空分支', hasChildren: true),
            ],
            value: const [],
            onChanged: (_) {},
            loadChildren: (_) async => [],
          ),
        ),
      );
      await tester.tap(find.byType(HyperDropdown));
      await tester.pumpAndSettle();
      final parent = tester.getRect(find.byType(HyperWheelPicker<int>).first);
      expect(
        tester.getRect(find.text('暂无可选项')).left,
        greaterThanOrEqualTo(parent.right),
      );
      expect(
        tester
            .widget<HyperButton>(
              find
                  .ancestor(
                    of: find.text('确定'),
                    matching: find.byType(HyperButton),
                  )
                  .first,
            )
            .onPressed,
        isNull,
      );
      expect(tester.takeException(), isNull);
    },
  );

  for (final scale in [1.0, 1.3, 2.0]) {
    testWidgets(
      'mobile wheels and title actions remain usable at scale $scale',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(320, 740));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        await tester.pumpWidget(
          _app(
            HyperCascader<int>(
              nodes: _nodes,
              value: const [1, 2, 3],
              onChanged: (_) {},
              placeholder: '地区',
            ),
            scale: scale,
          ),
        );
        await tester.tap(find.byType(HyperDropdown));
        await tester.pumpAndSettle();
        expect(find.byType(HyperWheelPicker<int>), findsNWidgets(3));
        expect(find.byType(HyperCard), findsNothing);
        await tester.ensureVisible(find.text('取消'));
        await tester.tap(find.text('取消'));
        await tester.pumpAndSettle();
        expect(find.byType(HyperBottomSheet), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );
  }

  test(
    'wheel and clear styles merge, interpolate and participate in equality',
    () {
      final a = HyperCascaderStyle(
        wheelStyle: HyperWheelPickerStyle(itemExtent: 40),
        clearButtonStyle: HyperButtonStyle(foregroundColor: Colors.red),
      );
      final b = a.copyWith(
        wheelStyle: const HyperWheelPickerStyle(itemExtent: 48),
        clearButtonStyle: HyperButtonStyle(foregroundColor: Colors.blue),
      );
      expect(a.copyWith(), a);
      expect(a.copyWith().hashCode, a.hashCode);
      expect(b, isNot(a));
      final mid = HyperCascaderStyle.lerp(a, b, .5);
      expect(mid.wheelStyle!.itemExtent, 44);
      expect(
        mid.clearButtonStyle!.foregroundColor,
        Color.lerp(Colors.red, Colors.blue, .5),
      );
    },
  );
}
