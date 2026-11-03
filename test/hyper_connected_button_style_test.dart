import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  const radius = BorderRadius.all(Radius.circular(999));
  const shadows = [BoxShadow(color: Colors.red, blurRadius: 4)];

  BoxDecoration surface(WidgetTester tester, Finder button) =>
      tester
              .widget<AnimatedContainer>(
                find
                    .descendant(
                      of: button,
                      matching: find.byWidgetPredicate(
                        (w) =>
                            w is AnimatedContainer &&
                            w.decoration is BoxDecoration,
                      ),
                    )
                    .first,
              )
              .decoration!
          as BoxDecoration;

  for (final source in ['default', 'global', 'local', 'instance', 'selected']) {
    testWidgets('connected button respects explicit surface from $source', (
      tester,
    ) async {
      final override = HyperButtonStyle(
        borderRadius: radius,
        boxShadow: shadows,
      );
      final theme = HyperThemeData.light().copyWith(
        buttonTheme: source == 'global'
            ? HyperButtonThemeData(ghost: override)
            : const HyperButtonThemeData(),
      );
      Widget child = source == 'selected'
          ? HyperSegmentedButton<int>(
              segments: const [
                HyperSegment(value: 1, label: '一'),
                HyperSegment(value: 2, label: '二'),
              ],
              selected: const {1},
              onSelectionChanged: (_) {},
              style: HyperSegmentedButtonStyle(selectedButton: override),
            )
          : HyperWidgetGroup(
              connected: true,
              children: [
                HyperWidgetGroupItem(
                  child: HyperButton.ghost(
                    onPressed: () {},
                    style: source == 'instance' ? override : null,
                    child: const Text('按钮'),
                  ),
                ),
              ],
            );
      if (source == 'local') {
        child = HyperButtonTheme(
          data: HyperButtonThemeData(ghost: override),
          child: child,
        );
      }
      await tester.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: theme,
            child: Scaffold(body: Center(child: child)),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final button = find.byType(HyperButton).first;
      final expected = source == 'default' ? BorderRadius.zero : radius;
      expect(surface(tester, button).borderRadius, expected);
      expect(
        surface(tester, button).boxShadow,
        source == 'default' ? isEmpty : shadows,
      );
      if (source == 'selected') {
        expect(
          surface(tester, find.byType(HyperButton).last).borderRadius,
          BorderRadius.zero,
        );
      }
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer(location: Offset.zero);
      await mouse.moveTo(tester.getCenter(button));
      await tester.pumpAndSettle();
      expect(surface(tester, button).borderRadius, expected);
      void expectOverlayRadius() {
        final container = tester.widget<AnimatedContainer>(
          find
              .descendant(
                of: button,
                matching: find.byWidgetPredicate(
                  (w) =>
                      w is AnimatedContainer && w.decoration is BoxDecoration,
                ),
              )
              .first,
        );
        expect(
          (container.foregroundDecoration! as BoxDecoration).borderRadius,
          expected,
        );
      }

      expectOverlayRadius();
      final press = await tester.startGesture(tester.getCenter(button));
      await tester.pumpAndSettle();
      expect(surface(tester, button).borderRadius, expected);
      expectOverlayRadius();
      await press.up();
      await mouse.removePointer();
    });
  }
}
