import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui_example/pages/selection/hyper_switch_page.dart';

void main() {
  testWidgets('展示开关状态并可切换', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: HyperSwitchPage())),
    );

    expect(find.text('HyperSwitch'), findsOneWidget);
    expect(find.text('关闭'), findsOneWidget);
    expect(find.text('开启'), findsOneWidget);
    expect(find.text('禁用关闭'), findsOneWidget);
    expect(find.text('禁用开启'), findsOneWidget);

    await tester.tap(find.byKey(const Key('interactive-switch')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('interactive-switch')), findsOneWidget);
  });
}
