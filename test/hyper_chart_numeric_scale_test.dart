import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui/src/components/charts/hyper_chart_axis_layout.dart';

void main() {
  test('boundary grids follow endpoint styles, directions and visibility', () {
    final grid = FlGridData(
      getDrawingHorizontalLine: (value) => FlLine(
        color: value == 0 ? Colors.blue : Colors.green,
        strokeWidth: 1,
      ),
      getDrawingVerticalLine: (_) =>
          const FlLine(color: Colors.red, strokeWidth: 1),
    );
    final border = hyperChartGridBoundary(
      grid,
      minY: 0,
      maxY: 40,
      minX: 0,
      maxX: 4,
    );
    expect(border.border.bottom.color, Colors.blue);
    expect(border.border.top.color, Colors.green);
    expect(border.border.left.color, Colors.red);
    expect(border.border.right.color, Colors.red);
    final hidden = hyperChartGridBoundary(
      grid.copyWith(show: false),
      minY: 0,
      maxY: 40,
    );
    expect(hidden.show, isFalse);
    final horizontal = hyperChartGridBoundary(
      grid.copyWith(drawVerticalLine: false),
      minY: 0,
      maxY: 40,
      minX: 0,
      maxX: 4,
    );
    expect(horizontal.border.left, BorderSide.none);
    expect(horizontal.border.right, BorderSide.none);
    final filtered = hyperChartGridBoundary(
      grid.copyWith(checkToShowHorizontalLine: (value) => value != 40),
      minY: 0,
      maxY: 40,
    );
    expect(filtered.border.top, BorderSide.none);
  });
  testWidgets('line families and rotated bars balance physical side gutters', (
    tester,
  ) async {
    const lines = [
      HyperLineSeries(
        name: '数据',
        points: [HyperLinePoint(x: 0, y: -10), HyperLinePoint(x: 1, y: 30)],
      ),
    ];
    const groups = [
      HyperBarGroup(label: '分类名称', values: [HyperBarValue(value: -10)]),
      HyperBarGroup(label: '另一类', values: [HyperBarValue(value: 30)]),
    ];
    const series = [HyperBarSeries(name: '数据')];
    final charts = <Widget>[
      const HyperLineChart(series: lines),
      const HyperLineChart.area(series: lines),
      const HyperLineChart.step(series: lines),
      const HyperBarChart(groups: groups, series: series, showValues: true),
      const HyperBarChart.horizontal(
        groups: groups,
        series: series,
        showValues: true,
      ),
      const HyperBarChart.stacked(
        groups: groups,
        series: series,
        showValues: true,
      ),
    ];
    for (final chart in charts) {
      await tester.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: HyperThemeData.light(),
            child: Scaffold(
              body: SizedBox(width: 360, height: 300, child: chart),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      for (final label in tester.widgetList<SideTitleWidget>(
        find.byType(SideTitleWidget),
      )) {
        expect(label.space, hyperChartAxisLabelGap);
      }
      final line = find.byType(LineChart);
      final titles = line.evaluate().isNotEmpty
          ? tester.widget<LineChart>(line).data.titlesData
          : tester.widget<BarChart>(find.byType(BarChart)).data.titlesData;
      final AxisChartData plot = line.evaluate().isNotEmpty
          ? tester.widget<LineChart>(line).data
          : tester.widget<BarChart>(find.byType(BarChart)).data;
      expect(plot.borderData.show, isTrue);
      expect(
        plot.borderData.border.top.color,
        plot.gridData.getDrawingHorizontalLine(plot.maxY).color,
      );
      expect(
        plot.borderData.border.bottom.color,
        plot.gridData.getDrawingHorizontalLine(plot.minY).color,
      );
      expect(plot.borderData.border.top.width, 1);
      expect(plot.borderData.border.bottom.width, 1);
      final horizontal = chart == charts[4];
      expect(
        hyperChartAxisExtent(
          horizontal ? titles.bottomTitles : titles.leftTitles,
        ),
        hyperChartAxisExtent(
          horizontal ? titles.topTitles : titles.rightTitles,
        ),
      );
      expect(tester.takeException(), isNull);
    }
  });
  testWidgets(
    'scatter plot balances axis gutters with title and text scaling',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(360, 400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      for (final scale in [1.0, 1.3, 2.0]) {
        for (final axis in [
          const HyperChartAxis(),
          const HyperChartAxis(title: '数值'),
          const HyperChartAxis(show: false),
        ]) {
          await tester.pumpWidget(
            MaterialApp(
              home: HyperTheme(
                data: HyperThemeData.light(),
                child: MediaQuery(
                  data: MediaQueryData(textScaler: TextScaler.linear(scale)),
                  child: Scaffold(
                    body: HyperScatterChart(
                      showLegend: false,
                      yAxis: axis,
                      series: const [
                        HyperScatterSeries(
                          name: '数据',
                          points: [
                            HyperScatterPoint(x: 1, y: 3),
                            HyperScatterPoint(x: 4, y: 2),
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
          for (final label in tester.widgetList<SideTitleWidget>(
            find.byType(SideTitleWidget),
          )) {
            expect(label.space, hyperChartAxisLabelGap);
          }
          final data = tester
              .widget<ScatterChart>(find.byType(ScatterChart))
              .data;
          double extent(AxisTitles titles) => titles.sideTitles.showTitles
              ? titles.sideTitles.reservedSize + titles.axisNameSize
              : 0;
          expect(
            extent(data.titlesData.rightTitles),
            extent(data.titlesData.leftTitles),
          );
          expect(data.minX, 1);
          expect(data.maxX, 4);
          expect(tester.takeException(), isNull);
        }
      }
    },
  );
  testWidgets('candlestick painter uses regular ticks and honors zero option', (
    tester,
  ) async {
    for (final includeZero in [false, true]) {
      final labels = <double>[];
      await tester.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: HyperThemeData.light(),
            child: SizedBox(
              width: 600,
              height: 300,
              child: HyperCandlestickChart(
                yAxis: HyperChartAxis(includeZero: includeZero),
                valueFormatter: (value) {
                  labels.add(value);
                  return value.toString();
                },
                data: const [
                  HyperCandlestickData(open: 10, high: 22, low: 8, close: 16),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(labels, contains(25.0));
      expect(labels.contains(0), includeZero);
      expect(tester.takeException(), isNull);
    }
  });
  test('automatic scales have regular ticks and a zero baseline', () {
    for (final range in [
      [20.0, 89.0],
      [-89.0, -20.0],
      [-13.0, 28.0],
      [0.0, 0.0],
    ]) {
      final scale = hyperChartNumericScale(
        range[0],
        range[1],
        const HyperChartAxis(),
      );
      expect(scale.min, lessThanOrEqualTo(range[0]));
      expect(scale.max, greaterThanOrEqualTo(range[1]));
      expect(scale.ticks, contains(0.0));
    }
  });

  test('price axes use readable bounds and allow a zero baseline', () {
    final price = hyperChartNumericScale(
      8,
      22,
      const HyperChartAxis(),
      includeZero: false,
    );
    expect(price.ticks.toList(), [5, 10, 15, 20, 25]);
    final zero = hyperChartNumericScale(
      8,
      22,
      const HyperChartAxis(includeZero: true),
      includeZero: false,
    );
    expect(zero.ticks.first, 0);
    final explicit = hyperChartNumericScale(
      8,
      22,
      const HyperChartAxis(min: 7, max: 23, interval: 5),
    );
    expect(explicit.ticks.toList(), [7, 10, 15, 20, 23]);
    expect(
      () => hyperChartNumericScale(0, 1, const HyperChartAxis(interval: 0)),
      throwsArgumentError,
    );
  });

  testWidgets('line value-axis shows its automatic zero endpoint', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: const SizedBox(
            width: 600,
            height: 300,
            child: HyperLineChart(
              series: [
                HyperLineSeries(
                  name: '数据',
                  points: [
                    HyperLinePoint(x: 0, y: 20),
                    HyperLinePoint(x: 1, y: 89),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final data = tester.widget<LineChart>(find.byType(LineChart)).data;
    expect(data.minY, 0);
    expect(data.maxY, 100);
    expect(data.titlesData.leftTitles.sideTitles.minIncluded, isTrue);
    expect(
      data.titlesData.leftTitles.sideTitles.interval,
      data.gridData.horizontalInterval,
    );
    expect(tester.takeException(), isNull);
  });
}
