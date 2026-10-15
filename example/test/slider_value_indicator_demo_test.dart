import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/pages/selection/hyper_slider_page.dart';

void main() {
  testWidgets('数值提示Demo常显且继承提示文字样式', (tester) async {
    await tester.pumpWidget(MaterialApp(home: HyperTheme(
      data: HyperThemeData.light().copyWith(sliderTheme: const HyperSliderThemeData(
        style: HyperSliderStyle(valueIndicatorTextStyle: TextStyle(fontSize: 24, color: Colors.red)))),
      duration: Duration.zero, child: const Scaffold(body: HyperSliderPage()))));
    final preview = find.byKey(const ValueKey('slider-value-indicator-preview'));
    await tester.scrollUntilVisible(preview, 300, scrollable: find.byType(Scrollable).first);
    await tester.pumpAndSettle();
    final slider = find.descendant(of: preview, matching: find.byType(Slider));
    final theme = SliderTheme.of(tester.element(slider));
    expect(theme.showValueIndicator, ShowValueIndicator.alwaysVisible);
    expect(theme.valueIndicatorTextStyle!.fontSize, 24);
    expect(theme.valueIndicatorTextStyle!.color, Colors.red);
    expect(tester.widget<Slider>(slider).label, '48%');
    expect(tester.takeException(), isNull);
  });
}

