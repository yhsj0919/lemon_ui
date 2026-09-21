import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
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

    final rendered = find.descendant(
      of: find.byKey(const Key('target')),
      matching: find.byType(Container),
    );
    expect(tester.getSize(rendered), const Size(180, 100));
    final container = tester.widget<Container>(rendered);
    final decoration = container.decoration! as BoxDecoration;
    expect(decoration.color, Colors.blue);
    expect(decoration.borderRadius, BorderRadius.circular(24));
    expect(container.padding, const EdgeInsets.all(10));
  });

  testWidgets('容器主题逐项回退到全局基础主题', (tester) async {
    final base = HyperThemeData.light();
    final theme = base.copyWith(
      sizes: base.sizes.copyWith(
        controlRadius: 30,
        controlPadding: const EdgeInsets.all(14),
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

    final container = tester.widget<Container>(
      find.descendant(
        of: find.byKey(const Key('target')),
        matching: find.byType(Container),
      ),
    );
    final decoration = container.decoration! as BoxDecoration;
    expect(decoration.color, Colors.green);
    expect(decoration.borderRadius, BorderRadius.circular(30));
    expect(container.padding, const EdgeInsets.all(14));
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

    final animated = tester.widgetList<AnimatedContainer>(
      find.byType(AnimatedContainer),
    );
    final first = animated.first.decoration! as BoxDecoration;
    final second = animated.last.decoration! as BoxDecoration;
    expect(first.gradient, gradient);
    expect(first.color, isNull);
    expect(second.color, isNull);
    expect(second.gradient, isNull);
    expect(second.boxShadow, isEmpty);
  });
}
