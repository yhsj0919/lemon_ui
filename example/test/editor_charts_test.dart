import 'package:flutter/material.dart';

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/editor/editor_theme_document.dart';
import 'package:lemon_ui_example/editor/editor_chart_fields.dart';
import 'package:lemon_ui_example/editor/editor_dimension_limits.dart';
import 'package:lemon_ui_example/gallery/gallery_registry.dart';
import 'package:lemon_ui_example/pages/content/hyper_charts_page.dart';

void main() {
  testWidgets(
    'year-data demo discards stale loads, zooms and restores its viewport',
    (tester) async {
      final small = await tester.runAsync(
        () => HyperLineChartDataset.prepare([
          HyperLineSeries(
            name: '旧数据',
            points: List.generate(
              365,
              (i) => HyperLinePoint(x: i.toDouble(), y: (i % 10).toDouble()),
            ),
          ),
        ]),
      );
      final large = await tester.runAsync(
        () => HyperLineChartDataset.prepare([
          HyperLineSeries(
            name: '新数据',
            points: List.generate(
              8760,
              (i) => HyperLinePoint(x: i.toDouble(), y: (i % 10).toDouble()),
            ),
          ),
        ]),
      );
      final first = Completer<HyperLineChartDataset>(),
          second = Completer<HyperLineChartDataset>();
      await tester.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: HyperThemeData.light(),
            child: Scaffold(
              body: HyperChartsPage(
                datasetLoader: (count) =>
                    count == 365 ? first.future : second.future,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('每天（365 点）'));
      await tester.tap(find.text('每天（365 点）'));
      await tester.pump();
      expect(find.text('正在准备 365 个数据点…'), findsOneWidget);
      await tester.ensureVisible(find.text('每小时（8760 点）'));
      await tester.tap(find.text('每小时（8760 点）'));
      await tester.pump();
      second.complete(large!);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(
        tester
            .widget<HyperLineChart>(
              find.byWidgetPredicate(
                (widget) =>
                    widget is HyperLineChart && widget.preparedData != null,
              ),
            )
            .preparedData!
            .pointCount,
        8760,
      );
      first.complete(small!);
      await tester.pumpAndSettle();
      final finder = find.byWidgetPredicate(
        (widget) => widget is HyperLineChart && widget.preparedData != null,
      );
      final chart = tester.widget<HyperLineChart>(finder);
      expect(chart.preparedData!.pointCount, 8760);
      expect(chart.viewportController!.isFullRange, isTrue);
      await tester.ensureVisible(find.text('放大'));
      await tester.tap(find.text('放大'));
      await tester.pumpAndSettle();
      expect(chart.viewportController!.range.span, closeTo(8759 / 2, .001));
      await tester.tap(find.text('恢复全量'));
      await tester.pumpAndSettle();
      expect(chart.viewportController!.isFullRange, isTrue);
      expect(tester.takeException(), isNull);
    },
  );
  test('related chart geometry changes constrain explicit values and save integers', () {
    final metrics = EditorChartMetrics()
      ..barWidth = 10
      ..radius = 60.5
      ..height = 100
      ..pieRadius = 40
      ..donutHoleRadius = 40.2;
    constrainEditorChartDimensions(
      metrics,
      const HyperChartSize(),
      const Size(300, 400),
    );
    expect(metrics.radius, 5);
    expect(metrics.donutHoleRadius, 10);
    expect(metrics.toJson()['radius'], 5);
    metrics.barWidth = 3;
    constrainEditorChartDimensions(
      metrics,
      const HyperChartSize(),
      const Size(300, 400),
    );
    expect(metrics.radius, 1);
    expect(editorChartRadiusLimit(const Size(30, 100), 20, 40), 0);
    metrics.radius = null;
    expect(metrics.resolve(const HyperChartSize()).radius, 5);
  });
  test('confirmed chart registration preserves ID, device geometry and appearance round trip', () {
    final section = gallerySections.singleWhere(
      (section) => section.title == '文字与内容',
    );
    expect(section.items.any((item) => item.id == 'hyper-charts'), isTrue);
    final doc = EditorThemeDocument();
    doc.desktop.chartMetrics
      ..height = 320
      ..lineWidth = 4
      ..pointRadius = 5;
    doc.light.chartVisual
      ..gridOpacity = .2
      ..legendPosition = HyperChartLegendPosition.right;
    final restored = EditorThemeDocument.decode(doc.encode());
    expect(restored.encode(), doc.encode());
    for (final dark in [false, true]) {
      expect(restored.resolve(dark).sizes.desktop.chart.height, 320);
      expect(restored.resolve(dark).sizes.phone.chart.height, 280);
    }
    expect(restored.resolve(false).chartTheme.style.gridOpacity, .2);
    expect(restored.resolve(true).chartTheme.style.gridOpacity, isNull);
    restored.desktop.chartMetrics.height = null;
    expect(restored.resolve(false).sizes.desktop.chart.height, 280);
    expect(
      () => EditorChartVisual.fromJson({'inactiveOpacity': 2}),
      throwsFormatException,
    );
    expect(
      () => EditorChartMetrics.fromJson({'height': double.nan}),
      throwsFormatException,
    );
  });

  testWidgets('complete chart demo builds and switches legend position', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: const Scaffold(body: HyperChartsPage()),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('图表'), findsOneWidget);
    await tester.tap(find.text('右侧'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
