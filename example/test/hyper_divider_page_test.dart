import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/pages/content/hyper_divider_page.dart';

void main() {
  testWidgets('展示 HyperDivider 的主要线型和主题覆盖', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          duration: Duration.zero,
          child: const HyperDividerPage(),
        ),
      ),
    );

    expect(find.text('HyperDivider'), findsOneWidget);
    expect(find.byType(HyperDivider), findsWidgets);
    await tester.drag(find.byType(ListView), const Offset(0, -600));
    await tester.pumpAndSettle();
    expect(find.text('局部主题与实例覆盖'), findsOneWidget);
  });
}
