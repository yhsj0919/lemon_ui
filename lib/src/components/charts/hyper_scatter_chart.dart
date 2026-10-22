// Adapted from local lemon_shadcn chart implementations.
import 'hyper_chart_tokens.dart';

import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'hyper_chart_pointer_tooltip.dart';
import 'hyper_chart_common.dart';

typedef HyperScatterChartTapCallback = void Function(HyperScatterChartHit hit);
typedef HyperScatterChartTooltipBuilder = Widget Function(
  BuildContext context,
  HyperScatterChartHit hit,
);
typedef HyperScatterChartDataBuilder = ScatterChartData Function(
  ScatterChartData data,
);

@immutable
class HyperScatterPoint {
  const HyperScatterPoint({
    required this.x,
    required this.y,
    this.label,
    this.color,
    this.radius,
  });

  final double x;
  final double y;
  final String? label;
  final Color? color;
  final double? radius;
}

@immutable
class HyperScatterSeries {
  const HyperScatterSeries({
    required this.name,
    required this.points,
    this.color,
  });

  final String name;
  final List<HyperScatterPoint> points;
  final Color? color;
}

@immutable
class HyperScatterChartHit {
  const HyperScatterChartHit({
    required this.selection,
    required this.series,
    required this.point,
  });

  final HyperChartSelection selection;
  final HyperScatterSeries series;
  final HyperScatterPoint point;
}

class HyperScatterChart extends StatefulWidget {
  const HyperScatterChart({
    super.key,
    this.style,
    required this.series,
    this.xAxis = const HyperChartAxis(),
    this.yAxis = const HyperChartAxis(),
    this.height,
    this.palette,
    this.showGrid = true,
    this.showTooltip = true,
    this.tooltipStyle,
    this.tooltipWidgetBuilder,
    this.showLegend = true,
    this.interactive = true,
    this.keyboardNavigation = true,
    this.autofocus = false,
    this.maxRenderedPointsPerSeries = 1000,
    this.samplingStrategy = HyperChartSamplingStrategy.none,
    this.semanticLabel = '散点图，使用方向键浏览数据',
    this.selectionEnabled = false,
    this.selected = const <HyperChartSelection>{},
    this.onSelectionChanged,
    this.onPointTap,
    this.dataBuilder,
  });

  final List<HyperScatterSeries> series;
  final HyperChartAxis xAxis;
  final HyperChartAxis yAxis;
  final double? height;
  final List<Color>? palette;
  final bool showGrid;
  final bool showTooltip;
  final HyperPointerTooltipStyle? tooltipStyle;
  final HyperScatterChartTooltipBuilder? tooltipWidgetBuilder;
  final bool showLegend;
  final bool interactive;
  final bool keyboardNavigation;
  final bool autofocus;
  final int? maxRenderedPointsPerSeries;
  final HyperChartSamplingStrategy samplingStrategy;
  final String semanticLabel;
  final bool selectionEnabled;
  final Set<HyperChartSelection> selected;
  final ValueChanged<Set<HyperChartSelection>>? onSelectionChanged;
  final HyperScatterChartTapCallback? onPointTap;
  final HyperScatterChartDataBuilder? dataBuilder;

  final HyperChartStyle? style;

  @override
  State<HyperScatterChart> createState() => _HyperScatterChartState();
}

class _HyperScatterChartState extends State<HyperScatterChart> {
  final Set<int> _hiddenSeries = <int>{};
  Set<HyperChartSelection> _internalSelected = <HyperChartSelection>{};
  HyperChartSelection? _hovered;
  Offset? _tooltipPosition;
  String? _tooltipMessage;

  bool get _controlled => widget.onSelectionChanged != null;
  Set<HyperChartSelection> get _selected => widget.selectionEnabled
      ? (_controlled ? widget.selected : _internalSelected)
      : const <HyperChartSelection>{};

  @override
  void initState() {
    super.initState();
    _internalSelected = Set<HyperChartSelection>.of(widget.selected);
  }

