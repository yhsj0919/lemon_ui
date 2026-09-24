import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/pages/container/hyper_card_page.dart';

void main() {
  testWidgets('HyperCard Demo 使用基础组合并支持整卡点击', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          duration: Duration.zero,
          child: const HyperCardPage(),
        ),
      ),
    );

    // ListView 按需构建；标题卡片在页面下方，由独立组件测试覆盖。
    expect(find.byType(HyperCard), findsNWidgets(4));
    expect(find.text('点击次数：0'), findsOneWidget);
    await tester.tap(find.text('点击次数：0'));
    await tester.pump();
    expect(find.text('点击次数：1'), findsOneWidget);
  });
}
