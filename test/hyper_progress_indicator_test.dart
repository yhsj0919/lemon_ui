import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  Widget app(
    Widget child, {
    HyperThemeData? theme,
    bool disableAnimations = true,
  }) => MaterialApp(
    home: MediaQuery(
      data: MediaQueryData(disableAnimations: disableAnimations),
      child: HyperTheme(
        data: theme ?? HyperThemeData.light(),
        duration: Duration.zero,
        child: Center(child: child),
      ),
    ),
  );

  testWidgets('统一入口转发到对应基础控件', (tester) async {
    await tester.pumpWidget(
      app(
        const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            HyperProgressIndicator.linear(value: .4),
            HyperProgressIndicator.circular(value: .6),
            HyperProgressIndicator.infinite(),
          ],
        ),
      ),
    );

    expect(find.byType(HyperLinearProgressIndicator), findsOneWidget);
    expect(find.byType(HyperCircularProgressIndicator), findsOneWidget);
    expect(find.byType(HyperInfiniteProgressIndicator), findsOneWidget);
  });

  testWidgets('无限进度使用 MIUIX 默认规格并支持实例覆盖', (tester) async {
    await tester.pumpWidget(
      app(
        const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            HyperInfiniteProgressIndicator(),
            HyperInfiniteProgressIndicator(
              color: Colors.orange,
              size: 40,
              thickness: 3,
              orbitingDotSize: 4,
            ),
          ],
        ),
      ),
    );

    final indicators = find.byType(HyperInfiniteProgressIndicator);
    expect(tester.getSize(indicators.at(0)), const Size.square(20));
    expect(tester.getSize(indicators.at(1)), const Size.square(40));
    expect(
      find.descendant(of: indicators, matching: find.byType(CustomPaint)),
      findsNWidgets(2),
    );
  });

  testWidgets('无限进度遵守正常动画和减少动画设置', (tester) async {
    await tester.pumpWidget(
      app(const HyperInfiniteProgressIndicator(), disableAnimations: false),
    );
    final animated = tester.widget<RotationTransition>(
      find.byType(RotationTransition),
    );
    final before = animated.turns.value;
    await tester.pump(const Duration(milliseconds: 100));
    expect(animated.turns.value, isNot(before));

    await tester.pumpWidget(app(const HyperInfiniteProgressIndicator()));
    final reduced = tester.widget<RotationTransition>(
      find.byType(RotationTransition),
    );
    expect(reduced.turns.value, 0);
    await tester.pump(const Duration(milliseconds: 100));
    expect(reduced.turns.value, 0);
  });

  testWidgets('进度值限制在零到一之间', (tester) async {
    await tester.pumpWidget(
      app(
        const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            HyperLinearProgressIndicator(value: 2),
            HyperCircularProgressIndicator(value: -1),
          ],
        ),
      ),
    );

    expect(
      tester
          .widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator))
          .value,
      1,
    );
    expect(
      tester
          .widget<CircularProgressIndicator>(
            find.byType(CircularProgressIndicator),
          )
          .value,
      0,
    );
  });

  testWidgets('实例样式优先于局部和全局主题', (tester) async {
    final theme = HyperThemeData.light().copyWith(
      progressIndicatorTheme: const HyperProgressIndicatorThemeData(
        style: HyperProgressIndicatorStyle(color: Colors.red),
      ),
    );
    await tester.pumpWidget(
      app(
        const HyperProgressIndicatorTheme(
          data: HyperProgressIndicatorThemeData(
            style: HyperProgressIndicatorStyle(color: Colors.green),
          ),
          child: HyperCircularProgressIndicator(
            value: .5,
            color: Colors.blue,
            size: 40,
            thickness: 4,
          ),
        ),
        theme: theme,
      ),
    );

    final indicator = tester.widget<CircularProgressIndicator>(
      find.byType(CircularProgressIndicator),
    );
    expect(indicator.color, Colors.blue);
    expect(indicator.strokeWidth, 4);
    expect(
      tester.getSize(find.byType(HyperCircularProgressIndicator)),
      const Size.square(40),
    );
  });

  testWidgets('三种进度指示器使用明确的设备规格', (tester) async {
    for (final entry in <(HyperSizeScheme, double, double, double, double)>[
      (const HyperSizeScheme.phone(), 6, 30, 4, 20),
      (const HyperSizeScheme.tablet(), 6, 30, 4, 20),
      (const HyperSizeScheme.desktop(), 4, 24, 3, 16),
      (const HyperSizeScheme.watch(), 6, 24, 3, 20),
    ]) {
      await tester.pumpWidget(
        app(
          const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              HyperLinearProgressIndicator(value: .5),
              HyperCircularProgressIndicator(value: .5),
              HyperInfiniteProgressIndicator(),
            ],
          ),
          theme: HyperThemeData.light(
            sizes: HyperSizeThemeData(
              phone: entry.$1,
              tablet: entry.$1,
              desktop: entry.$1,
              watch: entry.$1,
            ),
          ),
        ),
      );
      expect(
        tester.getSize(find.byType(HyperLinearProgressIndicator)).height,
        entry.$2,
      );
      expect(
        tester.getSize(find.byType(HyperCircularProgressIndicator)),
        Size.square(entry.$3),
      );
      expect(
        tester
            .widget<CircularProgressIndicator>(
              find.byType(CircularProgressIndicator),
            )
            .strokeWidth,
        entry.$4,
      );
      expect(
        tester.getSize(find.byType(HyperInfiniteProgressIndicator)),
        Size.square(entry.$5),
      );
    }
  });

  testWidgets('线性进度尺寸颜色可覆盖且默认圆角跟随厚度', (tester) async {
    await tester.pumpWidget(
      app(
        const HyperLinearProgressIndicator(
          value: .5,
          length: 180,
          thickness: 10,
          color: Colors.orange,
          trackColor: Colors.black12,
        ),
      ),
    );

    final indicator = tester.widget<LinearProgressIndicator>(
      find.byType(LinearProgressIndicator),
    );
    expect(
      tester.getSize(find.byType(HyperLinearProgressIndicator)),
      const Size(180, 10),
    );
    expect(indicator.color, Colors.orange);
    expect(indicator.backgroundColor, Colors.black12);
    expect(indicator.minHeight, 10);
    expect(indicator.borderRadius, BorderRadius.circular(5));
  });

  testWidgets('减少动画时不确定进度降级为静态状态', (tester) async {
    await tester.pumpWidget(
      app(
        const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            HyperLinearProgressIndicator(),
            HyperCircularProgressIndicator(),
          ],
        ),
      ),
    );

    expect(
      tester
          .widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator))
          .value,
      .35,
    );
    expect(
      tester
          .widget<CircularProgressIndicator>(
            find.byType(CircularProgressIndicator),
          )
          .value,
      .75,
    );
  });
}
