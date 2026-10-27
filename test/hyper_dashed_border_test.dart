import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui/src/painting/hyper_pattern_segments.dart';

void main() {
  test('虚线与点线共用分段，尾段截断且零步长不会死循环', () {
    expect(hyperPatternSegments(extent: 17, dashLength: 6, gap: 4).toList(), [
      (start: 0.0, end: 6.0),
      (start: 10.0, end: 16.0),
    ]);
    expect(
      hyperPatternSegments(
        extent: 9,
        dashLength: 6,
        gap: 2,
        dotDiameter: 2,
      ).toList(),
      [(start: 0.0, end: 0.0), (start: 4.0, end: 4.0), (start: 8.0, end: 8.0)],
    );
    expect(hyperPatternSegments(extent: 10, dashLength: 0, gap: 0).length, 1);
  });
  test('虚线主题覆盖、插值和值相等', () {
    const border = HyperDashedBorder(
      side: BorderSide(color: Colors.red, width: 2),
      dashLength: 8,
      gapLength: 3,
    );
    final style = HyperButtonStyle(boxBorder: border);
    expect(style.merge(HyperButtonStyle()).boxBorder, border);
    expect(style.copyWith(boxBorder: null).boxBorder, isNull);
    expect(style, HyperButtonStyle(boxBorder: border));
    final midpoint =
        HyperButtonStyle.lerp(
              style,
              HyperButtonStyle(boxBorder: border.scale(2)),
              .5,
            ).boxBorder
            as HyperLineBorder;
    expect(midpoint.side.width, 3);
    expect(midpoint.line.dashLength, 8);
    expect(
      HyperTextFieldStyle(border: border)
          .copyWith(border: const Border())
          .border,
      const Border(),
    );
    expect(
      HyperCardStyle.lerp(
        HyperCardStyle(border: border),
        HyperCardStyle(border: border.scale(2)),
        .5,
      ).border,
      midpoint,
    );
  });
  testWidgets('按钮、卡片与输入框接受同一虚线边框，显式关闭优先', (tester) async {
    const border = HyperDashedBorder(
      side: BorderSide(color: Colors.red, width: 2),
    );
    for (final value in <BoxBorder>[border, const Border()]) {
      for (final quality in HyperMaterialQuality.values) {
        await tester.pumpWidget(
          MaterialApp(
            home: HyperTheme(
              data: HyperThemeData.light().copyWith(
                materialTheme: HyperMaterialThemeData(
                  quality: quality,
                  material: const HyperSurfaceMaterial.frostedGlass(
                    background: HyperFill.color(Color(0x80ffffff)),
                    border: BorderSide(color: Colors.blue, width: 3),
                  ),
                ),
              ),
              child: Scaffold(
                body: Column(
                  children: [
                    HyperButton.outlined(
                      style: HyperButtonStyle(boxBorder: value),
                      onPressed: () {},
                      child: const Text('按钮'),
                    ),
                    HyperCard(
                      style: HyperCardStyle(border: value),
                      child: const Text('卡片'),
                    ),
                    HyperTextField(style: HyperTextFieldStyle(border: value)),
                  ],
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        for (final type in [HyperButton, HyperCard, HyperTextField]) {
          final decorations = tester.widgetList<DecoratedBox>(
            find.descendant(
              of: find.byType(type),
              matching: find.byType(DecoratedBox),
            ),
          );
          expect(
            decorations.any(
              (w) =>
                  w.decoration is BoxDecoration &&
                  (w.decoration as BoxDecoration).border == value,
            ),
            isTrue,
          );
          expect(
            decorations
                .map((w) => w.decoration)
                .whereType<BoxDecoration>()
                .map((d) => d.border)
                .whereType<Border>()
                .any(
                  (b) =>
                      b.top.color == Colors.blue &&
                      b.top.style != BorderStyle.none,
                ),
            isFalse,
          );
        }
        expect(tester.takeException(), isNull);
      }
    }
  });
  testWidgets('无填充不会在材质降级时回退为实色背景', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light().copyWith(
            materialTheme: const HyperMaterialThemeData(
              material: HyperSurfaceMaterial.frostedGlass(
                background: HyperFill.color(Colors.white),
              ),
            ),
          ),
          child: const HyperMaterialSurface(
            semanticBackground: HyperFill.none(),
            child: Text('内容'),
          ),
        ),
      ),
    );
    expect(
      tester.widget<BackdropFilter>(find.byType(BackdropFilter)).enabled,
      isFalse,
    );
    final boxes = tester.widgetList<DecoratedBox>(
      find.descendant(
        of: find.byType(HyperMaterialSurface),
        matching: find.byType(DecoratedBox),
      ),
    );
    expect(
      boxes
          .map((w) => w.decoration)
          .whereType<BoxDecoration>()
          .any((d) => d.color != null || d.gradient != null),
      isFalse,
    );
  });
  testWidgets('虚线边框绘制保留间隙与圆角，零宽度不绘制', (tester) async {
    Future<List<int>> alphaRow(
      HyperDashedBorder border, {
      double radius = 0,
    }) async {
      final recorder = ui.PictureRecorder();
      border.paint(
        Canvas(recorder),
        const Rect.fromLTWH(0, 0, 60, 30),
        borderRadius: BorderRadius.circular(radius),
      );
      final picture = recorder.endRecording();
      final data = await tester.runAsync(() async {
        final image = await picture.toImage(60, 30);
        final bytes = await image.toByteData(
          format: ui.ImageByteFormat.rawRgba,
        );
        image.dispose();
        return bytes!;
      });
      picture.dispose();
      return List.generate(60, (x) => data!.getUint8(x * 4 + 3));
    }

    const border = HyperDashedBorder(
      side: BorderSide(color: Colors.red, width: 2),
      dashLength: 6,
      gapLength: 4,
    );
    final row = await alphaRow(border);
    expect(row, contains(255));
    expect(row.sublist(2, 58), contains(0));
    expect((await alphaRow(border, radius: 8)).first, 0);
    expect(
      await alphaRow(const HyperDashedBorder(side: BorderSide(width: 0))),
      everyElement(0),
    );
  });
}
