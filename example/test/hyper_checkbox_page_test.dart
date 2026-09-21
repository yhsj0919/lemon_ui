import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/pages/selection/hyper_checkbox_page.dart';

void main() {
  testWidgets('展示并切换三态复选框', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          duration: Duration.zero,
          child: const HyperCheckboxPage(),
        ),
      ),
    );
    expect(find.text('未选中'), findsOneWidget);
    expect(find.text('圆角矩形变体'), findsOneWidget);
    await tester.tap(find.byType(HyperCheckbox).first);
    await tester.pump();
    expect(find.text('选中'), findsOneWidget);
    await tester.tap(find.byType(HyperCheckbox).first);
    await tester.pump();
    expect(find.text('半选中'), findsOneWidget);
  });
}
