import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

Iterable<TextStyle?> slots(TextTheme text) => [
  text.displayLarge,
  text.displayMedium,
  text.displaySmall,
  text.headlineLarge,
  text.headlineMedium,
  text.headlineSmall,
  text.titleLarge,
  text.titleMedium,
  text.titleSmall,
  text.bodyLarge,
  text.bodyMedium,
  text.bodySmall,
  text.labelLarge,
  text.labelMedium,
  text.labelSmall,
];

void main() {
  void expectFont(TextTheme text, String family, List<String> fallback) {
    for (final style in slots(text)) {
      expect(style!.fontFamily, family);
      expect(style.fontFamilyFallback, fallback);
    }
  }

  test('all factories apply custom fonts to every type scale slot', () {
    for (final theme in [
      HyperThemeData.light(
        fontFamily: 'SourceHanSansSC',
        fontFamilyFallback: const ['Arial'],
      ),
      HyperThemeData.dark(
        fontFamily: 'SourceHanSansSC',
        fontFamilyFallback: const ['Arial'],
      ),
      HyperThemeData.fromSeed(
        seedColor: Colors.blue,
        fontFamily: 'SourceHanSansSC',
        fontFamilyFallback: const ['Arial'],
      ),
      HyperThemeData.fromMaterial(
        ThemeData(),
        fontFamily: 'SourceHanSansSC',
        fontFamilyFallback: const ['Arial'],
      ),
    ]) {
      expectFont(theme.textTheme, 'SourceHanSansSC', ['Arial']);
      expectFont(theme.toMaterialThemeData().textTheme, 'SourceHanSansSC', [
        'Arial',
      ]);
    }
  });

  test(
    'copyWith retains metrics and supports fallback-only and empty fallback',
    () {
      final original = HyperThemeData.light();
      final custom = original.copyWith(
        fontFamily: 'SourceHanSansSC',
        fontFamilyFallback: const ['Arial'],
      );
      expectFont(custom.textTheme, 'SourceHanSansSC', ['Arial']);
      final before = slots(original.textTheme).toList();
      final after = slots(custom.textTheme).toList();
      for (var i = 0; i < before.length; i++) {
        expect(after[i]!.fontSize, before[i]!.fontSize);
        expect(after[i]!.height, before[i]!.height);
        expect(after[i]!.fontWeight, before[i]!.fontWeight);
      }
      expectFont(
        custom.copyWith(fontFamilyFallback: const []).textTheme,
        'SourceHanSansSC',
        [],
      );
      expect(custom.copyWith().textTheme, custom.textTheme);
      final material = ThemeData(fontFamily: 'Brand');
      expect(
        HyperThemeData.fromMaterial(material).textTheme.bodyMedium!.fontFamily,
        'Brand',
      );
    },
  );

  testWidgets(
    'device typography and Material descendants retain custom family',
    (tester) async {
      for (final device in HyperDeviceType.values) {
        await tester.pumpWidget(
          MaterialApp(
            home: HyperDeviceDetector(
              deviceType: device,
              builder: (context, device, child) => HyperTheme(
                duration: Duration.zero,
                data: HyperThemeData.light(
                  fontFamily: 'SourceHanSansSC',
                  fontFamilyFallback: const ['Arial'],
                ),
                child: Builder(
                  builder: (context) {
                    expectFont(
                      HyperTheme.of(context).textTheme,
                      'SourceHanSansSC',
                      ['Arial'],
                    );
                    expectFont(Theme.of(context).textTheme, 'SourceHanSansSC', [
                      'Arial',
                    ]);
                    return const Text('品牌字体');
                  },
                ),
              ),
            ),
          ),
        );
      }
    },
  );
}
