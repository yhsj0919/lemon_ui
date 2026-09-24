import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/pages/framework/hyper_sidebar_page.dart';

void main() {
  testWidgets('侧栏 Demo 展示树形选中和折叠切换', (tester) async {
    await tester.binding.setSurfaceSize(const Size(900, 650));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          duration: Duration.zero,
          child: const Scaffold(body: HyperSidebarPage()),
        ),
      ),
    );
    expect(find.byType(HyperSidebar), findsOneWidget);
    expect(find.text('固定头部'), findsOneWidget);
    expect(find.text('固定尾部'), findsOneWidget);
    expect(find.text('收藏'), findsOneWidget);
    await tester.tap(find.text('最近'));
    await tester.pumpAndSettle();
    expect(find.text('当前选择：recent'), findsOneWidget);
    await tester.tap(find.text('折叠'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<HyperSidebar>(find.byType(HyperSidebar)).collapsed,
      isTrue,
    );
  });
}
