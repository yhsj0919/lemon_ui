import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  testWidgets('breadcrumb defaults to slash and supports chevron override', (
    tester,
  ) async {
    for (final separator in [null, HyperBreadcrumbSeparator.chevron]) {
      await tester.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: HyperThemeData.light(),
            child: Scaffold(
              body: HyperBreadcrumb(
                items: const [
                  HyperBreadcrumbItem(path: 'Home'),
                  HyperBreadcrumbItem(path: 'Settings'),
                ],
                style: HyperBreadcrumbStyle(separator: separator),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('/'), separator == null ? findsOneWidget : findsNothing);
      expect(
        find.byIcon(HyperIcons.chevronRight),
        separator == null ? findsNothing : findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    }
  });
}
