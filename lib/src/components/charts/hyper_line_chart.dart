import 'hyper_chart_legend_binding.dart';
import 'hyper_chart_legend_controller.dart';
import 'hyper_chart_axis_layout.dart';
// Adapted from local lemon_shadcn chart implementations.
import 'hyper_chart_tokens.dart';

import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'hyper_chart_viewport.dart';

import 'hyper_chart_pointer_tooltip.dart';
import 'hyper_chart_common.dart';
part 'hyper_line_dataset.dart';

enum _HyperLineChartVariant { line, area, step }

typedef HyperLineChartTapCallback = void Function(HyperLineChartHit hit);
typedef HyperLineChartTooltipBuilder = Widget Function(
  BuildContext context,
  HyperLineChartTooltipData data,
);
typedef HyperLineChartDataBuilder = LineChartData Function(LineChartData data);

@immutable
class HyperLinePoint {
  const HyperLinePoint({required this.x, required this.y, this.label});

  final double x;
  final double? y;
  final String? label;
}

@immutable
class HyperLineSeries {
  const HyperLineSeries({
    required this.name,
    required this.points,
    this.color,
    this.width,
    this.showPoints = true,
  });

  final String name;
  final List<HyperLinePoint> points;
  final Color? color;
  final double? width;
  final bool showPoints;
}

@immutable
class HyperLineChartHit {
  const HyperLineChartHit({
    required this.selection,
    required this.series,
    required this.point,
  });

  final HyperChartSelection selection;
  final HyperLineSeries series;
  final HyperLinePoint point;
}

@immutable
class HyperLineChartTooltipItem {
  const HyperLineChartTooltipItem({
    required this.hit,
    required this.color,
    required this.formattedValue,
  });

  final HyperLineChartHit hit;
  final Color color;
  final String formattedValue;
}

@immutable
class HyperLineChartTooltipData {
  const HyperLineChartTooltipData({
    required this.x,
    required this.xLabel,
    required this.items,
  });

  final double x;
  final String xLabel;
  final List<HyperLineChartTooltipItem> items;
}

class HyperLineChart extends StatefulWidget {
  const HyperLineChart({
    super.key,
    this.style,
    required this.series,
    this.preparedData,
    this.viewportController,
    this.panEnabled = false,
    this.xAxis = const HyperChartAxis(),
    this.yAxis = const HyperChartAxis(),
    this.referenceLines = const <HyperChartReferenceLine>[],
    this.nullPolicy = HyperChartNullPolicy.gap,
    this.height,
    this.palette,
    this.showGrid = true,
    this.showTooltip = true,
    this.tooltipStyle,
    this.tooltipWidgetBuilder,
    this.showLegend = true,
    this.legendController,
    this.legendIds,
    this.onLegendChanged,
    this.interactive = true,
    this.selectionEnabled = false,
    this.keyboardNavigation = true,
    this.autofocus = false,
    this.maxRenderedPoints = 1000,
    this.samplingStrategy =
        HyperChartSamplingStrategy.largestTriangleThreeBuckets,
    this.semanticLabel = '折线图，使用方向键浏览数据',
    this.selected = const <HyperChartSelection>{},
    this.onSelectionChanged,
    this.onPointTap,
    this.dataBuilder,
  }) : _variant = _HyperLineChartVariant.line;

  const HyperLineChart.area({
    super.key,
    this.style,
    required this.series,
    this.preparedData,
    this.viewportController,
    this.panEnabled = false,
    this.xAxis = const HyperChartAxis(),
    this.yAxis = const HyperChartAxis(),
    this.referenceLines = const <HyperChartReferenceLine>[],
    this.nullPolicy = HyperChartNullPolicy.gap,
    this.height,
    this.palette,
    this.showGrid = true,
    this.showTooltip = true,
    this.tooltipStyle,
    this.tooltipWidgetBuilder,
    this.showLegend = true,
    this.legendController,
    this.legendIds,
    this.onLegendChanged,
    this.interactive = true,
    this.selectionEnabled = false,
    this.keyboardNavigation = true,
    this.autofocus = false,
    this.maxRenderedPoints = 1000,
    this.samplingStrategy =
        HyperChartSamplingStrategy.largestTriangleThreeBuckets,
    this.semanticLabel = '面积图，使用方向键浏览数据',
    this.selected = const <HyperChartSelection>{},
    this.onSelectionChanged,
    this.onPointTap,
    this.dataBuilder,
  }) : _variant = _HyperLineChartVariant.area;

