import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  const recipe = HyperSurfaceMaterial.softLightGlass(
    background: HyperFill.color(Color(0x99ffffff)),
    tint: Color(0x11ffffff),
    blurSigmaX: 18,
    fallback: HyperSurfaceMaterial.solid(
      background: HyperFill.color(Colors.white),
    ),
  );
  const theme = HyperMaterialThemeData(
    material: recipe,
    quality: HyperMaterialQuality.advanced,
  );
  test('语义染色保留透明度、模糊与降级颜色', () {
    final resolved = theme.resolveMaterial(
      semanticBackground: const HyperFill.color(Colors.red),
    )!;
    expect(resolved.background!.color!.r, Colors.red.r);
    expect(resolved.background!.color!.g, Colors.red.g);
    expect(resolved.background!.color!.a, closeTo(.6, .001));
    expect(resolved.blurSigmaX, 18);
    expect(resolved.tint!.r, Colors.red.r);
    expect(resolved.tint!.g, Colors.red.g);
    final ordinary = theme.resolveMaterial(
      semanticBackground: const HyperFill.color(Colors.red),
      reduceTransparency: true,
    )!;
    expect(ordinary.usesBackdrop, false);
    expect(ordinary.background!.color, Colors.red.withValues(alpha: 1));
    expect(
      theme.resolveMaterial(semanticBackground: const HyperFill.none()),
      isNull,
    );
    expect(theme.resolveMaterial(material: recipe), recipe);
  });
  test('渐变染色和动画恢复保持一致', () {
    const gradient = HyperFill.gradient(
      LinearGradient(colors: [Colors.red, Colors.blue]),
    );
    final result = theme.resolveMaterial(semanticBackground: gradient)!;
    expect(result.background!.gradient!.colors.first.a, closeTo(.6, .001));
    final middle = theme
        .copyWith(transitionProgress: .5)
        .resolveMaterial(
          semanticBackground: const HyperFill.color(Colors.red),
        )!;
    expect(middle.background!.color!.g, Colors.red.g);
    expect(middle.blurSigmaX, closeTo(9, .001));
  });
}
