import 'package:flutter/gestures.dart';
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
        children: [HyperCascaderNode(value: 3, label: '西湖区及更长的完整地区名称')],
      ),
    ],
  ),
];

Widget _app(List<int> value, {double scale = 1, bool reduced = false}) =>
    MaterialApp(
      home: HyperDeviceDetector(
        deviceType: HyperDeviceType.desktop,
        builder: (context, device, child) =>
            HyperTheme(data: HyperThemeData.light(), child: child!),
        child: Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(scale),
              disableAnimations: reduced,
            ),
            child: Scaffold(
              body: Center(
                child: SizedBox(
                  width: 180,
                  child: HyperCascader<int>(
                    nodes: _nodes,
                    value: value,
                    onChanged: (_) {},
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

ScrollPosition _position(WidgetTester tester) => tester
    .state<ScrollableState>(
      find
          .descendant(
            of: find.byType(HyperScrollingText),
            matching: find.byType(Scrollable),
          )
          .first,
    )
    .position;

void main() {
  for (final scale in [1.0, 1.3, 2.0]) {
    testWidgets('long paths do not add lines to the trigger at scale $scale', (
      tester,
    ) async {
      await tester.pumpWidget(_app(const [1], scale: scale));
      await tester.pumpAndSettle();
      final shortHeight = tester.getSize(find.byType(HyperDropdown)).height;
      await tester.pumpWidget(_app(const [1, 2, 3], scale: scale));
      await tester.pumpAndSettle();
      expect(tester.getSize(find.byType(HyperDropdown)).height, shortHeight);
      expect(_position(tester).maxScrollExtent, greaterThan(0));
      expect(
        tester.widget<Text>(find.text('浙江省 / 杭州市 / 西湖区及更长的完整地区名称')).maxLines,
        1,
      );
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets(
    'overflow scrolls only on hover and resets on exit without opening',
    (tester) async {
      await tester.pumpWidget(_app(const [1, 2, 3]));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 2));
      expect(_position(tester).pixels, 0);
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer(location: Offset.zero);
      await mouse.moveTo(tester.getCenter(find.byType(HyperScrollingText)));
      await tester.pump();
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      expect(_position(tester).pixels, greaterThan(0));
      expect(find.byType(HyperMenu), findsNothing);
      await mouse.moveTo(Offset.zero);
      await tester.pumpAndSettle();
      expect(_position(tester).pixels, 0);
      await mouse.removePointer();
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'reduced motion keeps hover still and permits manual horizontal reading',
    (tester) async {
      await tester.pumpWidget(_app(const [1, 2, 3], reduced: true));
      await tester.pumpAndSettle();
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer(location: Offset.zero);
      await mouse.moveTo(tester.getCenter(find.byType(HyperScrollingText)));
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      expect(_position(tester).pixels, 0);
      await mouse.removePointer();
      await tester.drag(find.byType(HyperScrollingText), const Offset(-80, 0));
      await tester.pumpAndSettle();
      expect(_position(tester).pixels, greaterThan(0));
      expect(find.byType(HyperMenu), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
}
