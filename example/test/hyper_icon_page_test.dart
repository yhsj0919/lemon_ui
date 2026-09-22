import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/pages/content/hyper_icon_page.dart';

void main() {
  testWidgets('展示图标主题并切换选中状态', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          duration: Duration.zero,
          child: const HyperIconPage(),
        ),
      ),
    );

    expect(find.text('HyperIcon'), findsOneWidget);
    final favorite = find.byIcon(Icons.favorite);
    final before = tester.widget<Icon>(favorite).color;
    await tester.tap(find.byType(HyperSwitch));
    await tester.pumpAndSettle();
    expect(tester.widget<Icon>(favorite).color, isNot(before));
  });
}
