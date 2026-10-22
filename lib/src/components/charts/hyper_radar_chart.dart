// Adapted from local lemon_shadcn chart implementations.
import 'hyper_chart_tokens.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'hyper_chart_pointer_tooltip.dart';
import 'hyper_chart_common.dart';

@immutable
class HyperRadarSeries {
  const HyperRadarSeries({
    required this.name,
    required this.values,
    this.color,
  });

  final String name;
  final List<double> values;
  final Color? color;
}

@immutable
class HyperRadarChartHit {
  const HyperRadarChartHit({
    required this.seriesIndex,
    required this.indicatorIndex,
    required this.series,
    required this.indicator,
    required this.value,
  });

  final int seriesIndex;
  final int indicatorIndex;
  final HyperRadarSeries series;
  final String indicator;
  final double value;
}

typedef HyperRadarChartDataBuilder = RadarChartData Function(
  RadarChartData data,
);
typedef HyperRadarChartTooltipBuilder = Widget Function(
  BuildContext context,
  HyperRadarChartHit hit,
);

class HyperRadarChart extends StatefulWidget {
  const HyperRadarChart({
    super.key,
    this.style,
    required this.indicators,
    required this.series,
    this.height,
    this.palette,
    this.tickCount = 4,
    this.showTickLabels = false,
    this.titlePositionPercentageOffset = 0.12,
    this.shape = RadarShape.polygon,
    this.showLegend = true,
    this.showTooltip = true,
    this.tooltipStyle,
    this.tooltipWidgetBuilder,
    this.interactive = true,
    this.keyboardNavigation = true,
    this.autofocus = false,
    this.semanticLabel = '雷达图，使用方向键浏览数据',
    this.onPointTap,
    this.dataBuilder,
  }) : assert(tickCount >= 1);

  final List<String> indicators;
  final List<HyperRadarSeries> series;
  final double? height;
  final List<Color>? palette;
  final int tickCount;
  final bool showTickLabels;
  final double titlePositionPercentageOffset;
  final RadarShape shape;
  final bool showLegend;
  final bool showTooltip;
  final HyperPointerTooltipStyle? tooltipStyle;
  final HyperRadarChartTooltipBuilder? tooltipWidgetBuilder;
  final bool interactive;
  final bool keyboardNavigation;
  final bool autofocus;
  final String semanticLabel;
  final ValueChanged<HyperRadarChartHit>? onPointTap;
  final HyperRadarChartDataBuilder? dataBuilder;

  final HyperChartStyle? style;

  @override
  State<HyperRadarChart> createState() => _HyperRadarChartState();
}

class _HyperRadarChartState extends State<HyperRadarChart> {
  final Set<int> _hidden = <int>{};
  Offset? _tooltipPosition;
  String? _tooltipMessage;
  HyperChartSelection? _hovered;

