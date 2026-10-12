import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import '../lib/pages/framework/hyper_top_navigation_page.dart';

void main() {
  testWidgets('完整顶部导航 Demo 在 2 倍文字下不溢出', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: HyperTheme(
          data: HyperThemeData.light(),
          duration: Duration.zero,
          child: const Scaffold(body: HyperTopNavigationPage()),
        ),
      ),
    ));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byType(HyperTopNavigation), findsNWidgets(2));
  });
}
