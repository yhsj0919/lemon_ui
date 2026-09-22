import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui_example/pages/foundation/hyper_theme_page.dart';

void main() {
  testWidgets('总主题演示可见并能切换亮暗模式', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HyperThemePage()));
    await tester.pumpAndSettle();

    expect(find.text('全局默认值'), findsOneWidget);
    expect(find.text('局部显式覆盖'), findsOneWidget);
    expect(tester.getSize(find.byKey(const Key('global-control'))).height, 52);
    expect(tester.getSize(find.byKey(const Key('local-control'))).height, 68);

    await tester.tap(find.text('暗色'));
    await tester.pumpAndSettle();
    final background = tester.widget<Material>(
      find.byKey(const Key('theme-background')),
    );
    expect(background.color!.computeLuminance(), lessThan(.2));
  });
}
