import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/pages/framework/hyper_drawer_page.dart';

void main() {
  testWidgets('四边四角实例演示可关闭，并支持窄宽文字缩放', (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 480));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    for (final scale in [1.0, 1.3, 2.0]) {
      await tester.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: HyperThemeData.light(),
            duration: Duration.zero,
            child: MediaQuery(
              data: MediaQueryData(textScaler: TextScaler.linear(scale)),
              child: HyperDrawerPage(key: ValueKey(scale)),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      tester.widget<HyperSwitch>(find.byType(HyperSwitch)).onChanged!(true);
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('打开起始侧'));
      await tester.tap(find.text('打开起始侧'));
      await tester.pumpAndSettle();
      final shape =
          tester.widget<Drawer>(find.byType(Drawer)).shape!
              as RoundedRectangleBorder;
      expect(shape.borderRadius.resolve(TextDirection.ltr).topLeft.x, 12);
      expect(tester.getTopLeft(find.byType(Drawer)).dy, 24);
      expect(tester.takeException(), isNull);
      await tester.tapAt(const Offset(5, 5));
      await tester.pumpAndSettle();
      tester.widget<HyperSwitch>(find.byType(HyperSwitch)).onChanged!(false);
      await tester.pumpAndSettle();
      await tester.tap(find.text('打开起始侧'));
      await tester.pumpAndSettle();
      expect(tester.getTopLeft(find.byType(Drawer)).dy, 0);
      await tester.tapAt(const Offset(319, 200));
      await tester.pumpAndSettle();
    }
  });
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