  const HyperLineChart.step({
    super.key,
    this.style,
    required this.series,
    this.preparedData,
    this.viewportController,
    this.panEnabled = false,
    this.xAxis = const HyperChartAxis(),
    this.yAxis = const HyperChartAxis(),
    this.referenceLines = const <HyperChartReferenceLine>[],
    this.nullPolicy = HyperChartNullPolicy.gap,
    this.height,
    this.palette,
    this.showGrid = true,
    this.showTooltip = true,
    this.tooltipStyle,
    this.tooltipWidgetBuilder,
    this.showLegend = true,
    this.legendController,
    this.legendIds,
    this.onLegendChanged,
    this.interactive = true,
    this.selectionEnabled = false,
    this.keyboardNavigation = true,
    this.autofocus = false,
    this.maxRenderedPoints = 1000,
    this.samplingStrategy =
        HyperChartSamplingStrategy.largestTriangleThreeBuckets,
    this.semanticLabel = '阶梯图，使用方向键浏览数据',
    this.selected = const <HyperChartSelection>{},
    this.onSelectionChanged,
    this.onPointTap,
    this.dataBuilder,
  }) : _variant = _HyperLineChartVariant.step;

  final List<HyperLineSeries> series;
  final HyperLineChartDataset? preparedData;
  final HyperChartViewportController? viewportController;
  final bool panEnabled;
  final HyperChartAxis xAxis;
  final HyperChartAxis yAxis;
  final List<HyperChartReferenceLine> referenceLines;
  final HyperChartNullPolicy nullPolicy;
  final double? height;
  final List<Color>? palette;
  final bool showGrid;
  final bool showTooltip;
  final HyperPointerTooltipStyle? tooltipStyle;
  final HyperLineChartTooltipBuilder? tooltipWidgetBuilder;
  final bool showLegend;
  final HyperChartLegendController? legendController;
  final List<String>? legendIds;
  final ValueChanged<List<HyperChartLegendEntry>>? onLegendChanged;
  final bool interactive;
  final bool selectionEnabled;
  final bool keyboardNavigation;
  final bool autofocus;
  final int? maxRenderedPoints;
  final HyperChartSamplingStrategy samplingStrategy;
  final String semanticLabel;
  final Set<HyperChartSelection> selected;
  final ValueChanged<Set<HyperChartSelection>>? onSelectionChanged;
  final HyperLineChartTapCallback? onPointTap;
  final HyperLineChartDataBuilder? dataBuilder;
  final _HyperLineChartVariant _variant;

  final HyperChartStyle? style;

  @override
  State<HyperLineChart> createState() => _HyperLineChartState();
}

