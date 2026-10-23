import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  testWidgets(
    'bar and scatter corner labels remain separate after rotation and scaling',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(360, 400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      const groups = [
        HyperBarGroup(label: '周一', values: [HyperBarValue(value: 12)]),
        HyperBarGroup(label: '周二', values: [HyperBarValue(value: 26)]),
      ];
      const series = [HyperBarSeries(name: '数据')];
      final charts = [
        const HyperBarChart(groups: groups, series: series, showLegend: false),
        const HyperBarChart.horizontal(
          groups: groups,
          series: series,
          showLegend: false,
        ),
        const HyperScatterChart(
          showLegend: false,
          series: [
            HyperScatterSeries(
              name: '数据',
              points: [
                HyperScatterPoint(x: 0, y: 0),
                HyperScatterPoint(x: 4, y: 20),
              ],
            ),
          ],
        ),
      ];
      for (final scale in [1.0, 1.3, 2.0]) {
        for (final chart in charts) {
          await tester.pumpWidget(
            MaterialApp(
              home: HyperTheme(
                data: HyperThemeData.light(),
                child: MediaQuery(
                  data: MediaQueryData(textScaler: TextScaler.linear(scale)),
                  child: Scaffold(body: chart),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          final labels = tester
              .widgetList<SideTitleWidget>(find.byType(SideTitleWidget))
              .toList();
          final horizontalBar = chart == charts[1];
          final left = horizontalBar ? AxisSide.bottom : AxisSide.left;
          final bottom = horizontalBar ? AxisSide.right : AxisSide.bottom;
          Rect textRect(SideTitleWidget label) => tester.getRect(
            find
                .descendant(
                  of: find.byWidget(label.child),
                  matching: find.byType(RichText),
                )
                .first,
          );
          for (final y in labels.where(
            (label) => label.meta.axisSide == left,
          )) {
            for (final x in labels.where(
              (label) => label.meta.axisSide == bottom,
            )) {
              expect(
                textRect(y).overlaps(textRect(x)),
                isFalse,
                reason: '${chart.runtimeType} / $scale',
              );
            }
          }
          expect(tester.takeException(), isNull);
        }
      }
    },
  );
  for (final scale in [1.0, 1.3, 2.0]) {
    for (final angle in [0.0, -45.0]) {
      testWidgets(
        'axis corner keeps zero aligned and labels separate at $scale / $angle',
        (tester) async {
          await tester.binding.setSurfaceSize(const Size(360, 400));
          addTearDown(() => tester.binding.setSurfaceSize(null));
          await tester.pumpWidget(
            MaterialApp(
              home: HyperTheme(
                data: HyperThemeData.light(),
                child: MediaQuery(
                  data: MediaQueryData(textScaler: TextScaler.linear(scale)),
                  child: Scaffold(
                    body: HyperLineChart.area(
                      showLegend: false,
                      xAxis: HyperChartAxis(labelRotation: angle),
                      series: const [
                        HyperLineSeries(
                          name: '数据',
                          points: [
                            HyperLinePoint(x: 0, y: 10, label: '周一'),
                            HyperLinePoint(x: 1, y: 20, label: '周二'),
                            HyperLinePoint(x: 2, y: 30, label: '周三'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          final labels = tester
              .widgetList<SideTitleWidget>(find.byType(SideTitleWidget))
              .toList();
          final zero = labels.firstWhere(
            (label) =>
                label.meta.axisSide == AxisSide.left &&
                label.meta.formattedValue == '0',
          );
          final first = labels.firstWhere(
            (label) =>
                label.meta.axisSide == AxisSide.bottom &&
                label.meta.formattedValue == '0',
          );
          final zeroRect = tester.getRect(
            find.descendant(
              of: find.byWidget(zero.child),
              matching: find.byType(RichText),
            ),
          );
          final firstContent = first.child is Transform
              ? (first.child as Transform).child!
              : first.child;
          final firstRect = tester.getRect(find.byWidget(firstContent));
          expect(
            zeroRect.overlaps(firstRect),
            isFalse,
            reason: 'zero=$zeroRect first=$firstRect',
          );
          final plot = tester.widget<LineChart>(find.byType(LineChart));
          final chartRect = tester.getRect(find.byType(LineChart));
          final baseline =
              chartRect.bottom -
              plot.data.titlesData.bottomTitles.sideTitles.reservedSize -
              plot.data.borderData.border.bottom.width;
          expect(
            zeroRect.center.dy,
            closeTo(baseline, 1.1),
            reason: '零标签必须对齐零刻度，不能向上移动避让',
          );
          final topLabel = labels
              .where((label) => label.meta.axisSide == AxisSide.left)
              .last;
          expect(
            tester.getRect(find.byWidget(topLabel.child)).top,
            greaterThanOrEqualTo(chartRect.top - .01),
          );
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}
