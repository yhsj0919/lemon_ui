import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui/src/components/charts/hyper_pie_leader_labels.dart';

void main() {
  testWidgets(
    'pie leader stroke inherits divider thickness rather than line-chart width',
    (tester) async {
      final theme = HyperThemeData.light();
      await tester.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: theme,
            child: const Scaffold(
              body: HyperPieChart(
                sections: [
                  HyperPieSection(label: '甲', value: 60),
                  HyperPieSection(label: '乙', value: 40),
                ],
                showLeaderLabels: true,
                style: HyperChartStyle(lineWidth: 8),
              ),
            ),
          ),
        ),
      );
      final labels = tester.widget<HyperPieLeaderLabels>(
        find.byType(HyperPieLeaderLabels),
      );
      final context = tester.element(find.byType(HyperPieLeaderLabels));
      expect(labels.strokeWidth, HyperTheme.sizesOf(context).divider.thickness);
      expect(labels.strokeWidth, isNot(8));
    },
  );
  testWidgets('wide leader lines remain near the pie with a thin stroke', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 280));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final key = GlobalKey();
    await tester.pumpWidget(
      MaterialApp(
        home: RepaintBoundary(
          key: key,
          child: const ColoredBox(
            color: Colors.white,
            child: HyperPieLeaderLabels(
              sections: [
                HyperPieSection(label: 'Desktop', value: 50),
                HyperPieSection(label: 'Mobile', value: 50),
              ],
              hidden: {},
              total: 100,
              radius: 60,
              style: TextStyle(color: Colors.black, fontSize: 12),
              strokeWidth: 1,
              gap: 12,
              scaler: TextScaler.noScaling,
              direction: TextDirection.ltr,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final boundary =
        key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await tester.runAsync(() => boundary.toImage(pixelRatio: 1));
    final bytes = await tester.runAsync(
      () => image!.toByteData(format: ui.ImageByteFormat.rawRgba),
    );
    final pixels = bytes!.buffer.asUint8List();
    bool dark(int x, int y) {
      final i = (y * 1200 + x) * 4;
      return pixels[i] < 200 && pixels[i + 1] < 200 && pixels[i + 2] < 200;
    }

    var distant = 0, stroke = 0;
    for (var y = 0; y < 280; y++) {
      for (var x = 0; x < 150; x++) {
        if (dark(x, y) || dark(1199 - x, y)) distant++;
      }
      if (dark(678, y)) stroke++;
    }
    expect(distant, 0, reason: '宽屏两端不应再出现贯穿容器的引导线或标签');
    expect(stroke, inInclusiveRange(1, 2), reason: '1 逻辑像素细线只覆盖一至两个抗锯齿像素');
    if (Platform.environment['HYPER_CAPTURE_LEADERS'] == '1') {
      final png = await tester.runAsync(
        () => image!.toByteData(format: ui.ImageByteFormat.png),
      );
      await tester.runAsync(() async {
        final file = File('build/test_artifacts/pie-leaders-wide.png');
        await file.parent.create(recursive: true);
        await file.writeAsBytes(png!.buffer.asUint8List());
      });
    }
    image!.dispose();
  });
}
