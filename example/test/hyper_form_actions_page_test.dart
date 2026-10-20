import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/pages/form/hyper_form_actions_page.dart';

void main() {
  testWidgets('FormActions demo builds its form and actions', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: const Scaffold(body: HyperFormActionsPage()),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(HyperFormActions), findsOneWidget);
    expect(find.text('提交'), findsOneWidget);
    expect(find.text('重置'), findsOneWidget);
    expect(find.text('取消'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
