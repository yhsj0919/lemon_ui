import 'dart:async';

import 'package:flutter/material.dart';
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
  HyperCascaderNode(value: 4, label: '不可用', enabled: false),
];

Widget _app(
  Widget child, {
  HyperDeviceType device = HyperDeviceType.desktop,
  HyperThemeData? theme,
  double scale = 1,
  double width = 320,
}) => MaterialApp(
  home: HyperDeviceDetector(
    deviceType: device,
    builder: (context, device, child) =>
        HyperTheme(data: theme ?? HyperThemeData.light(), child: child!),
    child: Builder(
      builder: (context) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: TextScaler.linear(scale)),
        child: Scaffold(
          body: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(width: width, child: child),
          ),
        ),
      ),
    ),
  ),
);

void main() {
  for (final device in [
    HyperDeviceType.desktop,
    HyperDeviceType.phone,
    HyperDeviceType.watch,
  ]) {
    testWidgets(
      'maxDepth one selects a root without loading children on $device',
      (tester) async {
        var loads = 0;
        List<int>? selected;
        await tester.pumpWidget(
          _app(
            HyperCascader<int>(
              nodes: const [
                HyperCascaderNode(value: 1, label: '一级行业', hasChildren: true),
              ],
              value: const [],
              maxDepth: 1,
              onChanged: (value) => selected = value,
              loadChildren: (_) async {
                loads++;
                return const [HyperCascaderNode(value: 2, label: '二级行业')];
              },
            ),
            device: device,
          ),
        );
        await tester.tap(find.text('请选择').first);
        await tester.pumpAndSettle();
        if (device == HyperDeviceType.phone) {
          await tester.tap(find.text('确定').last);
        } else {
          await tester.tap(find.text('一级行业').last);
        }
        await tester.pumpAndSettle();
        expect(selected, [1]);
        expect(loads, 0);
        expect(tester.takeException(), isNull);
      },
    );
  }
  testWidgets(
    'only leaves commit full paths; closing and browsing preserve value',
    (tester) async {
      List<int> value = [];
      final changes = <List<int>>[];
      await tester.pumpWidget(
        _app(
          StatefulBuilder(
            builder: (_, update) => HyperCascader<int>(
              nodes: _nodes,
              value: value,
              onChanged: (next) {
                changes.add(next);
                update(() => value = next);
              },
            ),
          ),
        ),
      );
      await tester.tap(find.text('请选择'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('浙江省'));
      await tester.pumpAndSettle();
      expect(changes, isEmpty);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(changes, isEmpty);
      await tester.tap(find.text('请选择'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('浙江省'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('杭州市'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('西湖区'));
      await tester.pumpAndSettle();
      expect(value, [1, 2, 3]);
      expect(find.text('浙江省 / 杭州市 / 西湖区'), findsOneWidget);
      expect(() => value.add(9), throwsUnsupportedError);
      await tester.tap(find.text('浙江省 / 杭州市 / 西湖区'));
      await tester.pumpAndSettle();
      expect(find.text('浙江省'), findsOneWidget);
      expect(find.text('西湖区'), findsNothing);
      await tester.tap(find.text('清空'));
      await tester.pumpAndSettle();
      expect(value, isEmpty);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'keyboard can enter, return and select; disabled items skip activation',
    (tester) async {
      List<int>? changed;
      await tester.pumpWidget(
        _app(
          HyperCascader<int>(
            nodes: _nodes,
            value: const [],
            onChanged: (value) => changed = value,
          ),
        ),
      );
      await tester.tap(find.text('请选择'));
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(find.text('杭州市'), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.pumpAndSettle();
      expect(find.text('不可用'), findsOneWidget);
      await tester.tap(find.text('不可用'));
      expect(changed, isNull);
      for (var i = 0; i < 3; i++) {
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pumpAndSettle();
      }
      expect(changed, [1, 2, 3]);
      expect(tester.takeException(), isNull);
    },
  );

  for (final device in HyperDeviceType.values) {
    testWidgets('adaptive presentation follows real device $device', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(
          HyperCascader<int>(nodes: _nodes, value: const [], onChanged: (_) {}),
          device: device,
        ),
      );
      await tester.tap(find.text('请选择'));
      await tester.pumpAndSettle();
      if (device == HyperDeviceType.desktop) {
        expect(find.byType(HyperCard), findsOneWidget);
      } else if (device == HyperDeviceType.watch) {
        expect(find.byType(HyperScaffold), findsOneWidget);
      } else {
        expect(find.byType(HyperBottomSheet), findsOneWidget);
        expect(find.byType(HyperCard), findsNothing);
      }
      expect(find.text('浙江省'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  for (final scale in [1.0, 1.3, 2.0]) {
    testWidgets('long labels wrap at narrow width and text scale $scale', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(
          HyperCascader<int>(
            nodes: const [
              HyperCascaderNode(value: 1, label: '这是一个需要自动换行的很长的地区名称'),
            ],
            value: const [1],
            onChanged: (_) {},
            style: const HyperCascaderStyle(
              selectStyle: HyperSelectStyle(
                width: 180,
                selectionStyle: HyperSelectionStyle(width: 180),
              ),
            ),
          ),
          scale: scale,
          width: 180,
        ),
      );
      await tester.tap(find.byType(HyperDropdown));
      await tester.pumpAndSettle();
      expect(find.text('这是一个需要自动换行的很长的地区名称'), findsNWidgets(2));
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('modal reflects external values and closes when disabled', (
    tester,
  ) async {
    List<int> value = [];
    var enabled = true;
    late StateSetter update;
    await tester.pumpWidget(
      _app(
        StatefulBuilder(
          builder: (_, setState) {
            update = setState;
            return HyperCascader<int>(
              nodes: _nodes,
              value: value,
              enabled: enabled,
              onChanged: (_) {},
            );
          },
        ),
        device: HyperDeviceType.phone,
      ),
    );
    await tester.tap(find.text('请选择'));
    await tester.pumpAndSettle();
    update(() => value = [1, 2, 3]);
    await tester.pumpAndSettle();
    expect(find.text('西湖区'), findsOneWidget);
    update(() => enabled = false);
    await tester.pumpAndSettle();
    expect(find.byType(HyperBottomSheet), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('replacement source ignores late requests in an open modal', (
    tester,
  ) async {
    final pending = Completer<List<HyperCascaderNode<int>>>();
    List<HyperCascaderNode<int>> nodes = const [
      HyperCascaderNode(value: 8, label: '旧分支', hasChildren: true),
    ];
    late StateSetter update;
    Future<List<HyperCascaderNode<int>>> load(List<HyperCascaderNode<int>> _) =>
        pending.future;
    await tester.pumpWidget(
      _app(
        StatefulBuilder(
          builder: (_, setState) {
            update = setState;
            return HyperCascader<int>(
              nodes: nodes,
              value: const [],
              onChanged: (_) {},
              loadChildren: load,
            );
          },
        ),
        device: HyperDeviceType.phone,
      ),
    );
    await tester.tap(find.text('请选择'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('旧分支'));
    await tester.pumpAndSettle();
    expect(find.text('正在加载…'), findsOneWidget);
    update(() => nodes = _nodes);
    await tester.pumpAndSettle();
    pending.complete(const [HyperCascaderNode(value: 9, label: '过期结果')]);
    await tester.pumpAndSettle();
    expect(find.text('过期结果'), findsNothing);
    expect(find.text('浙江省'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('global, nested local and instance styles merge field by field', (
    tester,
  ) async {
    final theme = HyperThemeData.light().copyWith(
      cascaderTheme: const HyperCascaderThemeData(
        style: HyperCascaderStyle(
          selectStyle: HyperSelectStyle(width: 210),
          branchIcon: Icons.add,
        ),
      ),
    );
    await tester.pumpWidget(
      _app(
        HyperCascaderTheme(
          data: HyperCascaderThemeData(
            style: HyperCascaderStyle(
              selectStyle: HyperSelectStyle(
                selectionStyle: HyperSelectionStyle(
                  surfaceStyle: HyperCardStyle(
                    border: Border.all(color: Colors.green),
                  ),
                ),
              ),
              branchIcon: Icons.arrow_forward,
            ),
          ),
          child: HyperCascaderTheme(
            data: const HyperCascaderThemeData(
              style: HyperCascaderStyle(backIcon: Icons.arrow_back_ios),
            ),
            child: HyperCascader<int>(
              nodes: _nodes,
              value: const [],
              onChanged: (_) {},
              style: const HyperCascaderStyle(branchIcon: Icons.chevron_right),
              surfaceStyle: HyperCardStyle(
                boxShadow: [],
                border: Border.all(color: Colors.blue),
              ),
            ),
          ),
        ),
        theme: theme,
      ),
    );
    final dropdown = tester.widget<HyperDropdown>(find.byType(HyperDropdown));
    expect(dropdown.style!.width, 210);
    await tester.tap(find.text('请选择'));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    final card = tester.widget<HyperCard>(find.byType(HyperCard));
    expect(card.style!.border, Border.all(color: Colors.blue));
    expect(card.style!.boxShadow, isEmpty);
    await tester.tap(find.text('浙江省'));
    await tester.pumpAndSettle();
    expect(find.text('浙江省'), findsOneWidget);
    expect(find.text('杭州市'), findsOneWidget);
    for (final surface in tester.widgetList<HyperCard>(
      find.byType(HyperCard),
    )) {
      expect(surface.style!.border, Border.all(color: Colors.blue));
      expect(surface.style!.boxShadow, isEmpty);
    }
    expect(
      HyperCascaderTheme.of(tester.element(find.byType(HyperCascader<int>)))
          .style
          .backIcon,
      Icons.arrow_back_ios,
    );
    expect(tester.takeException(), isNull);
  });

  for (final quality in HyperMaterialQuality.values) {
    testWidgets(
      'inherited material $quality has safe intermediate and final frames',
      (tester) async {
        final theme = HyperThemeData.light().copyWith(
          materialTheme: HyperMaterialThemeData(
            quality: quality,
            material: const HyperSurfaceMaterial.frostedGlass(
              background: HyperFill.color(Color(0x70FFFFFF)),
              boxShadow: [BoxShadow(blurRadius: 8)],
            ),
          ),
        );
        await tester.pumpWidget(
          _app(
            HyperCascader<int>(
              nodes: _nodes,
              value: const [],
              onChanged: (_) {},
            ),
            theme: theme,
          ),
        );
        await tester.tap(find.text('请选择'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 40));
        final content = tester.element(find.text('浙江省'));
        void checkSafeFilters() {
          final filters = find.descendant(
            of: find.byType(HyperCard),
            matching: find.byType(BackdropFilter),
          );
          for (final element in filters.evaluate()) {
            final filter = element.widget as BackdropFilter;
            if (!filter.enabled) continue;
            element.visitAncestorElements((ancestor) {
              final widget = ancestor.widget;
              if (widget is Opacity) expect(widget.opacity, 1);
              if (widget is FadeTransition) expect(widget.opacity.value, 1);
              return true;
            });
          }
        }

        checkSafeFilters();
        await tester.pumpAndSettle();
        checkSafeFilters();
        expect(tester.element(find.text('浙江省')), same(content));
        final filters = find.descendant(
          of: find.byType(HyperCard),
          matching: find.byType(BackdropFilter),
        );
        if (quality == HyperMaterialQuality.advanced) {
          expect(filters, findsWidgets);
          expect(
            tester.widgetList<BackdropFilter>(filters).any((f) => f.enabled),
            isTrue,
          );
        } else {
          expect(
            tester.widgetList<BackdropFilter>(filters).any((f) => f.enabled),
            isFalse,
          );
        }
        expect(tester.takeException(), isNull);
      },
    );
  }

  for (final device in [HyperDeviceType.desktop, HyperDeviceType.phone]) {
    testWidgets(
      'explicit solid material and empty shadows override global glass on $device',
      (tester) async {
        await tester.pumpWidget(
          _app(
            HyperCascader<int>(
              nodes: _nodes,
              value: const [],
              onChanged: (_) {},
              surfaceStyle: HyperCardStyle(
                material: const HyperSurfaceMaterial.solid(),
                boxShadow: [],
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(11),
              ),
            ),
            device: device,
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
        if (device == HyperDeviceType.desktop) {
          final style = tester.widget<HyperCard>(find.byType(HyperCard)).style!;
          expect(style.material!.usesBackdrop, isFalse);
          expect(style.boxShadow, isEmpty);
          expect(style.border, Border.all(color: Colors.blue));
          expect(style.borderRadius, BorderRadius.circular(11));
        } else {
          final style = tester
              .widget<HyperBottomSheet>(find.byType(HyperBottomSheet))
              .style!;
          expect(style.material!.usesBackdrop, isFalse);
          expect(style.boxShadow, isEmpty);
          expect(style.border, Border.all(color: Colors.blue));
          expect(style.borderRadius, BorderRadius.circular(11));
        }
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'disposing with a pending modal request safely closes the route',
    (tester) async {
      final pending = Completer<List<HyperCascaderNode<int>>>();
      var visible = true;
      late StateSetter update;
      await tester.pumpWidget(
        _app(
          StatefulBuilder(
            builder: (_, setState) {
              update = setState;
              return visible
                  ? HyperCascader<int>(
                      nodes: const [
                        HyperCascaderNode(
                          value: 1,
                          label: '加载分支',
                          hasChildren: true,
                        ),
                      ],
                      value: const [],
                      onChanged: (_) {},
                      loadChildren: (_) => pending.future,
                    )
                  : const SizedBox();
            },
          ),
          device: HyperDeviceType.phone,
        ),
      );
      await tester.tap(find.text('请选择'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('加载分支'));
      await tester.pumpAndSettle();
      update(() => visible = false);
      await tester.pumpAndSettle();
      pending.complete(const [HyperCascaderNode(value: 2, label: 'Late')]);
      await tester.pumpAndSettle();
      expect(find.byType(HyperBottomSheet), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  test('theme supports global copy, interpolation, equality and explicit empty shadows', () {
    const a = HyperCascaderThemeData(
      style: HyperCascaderStyle(selectStyle: HyperSelectStyle(width: 200)),
    );
    final b = a.copyWith(
      style: HyperCascaderStyle(
        selectStyle: HyperSelectStyle(
          width: 240,
          selectionStyle: HyperSelectionStyle(
            surfaceStyle: HyperCardStyle(boxShadow: []),
          ),
        ),
      ),
    );
    final theme = HyperThemeData.light().copyWith(cascaderTheme: a);
    expect(theme.copyWith(), theme);
    expect(theme.copyWith().hashCode, theme.hashCode);
    final changed = theme.copyWith(cascaderTheme: b);
    expect(changed, isNot(theme));
    expect(theme.lerp(changed, .5).cascaderTheme.style.selectStyle!.width, 220);
    expect(
      b.style.selectStyle!.selectionStyle!.surfaceStyle!.boxShadow,
      isEmpty,
    );
  });
}
