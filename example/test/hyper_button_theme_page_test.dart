import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/pages/button/hyper_button_theme_page.dart';

void main() {
  testWidgets('展示六种按钮变体并可启用局部主题', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          duration: Duration.zero,
          child: const HyperButtonThemePage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    for (final name in [
      'filled',
      'tonal',
      'outlined',
      'ghost',
      'text',
      'gradient',
    ]) {
      expect(find.byKey(ValueKey('button-style-$name')), findsOneWidget);
    }
    await tester.tap(find.byType(HyperSwitch));
    await tester.pumpAndSettle();
    expect(find.text('局部 outlined：紫色'), findsOneWidget);
    final outlined = tester.widget<Container>(
      find.byKey(const ValueKey('button-style-outlined')),
    );
    final decoration = outlined.decoration! as BoxDecoration;
    expect(decoration.border!.top.color, Colors.purple);
    expect(decoration.border!.top.width, 2);
  });
}
