import 'dart:ui' show PointerDeviceKind;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui/src/components/charts/hyper_chart_pointer_tooltip.dart';
import 'package:lemon_ui/src/components/surface/hyper_material_edge.dart';

const lines = [
  HyperLineSeries(
    name: '访问量',
    points: [
      HyperLinePoint(x: 0, y: 10, label: '周一'),
      HyperLinePoint(x: 1, y: 20, label: '周二'),
      HyperLinePoint(x: 2, y: 15, label: '周三'),
    ],
  ),
];
const sections = [
  HyperPieSection(label: '桌面', value: 60),
  HyperPieSection(label: '手机', value: 40),
];
const groups = [
  HyperBarGroup(
    label: '周一',
    values: [HyperBarValue(value: 10), HyperBarValue(value: 20)],
  ),
  HyperBarGroup(
    label: '周二',
    values: [HyperBarValue(value: 15), HyperBarValue(value: 12)],
  ),
];
const bars = [HyperBarSeries(name: '甲'), HyperBarSeries(name: '乙')];

Widget host(
  Widget chart, {
  double scale = 1,
  double width = 600,
  HyperThemeData? theme,
}) => MaterialApp(
  home: HyperTheme(
    data: theme ?? HyperThemeData.light(),
    duration: Duration.zero,
    child: MediaQuery(
      data: MediaQueryData(textScaler: TextScaler.linear(scale)),
      child: Scaffold(
        body: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(width: width, child: chart),
        ),
      ),
    ),
  ),
);

