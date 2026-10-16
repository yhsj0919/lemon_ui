import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

class _BackgroundPainter extends CustomPainter {
  int paints = 0;
  @override
  void paint(Canvas canvas, Size size) {
    paints++;
  }

  @override
  bool shouldRepaint(_BackgroundPainter oldDelegate) => false;
}

void main() {
  testWidgets('多块默认骨架动画只重绘自身，不逐帧重建组件或重绘背景', (tester) async {
    final background = _BackgroundPainter();
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: CustomPaint(
            painter: background,
            child: Column(
              children: [
                for (var i = 0; i < 20; i++)
                  HyperSkeleton.text(
                    effect: i.isEven
                        ? HyperSkeletonEffect.shimmer
                        : HyperSkeletonEffect.pulse,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 32));
    final initial = background.paints;
    final boundary = tester.renderObject<RenderRepaintBoundary>(
      find
          .descendant(
            of: find.byType(HyperSkeleton).first,
            matching: find.byType(RepaintBoundary),
          )
          .first,
    );
    final skeletonPaints =
        boundary.debugAsymmetricPaintCount + boundary.debugSymmetricPaintCount;
    var rebuilds = 0;
    final previous = debugOnRebuildDirtyWidget;
    debugOnRebuildDirtyWidget = (element, builtOnce) {
      previous?.call(element, builtOnce);
      rebuilds++;
    };
    try {
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }
    } finally {
      debugOnRebuildDirtyWidget = previous;
    }
    expect(background.paints, initial);
    expect(
      boundary.debugAsymmetricPaintCount + boundary.debugSymmetricPaintCount,
      greaterThan(skeletonPaints),
    );
    expect(rebuilds, 0);
    expect(
      find.descendant(
        of: find.byType(HyperSkeleton),
        matching: find.byType(Opacity),
      ),
      findsNothing,
    );
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('减少动画和 TickerMode 停止循环，自定义效果及内容切换保留', (tester) async {
    var customFrames = 0;
    Widget app({bool reduce = false, bool tick = true, bool loading = true}) =>
        MaterialApp(
          home: HyperTheme(
            data: HyperThemeData.light(),
            duration: Duration.zero,
            child: MediaQuery(
              data: MediaQueryData(disableAnimations: reduce),
              child: TickerMode(
                enabled: tick,
                child: HyperSkeleton.text(
                  loading: loading,
                  style: HyperSkeletonStyle(
                    effectBuilder: (context, child, progress) {
                      customFrames++;
                      return child;
                    },
                  ),
                  child: const Text('加载完成'),
                ),
              ),
            ),
          ),
        );
    await tester.pumpWidget(app());
    final before = customFrames;
    await tester.pump(const Duration(milliseconds: 80));
    expect(customFrames, greaterThan(before));
    await tester.pumpWidget(app(tick: false));
    final paused = customFrames;
    await tester.pump(const Duration(milliseconds: 100));
    expect(customFrames, paused);
    await tester.pumpWidget(app(reduce: true));
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.binding.transientCallbackCount, 0);
    await tester.pumpWidget(app(reduce: true, loading: false));
    await tester.pump();
    expect(find.text('加载完成'), findsOneWidget);
    expect(tester.binding.transientCallbackCount, 0);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('只设置边框宽度也绘制语义描边，默认无边框，零宽度关闭', (tester) async {
    for (final width in [null, 4.0, 0.0]) {
      final theme = HyperThemeData.light();
      await tester.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: theme,
            child: Center(
              child: HyperSkeleton(
                width: 100,
                height: 40,
                effect: HyperSkeletonEffect.none,
                style: HyperSkeletonStyle(borderWidth: width),
              ),
            ),
          ),
        ),
      );
      final decorations = tester.widgetList<DecoratedBox>(
        find.descendant(
          of: find.byType(HyperSkeleton),
          matching: find.byType(DecoratedBox),
        ),
      );
      final borders = decorations
          .map((d) => (d.decoration as BoxDecoration).border)
          .whereType<Border>()
          .toList();
      if (width == 4) {
        expect(borders, hasLength(1));
        expect(borders.single.top.width, 4);
        expect(borders.single.top.color, theme.colors.outline);
      } else {
        expect(borders, isEmpty);
      }
    }
  });
}
