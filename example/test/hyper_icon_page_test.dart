import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/pages/content/hyper_icon_page.dart';

void main() {
  testWidgets('默认图标预览跟随全局图标主题变化', (tester) async {
    Widget app(Color color) => MaterialApp(
      home: HyperTheme(
        data: HyperThemeData.light().copyWith(
          iconTheme: HyperIconThemeData(
            style: HyperIconStyle(color: HyperStateValue.all(color)),
          ),
        ),
        duration: Duration.zero,
        child: const HyperIconPage(),
      ),
    );
    await tester.pumpWidget(app(Colors.blue));

    expect(find.text('图标'), findsOneWidget);
    final favorite = find.byIcon(Icons.favorite);
    expect(tester.widget<Icon>(favorite).color, Colors.blue);
    await tester.pumpWidget(app(Colors.purple));
    await tester.pumpAndSettle();
    expect(tester.widget<Icon>(favorite).color, Colors.purple);
  });
}
