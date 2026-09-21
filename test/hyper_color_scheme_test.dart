import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  group('HyperColorScheme', () {
    test('默认提供亮色和暗色方案', () {
      final light = HyperColorScheme.light();
      final dark = HyperColorScheme.dark();

      expect(light.brightness, Brightness.light);
      expect(dark.brightness, Brightness.dark);
      expect(light.background, isNot(dark.background));
      expect(light.onBackground, isNot(dark.onBackground));
      expect(light.background, const Color(0xFFF7F7F8));
      expect(light.surfaceElevated, Colors.white);
      expect(light.surfaceMuted, const Color(0xFFF1F1F3));
      expect(light.scrim.a, greaterThan(0));
      expect(light.stateLayer, Colors.black);
      expect(dark.stateLayer, Colors.white);
    });

    test('能够从种子色生成方案', () {
      const seed = Color(0xFF3367D6);
      final scheme = HyperColorScheme.fromSeed(seedColor: seed);
      expect(scheme.primary, seed);
      expect(scheme.onPrimary, Colors.white);
      expect(scheme.brightness, Brightness.light);
    });

    test('copyWith 只替换显式字段', () {
      final original = HyperColorScheme.light();
      final changed = original.copyWith(primary: Colors.purple);

      expect(changed.primary, Colors.purple);
      expect(changed.surface, original.surface);
      expect(changed.textSecondary, original.textSecondary);
      expect(changed.warning, original.warning);
    });

    test('能够在两套颜色方案之间插值', () {
      final start = HyperColorScheme.light(seedColor: Colors.orange);
      final end = HyperColorScheme.dark(seedColor: Colors.blue);
      final result = HyperColorScheme.lerp(start, end, 0.5);

      expect(result.brightness, Brightness.dark);
      expect(result.primary, Color.lerp(start.primary, end.primary, 0.5));
      expect(result.surface, Color.lerp(start.surface, end.surface, 0.5));
      expect(
        result.surfaceElevated,
        Color.lerp(start.surfaceElevated, end.surfaceElevated, 0.5),
      );
    });

    test('能够映射为 Material ColorScheme', () {
      final hyper = HyperColorScheme.dark(seedColor: Colors.teal);
      final material = hyper.toMaterialColorScheme();

      expect(material.brightness, hyper.brightness);
      expect(material.primary, hyper.primary);
      expect(material.surface, hyper.background);
      expect(material.surfaceContainerHigh, hyper.surfaceElevated);
      expect(material.scrim, hyper.scrim);
      expect(material.error, hyper.error);
    });

    test('支持值相等比较', () {
      expect(HyperColorScheme.light(), HyperColorScheme.light());
      expect(
        HyperColorScheme.dark(seedColor: Colors.blue),
        HyperColorScheme.dark(seedColor: Colors.blue),
      );
    });
  });
}
