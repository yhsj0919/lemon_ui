import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui/src/components/charts/hyper_chart_pointer_tooltip.dart';

void main() {
  testWidgets('line hover uses structured default content and stays compact', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: Scaffold(
            body: HyperLineChart(
              showLegend: false,
              series: const [
                HyperLineSeries(
                  name: '访问量',
                  color: Colors.blue,
                  points: [
                    HyperLinePoint(x: 0, y: 12, label: '周一'),
                    HyperLinePoint(x: 1, y: 26, label: '周二'),
                  ],
                ),
                HyperLineSeries(
                  name: '成交量',
                  color: Colors.green,
                  points: [
                    HyperLinePoint(x: 0, y: 8, label: '周一'),
                    HyperLinePoint(x: 1, y: 16, label: '周二'),
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
    final bar = data.lineBarsData.first;
    final secondBar = data.lineBarsData.last;
    data.lineTouchData.touchCallback!(
      const FlPointerHoverEvent(PointerHoverEvent(position: Offset(100, 100))),
      LineTouchResponse(
        touchLocation: const Offset(100, 100),
        touchChartCoordinate: const Offset(100, 100),
        lineBarSpots: [
          TouchLineBarSpot(bar, 0, bar.spots[1], 1),
          TouchLineBarSpot(secondBar, 1, secondBar.spots[1], 1),
        ],
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(HyperChartTooltipContent), findsOneWidget);
    expect(
      tester.getSize(find.byType(HyperChartTooltipContent)).width,
      lessThan(300),
    );
    expect(tester.widget<Text>(find.text('26')).style!.color, Colors.blue);
    final name = tester.getRect(find.text('访问量'));
    final value = tester.getRect(find.text('26'));
    final secondValue = tester.getRect(find.text('16'));
    expect(name.width, greaterThan(30), reason: '松约束浮层中名称列不能被压成零宽');
    expect(
      name.height,
      closeTo(value.height, .01),
      reason: '名称不能被压成逐字换行，撑高数据行',
    );
    expect(name.right, lessThan(value.left));
    expect(secondValue.right, closeTo(value.right, .01));
    expect(secondValue.top - value.bottom, lessThan(10), reason: '数据行应紧凑排列');
    expect(tester.takeException(), isNull);
  });
  for (final scale in [1.0, 1.3, 2.0]) {
    for (final width in [160.0, 280.0]) {
      testWidgets(
        'default tooltip aligns columns and honors text scaling at $width / $scale',
        (tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: HyperTheme(
                data: HyperThemeData.light(),
                child: MediaQuery(
                  data: MediaQueryData(textScaler: TextScaler.linear(scale)),
                  child: Scaffold(
                    body: Center(
                      child: SizedBox(
                        width: width,
                        child: const HyperChartTooltipContent(
                          title: '周二',
                          rows: [
                            HyperChartTooltipRow(
                              label: '访问量',
                              value: '26 次',
                              color: Colors.blue,
                            ),
                            HyperChartTooltipRow(
                              label: '成交量',
                              value: '1600 次',
                              color: Colors.green,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          final title = tester.widget<Text>(find.text('周二'));
          expect(title.style!.fontWeight, FontWeight.w600);
          final first = tester.getRect(find.text('26 次'));
          final second = tester.getRect(find.text('1600 次'));
          expect(first.right, closeTo(second.right, .01));
          expect(
            tester.getRect(find.text('访问量')).left,
            closeTo(tester.getRect(find.text('成交量')).left, .01),
          );
          expect(
            tester.getRect(find.text('访问量')).top,
            greaterThan(tester.getRect(find.text('周二')).bottom),
          );
          expect(
            tester.widget<Text>(find.text('26 次')).style!.color,
            Colors.blue,
          );
          expect(
            tester.widget<Text>(find.text('1600 次')).style!.color,
            Colors.green,
          );
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}
