import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/pages/selection/hyper_text_area_page.dart';

void main() {
  testWidgets('unconfirmed demo renders default, counter and Form examples', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: const Scaffold(body: HyperTextAreaPage()),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(HyperTextArea), findsNWidgets(3));
    expect(find.byType(HyperTextAreaFormField), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