  @override
  Widget build(BuildContext context) {
    final chart = HyperChartTokens(context, widget.style);
    final theme = HyperTheme.of(context);
    final palette = hyperChartPalette(chart, theme.colors, widget.palette);
    final valid = widget.series.where(
      (series) => series.values.length == widget.indicators.length,
    );
    final hasData = widget.indicators.length >= 3 && valid.isNotEmpty;
    return HyperChartTheme(
      data: HyperChartThemeData(style: widget.style ?? const HyperChartStyle()),
      child: HyperChartKeyboardRegion(
        enabled: widget.keyboardNavigation && hasData,
        autofocus: widget.autofocus,
        semanticLabel: widget.semanticLabel,
        onPrevious: () => _moveKeyboard(-1),
        onNext: () => _moveKeyboard(1),
        onActivate: _activateCurrent,
        onClear: _clear,
        child: SizedBox(
          height: widget.height ?? chart.height,
          child: !hasData
              ? Center(
                  child: Text(
                    '暂无数据',
                    style: (theme.textTheme.bodySmall ?? const TextStyle())
                        .copyWith(color: theme.colors.textSecondary),
                  ),
                )
              : HyperChartLayout(
                  options: HyperChartTokens(context, widget.style).legend,
                  children: <Widget>[
                    if (widget.showLegend) ...<Widget>[
                      HyperChartLegend(
                        items: <HyperChartLegendData>[
                          for (
                            var index = 0;
                            index < widget.series.length;
                            index++
                          )
                            HyperChartLegendData(
                              label: widget.series[index].name,
                              color:
                                  widget.series[index].color ??
                                  palette[index % palette.length],
                            ),
                        ],
                        hidden: _hidden,
                        onToggle: _toggle,
                      ),
                      SizedBox(height: chart.legendSpacing),
                    ],
                    Expanded(
                      child: HyperPointerTooltipArea(
                        position: _tooltipPosition,
                        message: _tooltipMessage,
                        style:
                            widget.style?.tooltipStyle?.merge(
                              widget.tooltipStyle,
                            ) ??
                            widget.tooltipStyle,
                        builder: widget.tooltipWidgetBuilder == null
                            ? null
                            : (context, _) => widget.tooltipWidgetBuilder!(
                                context,
                                _hit(_hovered!),
                              ),
                        onExit: _clear,
                        child: RadarChart(
                          widget.dataBuilder?.call(
                                _data(theme, chart, palette),
                              ) ??
                              _data(theme, chart, palette),
                          duration:
                              MediaQuery.maybeOf(context)?.disableAnimations ==
                                  true
                              ? Duration.zero
                              : chart.animationDuration,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  RadarChartData _data(
    HyperThemeData theme,
    HyperChartTokens chart,
    List<Color> palette,
  ) => RadarChartData(
    dataSets: <RadarDataSet>[
      for (var index = 0; index < widget.series.length; index++)
        if (!_hidden.contains(index) &&
            widget.series[index].values.length == widget.indicators.length)
          RadarDataSet(
            dataEntries: <RadarEntry>[
              for (final value in widget.series[index].values)
                RadarEntry(value: value),
            ],
            borderColor:
                widget.series[index].color ?? palette[index % palette.length],
            fillColor:
                (widget.series[index].color ?? palette[index % palette.length])
                    .withValues(alpha: 0.16),
            borderWidth:
                chart.lineWidth * (_hovered?.seriesIndex == index ? 1.4 : 1),
            entryRadius:
                chart.pointRadius *
                (_hovered?.seriesIndex == index ? chart.hoverScale : 1),
          ),
    ],
    radarShape: widget.shape,
    radarBackgroundColor: Colors.transparent,
    radarBorderData: BorderSide(color: theme.colors.outline),
    gridBorderData: BorderSide(
      color: theme.colors.outline.withValues(alpha: chart.gridOpacity),
    ),
    tickBorderData: BorderSide(
      color: theme.colors.outline.withValues(alpha: chart.gridOpacity),
    ),
    tickCount: widget.tickCount,
    ticksTextStyle: widget.showTickLabels
        ? hyperChartAxisStyle(theme, chart)
        : const TextStyle(color: Colors.transparent, fontSize: 0),
    titleTextStyle: hyperChartAxisStyle(
      theme,
      chart,
    ).copyWith(color: theme.colors.textPrimary),
    titlePositionPercentageOffset: widget.titlePositionPercentageOffset,
    getTitle: (index, _) => RadarChartTitle(text: widget.indicators[index]),
    radarTouchData: RadarTouchData(
      enabled: widget.interactive,
      touchCallback: _handleTouch,
      mouseCursorResolver: (_, response) => response?.touchedSpot == null
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
    ),
  );

  void _handleTouch(FlTouchEvent event, RadarTouchResponse? response) {
    final spot = response?.touchedSpot;
    if (spot == null) {
      _clear();
      return;
    }
    final visible = <int>[
      for (var index = 0; index < widget.series.length; index++)
        if (!_hidden.contains(index) &&
            widget.series[index].values.length == widget.indicators.length)
          index,
    ];
    final seriesIndex = visible[spot.touchedDataSetIndex];
    final hit = HyperRadarChartHit(
      seriesIndex: seriesIndex,
      indicatorIndex: spot.touchedRadarEntryIndex,
      series: widget.series[seriesIndex],
      indicator: widget.indicators[spot.touchedRadarEntryIndex],
      value: spot.touchedRadarEntry.value,
    );
    setState(() {
      _hovered = HyperChartSelection(hit.indicatorIndex, hit.seriesIndex);
      _tooltipPosition = response?.touchLocation;
      _tooltipMessage = widget.showTooltip
          ? '${hit.indicator}\n${hit.series.name}: ${hyperChartNumber(hit.value)}'
          : null;
    });
    if (event is FlTapUpEvent) widget.onPointTap?.call(hit);
  }

  List<HyperChartSelection> get _keyboardItems => <HyperChartSelection>[
    for (var seriesIndex = 0; seriesIndex < widget.series.length; seriesIndex++)
      if (!_hidden.contains(seriesIndex) &&
          widget.series[seriesIndex].values.length == widget.indicators.length)
        for (
          var indicatorIndex = 0;
          indicatorIndex < widget.indicators.length;
          indicatorIndex++
        )
          HyperChartSelection(indicatorIndex, seriesIndex),
  ];

  HyperRadarChartHit _hit(HyperChartSelection selection) {
    final series = widget.series[selection.seriesIndex];
    return HyperRadarChartHit(
      seriesIndex: selection.seriesIndex,
      indicatorIndex: selection.groupIndex,
      series: series,
      indicator: widget.indicators[selection.groupIndex],
      value: series.values[selection.groupIndex],
    );
  }

  void _moveKeyboard(int delta) {
    final items = _keyboardItems;
    if (items.isEmpty) return;
    final current = _hovered == null ? -1 : items.indexOf(_hovered!);
    final next = current < 0
        ? (delta > 0 ? 0 : items.length - 1)
        : hyperChartLoopIndex(current, delta, items.length);
    setState(() {
      _hovered = items[next];
      _tooltipPosition = null;
      _tooltipMessage = null;
    });
  }

  void _activateCurrent() {
    final items = _keyboardItems;
    if (items.isEmpty) return;
    final selection = _hovered ?? items.first;
    if (_hovered == null) {
      setState(() => _hovered = selection);
    }
    final series = widget.series[selection.seriesIndex];
    widget.onPointTap?.call(
      HyperRadarChartHit(
        seriesIndex: selection.seriesIndex,
        indicatorIndex: selection.groupIndex,
        series: series,
        indicator: widget.indicators[selection.groupIndex],
        value: series.values[selection.groupIndex],
      ),
    );
  }

  void _toggle(int index) {
    if (!_hidden.contains(index) &&
        _hidden.length >= widget.series.length - 1) {
      return;
    }
    setState(() {
      _hidden.contains(index) ? _hidden.remove(index) : _hidden.add(index);
      _hovered = null;
      _tooltipPosition = null;
      _tooltipMessage = null;
    });
  }

  void _clear() {
    if (_tooltipPosition == null &&
        _tooltipMessage == null &&
        _hovered == null) {
      return;
    }
    setState(() {
      _hovered = null;
      _tooltipPosition = null;
      _tooltipMessage = null;
    });
  }
}
