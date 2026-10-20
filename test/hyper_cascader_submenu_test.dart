import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
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
        label: '宁波市',
        children: [
          HyperCascaderNode(value: 3, label: '海曙区'),
          HyperCascaderNode(value: 4, label: '江北区'),
        ],
      ),
      HyperCascaderNode(
        value: 5,
        label: '杭州市',
        children: [HyperCascaderNode(value: 6, label: '西湖区')],
      ),
    ],
  ),
  HyperCascaderNode(
    value: 7,
    label: '江苏省',
    children: [HyperCascaderNode(value: 8, label: '南京市')],
  ),
];

Widget _app(Widget child, {GlobalKey? capture, HyperThemeData? theme}) =>
    RepaintBoundary(
      key: capture,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HyperDeviceDetector(
          deviceType: HyperDeviceType.desktop,
          builder: (context, device, child) =>
              HyperTheme(data: theme ?? HyperThemeData.light(), child: child!),
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(40),
              child: Align(
                alignment: Alignment.topLeft,
                child: SizedBox(width: 232, child: child),
              ),
            ),
          ),
        ),
      ),
    );

void main() {
  testWidgets(
    'advanced child surfaces stay safe through opening and retain content',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(1000, 700));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        _app(
          HyperCascader<int>(nodes: _nodes, value: const [], onChanged: (_) {}),
          theme: HyperThemeData.light().copyWith(
            materialTheme: const HyperMaterialThemeData(
              quality: HyperMaterialQuality.advanced,
              material: HyperSurfaceMaterial.frostedGlass(),
            ),
          ),
        ),
      );
      await tester.tap(find.text('请选择'));
      await tester.pumpAndSettle();
      void checkFilters() {
        for (final element in find.byType(BackdropFilter).evaluate()) {
          if (!(element.widget as BackdropFilter).enabled) continue;
          element.visitAncestorElements((ancestor) {
            final widget = ancestor.widget;
            if (widget is Opacity) expect(widget.opacity, 1);
            if (widget is FadeTransition) expect(widget.opacity.value, 1);
            return true;
          });
        }
      }

      for (final (parent, child) in [('浙江省', '宁波市'), ('宁波市', '海曙区')]) {
        await tester.tap(find.text(parent));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 40));
        final content = tester.element(find.text(child));
        checkFilters();
        await tester.pumpAndSettle();
        checkFilters();
        expect(tester.element(find.text(child)), same(content));
      }
      expect(find.byType(HyperCard), findsNWidgets(3));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'three levels remain visible to the right; switching a sibling removes old descendants',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(900, 420));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      const output = String.fromEnvironment('CASCADER_REVIEW_OUTPUT');
      const font = String.fromEnvironment('CASCADER_REVIEW_FONT');
      const iconFont = String.fromEnvironment('CASCADER_REVIEW_ICON_FONT');
      if (output.isNotEmpty && font.isNotEmpty) {
        await tester.runAsync(() async {
          final loader = FontLoader('sans-serif');
          loader.addFont(File(font).readAsBytes().then(ByteData.sublistView));
          await loader.load();
          if (iconFont.isNotEmpty) {
            final icons = FontLoader('MaterialIcons');
            icons.addFont(
              File(iconFont).readAsBytes().then(ByteData.sublistView),
            );
            await icons.load();
          }
        });
      }
      final capture = GlobalKey();
      List<int>? committed;
      await tester.pumpWidget(
        _app(
          HyperCascader<int>(
            nodes: _nodes,
            value: const [1, 2, 3],
            onChanged: (value) => committed = value,
          ),
          capture: capture,
        ),
      );
      await tester.tap(find.text('浙江省 / 宁波市 / 海曙区'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('浙江省'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('宁波市'));
      await tester.pumpAndSettle();
      expect(find.text('浙江省'), findsOneWidget);
      expect(find.text('宁波市'), findsOneWidget);
      expect(find.text('海曙区'), findsOneWidget);
      expect(find.text('全部'), findsNothing);
      expect(find.text('返回上一级'), findsNothing);
      final province = tester.getRect(find.text('浙江省'));
      final city = tester.getRect(find.text('宁波市'));
      final district = tester.getRect(find.text('海曙区'));
      expect(city.left, greaterThan(province.right));
      expect(district.left, greaterThan(city.right));
      expect(find.byType(HyperCard), findsNWidgets(3));
      if (output.isNotEmpty) {
        await tester.runAsync(() async {
          final boundary =
              capture.currentContext!.findRenderObject()!
                  as RenderRepaintBoundary;
          final image = await boundary.toImage();
          final data = await image.toByteData(format: ui.ImageByteFormat.png);
          final file = File(output);
          await file.parent.create(recursive: true);
          await file.writeAsBytes(data!.buffer.asUint8List());
          image.dispose();
        });
      }
      await tester.tap(find.text('杭州市'));
      await tester.pumpAndSettle();
      expect(find.text('海曙区'), findsNothing);
      expect(find.text('西湖区'), findsOneWidget);
      expect(find.text('宁波市'), findsOneWidget);
      await tester.tap(find.text('西湖区'));
      await tester.pumpAndSettle();
      expect(committed, [1, 5, 6]);
      expect(find.byType(HyperMenu), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'hover loads in the child surface; retry keeps ancestors and ignores other branches',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      var calls = 0;
      final pending = Completer<List<HyperCascaderNode<int>>>();
      await tester.pumpWidget(
        _app(
          HyperCascader<int>(
            nodes: const [
              HyperCascaderNode(value: 1, label: '远程分支', hasChildren: true),
              HyperCascaderNode(
                value: 2,
                label: '另一个分支',
                children: [HyperCascaderNode(value: 3, label: '另一个末级')],
              ),
            ],
            value: const [],
            onChanged: (_) {},
            loadChildren: (_) async {
              if (++calls == 1) throw StateError('offline');
              return pending.future;
            },
          ),
        ),
      );
      await tester.tap(find.text('请选择'));
      await tester.pumpAndSettle();
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer(location: Offset.zero);
      addTearDown(mouse.removePointer);
      await mouse.moveTo(tester.getCenter(find.text('远程分支')));
      await tester.pumpAndSettle();
      expect(find.text('加载失败'), findsOneWidget);
      expect(
        tester.getRect(find.text('加载失败')).left,
        greaterThan(tester.getRect(find.text('远程分支')).right),
      );
      await tester.tap(find.text('重试'));
      await tester.pumpAndSettle();
      expect(find.text('正在加载…'), findsOneWidget);
      expect(find.text('远程分支'), findsOneWidget);
      await tester.tap(find.text('另一个分支'));
      await tester.pumpAndSettle();
      pending.complete(const [HyperCascaderNode(value: 9, label: '远程结果')]);
      await tester.pumpAndSettle();
      expect(find.text('另一个末级'), findsOneWidget);
      expect(find.text('远程结果'), findsNothing);
      await tester.tap(find.text('远程分支'));
      await tester.pumpAndSettle();
      expect(find.text('远程结果'), findsOneWidget);
      expect(calls, 2);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'all submenu surfaces retain explicit border and disabled shadow recipe',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        _app(
          HyperCascader<int>(
            nodes: _nodes,
            value: const [],
            onChanged: (_) {},
            style: HyperCascaderStyle(
              selectStyle: HyperSelectStyle(
                selectionStyle: HyperSelectionStyle(
                  menuStyle: HyperMenuStyle(
                    surfaceStyle: HyperCardStyle(
                      border: Border.all(color: Colors.red),
                    ),
                  ),
                ),
              ),
            ),
            surfaceStyle: HyperCardStyle(
              boxShadow: [],
              material: const HyperSurfaceMaterial.solid(),
              border: Border.all(color: Colors.blue),
            ),
          ),
          theme: HyperThemeData.light().copyWith(
            materialTheme: const HyperMaterialThemeData(
              quality: HyperMaterialQuality.advanced,
              material: HyperSurfaceMaterial.frostedGlass(
                boxShadow: [BoxShadow(blurRadius: 8)],
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('请选择'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('浙江省'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('宁波市'));
      await tester.pumpAndSettle();
      expect(find.byType(HyperCard), findsNWidgets(3));
      for (final card in tester.widgetList<HyperCard>(find.byType(HyperCard))) {
        expect(card.style!.border, Border.all(color: Colors.blue));
        expect(card.style!.boxShadow, isEmpty);
        expect(card.style!.material!.usesBackdrop, isFalse);
      }
      expect(tester.takeException(), isNull);
    },
  );

  for (final scale in [1.0, 1.3, 2.0]) {
    testWidgets('nested menu labels grow without clipping at scale $scale', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(1000, 700));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        _app(
          Builder(
            builder: (context) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.linear(scale)),
              child: HyperCascader<int>(
                nodes: const [
                  HyperCascaderNode(
                    value: 1,
                    label: '长省级名称需要保留完整内容',
                    children: [
                      HyperCascaderNode(
                        value: 2,
                        label: '长市级名称在子面板内允许自动换行',
                        children: [
                          HyperCascaderNode(
                            value: 3,
                            label: '长区级名称也应随文字缩放自然增高',
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
                value: const [],
                onChanged: (_) {},
                style: const HyperCascaderStyle(
                  selectStyle: HyperSelectStyle(
                    width: 180,
                    selectionStyle: HyperSelectionStyle(width: 180),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('请选择'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('长省级名称需要保留完整内容'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('长市级名称在子面板内允许自动换行'));
      await tester.pumpAndSettle();
      final text = tester.widget<Text>(find.text('长区级名称也应随文字缩放自然增高'));
      expect(text.maxLines, isNull);
      expect(find.byType(HyperCard), findsNWidgets(3));
      expect(tester.takeException(), isNull);
    });
  }
}
