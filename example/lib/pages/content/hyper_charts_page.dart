import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

class HyperChartsPage extends StatefulWidget {
  const HyperChartsPage({super.key, this.datasetLoader});
  final Future<HyperLineChartDataset> Function(int count)? datasetLoader;
  @override
  State<HyperChartsPage> createState() => _HyperChartsPageState();
}

class _HyperChartsPageState extends State<HyperChartsPage> {
  HyperChartLegendPosition _position = HyperChartLegendPosition.top;
  Axis _direction = Axis.horizontal;
  HyperLineChartDataset? _large;
  HyperChartViewportController? _viewport;
  bool _preparing = false;
  int _request = 0;
  String? _loadError;
  int? _prepareMilliseconds;
  int _count = 8760;
  final _export = HyperChartExportController();
  String _exportStatus = '';
  Uint8List? _exportPreview;
  final _externalLegendController = HyperChartLegendController();
  List<HyperChartLegendEntry> _externalLegend = const [];
  @override
  void dispose() {
    _request++;
    _viewport?.dispose();
    _externalLegendController.dispose();
    super.dispose();
  }

  Future<void> _loadYear(int count) async {
    final request = ++_request;
    setState(() {
      _count = count;
      _preparing = true;
      _loadError = null;
    });
    final watch = Stopwatch()..start();
    try {
      final data =
          await (widget.datasetLoader?.call(count) ??
              HyperLineChartDataset.generate(count, _generateYearSeries));
      if (!mounted || request != _request) return;
      final previous = _viewport;
      setState(() {
        _large = data;
        _viewport = HyperChartViewportController(
          domain: data.domain!,
          minimumSpan: 1,
        );
        _prepareMilliseconds = watch.elapsedMilliseconds;
        _preparing = false;
      });
      previous?.dispose();
    } catch (error) {
      if (mounted && request == _request) {
        setState(() {
          _preparing = false;
          _loadError = '准备失败：$error';
        });
      }
    }
  }

  static const _lines = [
    HyperLineSeries(
      name: '访问量',
      points: [
        HyperLinePoint(x: 0, y: 12, label: '周一'),
        HyperLinePoint(x: 1, y: 26, label: '周二'),
        HyperLinePoint(x: 2, y: 18, label: '周三'),
        HyperLinePoint(x: 3, y: 38, label: '周四'),
        HyperLinePoint(x: 4, y: 30, label: '周五'),
      ],
    ),
    HyperLineSeries(
      name: '成交量',
      points: [
        HyperLinePoint(x: 0, y: 8),
        HyperLinePoint(x: 1, y: 16),
        HyperLinePoint(x: 2, y: 12),
        HyperLinePoint(x: 3, y: 20),
        HyperLinePoint(x: 4, y: 22),
      ],
    ),
  ];
  static const _groups = [
    HyperBarGroup(
      label: '周一',
      values: [HyperBarValue(value: 12), HyperBarValue(value: 8)],
    ),
    HyperBarGroup(
      label: '周二',
      values: [HyperBarValue(value: 26), HyperBarValue(value: 16)],
    ),
    HyperBarGroup(
      label: '周三',
      values: [HyperBarValue(value: 18), HyperBarValue(value: 12)],
    ),
  ];
  static const _series = [
    HyperBarSeries(name: '访问量'),
    HyperBarSeries(name: '成交量'),
  ];
  static const _pie = [
    HyperPieSection(label: '桌面端', value: 56),
    HyperPieSection(label: '移动端', value: 31),
    HyperPieSection(label: '其他', value: 13),
  ];

