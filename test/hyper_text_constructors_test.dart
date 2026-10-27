import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  test('every text variant has a matching const named constructor', () {
    const samples = [
      HyperText.displayLarge('x'),
      HyperText.displayMedium('x'),
      HyperText.displaySmall('x'),
      HyperText.pageTitle('x'),
      HyperText.sectionTitle('x'),
      HyperText.subsectionTitle('x'),
      HyperText.bodyLarge('x'),
      HyperText.body('x'),
      HyperText.bodySmall('x'),
      HyperText.control('x'),
      HyperText.label('x'),
      HyperText.caption('x'),
    ];
    expect(samples.map((text) => text.variant), HyperTextVariant.values);
    expect(samples.every((text) => text.data == 'x'), isTrue);
  });
  testWidgets(
    'short constructors match existing type scale and preserve Text options',
    (tester) async {
      final theme = HyperThemeData.light();
      await tester.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: theme,
            child: const Column(
              children: [
                HyperText.body('body', maxLines: 2, textAlign: TextAlign.right),
                HyperText.caption('caption'),
                HyperText.title('title'),
              ],
            ),
          ),
        ),
      );
      expect(
        tester.widget<Text>(find.text('caption')).style!.fontSize,
        theme.textTheme.labelSmall!.fontSize,
      );
      expect(
        tester.widget<Text>(find.text('title')).style!.fontSize,
        theme.textTheme.headlineMedium!.fontSize,
      );
      final body = tester.widget<Text>(find.text('body'));
      expect(body.maxLines, 2);
      expect(body.textAlign, TextAlign.right);
    },
  );

  for (final dark in [false, true]) {
    testWidgets(
      'muted color follows theme and explicit overrides, dark=$dark',
      (tester) async {
        final theme = dark ? HyperThemeData.dark() : HyperThemeData.light();
        await tester.pumpWidget(
          MaterialApp(
            home: HyperTheme(
              data: theme,
              child: const Column(
                children: [
                  HyperText.muted('default'),
                  HyperText.muted(
                    'instance',
                    style: TextStyle(color: Colors.red),
                  ),
                  HyperTextTheme(
                    data: HyperTextThemeData(
                      body: TextStyle(color: Colors.green),
                    ),
                    child: HyperText.muted('local'),
                  ),
                ],
              ),
            ),
          ),
        );
        expect(
          tester.widget<Text>(find.text('default')).style!.color,
          theme.colors.textSecondary,
        );
        expect(
          tester.widget<Text>(find.text('instance')).style!.color,
          Colors.red,
        );
        expect(
          tester.widget<Text>(find.text('local')).style!.color,
          Colors.green,
        );
      },
    );
  }
}
