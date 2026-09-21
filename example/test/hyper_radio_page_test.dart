import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/pages/selection/hyper_radio_page.dart';

void main() {
  testWidgets('展示并切换单选项', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          duration: Duration.zero,
          child: const HyperRadioPage(),
        ),
      ),
    );
    await tester.tap(find.text('高级'));
    await tester.pump();
    final radios = tester.widgetList<HyperRadio<String>>(
      find.byType(HyperRadio<String>),
    );
    expect(radios.elementAt(1).groupValue, '高级');
    expect(find.byType(HyperRadio<String>), findsAtLeastNWidgets(7));
    expect(find.text('普通圆形变体'), findsOneWidget);
    expect(find.text('带背景变体'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('实例样式覆盖'),
      200,
      scrollable: find.byType(Scrollable),
    );
    expect(find.text('实例样式覆盖'), findsOneWidget);
  });
}
