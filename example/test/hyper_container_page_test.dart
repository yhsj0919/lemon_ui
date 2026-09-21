import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui_example/pages/container/hyper_container_page.dart';

void main() {
  testWidgets('HyperContainer 演示显示主题、覆盖和动画', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HyperContainerPage()));
    await tester.pumpAndSettle();

    expect(find.text('继承容器主题'), findsOneWidget);
    expect(find.text('实例渐变覆盖'), findsOneWidget);
    expect(find.text('显式清除背景和阴影'), findsOneWidget);
    expect(
      tester.getSize(find.byKey(const Key('themed-container'))),
      const Size(220, 120),
    );

    final animated = find.descendant(
      of: find.byKey(const Key('gradient-container')),
      matching: find.byType(AnimatedContainer),
    );
    final before = tester.widget<AnimatedContainer>(animated).decoration;
    await tester.tap(find.text('切换动画效果'));
    await tester.pumpAndSettle();
    final after = tester.widget<AnimatedContainer>(animated).decoration;
    expect(after, isNot(before));
  });
}
