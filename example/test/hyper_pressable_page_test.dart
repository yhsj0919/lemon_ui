import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/pages/interaction/hyper_pressable_page.dart';

void main() {
  testWidgets('演示页可以显示单击和长按结果', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          duration: Duration.zero,
          child: const HyperPressablePage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('pressable-demo')));
    await tester.pump(kDoubleTapTimeout + const Duration(milliseconds: 1));
    expect(find.text('最近事件：单击'), findsOneWidget);

    await tester.longPress(find.byKey(const Key('pressable-demo')));
    await tester.pumpAndSettle();
    expect(find.text('最近事件：长按'), findsOneWidget);
    expect(find.byKey(const Key('pressable-state')), findsOneWidget);
  });
}
