import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  for (final dark in [false, true]) {
    testWidgets('semantic tags follow theme colors, dark=$dark', (
      tester,
    ) async {
      final theme = (dark ? HyperThemeData.dark() : HyperThemeData.light());
      final colors = theme.colors;
      final tags = <(HyperTag, Color)>[
        (const HyperTag.success(label: 'success'), colors.success),
        (const HyperTag.warning(label: 'warning'), colors.warning),
        (const HyperTag.error(label: 'error'), colors.error),
        (const HyperTag.destructive(label: 'destructive'), colors.error),
        (const HyperTag.info(label: 'info'), colors.primary),
        (const HyperTag.neutral(label: 'neutral'), colors.textSecondary),
      ];
      await tester.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: theme,
            child: Column(children: [for (final entry in tags) entry.$1]),
          ),
        ),
      );
      for (final entry in tags) {
        final text = find.text(entry.$1.label);
        expect(DefaultTextStyle.of(tester.element(text)).style.color, entry.$2);
      }
    });
  }

  testWidgets(
    'semantic palette preserves theme, instance and disabled precedence',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: HyperThemeData.light(),
            child: HyperTagTheme(
              data: const HyperTagThemeData(
                style: HyperTagStyle(
                  colorVariant: HyperTagColorVariant.outlined,
                ),
                disabled: HyperTagStyle(foregroundColor: Colors.grey),
              ),
              child: const Column(
                children: [
                  HyperTag.success(label: 'outline'),
                  HyperTag.success(
                    label: 'override',
                    style: HyperTagStyle(foregroundColor: Colors.purple),
                  ),
                  HyperTag.error(label: 'disabled', enabled: false),
                ],
              ),
            ),
          ),
        ),
      );
      expect(
        DefaultTextStyle.of(tester.element(find.text('override'))).style.color,
        Colors.purple,
      );
      expect(
        DefaultTextStyle.of(tester.element(find.text('disabled'))).style.color,
        Colors.grey,
      );
      final surface = tester.widget<AnimatedContainer>(
        find.descendant(
          of: find.byWidgetPredicate(
            (widget) => widget is HyperTag && widget.label == 'outline',
          ),
          matching: find.byType(AnimatedContainer),
        ),
      );
      expect((surface.decoration! as BoxDecoration).border, isNotNull);
    },
  );
}
