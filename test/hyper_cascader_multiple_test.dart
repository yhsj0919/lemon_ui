import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

const nodes = [
  HyperCascaderNode(
    value: 1,
    label: '行业',
    children: [
      HyperCascaderNode(value: 2, label: '软件'),
      HyperCascaderNode(value: 3, label: '硬件'),
      HyperCascaderNode(value: 4, label: '禁用', enabled: false),
    ],
  ),
];

void main() {
  for (final scale in [1.0, 1.3, 2.0]) {
    testWidgets('async multiple compares paths by value at text scale $scale', (
      tester,
    ) async {
      List<List<int>> values = [
        [1, 2],
        [1, 2],
      ];
      final changes = <List<List<int>>>[];
      var loads = 0;
      Future<List<HyperCascaderNode<int>>> load(
        List<HyperCascaderNode<int>> path,
      ) async {
        loads++;
        return const [
          HyperCascaderNode(value: 2, label: '软件'),
          HyperCascaderNode(value: 3, label: '硬件', hasChildren: true),
        ];
      }

      await tester.pumpWidget(
        MaterialApp(
          home: HyperDeviceDetector(
            deviceType: HyperDeviceType.phone,
            builder: (_, _, child) =>
                HyperTheme(data: HyperThemeData.light(), child: child!),
            child: MediaQuery(
              data: MediaQueryData(
                size: const Size(360, 640),
                textScaler: TextScaler.linear(scale),
              ),
              child: Scaffold(
                body: StatefulBuilder(
                  builder: (_, update) => HyperCascader<int>.multiple(
                    nodes: const [
                      HyperCascaderNode(
                        value: 1,
                        label: '行业',
                        hasChildren: true,
                      ),
                    ],
                    loadChildren: load,
                    maxDepth: 2,
                    values: values,
                    onSelectionChanged: (next) {
                      changes.add(next);
                      update(() => values = next);
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('2、2').first);
      await tester.pumpAndSettle();
      expect(loads, 1);
      expect(changes, isEmpty);
      await tester.tap(find.text('硬件').last);
      await tester.pumpAndSettle();
      expect(values, [
        [1, 2],
        [1, 3],
      ]);
      expect(loads, 1);
      await tester.tap(find.text('软件').last);
      await tester.pumpAndSettle();
      expect(values, [
        [1, 3],
      ]);
      expect(tester.takeException(), isNull);
    });
  }
  for (final device in HyperDeviceType.values) {
    testWidgets('multiple paths toggle and clear on $device', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1000, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      List<List<int>> values = [];
      final changes = <List<List<int>>>[];
      await tester.pumpWidget(
        MaterialApp(
          home: HyperDeviceDetector(
            deviceType: device,
            builder: (_, _, child) =>
                HyperTheme(data: HyperThemeData.light(), child: child!),
            child: Scaffold(
              body: Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: 300,
                  child: StatefulBuilder(
                    builder: (_, update) => HyperCascader<int>.multiple(
                      nodes: nodes,
                      values: values,
                      onSelectionChanged: (next) {
                        changes.add(next);
                        update(() => values = next);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('请选择').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('行业').last);
      await tester.pumpAndSettle();
      expect(changes, isEmpty);
      await tester.tap(find.text('软件').last);
      await tester.pumpAndSettle();
      expect(values, [
        [1, 2],
      ]);
      expect(find.text('硬件'), findsOneWidget);
      await tester.tap(find.text('硬件').last);
      await tester.pumpAndSettle();
      expect(values, [
        [1, 2],
        [1, 3],
      ]);
      expect(() => values.add([9]), throwsUnsupportedError);
      expect(() => values.first.add(9), throwsUnsupportedError);
      await tester.tap(find.text('禁用').last);
      await tester.pumpAndSettle();
      expect(values.length, 2);
      await tester.tap(find.text('软件').last);
      await tester.pumpAndSettle();
      expect(values, [
        [1, 3],
      ]);
      await tester.tap(find.text('完成').last);
      await tester.pumpAndSettle();
      expect(values, [
        [1, 3],
      ]);
      expect(find.text('行业 / 硬件'), findsNothing);
      await tester.tap(find.text('硬件').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('清空').last);
      await tester.pumpAndSettle();
      expect(values, isEmpty);
      expect(tester.takeException(), isNull);
    });
  }
}
