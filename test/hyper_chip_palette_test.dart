import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  test('配色端点、覆盖与值插值', () {
    final theme = HyperThemeData.light();
    final colors = theme.colors;
    final contrast = theme.contrastTheme;
    const style = HyperChipStyle(
      colorVariant: HyperChipColorVariant.soft,
      baseColor: Colors.red,
      backgroundFade: 1,
      borderFade: 0,
      foregroundFade: 0,
    );
    final palette = style.resolvePalette(colors, contrast);
    expect(palette.background!.color, colors.surface);
    expect(palette.borderColor, Colors.red);
    expect(palette.foregroundColor, Colors.red);
    final override = style.copyWith(
      background: const HyperFill.none(),
      foregroundColor: Colors.green,
      boxBorder: const Border(),
    );
    expect(
      override.resolvePalette(colors, contrast).background!.isNone,
      isTrue,
    );
    expect(
      override.resolvePalette(colors, contrast).foregroundColor,
      Colors.green,
    );
    expect(override.resolvePalette(colors, contrast).boxBorder, const Border());
    final end = style.copyWith(backgroundFade: 0, borderFade: 1);
    final middle = HyperChipStyle.lerp(style, end, .5);
    expect(middle.backgroundFade, .5);
    expect(middle.borderFade, .5);
    expect(style, isNot(end));
    expect(style.copyWith(), style);
    expect(style.copyWith().hashCode, style.hashCode);
    final white = const HyperChipStyle(
      colorVariant: HyperChipColorVariant.filled,
      foregroundMode: HyperChipForegroundMode.white,
    ).resolvePalette(colors, contrast);
    expect(white.foregroundColor, Colors.white);
    final automatic = const HyperChipStyle(
      colorVariant: HyperChipColorVariant.filled,
      baseColor: Colors.yellow,
    ).resolvePalette(colors, contrast);
    expect(
      automatic.foregroundColor!.toARGB32(),
      contrast.darkForeground.toARGB32(),
    );
  });

  testWidgets('配色实际绘制、状态继承及文字缩放', (tester) async {
    for (final scale in [1.0, 1.3, 2.0]) {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(scale)),
            child: HyperChipTheme(
              data: const HyperChipThemeData(
                style: HyperChipStyle(
                  colorVariant: HyperChipColorVariant.soft,
                  baseColor: Colors.red,
                  backgroundFade: .8,
                ),
                selected: HyperChipStyle(
                  colorVariant: HyperChipColorVariant.outlined,
                ),
              ),
              child: Center(
                child: SizedBox(
                  width: 140,
                  child: HyperChip.choice(
                    label: '配色标签',
                    selected: true,
                    onSelected: (_) {},
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final container = tester
          .widgetList<AnimatedContainer>(
            find.descendant(
              of: find.byType(HyperChip),
              matching: find.byType(AnimatedContainer),
            ),
          )
          .first;
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, isNull);
      expect(decoration.border!.top.color, Colors.red);
      expect(decoration.border!.top.width, 1);
      expect(tester.takeException(), isNull);
    }
  });
}
