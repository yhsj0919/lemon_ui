import 'dart:isolate';
import 'dart:async';
import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

List<HyperLineSeries> _workerSeries(int count) => [
  HyperLineSeries(
    name: Isolate.current.debugName ?? '',
    showPoints: false,
    points: List.generate(
      count,
      (i) => HyperLinePoint(x: i.toDouble(), y: (i % 29).toDouble()),
    ),
  ),
];
Widget _host(Widget chart) => MaterialApp(
  home: HyperTheme(
    data: HyperThemeData.light(),
    child: Scaffold(body: SizedBox(width: 600, child: chart)),
  ),
);

void main() {
  test('one year of minute data prepares without starving the UI event loop', () async {
    var ticks = 0;
    final timer = Timer.periodic(
      const Duration(milliseconds: 1),
      (_) => ticks++,
    );
    final watch = Stopwatch()..start();
    try {
      final data = await HyperLineChartDataset.generate(525600, _workerSeries);
      expect(data.pointCount, 525600);
      expect(data.domain, HyperChartRange(0, 525599));
      if (!kIsWeb) expect(ticks, greaterThan(0));
      debugPrint(
        'minute-year preparation: ${watch.elapsedMilliseconds} ms; UI timer ticks: $ticks (test mode)',
      );
    } finally {
      timer.cancel();
    }
  });
  test(
    'viewport zoom anchor, pan boundaries, reset and domain replacement',
    () {
      final c = HyperChartViewportController(
        domain: HyperChartRange(0, 100),
        minimumSpan: 2,
      );
      addTearDown(c.dispose);
      var changes = 0;
      c.addListener(() => changes++);
      c.zoom(2, anchor: 0);
      expect(c.range, HyperChartRange(0, 50));
      c.pan(1000);
      expect(c.range, HyperChartRange(50, 100));
      c.pan(-1000);
      expect(c.range, HyperChartRange(0, 50));
      c.zoom(100);
      expect(c.range.span, 2);
      c.reset();
      expect(c.isFullRange, isTrue);
      final old = changes;
      c.reset();
      expect(changes, old);
      c.setDomain(HyperChartRange(10, 30));
      expect(c.range, HyperChartRange(10, 30));
      c.setRange(HyperChartRange(11, 15));
      c.setDomain(HyperChartRange(20, 40));
      expect(c.range, HyperChartRange(20, 24));
      expect(() => c.zoom(0), throwsArgumentError);
      expect(() => c.zoom(2, anchor: 2), throwsArgumentError);
      expect(() => HyperChartRange(0, double.infinity), throwsArgumentError);
      expect(() => HyperChartRange(-1e308, 1e308), throwsArgumentError);
    },
  );

  test('native generation and initial preparation run in a worker, snapshot is immutable', () async {
    final data = await HyperLineChartDataset.generate(
      10000,
      _workerSeries,
      maxRenderedPoints: 80,
    );
    expect(data.pointCount, 10000);
    expect(data.domain, HyperChartRange(0, 9999));
    if (!kIsWeb) {
      expect(data.series.single.name, isNot(Isolate.current.debugName));
    }
    expect(() => data.series.clear(), throwsUnsupportedError);
    expect(() => data.series.single.points.clear(), throwsUnsupportedError);
    final original = [HyperLinePoint(x: 0, y: 1), HyperLinePoint(x: 1, y: 2)];
    final copy = await HyperLineChartDataset.prepare([
      HyperLineSeries(
        name: '数据',
        points: original,
        color: Colors.red,
        width: 3,
        showPoints: false,
      ),
    ]);
    original.clear();
    expect(copy.pointCount, 2);
    expect(copy.series.single.color, Colors.red);
    expect(copy.series.single.width, 3);
    await expectLater(
      HyperLineChartDataset.prepare([
        const HyperLineSeries(
          name: '无效',
          points: [HyperLinePoint(x: double.nan, y: 0)],
        ),
      ]),
      throwsArgumentError,
    );
  });

  testWidgets(
    'viewport resamples original points, callbacks retain source indices and reset restores overview',
    (tester) async {
      final data = await tester.runAsync(
        () => HyperLineChartDataset.generate(
          10000,
          _workerSeries,
          maxRenderedPoints: 80,
        ),
      );
      final controller = HyperChartViewportController(
        domain: data!.domain!,
        minimumSpan: 1,
      );
      addTearDown(controller.dispose);
      HyperLineChartHit? hit;
      await tester.pumpWidget(
        _host(
          HyperLineChart(
            series: data.series,
            preparedData: data,
            viewportController: controller,
            maxRenderedPoints: 80,
            panEnabled: true,
            onPointTap: (value) => hit = value,
          ),
        ),
      );
      await tester.pumpAndSettle();
      LineChartData read() =>
          tester.widget<LineChart>(find.byType(LineChart)).data;
      expect(
        tester.widget<LineChart>(find.byType(LineChart)).duration,
        Duration.zero,
        reason: '视口更新不插值合成不存在于原始数据的采样点',
      );
      expect(read().lineBarsData.single.spots.length, 80);
      controller.setRange(HyperChartRange(5000, 5010));
      await tester.pumpAndSettle();
      var chart = read();
      expect(chart.minX, 5000);
      expect(chart.maxX, 5010);
      expect(chart.lineBarsData.single.spots.length, 13);
      final bar = chart.lineBarsData.single;
      final spot = bar.spots.firstWhere((point) => point.x == 5005);
      chart.lineTouchData.touchCallback!(
        FlTapUpEvent(
          TapUpDetails(
            localPosition: const Offset(20, 20),
            kind: PointerDeviceKind.mouse,
          ),
        ),
        LineTouchResponse(
          touchLocation: const Offset(20, 20),
          touchChartCoordinate: const Offset(5005, 17),
          lineBarSpots: [TouchLineBarSpot(bar, 0, spot, 6)],
        ),
      );
      await tester.pump();
      expect(hit!.selection.groupIndex, 5005);
      expect(identical(hit!.point, data.series.single.points[5005]), isTrue);
      await tester.drag(find.byType(LineChart), const Offset(-100, 0));
      await tester.pumpAndSettle();
      expect(controller.range.min, greaterThan(5000));
      controller.reset();
      await tester.pumpAndSettle();
      expect(read().minX, 0);
      expect(read().maxX, 9999);
      expect(read().lineBarsData.single.spots.length, 80);
      await tester.pumpWidget(
        _host(
          HyperLineChart(
            series: data.series,
            preparedData: data,
            viewportController: controller,
            maxRenderedPoints: 20,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(read().lineBarsData.single.spots.length, 20);
      controller.zoom(2);
      await tester.pumpAndSettle();
      expect(read().lineBarsData.single.spots.length, lessThanOrEqualTo(20));
      for (final point in read().lineBarsData.single.spots) {
        expect(point.y, data.series.single.points[point.x.toInt()].y);
      }
      await tester.pumpWidget(const SizedBox());
      controller.zoom(2); // Chart must have removed its listener.
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'source gaps and off-grid windows preserve connecting neighbours',
    (tester) async {
      final data = await tester.runAsync(
        () => HyperLineChartDataset.prepare([
          const HyperLineSeries(
            name: '空值',
            points: [
              HyperLinePoint(x: 0, y: 1),
              HyperLinePoint(x: 10, y: null),
              HyperLinePoint(x: 20, y: 2),
              HyperLinePoint(x: 30, y: 3),
            ],
          ),
        ]),
      );
      final c = HyperChartViewportController(domain: data!.domain!);
      addTearDown(c.dispose);
      c.setRange(HyperChartRange(8, 22));
      await tester.pumpWidget(
        _host(
          HyperLineChart(
            series: data.series,
            preparedData: data,
            viewportController: c,
          ),
        ),
      );
      await tester.pumpAndSettle();
      final spots = tester
          .widget<LineChart>(find.byType(LineChart))
          .data
          .lineBarsData
          .single
          .spots;
      expect(spots.contains(FlSpot.nullSpot), isTrue);
      expect(spots.first.x, 0);
      expect(spots.last.x, 30);
      expect(tester.takeException(), isNull);
    },
  );
}
