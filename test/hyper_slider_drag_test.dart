import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  testWidgets('鼠标越界拖动保持端点，回到轨道继续更新', (tester) async {
    var value = .5;
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: Scaffold(
            body: Center(
              child: SizedBox(
                width: 200,
                child: StatefulBuilder(
                  builder: (context, update) => HyperSlider(
                    value: value,
                    onChanged: (next) => update(() => value = next),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    final rect = tester.getRect(find.byType(HyperSlider));
    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: rect.center);
    await tester.pumpAndSettle();
    await gesture.down(rect.center);
    await gesture.moveTo(rect.center + const Offset(50, 0));
    await tester.pumpAndSettle();
    await gesture.moveTo(rect.center + const Offset(200, 60));
    await tester.pumpAndSettle();
    expect(value, 1);
    await gesture.moveTo(rect.center);
    await tester.pumpAndSettle();
    expect(value, closeTo(.5, .02));
    await gesture.moveTo(rect.center - const Offset(200, 60));
    await tester.pumpAndSettle();
    expect(value, 0);
    await gesture.up();
    expect(tester.takeException(), isNull);
  });
}
