import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/pages/framework/hyper_drawer_page.dart';

void main() {
  testWidgets('Drawer Demo 可打开两侧抽屉并显示自由内容', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          duration: Duration.zero,
          child: const HyperDrawerPage(),
        ),
      ),
    );

    await tester.tap(find.text('打开起始侧'));
    await tester.pumpAndSettle();
    expect(find.text('任意内容'), findsOneWidget);
    expect(find.text('固定头部'), findsOneWidget);
    expect(find.text('固定尾部'), findsOneWidget);

    await tester.tapAt(const Offset(380, 350));
    await tester.pumpAndSettle();
    await tester.tap(find.text('打开结束侧'));
    await tester.pumpAndSettle();
    expect(find.text('结束侧抽屉'), findsOneWidget);
  });
}
