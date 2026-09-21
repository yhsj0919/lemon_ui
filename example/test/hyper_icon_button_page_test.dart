import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui_example/pages/button/hyper_icon_button_page.dart';

void main() {
  testWidgets('展示四种图标按钮并运行异步进度', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: HyperIconButtonPage())),
    );

    expect(find.text('HyperIconButton'), findsOneWidget);
    expect(find.byTooltip('收藏'), findsOneWidget);
    expect(find.byTooltip('通知'), findsOneWidget);
    expect(find.byTooltip('分享'), findsOneWidget);
    expect(find.byTooltip('更多'), findsOneWidget);

    await tester.tap(find.byTooltip('异步刷新'));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('最近事件：异步执行中'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 700));
    await tester.pumpAndSettle();
    expect(find.text('最近事件：异步完成'), findsOneWidget);
  });
}
