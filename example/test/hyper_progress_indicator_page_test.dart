import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/pages/feedback/hyper_progress_page.dart';

void main() {
  testWidgets('进度 Demo 可以修改进度并切换减少动画', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          duration: Duration.zero,
          child: const HyperProgressPage(),
        ),
      ),
    );

    expect(find.text('35%'), findsOneWidget);
    await tester.ensureVisible(find.text('增加'));
    await tester.pump();
    await tester.tap(find.text('增加'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('55%'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.byType(HyperSwitch),
      -300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pump();
    await tester.tap(find.byType(HyperSwitch));
    await tester.pump();
    expect(
      MediaQuery.of(tester.element(find.byType(HyperSwitch))).disableAnimations,
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
