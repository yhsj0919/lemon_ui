import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui_example/pages/foundation/hyper_container_theme_page.dart';

void main() {
  testWidgets('主题预览可插值且保持显式尺寸', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: HyperContainerThemePage())),
    );
    final target = find.byKey(const ValueKey('interpolated-container'));
    expect(tester.getSize(target), const Size(180, 100));
    final before = tester.widget<Container>(target).decoration;
    await tester.tap(find.byKey(const ValueKey('theme-progress')));
    await tester.pumpAndSettle();
    expect(tester.widget<Container>(target).decoration, isNot(before));
    expect(tester.getSize(target), const Size(180, 100));
    expect(find.text('只覆盖圆角'), findsOneWidget);
    expect(find.text('取消背景和阴影'), findsOneWidget);
  });
}
