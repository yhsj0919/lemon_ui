import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  for (final alpha in [0.0, .5, 1.0]) {
    testWidgets(
      'icon button respects overlay alpha $alpha on hover and press',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: HyperTheme(
              data: HyperThemeData.light(),
              child: Scaffold(
                body: Center(
                  child: HyperIconButton.ghost(
                    icon: const Icon(HyperIcons.plus),
                    onPressed: () {},
                    style: HyperIconButtonStyle(
                      overlayColor: Colors.red.withValues(alpha: alpha),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        final button = find.byType(HyperIconButton);
        final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
        await mouse.addPointer(location: Offset.zero);
        addTearDown(mouse.removePointer);
        double paintedAlpha() {
          final containers = tester.widgetList<Container>(
            find.descendant(of: button, matching: find.byType(Container)),
          );
          final colors = containers
              .map((c) => c.foregroundDecoration)
              .whereType<BoxDecoration>()
              .map((d) => d.color?.a ?? 0);
          return colors.fold(0, (a, b) => a > b ? a : b);
        }

        await mouse.moveTo(tester.getCenter(button));
        await tester.pumpAndSettle();
        expect(paintedAlpha(), closeTo(alpha * .07, .005));
        await mouse.down(tester.getCenter(button));
        await tester.pumpAndSettle();
        expect(paintedAlpha(), closeTo(alpha * .12, .005));
        await mouse.up();
        await tester.pumpAndSettle();
      },
    );
  }

  testWidgets('vertical number stepper restores mouse hover feedback', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: Scaffold(body: HyperNumberInput(value: 1, onChanged: (_) {})),
        ),
      ),
    );
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    addTearDown(mouse.removePointer);
    for (final icon in [HyperIcons.chevronUp, HyperIcons.chevronDown]) {
      final button = find.ancestor(
        of: find.byIcon(icon),
        matching: find.byType(HyperIconButton),
      );
      await mouse.moveTo(tester.getCenter(button));
      await tester.pumpAndSettle();
      final decorations = tester
          .widgetList<Container>(
            find.descendant(of: button, matching: find.byType(Container)),
          )
          .map((c) => c.foregroundDecoration)
          .whereType<BoxDecoration>();
      expect(decorations.any((d) => (d.color?.a ?? 0) > 0), isTrue);
    }
    expect(tester.takeException(), isNull);
  });
}