void main() {
  testWidgets(
    'pointer surface inherits material and supports explicit empty shadows',
    (tester) async {
      for (final advanced in [false, true]) {
        final theme = HyperThemeData.light().copyWith(
          materialTheme: HyperMaterialThemeData(
            quality: advanced
                ? HyperMaterialQuality.advanced
                : HyperMaterialQuality.standard,
            material: advanced
                ? const HyperSurfaceMaterial.frostedGlass()
                : null,
          ),
          chartTheme: HyperChartThemeData(
            style: HyperChartStyle(
              tooltipStyle: HyperCardStyle(
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [BoxShadow(color: Colors.red)],
              ),
            ),
          ),
        );
        await tester.pumpWidget(
          host(
            SizedBox(
              height: 200,
              child: HyperPointerTooltipArea(
                position: const Offset(590, 190),
                message: '提示内容',
                onExit: () {},
                style: HyperCardStyle(boxShadow: const []),
                child: const SizedBox.expand(),
              ),
            ),
            theme: theme,
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 24));
        if (advanced) {
          for (final filter in tester.elementList(
            find.byType(BackdropFilter),
          )) {
            filter.visitAncestorElements((element) {
              final widget = element.widget;
              if (widget is Opacity) {
                expect(widget.opacity, 1, reason: '高级背景滤镜不得置于分数透明度层');
              }
              return true;
            });
          }
        }
        await tester.pumpAndSettle();
        final card = tester.widget<HyperCard>(find.byType(HyperCard));
        expect(card.style!.boxShadow, isEmpty);
        expect(card.style!.borderRadius, BorderRadius.circular(18));
        if (advanced) {
          expect(
            tester
                .widget<HyperMaterialEdge>(find.byType(HyperMaterialEdge))
                .material,
            isNotNull,
          );
        }
        final box = tester.getRect(find.byType(HyperCard));
        expect(box.right, lessThanOrEqualTo(600));
        expect(box.bottom, lessThanOrEqualTo(200));
        expect(tester.takeException(), isNull);
      }
    },
  );
  test(
    'chart size and style preserve typed overrides, equality and interpolation',
    () {
      const size = HyperChartSize();
      expect(size.copyWith(lineWidth: 4).lineWidth, 4);
      expect(
        HyperChartSize.lerp(size, size.copyWith(height: 300), .5).height,
        290,
      );
      const a = HyperChartStyle(
        lineWidth: 3,
        legend: HyperChartLegendOptions(
          position: HyperChartLegendPosition.right,
        ),
      );
      expect(a.merge(const HyperChartStyle(pointRadius: 5)).lineWidth, 3);
      expect(a.merge(const HyperChartStyle(pointRadius: 5)).pointRadius, 5);
      expect(a, a.copyWith());
      expect(HyperChartStyle.lerp(a, a, 0), a);
      final base = HyperThemeData.light();
      final updated = base.copyWith(
        chartTheme: const HyperChartThemeData(style: a),
      );
      expect(updated.chartTheme.style, a);
      expect(base.lerp(updated, 1).chartTheme.style, a);
    },
  );

  testWidgets(
    'global, local and explicit chart overrides have correct priority',
    (tester) async {
      final base = HyperThemeData.light();
      final theme = base.copyWith(
        chartTheme: const HyperChartThemeData(
          style: HyperChartStyle(lineWidth: 4),
        ),
        sizes: base.sizes.copyWith(
          desktop: base.sizes.desktop.copyWith(
            chart: const HyperChartSize(height: 310),
          ),
        ),
      );
      await tester.pumpWidget(
        host(
          const HyperChartTheme(
            data: HyperChartThemeData(style: HyperChartStyle(pointRadius: 5)),
            child: HyperLineChart(
              series: lines,
              style: HyperChartStyle(lineWidth: 6),
            ),
          ),
          theme: theme,
        ),
      );
      expect(
        tester
            .widget<LineChart>(find.byType(LineChart))
            .data
            .lineBarsData
            .single
            .barWidth,
        6,
      );
      expect(tester.takeException(), isNull);
    },
  );

  for (final position in HyperChartLegendPosition.values) {
    testWidgets(
      'legend supports $position, vertical arrangement, toggle and custom items',
      (tester) async {
        await tester.pumpWidget(
          host(
            HyperLineChart(
              series: lines,
              style: HyperChartStyle(
                legend: HyperChartLegendOptions(
                  position: position,
                  direction: Axis.vertical,
                  itemBuilder: (context, label, color, hidden, toggle) =>
                      GestureDetector(
                        onTap: toggle,
                        child: Text('$label ${hidden ? '隐藏' : '显示'}'),
                      ),
                ),
              ),
            ),
          ),
        );
        final plot = tester.getRect(find.byType(LineChart));
        final legend = tester.getRect(find.text('访问量 显示'));
        switch (position) {
          case HyperChartLegendPosition.top:
            expect(legend.bottom, lessThanOrEqualTo(plot.top));
          case HyperChartLegendPosition.bottom:
            expect(legend.top, greaterThanOrEqualTo(plot.bottom));
          case HyperChartLegendPosition.left:
            expect(legend.right, lessThanOrEqualTo(plot.left));
          case HyperChartLegendPosition.right:
            expect(legend.left, greaterThanOrEqualTo(plot.right));
        }
        await tester.tap(find.text('访问量 显示'));
        await tester.pump();
        expect(find.text('访问量 隐藏'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'keyboard custom tooltip uses source data, mouse motion and exit remain valid',
    (tester) async {
      HyperLineChartTooltipData? hit;
      await tester.pumpWidget(
        host(
          HyperLineChart(
            series: lines,
            autofocus: true,
            tooltipWidgetBuilder: (context, data) {
              hit = data;
              return Text('自定义 ${data.items.first.formattedValue}');
            },
          ),
        ),
      );
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pump();
      final data = tester.widget<LineChart>(find.byType(LineChart)).data;
      final bar = data.lineBarsData.single;
      data.lineTouchData.touchCallback!(
        const FlPointerHoverEvent(PointerHoverEvent(position: Offset(10, 10))),
        LineTouchResponse(
          touchLocation: const Offset(10, 10),
          touchChartCoordinate: const Offset(10, 10),
          lineBarSpots: [TouchLineBarSpot(bar, 0, bar.spots[1], 1)],
        ),
      );
      await tester.pump();
      expect(hit, isNotNull);
      expect(
        hit!.items.first.hit.point,
        lines.single.points[hit!.items.first.hit.selection.groupIndex],
      );
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer(location: Offset.zero);
      await mouse.moveTo(tester.getCenter(find.byType(LineChart)));
      await tester.pump();
      await mouse.moveTo(const Offset(799, 599));
      await tester.pump();
      await mouse.removePointer();
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'sampling keeps original source identity and invalidates on replacement',
    (tester) async {
      final source = List.generate(
        10000,
        (i) => HyperLinePoint(x: i.toDouble(), y: (i % 37).toDouble()),
      );
      await tester.pumpWidget(
        host(
          HyperLineChart(
            series: [
              HyperLineSeries(name: '一年', points: source, showPoints: false),
            ],
            maxRenderedPoints: 100,
          ),
        ),
      );
      var data = tester.widget<LineChart>(find.byType(LineChart)).data;
      expect(data.lineBarsData.single.spots.length, 100);
      expect(data.lineBarsData.single.spots.first.x, 0);
      expect(data.lineBarsData.single.spots.last.x, 9999);
      await tester.pumpWidget(host(const HyperLineChart(series: lines)));
      data = tester.widget<LineChart>(find.byType(LineChart)).data;
      expect(data.lineBarsData.single.spots.length, 3);
      expect(data.maxX, 2);
      expect(tester.takeException(), isNull);
    },
  );

  for (final scale in [1.0, 1.3, 2.0]) {
    testWidgets(
      'all chart families render at text scale $scale in narrow constraints',
      (tester) async {
        for (final chart in <Widget>[
          const HyperLineChart.area(series: lines),
          const HyperLineChart.step(series: lines),
          const HyperBarChart(groups: groups, series: bars),
          const HyperBarChart.stacked(groups: groups, series: bars),
          const HyperBarChart.horizontal(groups: groups, series: bars),
          const HyperBarChart.horizontalStacked(groups: groups, series: bars),
          const HyperPieChart(sections: sections, showLeaderLabels: true),
          const HyperPieChart.donut(sections: sections, showLeaderLabels: true),
          const HyperScatterChart(
            series: [
              HyperScatterSeries(
                name: '样本',
                points: [
                  HyperScatterPoint(x: 1, y: 2),
                  HyperScatterPoint(x: 2, y: 3),
                ],
              ),
            ],
          ),
          const HyperRadarChart(
            indicators: ['甲', '乙', '丙'],
            series: [
              HyperRadarSeries(name: '方案', values: [2, 3, 4]),
            ],
          ),
          const HyperCandlestickChart(
            data: [HyperCandlestickData(open: 10, high: 20, low: 5, close: 15)],
          ),
          const HyperRankBarChart(
            items: [HyperRankBarItem(label: '样本', value: 12)],
          ),
        ]) {
          await tester.pumpWidget(host(chart, scale: scale, width: 280));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull, reason: '$chart scale=$scale');
        }
      },
    );
  }
}
