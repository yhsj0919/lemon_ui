import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  testWidgets('短内容居中且明确长度不扩展，长文字随缩放增高', (tester) async {
    for (final scale in [1.0, 1.3, 2.0]) {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(scale)),
            child: const Center(
              child: HyperDivider(
                length: 180,
                child: Text('短文字', key: Key('label')),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final line = tester.getRect(find.byType(HyperDivider));
      expect(line.width, 180);
      expect(
        tester.getCenter(find.byKey(const Key('label'))).dx,
        closeTo(line.center.dx, .01),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(scale)),
            child: const Center(
              child: HyperDivider(length: 100, child: Text('长文字需要换行并保持正常显示')),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.getSize(find.byType(HyperDivider)).width, 100);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('完整线条统一渐变方向，内容位置不改变配色，内容区域透明裁切', (tester) async {
    for (final position in [
      null,
      HyperDividerContentAlignment.center,
      HyperDividerContentAlignment.start,
      HyperDividerContentAlignment.end,
    ]) {
      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: RepaintBoundary(
              key: const Key('frame'),
              child: HyperDivider(
                length: 300,
                thickness: 10,
                gradient: const LinearGradient(
                  colors: [Colors.red, Colors.blue],
                ),
                style: HyperDividerStyle(contentAlignment: position),
                child: position == null
                    ? null
                    : const SizedBox(
                        key: Key('content'),
                        width: 40,
                        height: 20,
                      ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.descendant(
          of: find.byType(HyperDivider),
          matching: find.byType(CustomPaint),
        ),
        findsOneWidget,
      );
      final boundary = tester.renderObject<RenderRepaintBoundary>(
        find.byKey(const Key('frame')),
      );
      final pixels = await tester.runAsync(() async {
        final image = await boundary.toImage(pixelRatio: 1);
        final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
        final result = (data: data!, width: image.width, height: image.height);
        image.dispose();
        return result;
      });
      int at(int x, int channel) => pixels!.data.getUint8(
        ((pixels.height ~/ 2) * pixels.width + x) * 4 + channel,
      );
      expect(at(4, 0), greaterThan(at(295, 0)));
      if (position != null) {
        final offset =
            tester.getCenter(find.byKey(const Key('content'))) -
            tester.getTopLeft(find.byKey(const Key('frame')));
        if (position == HyperDividerContentAlignment.center) {
          expect(offset.dx, closeTo(150, .01));
        }
        expect(at(offset.dx.floor(), 3), 0);
      }
      expect(tester.takeException(), isNull);
    }
  });
}
