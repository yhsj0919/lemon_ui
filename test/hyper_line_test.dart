import 'package:flutter/material.dart';

import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  testWidgets('透明渐变的分割线和边框保留各节点透明度', (tester) async {
    const gradientLine = HyperLine(
      fill: HyperFill.gradient(
        LinearGradient(colors: [Color(0x00ff0000), Color(0xff0000ff)]),
      ),
      thickness: 4,
    );
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: const Center(
            child: HyperDivider(line: gradientLine, length: 100),
          ),
        ),
      ),
    );
    final painter = tester
        .widget<CustomPaint>(
          find.descendant(
            of: find.byType(HyperDivider),
            matching: find.byType(CustomPaint),
          ),
        )
        .painter!;
    for (final border in [false, true]) {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      if (border) {
        gradientLine.toBorder().paint(
          canvas,
          const Rect.fromLTWH(0, 0, 100, 40),
        );
      } else {
        painter.paint(canvas, const Size(100, 4));
      }
      final picture = recorder.endRecording();
      final bytes = await tester.runAsync(() async {
        final image = await picture.toImage(100, 40);
        final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
        image.dispose();
        return data!;
      });
      picture.dispose();
      expect(bytes!.getUint8((100 + 90) * 4 + 3), greaterThan(200));
      expect(bytes.getUint8((100 + 2) * 4 + 3), lessThan(20));
    }
  });
  const line = HyperLine(
    fill: HyperFill.color(Colors.red),
    thickness: 2,
    pattern: HyperLinePattern.dashed,
    dashLength: 6,
    gap: 4,
  );
  test('线条样式可复制插值，分割线和边框共用同一值', () {
    final changed = line.copyWith(
      thickness: 4,
      gap: 8,
      fill: const HyperFill.color(Colors.blue),
    );
    final midpoint = HyperLine.lerp(line, changed, .5);
    expect(midpoint.thickness, 3);
    expect(midpoint.gap, 6);
    expect(midpoint.fill.color, Color.lerp(Colors.red, Colors.blue, .5));
    expect(line.toBorder(), HyperLineBorder(line: line));
    expect((line.toBorder() as HyperLineBorder).line, line);
    expect(const HyperLine.none().segments(100), isEmpty);
    expect(
      HyperDividerStyle(line: line),
      HyperDividerStyle(line: line.copyWith()),
    );
    expect(
      HyperDividerStyle(line: line).copyWith(thickness: 4).line!.thickness,
      4,
    );
    expect(
      HyperDividerStyle.lerp(
        HyperDividerStyle(line: line),
        HyperDividerStyle(line: changed),
        .5,
      ).line,
      midpoint,
    );
    expect(
      line.copyWith(pattern: HyperLinePattern.dotted).segments(15).toList(),
      [
        (start: 0.0, end: 0.0),
        (start: 6.0, end: 6.0),
        (start: 12.0, end: 12.0),
      ],
    );
  });
  testWidgets('全局线条继承，局部旧属性和实例属性覆盖，空线条关闭', (tester) async {
    Widget build(Widget child) => MaterialApp(
      home: HyperTheme(
        data: HyperThemeData.light().copyWith(
          dividerTheme: const HyperDividerThemeData(
            style: HyperDividerStyle(line: line),
          ),
        ),
        child: Center(child: child),
      ),
    );
    await tester.pumpWidget(build(const HyperDivider(length: 80)));
    expect(tester.getSize(find.byType(HyperDivider)).height, 2);
    await tester.pumpWidget(
      build(
        const HyperDividerTheme(
          data: HyperDividerThemeData(style: HyperDividerStyle(thickness: 4)),
          child: HyperDivider(length: 80),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byType(HyperDivider)).height, 4);
    await tester.pumpWidget(
      build(const HyperDivider(line: line, thickness: 6, length: 80)),
    );
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byType(HyperDivider)).height, 6);
    await tester.pumpWidget(
      build(const HyperDivider(line: HyperLine.none(), length: 80)),
    );
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byType(HyperDivider)).height, 0);
    expect(tester.takeException(), isNull);
  });
}
