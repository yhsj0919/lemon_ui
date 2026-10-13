import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  test('标签与选择标签共享配色，覆盖与插值完整', () {
    final theme = HyperThemeData.light();
    for (final variant in HyperTagColorVariant.values) {
      final tag = HyperTagStyle(
        colorVariant: variant,
        backgroundFade: .7,
        borderFade: .4,
        foregroundFade: .1,
      ).resolvePalette(theme.colors, theme.contrastTheme);
      final chip = HyperChipStyle(
        colorVariant: variant,
        backgroundFade: .7,
        borderFade: .4,
        foregroundFade: .1,
      ).resolvePalette(theme.colors, theme.contrastTheme);
      expect(tag.background, chip.background);
      expect(tag.foregroundColor, chip.foregroundColor);
      expect(tag.borderColor, chip.borderColor);
    }
    const start = HyperTagStyle(
      backgroundFade: 0,
      background: HyperFill.color(Colors.red),
    );
    final end = start.copyWith(backgroundFade: 1, boxBorder: const Border());
    expect(HyperTagStyle.lerp(start, end, .5).backgroundFade, .5);
    expect(start.copyWith(), start);
    expect(start.copyWith().hashCode, start.hashCode);
    expect(
      start
          .merge(const HyperTagStyle(backgroundColor: Colors.green))
          .background!
          .color,
      Colors.green,
    );
  });
  testWidgets('标签渐变与虚线绘制，缩放和禁用覆盖', (tester) async {
    final border = const HyperLine(
      fill: HyperFill.color(Colors.red),
      thickness: 2,
      pattern: HyperLinePattern.dashed,
    ).toBorder();
    for (final scale in [1.0, 1.3, 2.0]) {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(scale)),
            child: Center(
              child: SizedBox(
                width: 100,
                child: HyperTagTheme(
                  data: HyperTagThemeData(
                    style: HyperTagStyle(
                      boxBorder: border,
                      background: const HyperFill.gradient(
                        LinearGradient(colors: [Colors.red, Colors.blue]),
                      ),
                    ),
                    disabled: const HyperTagStyle(foregroundColor: Colors.grey),
                  ),
                  child: const HyperTag(label: '多文字标签', enabled: false),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final container = tester.widget<AnimatedContainer>(
        find.descendant(
          of: find.byType(HyperTag),
          matching: find.byType(AnimatedContainer),
        ),
      );
      final d = container.decoration as BoxDecoration;
      expect(d.border, border);
      expect(d.gradient, isA<LinearGradient>());
      expect(tester.takeException(), isNull);
    }
  });
}