class _HyperLineChartState extends State<HyperLineChart>
    with HyperChartLegendBinding<HyperLineChart> {
  Set<int> get _hiddenSeries => legendHiddenIndices;
  @override
  HyperChartLegendController? get externalLegendController =>
      widget.legendController;
  @override
  List<String>? get explicitLegendIds => widget.legendIds;
  @override
  ValueChanged<List<HyperChartLegendEntry>>? get legendChanged =>
      widget.onLegendChanged;
  Set<HyperChartSelection> _internalSelected = <HyperChartSelection>{};
  HyperChartSelection? _hovered;
  Offset? _tooltipPosition;
  String? _tooltipMessage;
  HyperLineChartTooltipData? _tooltipData;

  _HyperLineIndex? _index;
  _HyperLineIndex get _source =>
      _index ??= identical(widget.preparedData?.series, widget.series)
      ? widget.preparedData!._index
      : _HyperLineIndex(widget.series);
  HyperChartRange get _range {
    final min = widget.xAxis.min ?? _source.minX;
    final rawMax = widget.xAxis.max ?? _source.maxX;
    final max = rawMax > min ? rawMax : min + 1;
    final requested = widget.viewportController?.range;
    if (requested == null) return HyperChartRange(min, max);
    final span = math.min(requested.span, max - min);
    final start = requested.min.clamp(min, max - span);
    return HyperChartRange(start, start + span);
  }

  void _viewportChanged() {
    if (!mounted) return;
    setState(() {
      _sampleCache.clear();
      _clearHoverState();
    });
  }

  void _clearHoverState() {
    _hovered = null;
    _tooltipPosition = null;
    _tooltipMessage = null;
    _tooltipData = null;
  }

  @override
  void dispose() {
    widget.viewportController?.removeListener(_viewportChanged);
    super.dispose();
  }

  final Map<HyperLineSeries, List<HyperLinePoint>> _sampleCache = {};
  bool get _controlled => widget.onSelectionChanged != null;
  Set<HyperChartSelection> get _selected => widget.selectionEnabled
      ? (_controlled ? widget.selected : _internalSelected)
      : const <HyperChartSelection>{};

  @override
  void initState() {
    super.initState();
    widget.viewportController?.addListener(_viewportChanged);
    _internalSelected = Set<HyperChartSelection>.of(widget.selected);
  }

  @override
  void didUpdateWidget(covariant HyperLineChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.viewportController != widget.viewportController) {
      oldWidget.viewportController?.removeListener(_viewportChanged);
      widget.viewportController?.addListener(_viewportChanged);
    }
    final changed =
        !identical(oldWidget.series, widget.series) ||
        oldWidget.preparedData != widget.preparedData;
    if (changed) {
      _index = null;
    }
    if (changed ||
        oldWidget.maxRenderedPoints != widget.maxRenderedPoints ||
        oldWidget.nullPolicy != widget.nullPolicy ||
        oldWidget.samplingStrategy != widget.samplingStrategy ||
        oldWidget.xAxis != widget.xAxis ||
        oldWidget.viewportController != widget.viewportController) {
      _sampleCache.clear();
      _clearHoverState();
    }
    if (!_controlled && oldWidget.selected != widget.selected) {
      _internalSelected = Set<HyperChartSelection>.of(widget.selected);
    }
  }

  @override
  void legendVisibilityChanged() {
    _clearHoverState();
  }

  @override
  Widget build(BuildContext context) {
    final chart = HyperChartTokens(context, widget.style);
    final theme = HyperTheme.of(context);
    final palette = hyperChartPalette(chart, theme.colors, widget.palette);
    syncChartLegend([
      for (var index = 0; index < widget.series.length; index++)
        (
          label: widget.series[index].name,
          color: widget.series[index].color ?? palette[index % palette.length],
        ),
    ]);
    final empty = _source.valid.isEmpty;
    return HyperChartTheme(
      data: HyperChartThemeData(style: widget.style ?? const HyperChartStyle()),
      child: HyperChartKeyboardRegion(
        enabled: widget.keyboardNavigation && !empty,
        autofocus: widget.autofocus,
        semanticLabel: widget.semanticLabel,
        onPrevious: () => _moveKeyboard(-1),
        onNext: () => _moveKeyboard(1),
        onActivate: _activateCurrent,
        onClear: _clearKeyboard,
        child: SizedBox(
          height: widget.height ?? chart.height,
          child: empty
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
                    if (widget.showLegend &&
                        widget.series.isNotEmpty) ...<Widget>[
                      HyperChartLegend(
                        items: <HyperChartLegendData>[
                          for (var i = 0; i < widget.series.length; i++)
                            HyperChartLegendData(
                              label: widget.series[i].name,
                              color:
                                  widget.series[i].color ??
                                  palette[i % palette.length],
                            ),
                        ],
                        hidden: _hiddenSeries,
                        onToggle: (index) => setState(() {
                          toggleLegendIndex(index);
                        }),
                      ),
                      SizedBox(height: chart.legendSpacing),
                    ],
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final labelSize = widget.xAxis.show
                              ? _xLabelSize(
                                  widget.xAxis,
                                  _range.min,
                                  _range.max,
                                  hyperChartAxisStyle(theme, chart),
                                )
                              : Size.zero;
                          final inset = (labelSize.width / 2).clamp(
                            0.0,
                            math.max(
                              0.0,
                              (constraints.maxWidth -
                                      HyperTheme.sizesOf(context)
                                          .minimumInteractiveDimension) /
                                  2,
                            ),
                          );
                          final data = _data(
                            theme,
                            chart,
                            palette,
                            constraints.maxWidth - inset * 2,
                          );
                          final leftAxis = data.titlesData.leftTitles;
                          final plotWidth = math.max(
                            1.0,
                            constraints.maxWidth -
                                inset * 2 -
                                hyperChartAxisExtent(leftAxis) -
                                hyperChartAxisExtent(
                                  data.titlesData.rightTitles,
                                ),
                          );
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: inset.toDouble(),
                            ),
                            child: GestureDetector(
                              onHorizontalDragUpdate:
                                  widget.panEnabled &&
                                      widget.viewportController != null
                                  ? (details) => widget.viewportController!.pan(
                                      -details.delta.dx /
                                          plotWidth *
                                          _range.span,
                                    )
                                  : null,
                              child: HyperPointerTooltipArea(
                                position: _tooltipPosition,
                                message: _tooltipMessage,
                                style:
                                    widget.style?.tooltipStyle?.merge(
                                      widget.tooltipStyle,
                                    ) ??
                                    widget.tooltipStyle,
                                builder: _tooltipData == null
                                    ? null
                                    : (context, _) =>
                                          widget.tooltipWidgetBuilder?.call(
                                            context,
                                            _tooltipData!,
                                          ) ??
                                          HyperChartTooltipContent(
                                            title: _tooltipData!.xLabel,
                                            rows: [
                                              for (final item
                                                  in _tooltipData!.items)
                                                HyperChartTooltipRow(
                                                  label: item.hit.series.name,
                                                  value: item.formattedValue,
                                                  color: item.color,
                                                ),
                                            ],
                                          ),
                                onExit: _clearPointerHover,
                                child: LineChart(
                                  widget.dataBuilder?.call(data) ?? data,
                                  duration:
                                      widget.viewportController != null ||
                                          MediaQuery.maybeOf(context)
                                                  ?.disableAnimations ==
                                              true
                                      ? Duration.zero
                                      : chart.animationDuration,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  LineChartData _data(
    HyperThemeData theme,
    HyperChartTokens chart,
    List<Color> palette,
    double availableWidth,
  ) {
    final minX = _range.min;
    final maxX = _range.max;
    final rawMinY = _source.minY;
    final rawMaxY = _source.maxY;
    final scale = hyperChartNumericScale(rawMinY, rawMaxY, widget.yAxis);
    final minY = scale.min;
    final maxY = scale.max;
    final axisStyle = hyperChartAxisStyle(theme, chart);
    final xLabelExtent = math.max(
      0.0,
      availableWidth -
          (widget.yAxis.show
              ? widget.yAxis.reservedSize ??
                    hyperChartAxisReservedWidth(
                      hyperChartValueAxisLabels(
                        minY,
                        maxY,
                        widget.yAxis.formatter,
                      ),
                      axisStyle,
                      chart,
                    )
              : 0) -
          16,
    );

    final grid = FlGridData(
      show: widget.showGrid,
      drawVerticalLine: false,
      horizontalInterval: scale.interval,
      getDrawingHorizontalLine: (_) => FlLine(
        color: theme.colors.outline.withValues(alpha: chart.gridOpacity),
        strokeWidth: 1,
      ),
    );
    return LineChartData(
      minX: minX,
      maxX: maxX == minX ? minX + 1 : maxX,
      minY: minY,
      maxY: maxY == minY ? minY + 1 : maxY,
      clipData: widget.viewportController == null
          ? const FlClipData.none()
          : const FlClipData.all(),
      borderData: hyperChartGridBoundary(grid, minY: minY, maxY: maxY),
      gridData: grid,
      titlesData: hyperChartBalancedTitles(
        FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: _axisTitles(
            widget.xAxis,
            axisStyle,
            false,
            chart,
            minX,
            maxX,
            availableExtent: xLabelExtent,
          ),
          leftTitles: _axisTitles(
            widget.yAxis,
            axisStyle,
            true,
            chart,
            minY,
            maxY,
          ),
        ),
        verticalLabelHeight: hyperChartAxisLabelHeight(context, axisStyle),
      ),
      extraLinesData: ExtraLinesData(
        horizontalLines: <HorizontalLine>[
          for (final line in widget.referenceLines)
            HorizontalLine(
              y: line.value,
              color: line.color ?? theme.colors.primary,
              strokeWidth: line.width,
              dashArray: line.dash,
              label: HorizontalLineLabel(
                show: line.label != null,
                labelResolver: (_) => line.label ?? '',
                style: axisStyle.copyWith(
                  color: line.color ?? theme.colors.primary,
                ),
              ),
            ),
        ],
      ),
      lineBarsData: <LineChartBarData>[
        for (
          var seriesIndex = 0;
          seriesIndex < widget.series.length;
          seriesIndex++
        )
          _seriesData(seriesIndex, theme, chart, palette),
      ],
      lineTouchData: LineTouchData(
        enabled: widget.interactive,
        handleBuiltInTouches: false,
        touchCallback: _handleTouch,
        mouseCursorResolver: (_, response) =>
            response?.lineBarSpots?.isNotEmpty == true
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
      ),
    );
  }

  LineChartBarData _seriesData(
    int seriesIndex,
    HyperThemeData theme,
    HyperChartTokens chart,
    List<Color> palette,
  ) {
    final series = widget.series[seriesIndex];
    final base = series.color ?? palette[seriesIndex % palette.length];
    final hidden = _hiddenSeries.contains(seriesIndex);
    final activeSeries =
        _hovered?.seriesIndex == seriesIndex ||
        _selected.any((selection) => selection.seriesIndex == seriesIndex);
    final hasActive = _hovered != null || _selected.isNotEmpty;
    final color = base.withValues(
      alpha: hidden
          ? 0
          : (hasActive && !activeSeries ? chart.inactiveOpacity : 1),
    );
    return LineChartBarData(
      show: !hidden,
      spots: <FlSpot>[
        for (final point in _renderPoints(series))
          if (point.y == null && widget.nullPolicy == HyperChartNullPolicy.gap)
            FlSpot.nullSpot
          else if (point.y != null ||
              widget.nullPolicy == HyperChartNullPolicy.zero)
            FlSpot(point.x, point.y ?? 0),
      ],
      color: color,
      barWidth: series.width ?? chart.lineWidth,
      isCurved: widget._variant != _HyperLineChartVariant.step,
      preventCurveOverShooting: true,
      isStrokeCapRound: true,
      isStrokeJoinRound: true,
      isStepLineChart: widget._variant == _HyperLineChartVariant.step,
      belowBarData: BarAreaData(
        show: widget._variant == _HyperLineChartVariant.area,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            color.withValues(alpha: 0.24),
            color.withValues(alpha: 0.02),
          ],
        ),
      ),
      dotData: FlDotData(
        show: series.showPoints,
        getDotPainter: (spot, _, _, _) {
          final selection = HyperChartSelection(
            _pointIndexForX(seriesIndex, spot.x),
            seriesIndex,
          );
          final active = _hovered == selection || _selected.contains(selection);
          return FlDotCirclePainter(
            radius: active
                ? chart.pointRadius * chart.hoverScale
                : chart.pointRadius,
            color: color,
            strokeWidth: active ? 2 : 1.5,
            strokeColor: theme.colors.background,
          );
        },
      ),
    );
  }

  AxisTitles _axisTitles(
    HyperChartAxis axis,
    TextStyle style,
    bool vertical,
    HyperChartTokens chart,
    double min,
    double max, {
    double? availableExtent,
  }) => AxisTitles(
    axisNameWidget: !axis.show || axis.title == null
        ? null
        : Text(
            axis.title!,
            style: style,
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
          ),
    axisNameSize: !axis.show || axis.title == null ? 0 : 20,
    sideTitles: SideTitles(
      showTitles: axis.show,
      minIncluded: true,
      maxIncluded: vertical || !axis.autoLabelInterval,
      reservedSize:
          axis.reservedSize ??
          (vertical
              ? hyperChartAxisReservedWidth(
                  hyperChartValueAxisLabels(min, max, axis.formatter),
                  style,
                  chart,
                )
              : math.max(26, _xLabelSize(axis, min, max, style).height + 6)),
      interval:
          axis.interval ??
          (vertical
              ? hyperChartNumericScale(
                  _source.minY,
                  _source.maxY,
                  axis,
                ).interval
              : _automaticXInterval(axis, min, max, availableExtent, style)),
      getTitlesWidget: (value, meta) {
        final pointLabel = vertical ? null : _pointLabel(value);
        if (!vertical &&
            axis.formatter == null &&
            _hasPointLabels &&
            pointLabel == null) {
          return const SizedBox.shrink();
        }
        final label =
            axis.formatter?.call(value) ??
            pointLabel ??
            hyperChartNumber(value);
        final textSize = _measureLabel(label, style);
        final angle = vertical ? 0.0 : axis.labelRotation * math.pi / 180;
        final projected = _projectLabel(textSize, angle);
        return SideTitleWidget(
          meta: meta,
          space: hyperChartAxisLabelGap,
          child: hyperChartCornerLabel(
            meta,
            vertical
                ? projected.width
                : _xLabelSize(axis, min, max, style).width,
            SizedBox(
              width: vertical
                  ? projected.width
                  : _xLabelSize(axis, min, max, style).width,
              height: vertical
                  ? projected.height
                  : _xLabelSize(axis, min, max, style).height,
              child: OverflowBox(
                minWidth: textSize.width,
                maxWidth: textSize.width,
                minHeight: textSize.height,
                maxHeight: textSize.height,
                child: Transform.rotate(
                  angle: angle,
                  child: RichText(
                    text: TextSpan(
                      text: label,
                      style: DefaultTextStyle.of(context).style.merge(style),
                    ),
                    textScaler: MediaQuery.textScalerOf(context),
                    textDirection: Directionality.of(context),
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ),
  );

  bool get _hasPointLabels => _source.labels.isNotEmpty;

  double? _xPointInterval() => _source.interval;

  double? _automaticXInterval(
    HyperChartAxis axis,
    double min,
    double max,
    double? extent,
    TextStyle style,
  ) {
    final step = _xPointInterval();
    if (step == null || step <= 0) return null;
    final width = _xLabelSize(axis, min, max, style).width;
    // At an endpoint the label can move inward by half its width. Keep a
    // full label width plus that half-width between neighboring tick centers.
    final slots = math.max(
      1.0,
      ((extent ?? 1) - width) /
          math.max(1.0, width * 1.5 + axis.minLabelSpacing),
    );
    return step * math.max(1, ((max - min) / step / slots).ceil());
  }

  Size _measureLabel(String label, TextStyle style) {
    final painter = TextPainter(
      text: TextSpan(
        text: label,
        style: DefaultTextStyle.of(context).style.merge(style),
      ),
      textScaler: MediaQuery.textScalerOf(context),
      textDirection: Directionality.of(context),
      maxLines: 1,
    )..layout();
    final size = Size(
      painter.width.ceilToDouble(),
      painter.height.ceilToDouble(),
    );
    painter.dispose();
    return size;
  }

  Size _projectLabel(Size size, double angle) => Size(
    size.width * math.cos(angle).abs() + size.height * math.sin(angle).abs(),
    size.width * math.sin(angle).abs() + size.height * math.cos(angle).abs(),
  );

  Size _xLabelSize(
    HyperChartAxis axis,
    double min,
    double max,
    TextStyle style,
  ) {
    var width = 0.0, height = 0.0;
    for (var i = 0; i <= 4; i++) {
      final x = min + (max - min) * i / 4;
      final size = _projectLabel(
        _measureLabel(
          axis.formatter?.call(x) ?? _pointLabel(x) ?? hyperChartNumber(x),
          style,
        ),
        axis.labelRotation * math.pi / 180,
      );
      width = math.max(width, size.width);
      height = math.max(height, size.height);
    }
    return Size(width, height);
  }

  String? _pointLabel(double x) => _source.labels[x];

  void _handleTouch(FlTouchEvent event, LineTouchResponse? response) {
    final spots = response?.lineBarSpots
        ?.where(
          (spot) =>
              spot.barIndex >= 0 &&
              spot.barIndex < _source.indices.length &&
              _source.indices[spot.barIndex].containsKey(spot.x),
        )
        .toList();
    final spot = spots?.firstOrNull;
    final next = spot == null
        ? null
        : HyperChartSelection(
            _pointIndexForX(spot.barIndex, spot.x),
            spot.barIndex,
          );
    final tooltipMessage = spot == null || !widget.showTooltip || spots == null
        ? null
        : _tooltipFor(spots);
    final tooltipData = tooltipMessage == null || spots == null
        ? null
        : _tooltipDataFor(spots);
    final tooltipPosition = tooltipMessage == null
        ? null
        : response?.touchLocation;
    if (_hovered != next ||
        _tooltipPosition != tooltipPosition ||
        _tooltipMessage != tooltipMessage) {
      setState(() {
        _hovered = next;
        _tooltipPosition = tooltipPosition;
        _tooltipMessage = tooltipMessage;
        _tooltipData = tooltipData;
      });
    }
    if (event is! FlTapUpEvent || next == null) return;
    _activate(next);
  }

  void _clearPointerHover() {
    if (_hovered == null &&
        _tooltipPosition == null &&
        _tooltipMessage == null) {
      return;
    }
    setState(() {
      _hovered = null;
      _tooltipPosition = null;
      _tooltipMessage = null;
      _tooltipData = null;
    });
  }

  void _activate(HyperChartSelection next) {
    if (widget.selectionEnabled) {
      final changed = Set<HyperChartSelection>.of(_selected);
      changed.contains(next) ? changed.remove(next) : changed.add(next);
      if (!_controlled) setState(() => _internalSelected = changed);
      widget.onSelectionChanged?.call(
        Set<HyperChartSelection>.unmodifiable(changed),
      );
    }
    widget.onPointTap?.call(_hit(next));
  }

  List<HyperChartSelection> get _keyboardItems => <HyperChartSelection>[
    for (var seriesIndex = 0; seriesIndex < widget.series.length; seriesIndex++)
      if (!_hiddenSeries.contains(seriesIndex))
        for (final point in _renderPoints(widget.series[seriesIndex]))
          if ((point.y != null ||
                  widget.nullPolicy == HyperChartNullPolicy.zero) &&
              point.x >= _range.min &&
              point.x <= _range.max)
            HyperChartSelection(
              _pointIndexForX(seriesIndex, point.x),
              seriesIndex,
            ),
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
      _tooltipData = null;
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
    if (!widget.selectionEnabled) {
      setState(() {
        _hovered = null;
        _tooltipPosition = null;
        _tooltipMessage = null;
        _tooltipData = null;
      });
      return;
    }
    if (!_controlled) {
      setState(() {
        _hovered = null;
        _tooltipPosition = null;
        _tooltipMessage = null;
        _tooltipData = null;
        _internalSelected = <HyperChartSelection>{};
      });
    } else {
      setState(() {
        _hovered = null;
        _tooltipPosition = null;
        _tooltipMessage = null;
        _tooltipData = null;
      });
    }
    widget.onSelectionChanged?.call(const <HyperChartSelection>{});
  }

  HyperLineChartHit _hit(HyperChartSelection selection) => HyperLineChartHit(
    selection: selection,
    series: widget.series[selection.seriesIndex],
    point: widget.series[selection.seriesIndex].points[selection.groupIndex],
  );

  String _tooltipFor(List<TouchLineBarSpot> spots) {
    final first = spots.first;
    final xLabel =
        _pointLabel(first.x) ??
        widget.xAxis.formatter?.call(first.x) ??
        hyperChartNumber(first.x);
    final lines = <String>[xLabel];
    for (final spot in spots) {
      lines.add(
        '${widget.series[spot.barIndex].name} ${widget.yAxis.formatter?.call(spot.y) ?? hyperChartNumber(spot.y)}',
      );
    }
    return lines.join('\n');
  }

  HyperLineChartTooltipData _tooltipDataFor(List<TouchLineBarSpot> spots) {
    final first = spots.first;
    final chart = HyperChartTokens(context, widget.style);
    final theme = HyperTheme.of(context);
    final palette = hyperChartPalette(chart, theme.colors, widget.palette);
    final xLabel =
        _pointLabel(first.x) ??
        widget.xAxis.formatter?.call(first.x) ??
        hyperChartNumber(first.x);
    return HyperLineChartTooltipData(
      x: first.x,
      xLabel: xLabel,
      items: <HyperLineChartTooltipItem>[
        for (final spot in spots)
          HyperLineChartTooltipItem(
            hit: _hit(
              HyperChartSelection(
                _pointIndexForX(spot.barIndex, spot.x),
                spot.barIndex,
              ),
            ),
            color:
                widget.series[spot.barIndex].color ??
                palette[spot.barIndex % palette.length],
            formattedValue:
                widget.yAxis.formatter?.call(spot.y) ??
                hyperChartNumber(spot.y),
          ),
      ],
    );
  }

  int _pointIndexForX(int seriesIndex, double x) =>
      _source.indices[seriesIndex][x] ?? -1;

  List<HyperLinePoint> _renderPoints(HyperLineSeries series) =>
      _sampleCache.putIfAbsent(series, () => _samplePoints(series));

  List<HyperLinePoint> _samplePoints(HyperLineSeries series) {
    final prepared = widget.preparedData;
    final range = _range;
    final isFull = range.min <= _source.minX && range.max >= _source.maxX;
    final compatible =
        identical(prepared?.series, widget.series) &&
        prepared!.nullPolicy == widget.nullPolicy &&
        prepared.samplingStrategy == widget.samplingStrategy;
    if (isFull &&
        compatible &&
        prepared.maxRenderedPoints == widget.maxRenderedPoints) {
      return prepared._samples[series]!;
    }
    List<HyperLinePoint> points;
    if (compatible &&
        widget.maxRenderedPoints != null &&
        widget.samplingStrategy != HyperChartSamplingStrategy.none &&
        _source.sorted[series] == true) {
      points = const [];
      for (final tier in prepared._levels[series]!) {
        points = isFull ? tier : _source.window(series, range, tier);
        if (points.length >= widget.maxRenderedPoints! * 2 ||
            identical(tier, series.points)) {
          break;
        }
      }
    } else {
      points = isFull ? series.points : _source.window(series, range);
    }
    return _sampleHyperLinePoints(
      points,
      widget.maxRenderedPoints,
      widget.nullPolicy,
      widget.samplingStrategy,
    );
  }
}

/// Source summaries and lookups are rebuilt when the caller supplies updated data,
/// never on pointer motion. Data lists are treated as immutable snapshots.
class _HyperLineIndex {
  _HyperLineIndex(List<HyperLineSeries> series) {
    for (final item in series) {
      final lookup = <double, int>{};
      for (var i = 0; i < item.points.length; i++) {
        final point = item.points[i];
        lookup.putIfAbsent(point.x, () => i);
        if (point.label != null) {
          labels.putIfAbsent(point.x, () => point.label!);
        }
        if (point.y != null) {
          valid.add(point);
          minX = math.min(minX, point.x);
          maxX = math.max(maxX, point.x);
          minY = math.min(minY, point.y!);
          maxY = math.max(maxY, point.y!);
        }
      }
      indices.add(lookup);
      var ordered = true;
      for (var i = 1; i < item.points.length; i++) {
        if (item.points[i].x < item.points[i - 1].x) {
          ordered = false;
          break;
        }
      }
      sorted[item] = ordered;
    }
    final xs = indices.expand((map) => map.keys).toSet().toList()..sort();
    var minimum = double.infinity;
    for (var i = 1; i < xs.length; i++) {
      if (xs[i] > xs[i - 1]) minimum = math.min(minimum, xs[i] - xs[i - 1]);
    }
    interval = minimum.isFinite ? minimum : null;
  }
  final sorted = <HyperLineSeries, bool>{};
  List<HyperLinePoint> window(
    HyperLineSeries series,
    HyperChartRange range, [
    List<HyperLinePoint>? tier,
  ]) {
    final points = tier ?? series.points;
    if (points.isEmpty) return const [];
    if (sorted[series] != true) {
      return [
        for (final point in points)
          if (point.x >= range.min && point.x <= range.max) point,
      ];
    }
    int bound(double x, bool upper) {
      var low = 0, high = points.length;
      while (low < high) {
        final mid = (low + high) ~/ 2;
        if (points[mid].x < x || (upper && points[mid].x == x)) {
          low = mid + 1;
        } else {
          high = mid;
        }
      }
      return low;
    }

    final first = math.max(0, bound(range.min, false) - 1);
    final last = math.min(points.length, bound(range.max, true) + 1);
    return points.sublist(first, last);
  }

  final valid = <HyperLinePoint>[];
  final labels = <double, String>{};
  final indices = <Map<double, int>>[];
  late final double? interval;
  double minX = double.infinity,
      maxX = double.negativeInfinity,
      minY = double.infinity,
      maxY = double.negativeInfinity;
}

List<HyperLinePoint> _sampleHyperLinePoints(
  List<HyperLinePoint> points,
  int? limit,
  HyperChartNullPolicy nullPolicy,
  HyperChartSamplingStrategy strategy,
) {
  if (limit == null ||
      limit < 3 ||
      points.length <= limit ||
      strategy == HyperChartSamplingStrategy.none) {
    return points;
  }
  final valid = <HyperLinePoint>[
    for (final point in points)
      if (point.y != null || nullPolicy == HyperChartNullPolicy.zero) point,
  ];
  if (valid.length <= limit) return points;
  final sampled = hyperChartSampleIndices<HyperLinePoint>(
    valid,
    maxPoints: limit,
    x: (point) => point.x,
    y: (point) => point.y ?? 0,
    strategy: strategy,
  );
  final retained = <HyperLinePoint>{for (final index in sampled) valid[index]};
  if (nullPolicy != HyperChartNullPolicy.gap) {
    return <HyperLinePoint>[
      for (final point in points)
        if (retained.contains(point)) point,
    ];
  }
  return <HyperLinePoint>[
    for (var index = 0; index < points.length; index++)
      if (retained.contains(points[index]) ||
          (points[index].y == null &&
              (index == 0 || points[index - 1].y != null)))
        points[index],
  ];
}
