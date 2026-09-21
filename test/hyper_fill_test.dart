import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  group('HyperFill', () {
    test('能够区分无填充、纯色和渐变', () {
      const none = HyperFill.none();
      const color = HyperFill.color(Colors.red);
      const gradient = HyperFill.gradient(
        LinearGradient(colors: [Colors.red, Colors.blue]),
      );

      expect(none.isNone, isTrue);
      expect(none.color, isNull);
      expect(none.gradient, isNull);
      expect(color.color, Colors.red);
      expect(color.gradient, isNull);
      expect(gradient.color, isNull);
      expect(gradient.gradient, isA<LinearGradient>());
    });

    test('支持值相等比较', () {
      expect(
        const HyperFill.color(Colors.red),
        const HyperFill.color(Colors.red),
      );
      expect(
        const HyperFill.gradient(
          LinearGradient(colors: [Colors.red, Colors.blue]),
        ),
        const HyperFill.gradient(
          LinearGradient(colors: [Colors.red, Colors.blue]),
        ),
      );
      expect(const HyperFill.none(), const HyperFill.none());
    });

    test('能够在纯色之间插值', () {
      const start = HyperFill.color(Colors.black);
      const end = HyperFill.color(Colors.white);

      final result = HyperFill.lerp(start, end, 0.5);

      expect(result.color, Color.lerp(Colors.black, Colors.white, 0.5));
    });

    test('能够在兼容渐变之间插值', () {
      const start = HyperFill.gradient(
        LinearGradient(colors: [Colors.black, Colors.red]),
      );
      const end = HyperFill.gradient(
        LinearGradient(colors: [Colors.white, Colors.blue]),
      );

      final result = HyperFill.lerp(start, end, 0.5);

      expect(result.gradient, isA<LinearGradient>());
      final gradient = result.gradient! as LinearGradient;
      expect(
        gradient.colors.first,
        Color.lerp(Colors.black, Colors.white, 0.5),
      );
      expect(gradient.colors.last, Color.lerp(Colors.red, Colors.blue, 0.5));
    });

    test('不兼容填充类型在中点切换', () {
      const color = HyperFill.color(Colors.red);
      const gradient = HyperFill.gradient(
        LinearGradient(colors: [Colors.red, Colors.blue]),
      );

      expect(HyperFill.lerp(color, gradient, 0.49), same(color));
      expect(HyperFill.lerp(color, gradient, 0.5), same(gradient));
    });
  });
}
