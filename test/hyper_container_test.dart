import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  Finder surface(String key) => find.descendant(
    of: find.byKey(Key(key)),
    matching: find.byType(HyperMaterialSurface),
  );
  BoxDecoration background(WidgetTester tester, String key) {
    final filter = find.descendant(
      of: surface(key),
      matching: find.byType(BackdropFilter),
    );
    return tester
            .widget<DecoratedBox>(
              find
                  .descendant(of: filter, matching: find.byType(DecoratedBox))
                  .first,
            )
            .decoration
        as BoxDecoration;
  }

  testWidgets('实例属性覆盖容器主题且显式尺寸保持精确', (tester) async {
    final theme = HyperThemeData.light().copyWith(
      containerTheme: HyperContainerThemeData(
        background: const HyperFill.color(Colors.red),
        borderRadius: BorderRadius.circular(12),
        padding: const EdgeInsets.all(10),
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: theme,
          duration: Duration.zero,
          child: const Center(
            child: HyperContainer(
              key: Key('target'),
              width: 180,
              height: 100,
              animationDuration: Duration.zero,
              background: HyperFill.color(Colors.blue),
              borderRadius: BorderRadius.all(Radius.circular(24)),
            ),
          ),
        ),
      ),
    );

    expect(
      tester.getSize(find.byKey(const Key('target'))),
      const Size(180, 100),
    );
    final container = tester.widget<HyperMaterialSurface>(surface('target'));
    final decoration = background(tester, 'target');
    expect(decoration.color, Colors.blue);
    expect(decoration.borderRadius, BorderRadius.circular(24));
    expect(container.padding, const EdgeInsets.all(10));
  });

  testWidgets('容器未覆盖项保持中性，不继承基础控件留白与圆角', (tester) async {
    final base = HyperThemeData.light();
    final theme = base.copyWith(
      sizes: base.sizes.copyWith(
        tablet: base.sizes.tablet.copyWith(
          controlRadius: 30,
          controlPadding: const EdgeInsets.all(14),
        ),
      ),
      containerTheme: HyperContainerThemeData(
        background: const HyperFill.color(Colors.green),
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: theme,
          duration: Duration.zero,
          child: const HyperContainer(
            key: Key('target'),
            animationDuration: Duration.zero,
          ),
        ),
      ),
    );

    final container = tester.widget<HyperMaterialSurface>(surface('target'));
    final decoration = background(tester, 'target');
    expect(decoration.color, Colors.green);
    expect(decoration.borderRadius, BorderRadius.zero);
    expect(container.padding, EdgeInsets.zero);
  });

  testWidgets('渐变、显式无背景和空阴影保持独立语义', (tester) async {
    const gradient = LinearGradient(colors: [Colors.red, Colors.blue]);
    await tester.pumpWidget(
      MaterialApp(
        home: Column(
          children: const [
            HyperContainer(
              key: Key('gradient'),
              background: HyperFill.gradient(gradient),
            ),
            HyperContainer(
              key: Key('none'),
              background: HyperFill.none(),
              boxShadow: [],
            ),
          ],
        ),
      ),
    );

    final first = background(tester, 'gradient');
    final second = background(tester, 'none');
    expect(first.gradient, gradient);
    expect(first.color, isNull);
    expect(second.color, isNull);
    expect(second.gradient, isNull);
    expect(
      tester.widget<HyperMaterialSurface>(surface('none')).boxShadow,
      isEmpty,
    );
  });

  testWidgets('容器默认不裁切且可显式开启裁切', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Column(
          children: [
            HyperContainer(
              key: Key('clipped'),
              clipBehavior: Clip.antiAlias,
              animationDuration: Duration.zero,
              child: ColoredBox(color: Colors.red),
            ),
            HyperContainer(
              key: Key('overflow'),
              animationDuration: Duration.zero,
              clipBehavior: Clip.none,
              child: ColoredBox(color: Colors.blue),
            ),
          ],
        ),
      ),
    );

    final clipped = tester.widget<HyperMaterialSurface>(
      find.descendant(
        of: find.byKey(const Key('clipped')),
        matching: find.byType(HyperMaterialSurface),
      ),
    );
    final overflow = tester.widget<HyperMaterialSurface>(
      find.descendant(
        of: find.byKey(const Key('overflow')),
        matching: find.byType(HyperMaterialSurface),
      ),
    );
    expect(clipped.clipBehavior, Clip.antiAlias);
    expect(overflow.clipBehavior, Clip.none);
    for (final (key, expected) in [
      ('clipped', Clip.antiAlias),
      ('overflow', Clip.none),
    ]) {
      expect(
        tester
            .widget<ClipRRect>(
              find.descendant(
                of: surface(key),
                matching: find.byType(ClipRRect),
              ),
            )
            .clipBehavior,
        expected,
      );
    }
  });
}
