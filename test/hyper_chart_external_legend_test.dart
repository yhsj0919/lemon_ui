import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

const first = HyperLineSeries(
  name: '访问量',
  color: Colors.blue,
  points: [HyperLinePoint(x: 0, y: 10), HyperLinePoint(x: 1, y: 20)],
);
const second = HyperLineSeries(
  name: '成交量',
  color: Colors.green,
  points: [HyperLinePoint(x: 0, y: 5), HyperLinePoint(x: 1, y: 8)],
);
Widget host(Widget child) => MaterialApp(
  home: HyperTheme(
    data: HyperThemeData.light(),
    child: Scaffold(body: child),
  ),
);

void main() {
  test('controller exposes immutable state and only notifies on changes', () {
    final controller = HyperChartLegendController(hiddenIds: ['a']);
    var changes = 0;
    controller.addListener(() => changes++);
    controller.setVisible('a', false);
    controller.toggle('a');
    controller.setVisible('b', false);
    expect(controller.hiddenIds, {'b'});
    expect(() => controller.hiddenIds.add('c'), throwsUnsupportedError);
    controller.showAll();
    controller.showAll();
    expect(changes, 3);
    controller.dispose();
  });

  testWidgets(
    'external legend receives snapshots, shares IDs across reordered charts and avoids callback loops',
    (tester) async {
      final controller = HyperChartLegendController();
      addTearDown(controller.dispose);
      List<HyperChartLegendEntry> entries = [];
      var callbacks = 0;
      await tester.pumpWidget(
        host(
          StatefulBuilder(
            builder: (context, update) => Column(
              children: [
                Text('外部图例 ${entries.where((e) => !e.hidden).length}'),
                SizedBox(
                  height: 220,
                  child: HyperLineChart(
                    series: const [first, second],
                    showLegend: false,
                    legendIds: const ['visits', 'sales'],
                    legendController: controller,
                    onLegendChanged: (next) => update(() {
                      entries = next;
                      callbacks++;
                    }),
                  ),
                ),
                SizedBox(
                  height: 220,
                  child: HyperLineChart.area(
                    series: const [second, first],
                    showLegend: false,
                    legendIds: const ['sales', 'visits'],
                    legendController: controller,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(callbacks, 1);
      expect(entries.first.color, Colors.blue);
      expect(entries.first.id, 'visits');
      expect(() => entries.clear(), throwsUnsupportedError);
      controller.toggle('visits');
      await tester.pumpAndSettle();
      expect(callbacks, 2);
      expect(entries.first.hidden, isTrue);
      final plots = tester
          .widgetList<LineChart>(find.byType(LineChart))
          .toList();
      expect(plots[0].data.lineBarsData[0].show, isFalse);
      expect(plots[1].data.lineBarsData[1].show, isFalse);
      expect(find.text('外部图例 1'), findsOneWidget);
      controller.showAll();
      await tester.pumpAndSettle();
      expect(callbacks, 3);
      expect(entries.every((entry) => !entry.hidden), isTrue);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'controller replacement detaches old listeners; local legends publish toggles',
    (tester) async {
      final old = HyperChartLegendController(),
          next = HyperChartLegendController();
      addTearDown(old.dispose);
      addTearDown(next.dispose);
      List<HyperChartLegendEntry> entries = [];
      Widget chart(HyperChartLegendController controller) => host(
        HyperLineChart(
          series: const [first, second],
          legendController: controller,
          onLegendChanged: (value) => entries = value,
        ),
      );
      await tester.pumpWidget(chart(old));
      await tester.pumpAndSettle();
      await tester.tap(find.text('访问量'));
      await tester.pumpAndSettle();
      expect(old.isHidden('访问量'), isTrue);
      expect(entries.first.hidden, isTrue);
      await tester.pumpWidget(chart(next));
      await tester.pumpAndSettle();
      expect(entries.first.hidden, isFalse);
      old.showAll();
      await tester.pumpAndSettle();
      expect(entries.first.hidden, isFalse);
      await tester.pumpWidget(const SizedBox());
      next.toggle('访问量');
      await tester.pump();
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'all legend families publish without built-in legends and tolerate all hidden',
    (tester) async {
      final controller = HyperChartLegendController();
      addTearDown(controller.dispose);
      List<HyperChartLegendEntry> entries = [];
      void changed(List<HyperChartLegendEntry> value) => entries = value;
      final charts = [
        HyperBarChart(
          series: const [HyperBarSeries(name: 'a')],
          groups: const [
            HyperBarGroup(label: '一', values: [HyperBarValue(value: 10)]),
          ],
          showLegend: false,
          legendController: controller,
          onLegendChanged: changed,
        ),
        HyperScatterChart(
          series: const [
            HyperScatterSeries(
              name: 'a',
              points: [HyperScatterPoint(x: 1, y: 2)],
            ),
          ],
          showLegend: false,
          legendController: controller,
          onLegendChanged: changed,
        ),
        HyperPieChart(
          sections: const [HyperPieSection(label: 'a', value: 10)],
          showLegend: false,
          legendController: controller,
          onLegendChanged: changed,
        ),
        HyperPieChart.donut(
          sections: const [HyperPieSection(label: 'a', value: 10)],
          showLegend: false,
          legendController: controller,
          onLegendChanged: changed,
        ),
        HyperRadarChart(
          indicators: const ['甲', '乙', '丙'],
          series: const [
            HyperRadarSeries(name: 'a', values: [1, 2, 3]),
          ],
          showLegend: false,
          legendController: controller,
          onLegendChanged: changed,
        ),
      ];
      for (final chart in charts) {
        controller.showAll();
        await tester.pumpWidget(host(chart));
        await tester.pumpAndSettle();
        expect(entries.single.id, 'a');
        expect(entries.single.hidden, isFalse);
        controller.setVisible('a', false);
        await tester.pumpAndSettle();
        expect(entries.single.hidden, isTrue);
        controller.showAll();
        await tester.pumpAndSettle();
        expect(entries.single.hidden, isFalse);
        expect(tester.takeException(), isNull);
      }
    },
  );
}
