import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  testWidgets(
    'material fallback and seeded themes interpolate complete text styles',
    (tester) async {
      late HyperThemeData fallback;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              fallback = HyperThemeData.fromMaterial(Theme.of(context));
              return const SizedBox();
            },
          ),
        ),
      );
      final seeded = HyperThemeData.fromSeed(seedColor: Colors.orange);
      final raw = ThemeData().textTheme;
      expect(seeded.textTheme.labelLarge!.height, raw.labelLarge!.height);
      expect(seeded.textTheme.displayLarge!.height, raw.displayLarge!.height);
      expect(
        seeded.textTheme.labelLarge!.textBaseline,
        TextBaseline.alphabetic,
      );
      for (final (from, to) in [
        (fallback, seeded),
        (seeded, fallback),
        (seeded, HyperThemeData.dark()),
      ]) {
        for (final progress in [0.0, .25, .5, .75, 1.0]) {
          final interpolated = from.lerp(to, progress);
          expect(
            interpolated.textTheme.displayLarge!.fontSize,
            closeTo(
              from.textTheme.displayLarge!.fontSize! * (1 - progress) +
                  to.textTheme.displayLarge!.fontSize! * progress,
              .001,
            ),
          );
          expect(interpolated.textTheme.displayLarge!.inherit, isFalse);
        }
      }
    },
  );
}