  @override
  void didUpdateWidget(covariant HyperScatterChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_controlled && oldWidget.selected != widget.selected) {
      _internalSelected = Set<HyperChartSelection>.of(widget.selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final chart = HyperChartTokens(context, widget.style);
    final theme = HyperTheme.of(context);
    final palette = hyperChartPalette(chart, theme.colors, widget.palette);
    final flattened = _flattened;
    return HyperChartTheme(
      data: HyperChartThemeData(style: widget.style ?? const HyperChartStyle()),
      child: HyperChartKeyboardRegion(
        enabled: widget.keyboardNavigation && flattened.isNotEmpty,
        autofocus: widget.autofocus,
        semanticLabel: widget.semanticLabel,
        onPrevious: () => _moveKeyboard(-1),
        onNext: () => _moveKeyboard(1),
        onActivate: _activateCurrent,
        onClear: _clearKeyboard,
        child: SizedBox(
          height: widget.height ?? chart.height,
          child: flattened.isEmpty
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
                        hidden: _hiddenSeries,
                        onToggle: (index) => setState(() {
                          if (!_hiddenSeries.contains(index) &&
                              _hiddenSeries.length >=
                                  widget.series.length - 1) {
                            return;
                          }
                          _hiddenSeries.contains(index)
                              ? _hiddenSeries.remove(index)
                              : _hiddenSeries.add(index);
                        }),
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
                        onExit: _clearHover,
                        child: Builder(
                          builder: (context) {
                            final data = _data(
                              theme,
                              chart,
                              palette,
                              flattened,
                            );
                            return ScatterChart(
                              widget.dataBuilder?.call(data) ?? data,
                              duration:
                                  MediaQuery.maybeOf(context)
                                          ?.disableAnimations ==
                                      true
                                  ? Duration.zero
                                  : chart.animationDuration,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  List<_HyperScatterEntry> get _flattened => <_HyperScatterEntry>[
    for (var seriesIndex = 0; seriesIndex < widget.series.length; seriesIndex++)
      if (!_hiddenSeries.contains(seriesIndex))
        for (final pointIndex in _sampledPointIndices(seriesIndex))
          _HyperScatterEntry(seriesIndex, pointIndex),
  ];

  List<int> _sampledPointIndices(int seriesIndex) {
    final points = widget.series[seriesIndex].points;
    final limit = widget.maxRenderedPointsPerSeries;
    if (limit == null || limit < 3) {
      return List<int>.generate(points.length, (index) => index);
    }
    return hyperChartSampleIndices<HyperScatterPoint>(
      points,
      maxPoints: limit,
      x: (point) => point.x,
      y: (point) => point.y,
      strategy: widget.samplingStrategy,
    );
  }

  ScatterChartData _data(
    HyperThemeData theme,
    HyperChartTokens chart,
    List<Color> palette,
    List<_HyperScatterEntry> flattened,
  ) {
    final points = <HyperScatterPoint>[
      for (
        var seriesIndex = 0;
        seriesIndex < widget.series.length;
        seriesIndex++
      )
        if (!_hiddenSeries.contains(seriesIndex))
          ...widget.series[seriesIndex].points,
    ];
    final rawMinX = points.map((e) => e.x).reduce(math.min);
    final rawMaxX = points.map((e) => e.x).reduce(math.max);
    final rawMinY = points.map((e) => e.y).reduce(math.min);
    final rawMaxY = points.map((e) => e.y).reduce(math.max);
    final xPadding = math.max((rawMaxX - rawMinX).abs() * 0.06, 0.5);
    final yPadding = math.max((rawMaxY - rawMinY).abs() * 0.06, 0.5);
    final minX = widget.xAxis.min ?? rawMinX - xPadding;
    final maxX = widget.xAxis.max ?? rawMaxX + xPadding;
    final minY = widget.yAxis.min ?? rawMinY - yPadding;
    final maxY = widget.yAxis.max ?? rawMaxY + yPadding;
    final style = hyperChartAxisStyle(theme, chart);
    return ScatterChartData(
      minX: minX,
      maxX: maxX == minX ? minX + 1 : maxX,
      minY: minY,
      maxY: maxY == minY ? minY + 1 : maxY,
      borderData: FlBorderData(show: false),
      gridData: FlGridData(
        show: widget.showGrid,
        drawVerticalLine: true,
        horizontalInterval: widget.yAxis.interval,
        verticalInterval: widget.xAxis.interval,
        getDrawingHorizontalLine: (_) => FlLine(
          color: theme.colors.outline.withValues(alpha: chart.gridOpacity),
          strokeWidth: 1,
        ),
        getDrawingVerticalLine: (_) => FlLine(
          color: theme.colors.outline.withValues(alpha: chart.gridOpacity),
          strokeWidth: 1,
        ),
      ),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: _axis(widget.xAxis, style, false, chart, minX, maxX),
        leftTitles: _axis(widget.yAxis, style, true, chart, minY, maxY),
      ),
      scatterSpots: <ScatterSpot>[
        for (final entry in flattened) _spot(entry, chart, palette),
      ],
      scatterTouchData: ScatterTouchData(
        enabled: widget.interactive,
        handleBuiltInTouches: false,
        touchSpotThreshold: 12,
        touchCallback: (event, response) =>
            _handleTouch(event, response, flattened),
        mouseCursorResolver: (_, response) => response?.touchedSpot == null
            ? SystemMouseCursors.basic
            : SystemMouseCursors.click,
      ),
    );
  }

  ScatterSpot _spot(
    _HyperScatterEntry entry,
    HyperChartTokens chart,
    List<Color> palette,
  ) {
    final point = _point(entry);
    final selection = HyperChartSelection(entry.pointIndex, entry.seriesIndex);
    final active = _hovered == selection || _selected.contains(selection);
    final hasActive = _hovered != null || _selected.isNotEmpty;
    final base =
        point.color ??
        widget.series[entry.seriesIndex].color ??
        palette[entry.seriesIndex % palette.length];
    return ScatterSpot(
      point.x,
      point.y,
      dotPainter: FlDotCirclePainter(
        radius:
            (point.radius ?? chart.pointRadius + 1) *
            (active ? chart.hoverScale : 1),
        color: base.withValues(
          alpha: hasActive && !active ? chart.inactiveOpacity : 1,
        ),
        strokeWidth: active ? 2 : 1.5,
        strokeColor: HyperTheme.of(context).colors.background,
      ),
    );
  }

  AxisTitles _axis(
    HyperChartAxis axis,
    TextStyle style,
    bool vertical,
    HyperChartTokens chart,
    double min,
    double max,
  ) => AxisTitles(
    axisNameWidget: !axis.show || axis.title == null
        ? null
        : Text(axis.title!, style: style, maxLines: 1),
    axisNameSize: !axis.show || axis.title == null ? 0 : 20,
    sideTitles: SideTitles(
      showTitles: axis.show,
      minIncluded: axis.min != null,
      maxIncluded: axis.max != null,
      reservedSize:
          axis.reservedSize ??
          (vertical
              ? hyperChartAxisReservedWidth(
                  hyperChartValueAxisLabels(min, max, axis.formatter),
                  style,
                  chart,
                )
              : 26),
      interval: axis.interval,
      getTitlesWidget: (value, meta) => SideTitleWidget(
        meta: meta,
        space: 6,
        child: Text(
          axis.formatter?.call(value) ?? hyperChartNumber(value),
          style: style,
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ),
  );

  void _handleTouch(
    FlTouchEvent event,
    ScatterTouchResponse? response,
    List<_HyperScatterEntry> flattened,
  ) {
    final index = response?.touchedSpot?.spotIndex;
    final entry = index == null || index < 0 || index >= flattened.length
        ? null
        : flattened[index];
    final next = entry == null
        ? null
        : HyperChartSelection(entry.pointIndex, entry.seriesIndex);
    setState(() {
      _hovered = next;
      _tooltipPosition = next == null ? null : response?.touchLocation;
      _tooltipMessage = next == null || !widget.showTooltip
          ? null
          : _tooltip(next);
    });
    if (event is! FlTapUpEvent || next == null) return;
    _activate(next);
  }

  void _activate(HyperChartSelection next) {
    if (widget.selectionEnabled) {
      final changed = Set<HyperChartSelection>.of(_selected);
      changed.contains(next) ? changed.remove(next) : changed.add(next);
      if (!_controlled) setState(() => _internalSelected = changed);
      widget.onSelectionChanged?.call(Set.unmodifiable(changed));
    }
    widget.onPointTap?.call(_hit(next));
  }

  List<HyperChartSelection> get _keyboardItems => <HyperChartSelection>[
    for (final entry in _flattened)
      HyperChartSelection(entry.pointIndex, entry.seriesIndex),
  ];

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
    final current = _hovered ?? items.first;
    if (_hovered == null) setState(() => _hovered = current);
    _activate(current);
  }

  void _clearKeyboard() {
    if (_hovered == null && _selected.isEmpty) return;
    setState(() {
      _hovered = null;
      _tooltipPosition = null;
      _tooltipMessage = null;
      if (!_controlled) _internalSelected = <HyperChartSelection>{};
    });
    if (widget.selectionEnabled) {
      widget.onSelectionChanged?.call(const <HyperChartSelection>{});
    }
  }

  String _tooltip(HyperChartSelection selection) {
    final hit = _hit(selection);
    return <String>[
      if (hit.point.label != null) hit.point.label! else hit.series.name,
      'x: ${widget.xAxis.formatter?.call(hit.point.x) ?? hyperChartNumber(hit.point.x)}',
      'y: ${widget.yAxis.formatter?.call(hit.point.y) ?? hyperChartNumber(hit.point.y)}',
    ].join('\n');
  }

  HyperScatterChartHit _hit(HyperChartSelection selection) =>
      HyperScatterChartHit(
        selection: selection,
        series: widget.series[selection.seriesIndex],
        point:
            widget.series[selection.seriesIndex].points[selection.groupIndex],
      );

  HyperScatterPoint _point(_HyperScatterEntry entry) =>
      widget.series[entry.seriesIndex].points[entry.pointIndex];

  void _clearHover() {
    if (_hovered == null && _tooltipPosition == null) return;
    setState(() {
      _hovered = null;
      _tooltipPosition = null;
      _tooltipMessage = null;
    });
  }
}

class _HyperScatterEntry {
  const _HyperScatterEntry(this.seriesIndex, this.pointIndex);

  final int seriesIndex;
  final int pointIndex;
}
