import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  test('高级玻璃只在 advanced 且未减少透明度时保留模糊', () {
    const fallback = HyperSurfaceMaterial.solid(
      background: HyperFill.color(Colors.white),
    );
    const glass = HyperSurfaceMaterial.frostedGlass(
      blurSigmaX: 18,
      blurSigmaY: 22,
      fallback: fallback,
    );

    expect(glass.resolve(quality: HyperMaterialQuality.advanced), same(glass));
    expect(glass.resolve(quality: HyperMaterialQuality.standard), fallback);
    expect(
      glass.resolve(
        quality: HyperMaterialQuality.advanced,
        reduceTransparency: true,
      ),
      fallback,
    );
  });

  test('同种材质能够插值且不同种材质离散切换', () {
    const start = HyperSurfaceMaterial.frostedGlass(blurSigmaX: 10);
    const end = HyperSurfaceMaterial.frostedGlass(blurSigmaX: 30);
    expect(HyperSurfaceMaterial.lerp(start, end, .5).blurSigmaX, 20);
    const solid = HyperSurfaceMaterial.solid();
    expect(HyperSurfaceMaterial.lerp(solid, end, .25), solid);
    expect(HyperSurfaceMaterial.lerp(solid, end, .75), end);
  });

  testWidgets('普通质量不创建背景滤镜，高级质量才创建', (tester) async {
    const glass = HyperSurfaceMaterial.frostedGlass(
      background: HyperFill.color(Color(0x66FFFFFF)),
    );

    Future<void> pump(HyperMaterialQuality quality) => tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light().copyWith(
            materialTheme: HyperMaterialThemeData(quality: quality),
          ),
          duration: Duration.zero,
          child: const Align(
            child: HyperMaterialSurface(
              material: glass,
              width: 120,
              height: 80,
              child: Text('材质'),
            ),
          ),
        ),
      ),
    );

    await pump(HyperMaterialQuality.standard);
    expect(find.byType(BackdropFilter), findsNothing);
    expect(find.byType(ClipRRect), findsNothing);
    expect(
      tester.getSize(find.byType(HyperMaterialSurface)),
      const Size(120, 80),
    );

    await pump(HyperMaterialQuality.advanced);
    expect(find.byType(BackdropFilter), findsOneWidget);
    expect(find.byType(ClipRRect), findsOneWidget);
    expect(
      tester.getSize(find.byType(HyperMaterialSurface)),
      const Size(120, 80),
    );
  });

  testWidgets('嵌套局部材质主题逐字段继承', (tester) async {
    late HyperMaterialThemeData resolved;
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light().copyWith(
            materialTheme: const HyperMaterialThemeData(
              quality: HyperMaterialQuality.standard,
              reduceTransparency: false,
            ),
          ),
          duration: Duration.zero,
          child: HyperMaterialTheme(
            data: const HyperMaterialThemeData(
              quality: HyperMaterialQuality.advanced,
            ),
            child: HyperMaterialTheme(
              data: const HyperMaterialThemeData(reduceTransparency: true),
              child: Builder(
                builder: (context) {
                  resolved = HyperMaterialTheme.of(context);
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      ),
    );
    expect(resolved.quality, HyperMaterialQuality.advanced);
    expect(resolved.reduceTransparency, isTrue);
  });
}
