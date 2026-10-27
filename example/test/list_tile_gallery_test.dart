import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/pages/content/hyper_list_tile_page.dart';
import 'package:lemon_ui_example/gallery/demo_section.dart';

void main() {
  testWidgets('list tile demo uses list groups without nested cards', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: const Scaffold(body: HyperListTilePage()),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(DemoSection), findsNothing);
    expect(find.byType(HyperListGroup), findsWidgets);
    for (final group in find.byType(HyperListGroup).evaluate()) {
      expect(
        find.descendant(
          of: find.byWidget(group.widget),
          matching: find.byType(HyperCard),
        ),
        findsOneWidget,
      );
    }
    expect(tester.takeException(), isNull);
  });
}
