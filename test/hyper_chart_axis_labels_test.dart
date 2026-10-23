import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  for (final width in [280.0, 600.0, 1600.0]) {
    for (final scale in [1.0, 1.3, 2.0]) {
      for (final angle in [0.0, -45.0]) {
        testWidgets('axis labels avoid overlaps at $width / $scale / $angle', (
          tester,
        ) async {
          await tester.binding.setSurfaceSize(Size(width, 400));
          addTearDown(() => tester.binding.setSurfaceSize(null));
          await tester.pumpWidget(
            MaterialApp(
              home: HyperTheme(
                data: HyperThemeData.light(),
                child: MediaQuery(
                  data: MediaQueryData(textScaler: TextScaler.linear(scale)),
                  child: Scaffold(
                    body: HyperLineChart(
                      showLegend: false,
                      series: [
                        HyperLineSeries(
                          name: '一年',
                          showPoints: false,
                          points: List.generate(
                            365,
                            (i) => HyperLinePoint(
                              x: i.toDouble(),
                              y: (i % 17).toDouble(),
                            ),
                          ),
                        ),
                      ],
                      xAxis: HyperChartAxis(
                        labelRotation: angle,
                        formatter: (x) => '第 ${x.round()} 次',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          final axis = tester
              .widget<LineChart>(find.byType(LineChart))
              .data
              .titlesData
              .bottomTitles
              .sideTitles;
          expect(axis.maxIncluded, isFalse);
          final labels = tester
              .widgetList<SideTitleWidget>(find.byType(SideTitleWidget))
              .where((label) => label.meta.axisSide == AxisSide.bottom)
              .toList();
          final rects = [
            for (final label in labels)
              tester.getRect(
                find.byWidget(
                  label.child is Transform
                      ? (label.child as Transform).child!
                      : label.child,
                ),
              ),
          ]..sort((a, b) => a.left.compareTo(b.left));
          expect(rects, isNotEmpty);
          final positions =
              labels.map((label) => label.meta.axisPosition).toList()..sort();
          if (positions.length > 2) {
            final gap = positions[1] - positions[0];
            for (var i = 2; i < positions.length; i++) {
              expect(
                positions[i] - positions[i - 1],
                closeTo(gap, .001),
                reason: '刻度应保持等距，不得临时删除单个标签',
              );
            }
          }
          for (final label in labels) {
            final rich = find.descendant(
              of: find.byWidget(label.child),
              matching: find.byType(RichText),
            );
            final paragraph = tester.renderObject<RenderParagraph>(rich);
            expect(paragraph.didExceedMaxLines, isFalse);
            expect(paragraph.overflow, TextOverflow.visible);
            expect(paragraph.text.toPlainText(), endsWith(' 次'));
          }
          for (var i = 0; i < rects.length; i++) {
            expect(rects[i].left, greaterThanOrEqualTo(-.01));
            expect(rects[i].right, lessThanOrEqualTo(width + .01));
            if (i > 0) {
              expect(rects[i].left, greaterThanOrEqualTo(rects[i - 1].right));
            }
          }
          expect(tester.takeException(), isNull);
        });
      }
    }
  }
}
