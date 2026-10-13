import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  for (final reduced in [false, true]) {
    testWidgets('按钮变换不改变布局，减少动画=$reduced', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: HyperThemeData.light(),
            child: MediaQuery(
              data: MediaQueryData(disableAnimations: reduced),
              child: Center(
                child: HyperButton.filled(
                  label: const Text('变换按钮'),
                  focusHighlight: false,
                  onPressed: () {},
                  style: HyperButtonStyle(
                    hoveredOffset: const Offset(0, -3),
                    hoveredScale: 1.05,
                    pressedOffset: const Offset(0, 2),
                    pressedScale: .95,
                    animationDuration: const Duration(milliseconds: 100),
                    animationCurve: Curves.linear,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      final button = find.byType(HyperButton), label = find.text('变换按钮');
      final initialRect = tester.getRect(button),
          initialCenter = tester.getCenter(label);
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer(location: Offset.zero);
      await mouse.moveTo(initialRect.center);
      await tester.pumpAndSettle();
      expect(tester.getRect(button), initialRect);
      expect(
        tester.getCenter(label).dy,
        closeTo(initialCenter.dy + (reduced ? 0 : -3), .01),
      );
      final transforms = tester.widgetList<Transform>(
        find.descendant(of: button, matching: find.byType(Transform)),
      );
      expect(
        transforms.any(
          (t) => (t.transform.storage[0] - (reduced ? 1 : 1.05)).abs() < .001,
        ),
        isTrue,
      );
      await mouse.down(initialRect.center);
      await tester.pumpAndSettle();
      expect(tester.getRect(button), initialRect);
      expect(
        tester.getCenter(label).dy,
        closeTo(initialCenter.dy + (reduced ? 0 : 2), .01),
      );
      await mouse.up();
      await mouse.moveTo(Offset.zero);
      await tester.pumpAndSettle();
      expect(tester.getCenter(label), initialCenter);
      await mouse.removePointer();
    });
  }
  test('变换样式的复制、插值、相等与清空', () {
    final a = HyperButtonStyle(
      hoveredOffset: const Offset(0, -2),
      pressedScale: .95,
    );
    expect(a.copyWith(), a);
    expect(a.copyWith(hoveredOffset: null).hoveredOffset, isNull);
    final b = a.copyWith(hoveredOffset: const Offset(0, -4), pressedScale: .85);
    expect(HyperButtonStyle.lerp(a, b, .5).hoveredOffset, const Offset(0, -3));
    expect(HyperButtonStyle.lerp(a, b, .5).pressedScale, closeTo(.9, .001));
  });
}
