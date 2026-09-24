import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/pages/interaction/hyper_menu_page.dart';

void main() {
  testWidgets('菜单 Demo 从按钮打开，选择后关闭', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          duration: Duration.zero,
          child: const Scaffold(body: HyperMenuPage()),
        ),
      ),
    );

    await tester.tap(find.text('打开菜单'));
    await tester.pumpAndSettle();
    expect(find.text('新建窗口'), findsOneWidget);
    expect(find.text('退出登录'), findsOneWidget);
    await tester.tap(find.text('新建窗口'));
    await tester.pumpAndSettle();
    expect(find.text('最近操作：new_window'), findsOneWidget);
    expect(find.text('新建窗口'), findsNothing);
  });

  testWidgets('菜单 Demo 打开后方向键可以进入子菜单', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          duration: Duration.zero,
          child: const Scaffold(body: HyperMenuPage()),
        ),
      ),
    );
    await tester.tap(find.text('打开菜单'));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    expect(find.text('通用'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pumpAndSettle();
    final row = tester.widget<HyperPressable>(
      find.ancestor(of: find.text('通用'), matching: find.byType(HyperPressable)),
    );
    expect(row.focusNode!.hasPrimaryFocus, isTrue);
  });
}
