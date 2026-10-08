import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/pages/selection/hyper_slider_page.dart';

void main() {
  for (final width in [390.0, 1000.0]) {
    testWidgets('音量展示在 $width 宽度下有完整卡片与留白', (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = Size(width, 1400);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MaterialApp(
          home: HyperDeviceDetector(
            deviceType: HyperDeviceType.desktop,
            builder: (context, deviceType, child) => HyperTheme(
              data: HyperThemeData.light(),
              child: const HyperScaffold(body: HyperSliderPage()),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final card = find.ancestor(
        of: find.text('音量调节'),
        matching: find.byType(HyperCard),
      );
      expect(card, findsOneWidget);
      final cardRect = tester.getRect(card);
      final titleRect = tester.getRect(find.text('音量调节'));
      expect(cardRect.contains(titleRect.topLeft), isTrue);
      final sliders = find.descendant(
        of: card,
        matching: find.byType(HyperSlider),
      );
      expect(sliders, findsNWidgets(5));
      for (final slider in sliders.evaluate()) {
        final rect = tester.getRect(find.byWidget(slider.widget));
        expect(rect.left, greaterThan(cardRect.left));
        expect(rect.right, lessThan(cardRect.right));
        expect(rect.bottom, lessThan(cardRect.bottom));
      }

      final first = sliders.first;
      final before = tester.widget<HyperSlider>(first).value;
      await tester.drag(first, const Offset(50, 0));
      await tester.pumpAndSettle();
      expect(tester.widget<HyperSlider>(first).value, greaterThan(before));
      expect(tester.takeException(), isNull);
      // 本测试验证卡片布局和拖动；Slider 的语义动作断言另行处理。
    }, semanticsEnabled: false);
  }
}
