import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  const gradient = LinearGradient(colors: [Colors.red, Colors.blue]);
  test('渐变参与样式复制、主题插值和显式纯色覆盖', () {
    const style = HyperProgressStyle(gradient: gradient);
    expect(style.copyWith(size: 100).gradient, gradient);
    expect(style.copyWith(), style);
    expect(style.copyWith().hashCode, style.hashCode);
    expect(
      style.merge(const HyperProgressStyle(color: Colors.green)).gradient,
      isNull,
    );
    expect(
      HyperProgressStyle.lerp(
        style,
        style.copyWith(
          gradient: const LinearGradient(colors: [Colors.green, Colors.blue]),
        ),
        .5,
      ).gradient,
      isA<LinearGradient>(),
    );
  });
  testWidgets('渐变填充使用完整轨道坐标，轨道底色保留，RTL 正常', (tester) async {
    for (final direction in TextDirection.values) {
      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: direction,
            child: Center(
              child: RepaintBoundary(
                key: const Key('frame'),
                child: const HyperProgress.linear(
                  value: .5,
                  size: 200,
                  thickness: 10,
                  radius: 0,
                  fillRadius: 0,
                  trackColor: Colors.green,
                  gradient: gradient,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final boundary = tester.renderObject<RenderRepaintBoundary>(
        find.byKey(const Key('frame')),
      );
      final data = await tester.runAsync(() async {
        final image = await boundary.toImage();
        final bytes = await image.toByteData(
          format: ui.ImageByteFormat.rawRgba,
        );
        image.dispose();
        return bytes;
      });
      int channel(int x, int c) => data!.getUint8((5 * 200 + x) * 4 + c);
      final filled = direction == TextDirection.ltr ? 25 : 175;
      final empty = direction == TextDirection.ltr ? 175 : 25;
      expect(channel(filled, 0) + channel(filled, 2), greaterThan(100));
      expect(channel(empty, 1), Colors.green.g * 255);
      expect(channel(empty, 0), Colors.green.r * 255);
      expect(tester.takeException(), isNull);
    }
  });
  testWidgets('不确定渐变与轨道分层，减少动画时保持渐变', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Center(
          child: HyperLinearProgress(length: 200, gradient: gradient),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byType(ShaderMask), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(disableAnimations: true),
          child: Center(
            child: HyperLinearProgress(length: 200, gradient: gradient),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(ShaderMask), findsNothing);
    expect(find.byType(CustomPaint), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
