import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/pages/interaction/hyper_anchored_overlay_page.dart';

void main() {
  testWidgets('锚定浮层 Demo 展示点击与悬停两种入口', (tester) async {
    await tester.binding.setSurfaceSize(const Size(600, 500));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          duration: Duration.zero,
          child: const Scaffold(body: HyperAnchoredOverlayPage()),
        ),
      ),
    );

    await tester.tap(find.text('点击打开'));
    await tester.pumpAndSettle();
    expect(find.text('关闭浮层'), findsOneWidget);
    await tester.tap(find.text('关闭浮层'));
    await tester.pumpAndSettle();
    expect(find.text('关闭浮层'), findsNothing);

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(find.text('悬停查看子项')));
    await tester.pumpAndSettle();
    expect(find.text('鼠标移入此处，浮层会保持打开'), findsOneWidget);
    await mouse.removePointer();
  });
}
