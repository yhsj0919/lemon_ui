import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/pages/content/hyper_text_page.dart';

void main() {
  testWidgets('展示语义字号并切换正文主题', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          duration: Duration.zero,
          child: const HyperTextPage(),
        ),
      ),
    );

    expect(find.text('HyperText'), findsOneWidget);
    expect(find.text('默认正文'), findsOneWidget);
    await tester.tap(find.byType(HyperSwitch));
    await tester.pumpAndSettle();

    final body = tester.widget<Text>(find.text('默认正文'));
    expect(body.style?.fontWeight, FontWeight.w600);
  });
}
