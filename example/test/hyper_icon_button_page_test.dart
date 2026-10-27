import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/pages/button/hyper_icon_button_page.dart';

void main() {
  testWidgets('展示四种图标按钮并运行异步进度', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: HyperIconButtonPage())),
    );

    expect(find.text('图标按钮'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) => widget is HyperIconButton && widget.tooltip == '收藏',
      ),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (widget) => widget is HyperIconButton && widget.tooltip == '通知',
      ),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (widget) => widget is HyperIconButton && widget.tooltip == '分享',
      ),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (widget) => widget is HyperIconButton && widget.tooltip == '更多',
      ),
      findsOneWidget,
    );

    await tester.scrollUntilVisible(
      find.byKey(const Key('async-icon-button')),
      200,
    );
    await tester.tap(find.byKey(const Key('async-icon-button')));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('最近事件：异步执行中'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 700));
    await tester.pumpAndSettle();
    expect(find.text('最近事件：异步完成'), findsOneWidget);
  });
}
