import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

class HyperChartsPage extends StatefulWidget {
  const HyperChartsPage({super.key});
  @override
  State<HyperChartsPage> createState() => _HyperChartsPageState();
}

class _HyperChartsPageState extends State<HyperChartsPage> {
  HyperChartLegendPosition _position = HyperChartLegendPosition.top;
  Axis _direction = Axis.horizontal;
  List<HyperLineSeries>? _large;
  int _count = 8760;
  final _export = HyperChartExportController();
  String _exportStatus = '';
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
      padding: EdgeInsets.all(sizes.pageHorizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const HyperText('图表 · 未确认'),
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
          title('折线图 · 自定义鼠标跟随提示'),
          HyperChartExportBoundary(
            controller: _export,
            child: HyperLineChart(
              series: _lines,
              style: style,
              tooltipWidgetBuilder: (context, data) => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HyperText(data.xLabel),
                  for (final item in data.items)
                    HyperText(
                      '${item.hit.series.name}：${item.formattedValue} 次',
                    ),
                ],
              ),
            ),
          ),
          HyperButton.outlined(
            onPressed: () async {
              final bytes = await _export.capturePng();
              if (mounted) {
                setState(
                  () => _exportStatus = '已生成 PNG：${bytes.length} 字节，可交给应用保存或分享',
                );
              }
            },
            child: const Text('测试导出 PNG'),
          ),
          HyperText(_exportStatus),
          title('面积图'),
          HyperLineChart.area(series: _lines, style: style),
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
                  onPressed: () => setState(() {
                    _count = entry.key;
                    _large = [
                      HyperLineSeries(
                        name: '一年数据',
                        showPoints: false,
                        points: List.generate(
                          _count,
                          (i) => HyperLinePoint(
                            x: i.toDouble(),
                            y:
                                50 +
                                math.sin(i * .05) * 20 +
                                math.cos(i * .001) * 10,
                          ),
                        ),
                      ),
                    ];
                  }),
                  child: Text('${entry.value}（${entry.key} 点）'),
                ),
            ],
          ),
          if (_large != null)
            HyperLineChart(
              series: _large!,
              maxRenderedPoints: 1000,
              xAxis: HyperChartAxis(
                labelRotation: -45,
                formatter: (v) => '第 ${v.round()} 次',
              ),
              style: style,
            ),
        ],
      ),
    );
  }
}
