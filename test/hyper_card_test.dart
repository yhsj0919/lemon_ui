import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  Finder cardLayer({bool background = false}) {
    final layers = find.descendant(
      of: find.byType(HyperCard),
      matching: find.byType(AnimatedContainer),
    );
    return background ? layers.first : layers.last;
  }

  Widget app(Widget child, {HyperThemeData? theme}) => MaterialApp(
    home: HyperTheme(
      data:
          theme ??
          HyperThemeData.light(
            sizes: const HyperSizeThemeData(tablet: HyperSizeScheme.phone()),
          ),
      duration: Duration.zero,
      child: Center(child: SizedBox(width: 240, child: child)),
    ),
  );

  testWidgets('手机默认 Card 使用主题的 16 圆角和内容内边距', (tester) async {
    await tester.pumpWidget(
      app(const HyperCard(child: SizedBox(width: 80, height: 40))),
    );

    final card = tester.widget<AnimatedContainer>(cardLayer());
    final decoration =
        tester
                .widget<AnimatedContainer>(cardLayer(background: true))
                .decoration!
            as BoxDecoration;
    expect(card.padding, const EdgeInsets.all(16));
    expect(decoration.borderRadius, BorderRadius.circular(16));
    expect(tester.getSize(find.byType(HyperCard)), const Size(240, 72));
  });

  testWidgets('Card 主题与 Container 主题隔离并支持实例覆盖', (tester) async {
    final base = HyperThemeData.light(
      sizes: const HyperSizeThemeData(tablet: HyperSizeScheme.phone()),
    );
    final theme = base.copyWith(
      containerTheme: HyperContainerThemeData(
        background: HyperFill.color(Colors.red),
      ),
      cardTheme: HyperCardThemeData(
        style: HyperCardStyle(
          background: HyperFill.color(Colors.blue),
          padding: const EdgeInsets.all(12),
        ),
      ),
    );
    await tester.pumpWidget(
      app(
        HyperCard(
          style: HyperCardStyle(background: HyperFill.color(Colors.green)),
          child: const Text('Card'),
        ),
        theme: theme,
      ),
    );

    final card = tester.widget<AnimatedContainer>(cardLayer());
    final decoration =
        tester
                .widget<AnimatedContainer>(cardLayer(background: true))
                .decoration!
            as BoxDecoration;
    expect(decoration.color, Colors.green);
    expect(card.padding, const EdgeInsets.all(12));
  });

  testWidgets('交互 Card 点击整张卡片', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      app(HyperCard(onTap: () => taps++, child: const Text('打开'))),
    );

    await tester.tap(find.byType(HyperCard));
    expect(taps, 1);
  });

  testWidgets('Card 材质遵守质量等级和透明度降级', (tester) async {
    const glass = HyperSurfaceMaterial.frostedGlass(
      background: HyperFill.color(Color(0x66FFFFFF)),
      blurSigmaX: 18,
      blurSigmaY: 18,
      fallback: HyperSurfaceMaterial.solid(
        background: HyperFill.color(Colors.red),
      ),
    );

    Future<void> pump(HyperMaterialQuality quality) => tester.pumpWidget(
      app(
        const HyperCard(child: Text('Glass')),
        theme:
            HyperThemeData.light(
              sizes: const HyperSizeThemeData(tablet: HyperSizeScheme.phone()),
            ).copyWith(
              materialTheme: HyperMaterialThemeData(quality: quality),
              cardTheme: HyperCardThemeData(
                style: HyperCardStyle(material: glass),
              ),
            ),
      ),
    );

    await pump(HyperMaterialQuality.standard);
    expect(
      tester.widget<BackdropFilter>(find.byType(BackdropFilter)).enabled,
      isFalse,
    );
    expect(
      (tester.widget<AnimatedContainer>(cardLayer(background: true)).decoration!
              as BoxDecoration)
          .color,
      Colors.red,
    );

    await pump(HyperMaterialQuality.advanced);
    expect(
      tester.widget<BackdropFilter>(find.byType(BackdropFilter)).enabled,
      isTrue,
    );
    expect(
      find.ancestor(
        of: find.text('Glass'),
        matching: find.byType(BackdropFilter),
      ),
      findsNothing,
    );
  });

  testWidgets('Card 继承材质不透明度并保留语义底色，实例覆盖优先', (tester) async {
    final base = HyperThemeData.light(
      sizes: const HyperSizeThemeData(tablet: HyperSizeScheme.phone()),
    );
    final theme = base.copyWith(
      materialTheme: const HyperMaterialThemeData(
        material: HyperSurfaceMaterial.solid(
          background: HyperFill.color(Color(0x80FF0000)),
        ),
      ),
    );

    Color? fill() =>
        (tester
                    .widget<AnimatedContainer>(cardLayer(background: true))
                    .decoration!
                as BoxDecoration)
            .color;

    await tester.pumpWidget(
      app(const HyperCard(child: Text('Card')), theme: theme),
    );
    expect(fill(), base.colors.surface.withAlpha(128));

    await tester.pumpWidget(
      app(
        const HyperMaterialTheme(
          data: HyperMaterialThemeData(
            material: HyperSurfaceMaterial.solid(
              background: HyperFill.color(Color(0x400000FF)),
            ),
          ),
          child: HyperCard(child: Text('Card')),
        ),
        theme: theme,
      ),
    );
    expect(fill(), base.colors.surface.withAlpha(64));

    await tester.pumpWidget(
      app(
        HyperCard(
          style: HyperCardStyle(background: HyperFill.color(Colors.green)),
          child: const Text('Card'),
        ),
        theme: theme,
      ),
    );
    expect(fill(), Colors.green);
    await tester.pumpWidget(
      app(
        HyperCard(
          style: HyperCardStyle(
            material: const HyperSurfaceMaterial.solid(
              background: HyperFill.color(Colors.blue),
            ),
          ),
          child: const Text('Card'),
        ),
        theme: theme,
      ),
    );
    expect(fill(), Colors.blue);
  });

  test('四端 Card 尺寸独立且可以 copyWith', () {
    const sizes = HyperSizeThemeData();
    expect(sizes.phone.card.radius, 16);
    expect(sizes.tablet.card.radius, 20);
    expect(sizes.desktop.card.radius, 8);
    expect(sizes.watch.card.radius, 20);

    final changed = sizes.copyWith(
      desktop: sizes.desktop.copyWith(
        card: sizes.desktop.card.copyWith(
          radius: 14,
          padding: const EdgeInsets.all(8),
        ),
      ),
    );
    expect(changed.desktop.card.radius, 14);
    expect(changed.desktop.card.padding, const EdgeInsets.all(8));
    expect(changed.phone.card, sizes.phone.card);
  });
}
