import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/pages/feedback/hyper_progress_indicator_page.dart';

void main() {
  testWidgets('进度 Demo 可以修改进度并切换减少动画', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          duration: Duration.zero,
          child: const HyperProgressIndicatorPage(),
        ),
      ),
    );

    expect(find.text('35%'), findsOneWidget);
    await tester.tap(find.text('增加'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('55%'), findsOneWidget);
    await tester.tap(find.byType(HyperSwitch));
    await tester.pump();
    expect(
      tester
          .widget<MediaQuery>(find.byType(MediaQuery).last)
          .data
          .disableAnimations,
      isTrue,
    );
    await tester.scrollUntilVisible(find.text('普通圆环'), 250);
    expect(find.text('普通圆环'), findsOneWidget);
    expect(find.text('按钮加载态'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(HyperButton).last,
        matching: find.byType(CircularProgressIndicator),
      ),
      findsOneWidget,
    );
  });
}
