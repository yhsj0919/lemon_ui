// Adapted from local lemon_shadcn chart implementations.
import 'hyper_chart_tokens.dart';

import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'hyper_chart_pointer_tooltip.dart';
import 'hyper_chart_common.dart';

typedef HyperBarChartTapCallback = void Function(HyperBarChartHit hit);
typedef HyperBarChartTooltipBuilder = Widget Function(
  BuildContext context,
  HyperBarChartHit hit,
);
typedef HyperBarChartColorResolver = Color Function(
  HyperBarChartStyleContext data,
);
typedef HyperBarChartDataBuilder = BarChartData Function(BarChartData data);

enum _HyperBarChartVariant { grouped, stacked, horizontal, horizontalStacked }

@immutable
class HyperBarValue {
  const HyperBarValue({required this.value, this.color, this.gradient})
    : assert(color == null || gradient == null);

  final double? value;
  final Color? color;
  final Gradient? gradient;
}

@immutable
class HyperBarGroup {
  const HyperBarGroup({required this.label, required this.values});

  final String label;
  final List<HyperBarValue> values;
}

@immutable
class HyperBarSeries {
  const HyperBarSeries({required this.name, this.color});

  final String name;
  final Color? color;
}

@immutable
class HyperBarChartHit {
  const HyperBarChartHit({
    required this.selection,
    required this.group,
    required this.value,
    this.series,
  });

  final HyperChartSelection selection;
  final HyperBarGroup group;
  final HyperBarSeries? series;
  final HyperBarValue value;
}

@immutable
class HyperBarChartStyleContext {
  const HyperBarChartStyleContext({
    required this.hit,
    required this.baseColor,
    required this.isHovered,
    required this.isSelected,
  });

  final HyperBarChartHit hit;
  final Color baseColor;
  final bool isHovered;
  final bool isSelected;
}

/// A business-first bar chart whose defaults are derived from Lemon's shadcn
/// theme. fl_chart remains the renderer, never the source of visual defaults.
class HyperBarChart extends StatefulWidget {
  const HyperBarChart({
    super.key,
    this.style,
    required this.groups,
    this.series = const <HyperBarSeries>[],
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
    this.showValues = false,
    this.interactive = true,
    this.selectionEnabled = false,
    this.keyboardNavigation = true,
    this.autofocus = false,
    this.semanticLabel = '柱状图，使用方向键浏览数据',
    this.selected = const <HyperChartSelection>{},
    this.onSelectionChanged,
    this.onBarTap,
    this.colorResolver,
    this.dataBuilder,
  }) : _variant = _HyperBarChartVariant.grouped;

  const HyperBarChart.stacked({
    super.key,
    this.style,
    required this.groups,
    this.series = const <HyperBarSeries>[],
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
    this.showValues = false,
    this.interactive = true,
    this.selectionEnabled = false,
    this.keyboardNavigation = true,
    this.autofocus = false,
    this.semanticLabel = '堆叠柱状图，使用方向键浏览数据',
    this.selected = const <HyperChartSelection>{},
    this.onSelectionChanged,
    this.onBarTap,
    this.colorResolver,
    this.dataBuilder,
  }) : _variant = _HyperBarChartVariant.stacked;

  /// Horizontal business chart. [xAxis] configures numeric values while
  /// [yAxis] configures category labels and the category axis title.
  const HyperBarChart.horizontal({
    super.key,
    this.style,
    required this.groups,
    this.series = const <HyperBarSeries>[],
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
    this.showValues = false,
    this.interactive = true,
    this.selectionEnabled = false,
    this.keyboardNavigation = true,
    this.autofocus = false,
    this.semanticLabel = '横向柱状图，使用方向键浏览数据',
    this.selected = const <HyperChartSelection>{},
    this.onSelectionChanged,
    this.onBarTap,
    this.colorResolver,
    this.dataBuilder,
  }) : _variant = _HyperBarChartVariant.horizontal;

