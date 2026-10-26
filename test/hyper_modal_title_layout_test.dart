import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui/src/components/overlay/hyper_modal_content.dart';

void main() {
  for (final sheet in [false, true]) {
    testWidgets('modal title uses prominent theme typography sheet=$sheet', (
      tester,
    ) async {
      final theme = HyperThemeData.light();
      await tester.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: theme,
            duration: Duration.zero,
            child: Center(
              child: SizedBox(
                width: 280,
                child: sheet
                    ? const HyperBottomSheet(
                        title: HyperText('Heading'),
                        content: Text('Content'),
                      )
                    : const HyperDialog(
                        title: HyperText('Heading'),
                        content: Text('Content'),
                      ),
              ),
            ),
          ),
        ),
      );
      final text = tester.widget<Text>(find.text('Heading'));
      expect(text.style!.fontSize, theme.textTheme.bodyLarge!.fontSize);
      expect(text.style!.fontWeight, FontWeight.w500);
      expect(tester.takeException(), isNull);
    });
  }
  for (final direction in TextDirection.values) {
    for (final scale in [1.0, 1.3, 2.0]) {
      testWidgets('independent title actions $direction $scale', (
        tester,
      ) async {
        var taps = 0;
        Future<void> render(double actionHeight) => tester.pumpWidget(
          MaterialApp(
            home: Directionality(
              textDirection: direction,
              child: MediaQuery(
                data: MediaQueryData(textScaler: TextScaler.linear(scale)),
                child: Center(
                  child: SizedBox(
                    width: 240,
                    child: HyperModalContent(
                      title: const Text('Title', key: Key('title')),
                      closeButton: GestureDetector(
                        onTap: () => taps++,
                        behavior: HitTestBehavior.opaque,
                        child: SizedBox(
                          key: const Key('action'),
                          width: 48,
                          height: actionHeight,
                        ),
                      ),
                      content: const SizedBox(key: Key('body'), height: 100),
                      actions: const [],
                      scrollable: false,
                      padding: const EdgeInsets.all(24),
                      titleStyle: const TextStyle(fontSize: 16),
                      contentStyle: const TextStyle(fontSize: 16),
                      titleSpacing: 24,
                      actionSpacing: 8,
                      actionRunSpacing: 8,
                      actionsAlignment: WrapAlignment.end,
                      actionsDirection: Axis.horizontal,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        await render(16);
        final original = tester.getTopLeft(find.byKey(const Key('body'))).dy;
        await render(36);
        expect(tester.getTopLeft(find.byKey(const Key('body'))).dy, original);
        final action = tester.getRect(find.byKey(const Key('action')));
        await tester.tapAt(Offset(action.center.dx, action.bottom - 1));
        expect(taps, 1);
        expect(tester.takeException(), isNull);
      });
    }
  }
}
