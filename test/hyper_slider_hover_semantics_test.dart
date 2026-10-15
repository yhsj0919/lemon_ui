import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  testWidgets('滑块悬停动画保持语义节点与调节动作', (tester) async {
    final handle = tester.ensureSemantics();

    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: Material(
            child: Center(
              child: SizedBox(
                width: 300,
                child: HyperSlider(value: .5, onChanged: (_) {}),
              ),
            ),
          ),
        ),
      ),
    );
    final slider = find.byType(Slider);
    final before = tester.getSemantics(slider);
    final id = before.id;
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(slider));
    for (var i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 20));
      expect(tester.getSemantics(slider).id, id);
      expect(tester.takeException(), isNull);
    }
    await mouse.removePointer();
    handle.dispose();
    await tester.pumpAndSettle();
  });
}