  /// Horizontal stacked business chart. [xAxis] is the numeric value axis and
  /// can be hidden with `HyperChartAxis(show: false)`.
  const HyperBarChart.horizontalStacked({
    super.key,
    this.style,
    required this.groups,
    this.series = const <HyperBarSeries>[],
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
    this.showValues = false,
    this.interactive = true,
    this.selectionEnabled = false,
    this.keyboardNavigation = true,
    this.autofocus = false,
    this.semanticLabel = '横向堆叠柱状图，使用方向键浏览数据',
    this.selected = const <HyperChartSelection>{},
    this.onSelectionChanged,
    this.onBarTap,
    this.colorResolver,
    this.dataBuilder,
  }) : _variant = _HyperBarChartVariant.horizontalStacked;

  factory HyperBarChart.simple({
    Key? key,
    required List<HyperBarValue> values,
    required List<String> labels,
    HyperChartAxis xAxis = const HyperChartAxis(),
    HyperChartAxis yAxis = const HyperChartAxis(),
    bool showValues = false,
    HyperPointerTooltipStyle? tooltipStyle,
    HyperBarChartTooltipBuilder? tooltipWidgetBuilder,
    HyperBarChartTapCallback? onBarTap,
    double? height,
  }) {
    assert(values.length == labels.length);
    return HyperBarChart(
      key: key,
      groups: <HyperBarGroup>[
        for (var i = 0; i < values.length; i++)
          HyperBarGroup(label: labels[i], values: <HyperBarValue>[values[i]]),
      ],
      xAxis: xAxis,
      yAxis: yAxis,
      showValues: showValues,
      tooltipStyle: tooltipStyle,
      tooltipWidgetBuilder: tooltipWidgetBuilder,
      onBarTap: onBarTap,
      height: height,
    );
  }

  final List<HyperBarGroup> groups;
  final List<HyperBarSeries> series;
  final HyperChartAxis xAxis;
  final HyperChartAxis yAxis;
  final List<HyperChartReferenceLine> referenceLines;
  final HyperChartNullPolicy nullPolicy;
  final double? height;
  final List<Color>? palette;
  final bool showGrid;
  final bool showTooltip;
  final HyperPointerTooltipStyle? tooltipStyle;
  final HyperBarChartTooltipBuilder? tooltipWidgetBuilder;
  final bool showLegend;
  final bool showValues;
  final bool interactive;
  final bool selectionEnabled;
  final bool keyboardNavigation;
  final bool autofocus;
  final String semanticLabel;
  final Set<HyperChartSelection> selected;
  final ValueChanged<Set<HyperChartSelection>>? onSelectionChanged;
  final HyperBarChartTapCallback? onBarTap;
  final HyperBarChartColorResolver? colorResolver;
  final HyperBarChartDataBuilder? dataBuilder;
  final _HyperBarChartVariant _variant;

  final HyperChartStyle? style;

  @override
  State<HyperBarChart> createState() => _HyperBarChartState();
}

class _HyperBarChartState extends State<HyperBarChart> {
  final GlobalKey _chartAreaKey = GlobalKey();
  HyperChartSelection? _hovered;
  Offset? _tooltipPosition;
  String? _tooltipMessage;
  Set<HyperChartSelection> _internalSelected = <HyperChartSelection>{};
  final Set<int> _hiddenSeries = <int>{};

  bool get _selectionIsControlled => widget.onSelectionChanged != null;
  Set<HyperChartSelection> get _selected => widget.selectionEnabled
      ? (_selectionIsControlled ? widget.selected : _internalSelected)
      : const <HyperChartSelection>{};
  bool get _horizontal =>
      widget._variant == _HyperBarChartVariant.horizontal ||
      widget._variant == _HyperBarChartVariant.horizontalStacked;
  bool get _stacked =>
      widget._variant == _HyperBarChartVariant.stacked ||
      widget._variant == _HyperBarChartVariant.horizontalStacked;
  HyperChartAxis get _categoryAxis => _horizontal ? widget.yAxis : widget.xAxis;
  HyperChartAxis get _valueAxis => _horizontal ? widget.xAxis : widget.yAxis;

