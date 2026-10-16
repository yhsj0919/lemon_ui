import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  testWidgets('缓冲层按LTR和RTL绘制在主进度之后、底轨之前', (tester) async {
    for (final direction in TextDirection.values) {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Directionality(
                textDirection: direction,
                child: RepaintBoundary(
                  key: const Key('track'),
                  child: SizedBox(
                    width: 300,
                    height: 80,
                    child: HyperSlider(
                      value: .25,
                      bufferValue: .75,
                      style: const HyperSliderStyle(
                        trackHeight: 20,
                        thumbRadius: 0,
                        overlayRadius: 0,
                        activeTrackColor: Colors.red,
                        bufferColor: Colors.blue,
                        inactiveTrackColor: Colors.grey,
                      ),
                      onChanged: (_) {},
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final boundary = tester.renderObject<RenderRepaintBoundary>(
        find.byKey(const Key('track')),
      );
      await tester.runAsync(() async {
        final image = await boundary.toImage();
        final data = (await image.toByteData(
          format: ui.ImageByteFormat.rawRgba,
        ))!;
        Color pixel(int x) {
          final i = (40 * image.width + x) * 4;
          return Color.fromARGB(
            data.getUint8(i + 3),
            data.getUint8(i),
            data.getUint8(i + 1),
            data.getUint8(i + 2),
          );
        }

        expect(
          pixel(direction == TextDirection.ltr ? 30 : 270).toARGB32(),
          Colors.red.toARGB32(),
        );
        expect(pixel(150).toARGB32(), Colors.blue.toARGB32());
        expect(
          pixel(direction == TextDirection.ltr ? 270 : 30).toARGB32(),
          Colors.grey.toARGB32(),
        );
        image.dispose();
      });
    }
  });
  testWidgets('缓冲范围钳制、空值及垂直转发不改变主值', (tester) async {
    for (final buffer in <double?>[null, -10, 200]) {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HyperVerticalSlider(
              value: 25,
              bufferValue: buffer,
              min: 0,
              max: 100,
              height: 300,
              onChanged: (_) {},
            ),
          ),
        ),
      );
      final slider = tester.widget<Slider>(find.byType(Slider));
      expect(slider.value, 25);
      expect(slider.secondaryTrackValue, buffer?.clamp(0, 100));
      expect(tester.takeException(), isNull);
    }
  });
  test('缓冲样式支持主题合并、插值及显式颜色替换渐变', () {
    const gradient = LinearGradient(colors: [Colors.red, Colors.blue]);
    const a = HyperSliderStyle(
      bufferColor: Colors.red,
      bufferGradient: gradient,
    );
    final b = a.merge(const HyperSliderStyle(bufferColor: Colors.green));
    expect(b.bufferGradient, isNull);
    expect(b.bufferColor, Colors.green);
    expect(HyperSliderStyle.lerp(a, b, 1), b);
    expect(a.merge(null), a);
  });
}
