import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui_example/pages/foundation/hyper_state_value_page.dart';

void main() {
  testWidgets('多个状态按统一优先级显示解析结果', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HyperStateValuePage()));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('resolved-state-label')), findsOneWidget);
    expect(find.text('默认'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilterChip, '悬停'));
    await tester.tap(find.widgetWithText(FilterChip, '按压'));
    await tester.pumpAndSettle();
    expect(find.text('最高优先级：按压'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilterChip, '禁用'));
    await tester.pumpAndSettle();
    expect(find.text('最高优先级：禁用'), findsOneWidget);
    expect(find.text('禁用'), findsWidgets);
  });
}
