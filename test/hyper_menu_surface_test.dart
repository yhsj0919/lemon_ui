import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui/src/components/menu/hyper_menu_surface.dart';
import 'package:lemon_ui/src/components/overlay/hyper_overlay_material.dart';

void main() {
  final colors = HyperThemeData.light().colors;
  test('Card 无阴影材质保留浮层阴影，主题与实例阴影覆盖优先', () {
    const customShadow = [BoxShadow(blurRadius: 7)];
    for (final material in [
      const HyperSurfaceMaterial.solid(),
      const HyperSurfaceMaterial.translucent(),
      const HyperSurfaceMaterial.frostedGlass(),
      const HyperSurfaceMaterial.softLightGlass(),
    ]) {
      HyperCardStyle surface({
        List<BoxShadow>? shadows,
        HyperCardStyle? style,
      }) => resolveHyperMenuSurfaceStyle(
        colors: colors,
        radius: 12,
        padding: EdgeInsets.zero,
        cardThemeStyle: HyperCardStyle(material: material, boxShadow: shadows),
        style: style,
      );
      expect(surface().boxShadow, isNotEmpty);
      // Null lets HyperCard inherit the theme's explicit shadow list.
      expect(surface(shadows: const []).boxShadow, isNull);
      expect(surface(shadows: customShadow).boxShadow, isNull);
      expect(
        surface(style: HyperCardStyle(boxShadow: const [])).boxShadow,
        isEmpty,
      );
      expect(
        surface(style: HyperCardStyle(boxShadow: customShadow)).boxShadow,
        customShadow,
      );
    }
  });
  test('阴影依据最终材质解析，保留配方阴影及实例材质优先级', () {
    final surface = resolveHyperMenuSurfaceStyle(
      colors: colors,
      radius: 12,
      padding: EdgeInsets.zero,
      cardThemeStyle: HyperCardStyle(
        material: const HyperSurfaceMaterial.clearFrostedGlass(),
      ),
    );
    expect(surface.boxShadow, isNull);
    final overridden = resolveHyperMenuSurfaceStyle(
      colors: colors,
      radius: 12,
      padding: EdgeInsets.zero,
      globalMaterial: const HyperSurfaceMaterial.clearFrostedGlass(),
      cardThemeStyle: HyperCardStyle(
        material: const HyperSurfaceMaterial.clearFrostedGlass(),
      ),
      style: HyperCardStyle(material: const HyperSurfaceMaterial.solid()),
    );
    expect(overridden.boxShadow, isNotEmpty);
  });
  test('切换无阴影的全局材质保留浮层阴影，显式关闭仍优先', () {
    for (final material in [
      const HyperSurfaceMaterial.solid(),
      const HyperSurfaceMaterial.translucent(),
      const HyperSurfaceMaterial.frostedGlass(),
      const HyperSurfaceMaterial.softLightGlass(),
    ]) {
      final surface = resolveHyperMenuSurfaceStyle(
        colors: colors,
        radius: 12,
        padding: EdgeInsets.zero,
        globalMaterial: material,
      );
      expect(surface.boxShadow, isNotEmpty);
      final disabled = resolveHyperMenuSurfaceStyle(
        colors: colors,
        radius: 12,
        padding: EdgeInsets.zero,
        globalMaterial: material,
        style: HyperCardStyle(boxShadow: const []),
      );
      expect(disabled.boxShadow, isEmpty);
    }
  });
  test('Menu 与 Select 共用玻璃配方及阴影，统一质量降级仍保留阴影', () {
    final material = HyperOverlayMaterial.fallbackFor(colors: colors)!;
    for (final padding in [EdgeInsets.zero, const EdgeInsets.all(8)]) {
      final surface = resolveHyperMenuSurfaceStyle(
        colors: colors,
        radius: 12,
        padding: padding,
        fallbackMaterial: material,
      );
      expect(surface.material, same(material));
      expect(surface.padding, padding);
      expect(surface.borderRadius, BorderRadius.circular(12));
      for (final quality in HyperMaterialQuality.values) {
        final resolved = surface.material!.resolve(quality: quality);
        expect(resolved.boxShadow, isNotEmpty);
        if (quality == HyperMaterialQuality.advanced) {
          expect(resolved.border, isNull);
          expect(resolved.resolveEdgeGradient(defaultEnabled: true), isNotNull);
        } else {
          expect(resolved.border, isNotNull);
        }
        expect(
          resolved.kind,
          quality == HyperMaterialQuality.advanced
              ? HyperSurfaceMaterialKind.softLightGlass
              : HyperSurfaceMaterialKind.solid,
        );
      }
      expect(
        surface.material!
            .resolve(
              quality: HyperMaterialQuality.advanced,
              reduceTransparency: true,
            )
            .boxShadow,
        isNotEmpty,
      );
    }
  });
  test('显式背景保持纯色表面的边框和默认阴影', () {
    expect(
      HyperOverlayMaterial.fallbackFor(
        colors: colors,
        hasExplicitBackground: true,
      ),
      isNull,
    );
    final surface = resolveHyperMenuSurfaceStyle(
      colors: colors,
      radius: 12,
      padding: EdgeInsets.zero,
      style: HyperCardStyle(background: const HyperFill.color(Colors.white)),
    );
    expect(surface.material, isNull);
    expect(surface.border, isNotNull);
    expect(surface.boxShadow, isNotEmpty);
  });
  test('全局与局部配方优先，实例可以明确关闭阴影', () {
    const custom = HyperSurfaceMaterial.solid(
      background: HyperFill.color(Colors.blue),
    );
    expect(
      HyperOverlayMaterial.fallbackFor(colors: colors, globalMaterial: custom),
      isNull,
    );
    expect(
      HyperOverlayMaterial.fallbackFor(
        colors: colors,
        instanceMaterial: custom,
      ),
      isNull,
    );
    final surface = resolveHyperMenuSurfaceStyle(
      colors: colors,
      radius: 12,
      padding: EdgeInsets.zero,
      style: HyperCardStyle(material: custom, boxShadow: const []),
    );
    expect(surface.material, custom);
    expect(surface.boxShadow, isEmpty);
  });
}
