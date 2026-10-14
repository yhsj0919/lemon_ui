import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  test('缓冲样式复制、合并、插值和值相等', () {
    const style = HyperProgressStyle(
      bufferColor: Colors.red,
      bufferGradient: LinearGradient(colors: [Colors.red, Colors.blue]),
    );
    expect(style.copyWith().bufferColor, Colors.red);
    expect(style.copyWith(), style);
    expect(style.copyWith().hashCode, style.hashCode);
    expect(
      style
          .merge(const HyperProgressStyle(bufferColor: Colors.green))
          .bufferGradient,
      isNull,
    );
    expect(
      HyperProgressStyle.lerp(
        style,
        const HyperProgressStyle(bufferColor: Colors.blue),
        .5,
      ).bufferColor,
      Color.lerp(Colors.red, Colors.blue, .5),
    );
  });
  testWidgets('主进度、缓冲和轨道按顺序绘制，RTL 与越界值正确', (tester) async {
    for (final direction in TextDirection.values) {
      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: direction,
            child: Center(
              child: RepaintBoundary(
                key: const Key('frame'),
                child: const HyperProgress.linear(
                  value: .25,
                  bufferValue: .7,
                  color: Colors.blue,
                  bufferColor: Colors.red,
                  trackColor: Colors.green,
                  size: 200,
                  thickness: 10,
                  radius: 0,
                  fillRadius: 0,
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
      final bytes = await tester.runAsync(() async {
        final image = await boundary.toImage();
        final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
        image.dispose();
        return data;
      });
      int pixel(int position, int channel) {
        final x = direction == TextDirection.ltr ? position : 199 - position;
        return bytes!.getUint8((5 * 200 + x) * 4 + channel);
      }

      expect(pixel(20, 2), closeTo((Colors.blue.b * 255).round(), 1));
      expect(pixel(80, 0), closeTo((Colors.red.r * 255).round(), 1));
      expect(pixel(180, 1), (Colors.green.g * 255).round());
      expect(tester.takeException(), isNull);
    }
    await tester.pumpWidget(
      const MaterialApp(
        home: Center(
          child: HyperLinearProgress(length: 200, value: .5, bufferValue: -1),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(
      const MaterialApp(
        home: Center(
          child: HyperLinearProgress(
            length: 200,
            value: .5,
            bufferValue: 2,
            bufferGradient: LinearGradient(colors: [Colors.red, Colors.blue]),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
  testWidgets('缓冲动画连续且减少动画可立即完成', (tester) async {
    Widget app(double buffer, bool reduced) => MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(disableAnimations: reduced),
        child: Center(
          child: HyperLinearProgress(
            length: 200,
            value: .2,
            bufferValue: buffer,
            animationDuration: const Duration(milliseconds: 200),
          ),
        ),
      ),
    );
    await tester.pumpWidget(app(.4, false));
    await tester.pumpAndSettle();
    await tester.pumpWidget(app(.8, false));
    await tester.pump(const Duration(milliseconds: 100));
    final dynamic painter = tester
        .widget<CustomPaint>(
          find.descendant(
            of: find.byType(HyperLinearProgress),
            matching: find.byType(CustomPaint),
          ),
        )
        .painter;
    expect(painter.bufferValue, greaterThan(.4));
    expect(painter.bufferValue, lessThan(.8));
    await tester.pumpWidget(app(1, true));
    await tester.pumpAndSettle();
    final dynamic done = tester
        .widget<CustomPaint>(
          find.descendant(
            of: find.byType(HyperLinearProgress),
            matching: find.byType(CustomPaint),
          ),
        )
        .painter;
    expect(done.bufferValue, 1);
  });
}