  @override
  Widget build(BuildContext context) {
    final sizes = HyperTheme.sizesOf(context);
    final style =
        _position == HyperChartLegendPosition.top &&
            _direction == Axis.horizontal
        ? null
        : HyperChartStyle(
            legend: HyperChartLegendOptions(
              position: _position,
              direction: _direction,
            ),
          );
    Widget title(String text) => Padding(
      padding: EdgeInsets.only(
        top: sizes.sectionSpacing,
        bottom: sizes.compactSectionSpacing,
      ),
      child: HyperText(text),
    );
    return SingleChildScrollView(
      // The gallery surface owns the outer clearance; chart labels retain
      // their positions relative to the data and axes.
      padding: EdgeInsets.all(
        sizes.pageHorizontalPadding + sizes.compactSectionSpacing,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const HyperText('图表'),
          const HyperText('默认主题预览。图例可点击隐藏数据，鼠标悬停或键盘方向键查看数据。'),
          title('图例位置与排列（显式实例覆盖）'),
          Wrap(
            spacing: sizes.navigationItemSpacing,
            children: [
              for (final entry in const {
                HyperChartLegendPosition.top: '上方',
                HyperChartLegendPosition.bottom: '下方',
                HyperChartLegendPosition.left: '左侧',
                HyperChartLegendPosition.right: '右侧',
              }.entries)
                HyperButton.outlined(
                  onPressed: () => setState(() => _position = entry.key),
                  child: Text(entry.value),
                ),
              HyperButton.outlined(
                onPressed: () => setState(
                  () => _direction = _direction == Axis.horizontal
                      ? Axis.vertical
                      : Axis.horizontal,
                ),
                child: Text(_direction == Axis.horizontal ? '图例横排' : '图例竖排'),
              ),
            ],
          ),
          title('折线图 · 默认鼠标跟随提示'),
          HyperChartExportBoundary(
            controller: _export,
            child: HyperLineChart(series: _lines, style: style),
          ),
          HyperButton.outlined(
            onPressed: () async {
              final bytes = await _export.capturePng();
              if (mounted) {
                setState(() {
                  _exportPreview = bytes;
                  _exportStatus =
                      '已生成完整 PNG（不含鼠标提示）：${bytes.length} 字节，下方为实际导出图片';
                });
              }
            },
            child: const Text('测试导出 PNG'),
          ),
          HyperText(_exportStatus),
          if (_exportPreview != null)
            Image.memory(_exportPreview!, fit: BoxFit.contain),
          title('面积图'),
          HyperLineChart.area(series: _lines, style: style),
          title('外部图例（独立绘制，共享显隐）'),
          const HyperText('图例由回调提供，可放在任意位置；下方两个图表共用控制器。'),
          Wrap(
            spacing: sizes.navigationItemSpacing,
            children: [
              for (final item in _externalLegend)
                HyperButton.outlined(
                  onPressed: () => _externalLegendController.toggle(item.id),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item.hidden
                            ? Icons.visibility_off_outlined
                            : Icons.circle,
                        color: item.color,
                        size: sizes.chart.labelFontSize,
                      ),
                      SizedBox(width: sizes.navigationItemSpacing),
                      Text(item.label),
                    ],
                  ),
                ),
              HyperButton.outlined(
                onPressed: _externalLegendController.showAll,
                child: const Text('显示全部图例'),
              ),
            ],
          ),
          HyperLineChart(
            series: _lines,
            showLegend: false,
            legendController: _externalLegendController,
            onLegendChanged: (items) => setState(() => _externalLegend = items),
          ),
          HyperLineChart.area(
            series: _lines,
            showLegend: false,
            legendController: _externalLegendController,
          ),
          title('阶梯图'),
          HyperLineChart.step(series: _lines, style: style),
          title('纵向分组柱状图'),
          HyperBarChart(groups: _groups, series: _series, style: style),
          title('纵向堆叠柱状图'),
          HyperBarChart.stacked(groups: _groups, series: _series, style: style),
          title('横向分组柱状图'),
          HyperBarChart.horizontal(
            groups: _groups,
            series: _series,
            style: style,
          ),
          title('横向堆叠柱状图'),
          HyperBarChart.horizontalStacked(
            groups: _groups,
            series: _series,
            style: style,
          ),
          title('饼图 · 外部指示线'),
          HyperPieChart(sections: _pie, showLeaderLabels: true, style: style),
          title('环形图 · 自定义指示文字'),
          HyperPieChart.donut(
            sections: _pie,
            showLeaderLabels: true,
            style: style,
            leaderLabelFormatter: (hit, percent) =>
                '${hit.section.label}\n${percent.toStringAsFixed(0)}%',
          ),
          title('散点图'),
          HyperScatterChart(
            style: style,
            series: const [
              HyperScatterSeries(
                name: '样本',
                points: [
                  HyperScatterPoint(x: 1, y: 3),
                  HyperScatterPoint(x: 2, y: 5),
                  HyperScatterPoint(x: 4, y: 2),
                ],
              ),
            ],
          ),
          title('雷达图'),
          HyperRadarChart(
            style: style,
            indicators: const ['速度', '质量', '容量', '稳定'],
            series: const [
              HyperRadarSeries(name: '方案一', values: [8, 6, 9, 7]),
              HyperRadarSeries(name: '方案二', values: [6, 9, 7, 8]),
            ],
          ),
          title('排名条形图'),
          const HyperRankBarChart(
            items: [
              HyperRankBarItem(label: '桌面端', value: 56),
              HyperRankBarItem(label: '移动端', value: 31),
              HyperRankBarItem(label: '其他', value: 13),
            ],
          ),
          title('K 线图'),
          const HyperCandlestickChart(
            data: [
              HyperCandlestickData(open: 10, high: 18, low: 8, close: 16),
              HyperCandlestickData(open: 16, high: 20, low: 12, close: 14),
              HyperCandlestickData(open: 14, high: 22, low: 13, close: 20),
            ],
          ),
          title('一年数据 · 性能测试入口'),
          const HyperText('横轴显式倾斜 45°。这里只提供测试数据与采样预览，不代表已通过真实性能压测。'),
          Wrap(
            spacing: sizes.navigationItemSpacing,
            children: [
              for (final entry in const {
                365: '每天',
                8760: '每小时',
                525600: '每分钟',
              }.entries)
                HyperButton.outlined(
                  onPressed: () => _loadYear(entry.key),
                  child: Text('${entry.value}（${entry.key} 点）'),
                ),
            ],
          ),
          if (_preparing) ...[
            const HyperProgress.infinite(),
            HyperText('正在准备 $_count 个数据点…'),
          ],
          if (_loadError != null) HyperText(_loadError!),
          if (_large != null && _viewport != null) ...[
            HyperText(
              '共 ${_large!.pointCount} 点，准备耗时 ${_prepareMilliseconds ?? 0} ms（当前运行模式，仅供对比）',
            ),
            Wrap(
              spacing: sizes.navigationItemSpacing,
              children: [
                HyperButton.outlined(
                  onPressed: () => _viewport!.zoom(2),
                  child: const Text('放大'),
                ),
                HyperButton.outlined(
                  onPressed: () => _viewport!.zoom(.5),
                  child: const Text('缩小'),
                ),
                HyperButton.outlined(
                  onPressed: () => _viewport!.pan(-_viewport!.range.span / 4),
                  child: const Text('向前'),
                ),
                HyperButton.outlined(
                  onPressed: () => _viewport!.pan(_viewport!.range.span / 4),
                  child: const Text('向后'),
                ),
                HyperButton.outlined(
                  onPressed: () => _viewport!.reset(),
                  child: const Text('恢复全量'),
                ),
              ],
            ),
            ListenableBuilder(
              listenable: _viewport!,
              builder: (context, _) => HyperText(
                '可见范围：第 ${_viewport!.range.min.round()} 至 ${_viewport!.range.max.round()} 次；可横向拖动绘图区',
              ),
            ),
            HyperLineChart(
              series: _large!.series,
              preparedData: _large,
              viewportController: _viewport,
              panEnabled: true,
              maxRenderedPoints: 1000,
              xAxis: HyperChartAxis(
                labelRotation: -45,
                formatter: (v) => '第 ${v.round()} 次',
              ),
              style: style,
            ),
          ],
        ],
      ),
    );
  }
}

List<HyperLineSeries> _generateYearSeries(int count) => [
  HyperLineSeries(
    name: '一年数据',
    showPoints: false,
    points: List.generate(
      count,
      (i) => HyperLinePoint(
        x: i.toDouble(),
        y: 50 + math.sin(i * .05) * 20 + math.cos(i * .001) * 10,
      ),
    ),
  ),
];