  @override
  void initState() {
    super.initState();
    _internalSelected = Set<HyperChartSelection>.of(widget.selected);
  }

  @override
  void didUpdateWidget(covariant HyperBarChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_selectionIsControlled && oldWidget.selected != widget.selected) {
      _internalSelected = Set<HyperChartSelection>.of(widget.selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final chartTheme = HyperChartTokens(context, widget.style);
    final theme = HyperTheme.of(context);
    final colors = theme.colors;
    final palette = hyperChartPalette(chartTheme, colors, widget.palette);
    return HyperChartTheme(
      data: HyperChartThemeData(style: widget.style ?? const HyperChartStyle()),
      child: HyperChartKeyboardRegion(
        enabled: widget.keyboardNavigation && widget.groups.isNotEmpty,
        autofocus: widget.autofocus,
        semanticLabel: widget.semanticLabel,
        onPrevious: () => _moveKeyboard(-1),
        onNext: () => _moveKeyboard(1),
        onUp: _stacked ? () => _moveKeyboard(1) : null,
        onDown: _stacked ? () => _moveKeyboard(-1) : null,
        onActivate: _activateCurrent,
        onClear: _clearKeyboard,
        child: SizedBox(
          height: widget.height ?? chartTheme.height,
          child: widget.groups.isEmpty
              ? Center(
                  child: Text(
                    '暂无数据',
                    style: (theme.textTheme.bodySmall ?? const TextStyle())
                        .copyWith(color: colors.textSecondary),
                  ),
                )
              : LayoutBuilder(
                  builder: (context, constraints) {
                    final labelLayout = _labelLayout(constraints, chartTheme);
                    final categoryLabelStride =
                        !_horizontal &&
                            _categoryAxis.interval == null &&
                            _categoryAxis.autoLabelInterval
                        ? hyperChartLabelStride(
                            widget.groups.map((group) => group.label),
                            _horizontal
                                ? constraints.maxHeight
                                : math.max(
                                    0,
                                    constraints.maxWidth -
                                        (_valueAxis.show
                                            ? _valueAxis.reservedSize ??
                                                  chartTheme.axisMinReservedSize
                                            : 0) -
                                        16,
                                  ),
                            hyperChartAxisStyle(theme, chartTheme),
                            minSpacing: _categoryAxis.minLabelSpacing,
                          )
                        : 1;
                    final data = _buildData(
                      theme,
                      chartTheme,
                      palette,
                      labelLayout,
                      categoryLabelStride,
                    );
                    final chart = BarChart(
                      widget.dataBuilder?.call(data) ?? data,
                      duration:
                          MediaQuery.maybeOf(context)?.disableAnimations == true
                          ? Duration.zero
                          : chartTheme.animationDuration,
                    );
                    return HyperChartLayout(
                      options: HyperChartTokens(context, widget.style).legend,
                      children: <Widget>[
                        if (widget.showLegend &&
                            widget.series.isNotEmpty) ...<Widget>[
                          _legend(palette),
                          SizedBox(height: chartTheme.legendSpacing),
                        ],
                        Expanded(
                          child: HyperPointerTooltipArea(
                            key: _chartAreaKey,
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
                            onExit: _clearPointerHover,
                            child: chart,
                          ),
                        ),
                      ],
                    );
                  },
                ),
        ),
      ),
    );
  }

  Widget _legend(List<Color> palette) => HyperChartLegend(
    items: <HyperChartLegendData>[
      for (var index = 0; index < widget.series.length; index++)
        HyperChartLegendData(
          label: widget.series[index].name,
          color: widget.series[index].color ?? palette[index % palette.length],
        ),
    ],
    hidden: _hiddenSeries,
    onToggle: (index) => setState(() {
      _hiddenSeries.contains(index)
          ? _hiddenSeries.remove(index)
          : _hiddenSeries.add(index);
    }),
  );

  _HyperBarLabelLayout _labelLayout(
    BoxConstraints constraints,
    HyperChartTokens chart,
  ) {
    if (!widget.showValues || widget.groups.isEmpty) {
      return const _HyperBarLabelLayout.hidden();
    }
    var extent = _horizontal ? constraints.maxHeight : constraints.maxWidth;
    if (!extent.isFinite) {
      return const _HyperBarLabelLayout(stride: 1, singlePerGroup: false);
    }
    if (widget.showLegend && widget.series.isNotEmpty) {
      extent = math.max(0, extent - chart.legendSpacing - 28);
    }
    final groupSlot = extent / widget.groups.length;
    if (groupSlot <= 0) return const _HyperBarLabelLayout.hidden();
    final stride = math.max(1, (chart.dataLabelMinSpacing / groupSlot).ceil());
    final maxSeries = _stacked
        ? 1
        : widget.groups.fold<int>(
            1,
            (count, group) => math.max(count, group.values.length),
          );
    return _HyperBarLabelLayout(
      stride: stride,
      singlePerGroup:
          !_stacked && groupSlot / maxSeries < chart.dataLabelMinSpacing,
    );
  }

  bool _showLabel(
    _HyperBarLabelLayout layout,
    int groupIndex,
    int seriesIndex,
  ) {
    if (!layout.visible || groupIndex % layout.stride != 0) return false;
    if (!layout.singlePerGroup) return true;
    final values = widget.groups[groupIndex].values;
    var largestIndex = 0;
    var largest = -1.0;
    for (var index = 0; index < values.length; index++) {
      final magnitude = (values[index].value ?? 0).abs();
      if (magnitude > largest) {
        largest = magnitude;
        largestIndex = index;
      }
    }
    return seriesIndex == largestIndex;
  }

  BarChartData _buildData(
    HyperThemeData theme,
    HyperChartTokens chart,
    List<Color> palette,
    _HyperBarLabelLayout labelLayout,
    int categoryLabelStride,
  ) {
    final values = _stacked
        ? <double>[
            for (final group in widget.groups) ...<double>[
              group.values
                  .map((bar) => bar.value ?? 0)
                  .where((value) => value < 0)
                  .fold<double>(0, (sum, value) => sum + value),
              group.values
                  .map((bar) => bar.value ?? 0)
                  .where((value) => value > 0)
                  .fold<double>(0, (sum, value) => sum + value),
            ],
          ]
        : widget.groups
              .expand((group) => group.values)
              .map((bar) => bar.value)
              .whereType<double>()
              .toList();
    final minValue = values.isEmpty ? 0.0 : values.reduce(math.min);
    final maxValue = values.isEmpty ? 1.0 : values.reduce(math.max);
    final minY = _valueAxis.min ?? math.min(0, minValue * 1.12);
    final maxY =
        _valueAxis.max ??
        hyperChartNiceMaximum(
          minY,
          math.max(0.0, maxValue),
          interval: _valueAxis.interval,
        );
    final valueInterval =
        _valueAxis.interval ?? hyperChartNiceInterval(minY, maxY);
    final axisStyle = (theme.textTheme.labelSmall ?? const TextStyle())
        .copyWith(
          fontSize: chart.labelFontSize,
          color: theme.colors.textSecondary,
        );

    final groups = <BarChartGroupData>[];
    for (var groupIndex = 0; groupIndex < widget.groups.length; groupIndex++) {
      final group = widget.groups[groupIndex];
      final rods = <BarChartRodData>[];
      if (_stacked) {
        rods.add(
          _stackedRod(
            groupIndex,
            theme,
            chart,
            palette,
            axisStyle,
            labelLayout,
          ),
        );
      } else {
        for (
          var seriesIndex = 0;
          seriesIndex < group.values.length;
          seriesIndex++
        ) {
          final value = group.values[seriesIndex];
          final hidden = _hiddenSeries.contains(seriesIndex);
          final suppressNull =
              value.value == null &&
              widget.nullPolicy != HyperChartNullPolicy.zero;
          final numeric = hidden ? 0.0 : (value.value ?? 0);
          final selection = HyperChartSelection(groupIndex, seriesIndex);
          final hit = _hit(selection);
          final baseColor =
              value.color ??
              (seriesIndex < widget.series.length
                  ? widget.series[seriesIndex].color
                  : null) ??
              palette[seriesIndex % palette.length];
          final isHovered = selection == _hovered;
          final isSelected = _selected.contains(selection);
          final resolved =
              widget.colorResolver?.call(
                HyperBarChartStyleContext(
                  hit: hit,
                  baseColor: baseColor,
                  isHovered: isHovered,
                  isSelected: isSelected,
                ),
              ) ??
              baseColor;
          final hasActive = _hovered != null || _selected.isNotEmpty;
          final active = isHovered || isSelected;
          rods.add(
            BarChartRodData(
              toY: numeric,
              color: value.gradient == null
                  ? resolved.withValues(
                      alpha: hidden || suppressNull
                          ? 0
                          : (hasActive && !active ? chart.inactiveOpacity : 1),
                    )
                  : null,
              gradient: hidden || suppressNull ? null : value.gradient,
              // Keep plot geometry stable while the pointer moves. Changing
              // rod width here makes fl_chart relayout and animate axis labels
              // on every hover update.
              width: chart.barWidth,
              borderRadius: BorderRadius.circular(chart.radius),
              label: BarChartRodLabel(
                show:
                    _showLabel(labelLayout, groupIndex, seriesIndex) &&
                    !hidden &&
                    value.value != null,
                text:
                    _valueAxis.formatter?.call(numeric) ??
                    hyperChartNumber(numeric),
                style: axisStyle.copyWith(color: theme.colors.textPrimary),
              ),
            ),
          );
        }
      }
      groups.add(
        BarChartGroupData(
          x: groupIndex,
          barRods: rods,
          barsSpace: math.max(2, chart.groupSpacing / 4),
        ),
      );
    }

    final boundaryLabelSpace = widget.showValues
        ? _valueLabelExtent(axisStyle) + 8
        : 0.0;
    final positiveLabelSpace = maxValue > 0 ? boundaryLabelSpace : 0.0;
    final negativeLabelSpace = minValue < 0 ? boundaryLabelSpace : 0.0;

    return BarChartData(
      barGroups: groups,
      groupsSpace: chart.groupSpacing,
      minY: minY,
      maxY: maxY,
      alignment: BarChartAlignment.spaceAround,
      borderData: FlBorderData(show: false),
      gridData: FlGridData(
        show: widget.showGrid,
        drawVerticalLine: false,
        horizontalInterval: valueInterval,
        getDrawingHorizontalLine: (_) => FlLine(
          color: theme.colors.outline.withValues(alpha: chart.gridOpacity),
          strokeWidth: 1,
        ),
      ),
      titlesData: FlTitlesData(
        // With a quarter-turn, the logical top side becomes the physical
        // right edge. Reserve this side for positive labels in both layouts.
        topTitles: _reservedTitles(positiveLabelSpace),
        rightTitles: _horizontal
            ? _leftTitles(axisStyle, chart, minY, maxY, valueInterval, 0)
            : const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: _bottomTitles(
          axisStyle,
          chart,
          categoryLabelStride,
          negativeLabelSpace,
        ),
        leftTitles: _horizontal
            ? const AxisTitles(sideTitles: SideTitles(showTitles: false))
            : _leftTitles(axisStyle, chart, minY, maxY, valueInterval, 0),
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
                direction: _horizontal
                    ? LabelDirection.verticalMirrored
                    : LabelDirection.horizontal,
              ),
            ),
        ],
      ),
      rotationQuarterTurns: _horizontal ? 1 : 0,
      barTouchData: BarTouchData(
        enabled: widget.interactive,
        handleBuiltInTouches: false,
        mouseCursorResolver: (_, response) => response?.spot == null
            ? SystemMouseCursors.basic
            : SystemMouseCursors.click,
        touchCallback: _handleTouch,
      ),
    );
  }

  BarChartRodData _stackedRod(
    int groupIndex,
    HyperThemeData theme,
    HyperChartTokens chart,
    List<Color> palette,
    TextStyle axisStyle,
    _HyperBarLabelLayout labelLayout,
  ) {
    final group = widget.groups[groupIndex];
    final items = <BarChartRodStackItem>[];
    var positive = 0.0;
    var negative = 0.0;
    for (
      var seriesIndex = 0;
      seriesIndex < group.values.length;
      seriesIndex++
    ) {
      final value = group.values[seriesIndex];
      final hidden = _hiddenSeries.contains(seriesIndex);
      final suppressNull =
          value.value == null && widget.nullPolicy != HyperChartNullPolicy.zero;
      final numeric = hidden || suppressNull ? 0.0 : (value.value ?? 0);
      final from = numeric >= 0 ? positive : negative;
      final to = from + numeric;
      if (numeric >= 0) {
        positive = to;
      } else {
        negative = to;
      }
      final selection = HyperChartSelection(groupIndex, seriesIndex);
      final isHovered = selection == _hovered;
      final isSelected = _selected.contains(selection);
      final baseColor =
          value.color ??
          (seriesIndex < widget.series.length
              ? widget.series[seriesIndex].color
              : null) ??
          palette[seriesIndex % palette.length];
      final resolved =
          widget.colorResolver?.call(
            HyperBarChartStyleContext(
              hit: _hit(selection),
              baseColor: baseColor,
              isHovered: isHovered,
              isSelected: isSelected,
            ),
          ) ??
          baseColor;
      final hasActive = _hovered != null || _selected.isNotEmpty;
      final active = isHovered || isSelected;
      final color = resolved.withValues(
        alpha: hidden || suppressNull
            ? 0
            : (hasActive && !active ? chart.inactiveOpacity : 1),
      );
      items.add(
        BarChartRodStackItem(
          from,
          to,
          hidden || suppressNull
              ? Colors.transparent
              : (value.gradient == null ? color : null),
          gradient: hidden || suppressNull ? null : value.gradient,
        ),
      );
    }
    final total = positive + negative;
    return BarChartRodData(
      fromY: negative,
      toY: positive,
      color: Colors.transparent,
      // Hover is conveyed by segment color/opacity. A stable width prevents
      // category and value-axis labels from shifting during pointer movement.
      width: chart.barWidth,
      borderRadius: BorderRadius.circular(chart.radius),
      rodStackItems: items,
      label: BarChartRodLabel(
        show: _showLabel(labelLayout, groupIndex, 0),
        text: _valueAxis.formatter?.call(total) ?? hyperChartNumber(total),
        style: axisStyle.copyWith(color: theme.colors.textPrimary),
      ),
    );
  }

  double _valueLabelExtent(TextStyle style) {
    final labels = <String>[];
    for (final group in widget.groups) {
      if (_stacked) {
        final total = group.values.fold<double>(
          0,
          (sum, value) => sum + (value.value ?? 0),
        );
        labels.add(
          _valueAxis.formatter?.call(total) ?? hyperChartNumber(total),
        );
      } else {
        for (final value in group.values) {
          if (value.value == null) continue;
          labels.add(
            _valueAxis.formatter?.call(value.value!) ??
                hyperChartNumber(value.value!),
          );
        }
      }
    }
    if (labels.isEmpty) return 0;
    final painter = TextPainter(maxLines: 1, textDirection: TextDirection.ltr);
    var extent = 0.0;
    for (final label in labels) {
      painter.text = TextSpan(text: label, style: style);
      painter.layout();
      extent = math.max(extent, _horizontal ? painter.width : painter.height);
    }
    painter.dispose();
    return extent;
  }

  AxisTitles _reservedTitles(double size) => AxisTitles(
    sideTitles: SideTitles(
      showTitles: size > 0,
      reservedSize: size,
      getTitlesWidget: (_, _) => const SizedBox.shrink(),
    ),
  );

  AxisTitles _bottomTitles(
    TextStyle style,
    HyperChartTokens chart,
    int labelStride,
    double boundaryLabelSpace,
  ) => AxisTitles(
    axisNameWidget: !_categoryAxis.show || _categoryAxis.title == null
        ? null
        : Text(
            _categoryAxis.title!,
            style: style,
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
          ),
    axisNameSize: !_categoryAxis.show || _categoryAxis.title == null ? 0 : 20,
    sideTitles: SideTitles(
      showTitles: _categoryAxis.show,
      reservedSize: math.max(
        _categoryAxis.reservedSize ??
            (_horizontal
                ? hyperChartAxisReservedWidth(
                    widget.groups.map((group) => group.label),
                    style,
                    chart,
                  )
                : 26),
        boundaryLabelSpace,
      ),
      // Horizontal bars map categories to the physical Y axis. Keep one
      // title per bar; fl_chart otherwise derives an interval and silently
      // drops alternating category labels.
      interval: _categoryAxis.interval ?? (_horizontal ? 1 : null),
      getTitlesWidget: (value, meta) {
        final index = value.round();
        if (index < 0 || index >= widget.groups.length || value != index) {
          return const SizedBox.shrink();
        }
        if (_categoryAxis.interval == null &&
            labelStride > 1 &&
            !hyperChartShowSampledLabel(
              index,
              widget.groups.length,
              labelStride,
            )) {
          return const SizedBox.shrink();
        }
        return SideTitleWidget(
          meta: meta,
          space: 6,
          child: Text(
            widget.groups[index].label,
            style: style,
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
    ),
  );

  AxisTitles _leftTitles(
    TextStyle style,
    HyperChartTokens chart,
    double min,
    double max,
    double valueInterval,
    double boundaryLabelSpace,
  ) => AxisTitles(
    axisNameWidget: !_valueAxis.show || _valueAxis.title == null
        ? null
        : Text(
            _valueAxis.title!,
            style: style,
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
          ),
    axisNameSize: !_valueAxis.show || _valueAxis.title == null ? 0 : 20,
    sideTitles: SideTitles(
      showTitles: _valueAxis.show,
      maxIncluded: true,
      reservedSize: math.max(
        _valueAxis.reservedSize ??
            (_horizontal
                ? 26
                : hyperChartAxisReservedWidth(
                    hyperChartValueAxisLabels(min, max, _valueAxis.formatter),
                    style,
                    chart,
                  )),
        boundaryLabelSpace,
      ),
      interval: valueInterval,
      getTitlesWidget: (value, meta) => SideTitleWidget(
        meta: meta,
        space: 6,
        child: Text(
          _valueAxis.formatter?.call(value) ?? hyperChartNumber(value),
          style: style,
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ),
  );

  void _handleTouch(FlTouchEvent event, BarTouchResponse? response) {
    final spot = response?.spot;
    final seriesIndex = spot == null
        ? -1
        : _stacked
        ? spot.touchedStackItemIndex
        : spot.touchedRodDataIndex;
    final next = spot == null || seriesIndex < 0
        ? null
        : HyperChartSelection(spot.touchedBarGroupIndex, seriesIndex);
    final tooltipMessage = next == null || !widget.showTooltip
        ? null
        : _tooltipFor(next);
    final tooltipPosition = tooltipMessage == null
        ? null
        : _pointerPosition(response?.touchLocation);
    if (_hovered != next ||
        _tooltipPosition != tooltipPosition ||
        _tooltipMessage != tooltipMessage) {
      setState(() {
        _hovered = next;
        _tooltipPosition = tooltipPosition;
        _tooltipMessage = tooltipMessage;
      });
    }
    if (event is! FlTapUpEvent || next == null) return;
    _activate(next);
  }

  Offset? _pointerPosition(Offset? position) {
    if (position == null || !_horizontal) return position;
    final size = _chartAreaKey.currentContext?.size;
    if (size == null) return position;
    return Offset(size.width - position.dy, position.dx);
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
    });
  }

  void _activate(HyperChartSelection next) {
    if (widget.selectionEnabled) {
      final changed = Set<HyperChartSelection>.of(_selected);
      changed.contains(next) ? changed.remove(next) : changed.add(next);
      if (!_selectionIsControlled) setState(() => _internalSelected = changed);
      widget.onSelectionChanged?.call(
        Set<HyperChartSelection>.unmodifiable(changed),
      );
    }
    widget.onBarTap?.call(_hit(next));
  }

  List<HyperChartSelection> get _keyboardItems => <HyperChartSelection>[
    for (var groupIndex = 0; groupIndex < widget.groups.length; groupIndex++)
      for (
        var seriesIndex = 0;
        seriesIndex < widget.groups[groupIndex].values.length;
        seriesIndex++
      )
        if (!_hiddenSeries.contains(seriesIndex) &&
            (widget.groups[groupIndex].values[seriesIndex].value != null ||
                widget.nullPolicy == HyperChartNullPolicy.zero))
          HyperChartSelection(groupIndex, seriesIndex),
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
    if (!widget.selectionEnabled) {
      setState(() {
        _hovered = null;
        _tooltipPosition = null;
        _tooltipMessage = null;
      });
      return;
    }
    if (!_selectionIsControlled) {
      setState(() {
        _hovered = null;
        _tooltipPosition = null;
        _tooltipMessage = null;
        _internalSelected = <HyperChartSelection>{};
      });
    } else {
      setState(() {
        _hovered = null;
        _tooltipPosition = null;
        _tooltipMessage = null;
      });
    }
    widget.onSelectionChanged?.call(const <HyperChartSelection>{});
  }

  String _tooltipFor(HyperChartSelection selection) {
    final hit = _hit(selection);
    if (_stacked) {
      final lines = <String>[hit.group.label];
      for (var index = 0; index < hit.group.values.length; index++) {
        if (_hiddenSeries.contains(index)) continue;
        final name = index < widget.series.length
            ? widget.series[index].name
            : '系列 ${index + 1}';
        final value = hit.group.values[index].value ?? 0;
        lines.add(
          '$name ${_valueAxis.formatter?.call(value) ?? hyperChartNumber(value)}',
        );
      }
      return lines.join('\n');
    }
    final seriesName = hit.series?.name;
    final value = hit.value.value ?? 0;
    return '${hit.group.label}${seriesName == null ? '' : ' · $seriesName'}\n${_valueAxis.formatter?.call(value) ?? hyperChartNumber(value)}';
  }

  HyperBarChartHit _hit(HyperChartSelection selection) {
    final group = widget.groups[selection.groupIndex];
    return HyperBarChartHit(
      selection: selection,
      group: group,
      series: selection.seriesIndex < widget.series.length
          ? widget.series[selection.seriesIndex]
          : null,
      value: group.values[selection.seriesIndex],
    );
  }
}

@immutable
class _HyperBarLabelLayout {
  const _HyperBarLabelLayout({
    required this.stride,
    required this.singlePerGroup,
  }) : visible = true;

  const _HyperBarLabelLayout.hidden()
    : stride = 1,
      singlePerGroup = false,
      visible = false;

  final int stride;
  final bool singlePerGroup;
  final bool visible;
}
