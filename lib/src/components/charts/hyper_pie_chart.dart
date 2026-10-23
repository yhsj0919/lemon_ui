import 'hyper_chart_legend_binding.dart';
import 'hyper_chart_legend_controller.dart';

import 'dart:math' as math;

import 'hyper_pie_leader_labels.dart';
// Adapted from local lemon_shadcn chart implementations.
import 'hyper_chart_tokens.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'hyper_chart_pointer_tooltip.dart';
import 'hyper_chart_common.dart';

typedef HyperPieChartTapCallback = void Function(HyperPieChartHit hit);
typedef HyperPieChartTooltipBuilder = Widget Function(
  BuildContext context,
  HyperPieChartHit hit,
);
typedef HyperPieChartDataBuilder = PieChartData Function(PieChartData data);

@immutable
class HyperPieSection {
  const HyperPieSection({required this.label, required this.value, this.color})
    : assert(value >= 0);

  final String label;
  final double value;
  final Color? color;
}

@immutable
class HyperPieChartHit {
  const HyperPieChartHit({required this.index, required this.section});

  final int index;
  final HyperPieSection section;
}

class HyperPieChart extends StatefulWidget {
  const HyperPieChart({
    super.key,
    this.style,
    required this.sections,
    this.height,
    this.palette,
    this.showLegend = true,
    this.legendController,
    this.legendIds,
    this.onLegendChanged,
    this.showValues = true,
    this.showLeaderLabels = false,
    this.leaderLabelFormatter,
    this.showTooltip = true,
    this.tooltipStyle,
    this.tooltipWidgetBuilder,
    this.interactive = true,
    this.selectionEnabled = false,
    this.keyboardNavigation = true,
    this.autofocus = false,
    this.semanticLabel = '饼图，使用方向键浏览数据',
    this.valueFormatter,
    this.selectedIndex,
    this.onSelectionChanged,
    this.onSectionTap,
    this.dataBuilder,
  }) : _donut = false;

  const HyperPieChart.donut({
    super.key,
    this.style,
    required this.sections,
    this.height,
    this.palette,
    this.showLegend = true,
    this.legendController,
    this.legendIds,
    this.onLegendChanged,
    this.showValues = true,
    this.showLeaderLabels = false,
    this.leaderLabelFormatter,
    this.showTooltip = true,
    this.tooltipStyle,
    this.tooltipWidgetBuilder,
    this.interactive = true,
    this.selectionEnabled = false,
    this.keyboardNavigation = true,
    this.autofocus = false,
    this.semanticLabel = '环形图，使用方向键浏览数据',
    this.valueFormatter,
    this.selectedIndex,
    this.onSelectionChanged,
    this.onSectionTap,
    this.dataBuilder,
  }) : _donut = true;

  final List<HyperPieSection> sections;
  final double? height;
  final List<Color>? palette;
  final bool showLegend;
  final HyperChartLegendController? legendController;
  final List<String>? legendIds;
  final ValueChanged<List<HyperChartLegendEntry>>? onLegendChanged;
  final bool showValues;
  final bool showLeaderLabels;
  final String Function(HyperPieChartHit hit, double percent)?
  leaderLabelFormatter;
  final bool showTooltip;
  final HyperPointerTooltipStyle? tooltipStyle;
  final HyperPieChartTooltipBuilder? tooltipWidgetBuilder;
  final bool interactive;
  final bool selectionEnabled;
  final bool keyboardNavigation;
  final bool autofocus;
  final String semanticLabel;
  final HyperChartValueFormatter? valueFormatter;
  final int? selectedIndex;
  final ValueChanged<int?>? onSelectionChanged;
  final HyperPieChartTapCallback? onSectionTap;
  final HyperPieChartDataBuilder? dataBuilder;
  final bool _donut;

  final HyperChartStyle? style;

  @override
  State<HyperPieChart> createState() => _HyperPieChartState();
}

class _HyperPieChartState extends State<HyperPieChart>
    with HyperChartLegendBinding<HyperPieChart> {
  Set<int> get _hidden => legendHiddenIndices;
  @override
  HyperChartLegendController? get externalLegendController =>
      widget.legendController;
  @override
  List<String>? get explicitLegendIds => widget.legendIds;
  @override
  ValueChanged<List<HyperChartLegendEntry>>? get legendChanged =>
      widget.onLegendChanged;
  int? _internalSelected;
  int? _hovered;
  Offset? _tooltipPosition;
  String? _tooltipMessage;

  bool get _controlled => widget.onSelectionChanged != null;
  int? get _selected => widget.selectionEnabled
      ? (_controlled ? widget.selectedIndex : _internalSelected)
      : null;

  @override
  void initState() {
    super.initState();
    _internalSelected = widget.selectedIndex;
  }

  @override
  void didUpdateWidget(covariant HyperPieChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_controlled && oldWidget.selectedIndex != widget.selectedIndex) {
      _internalSelected = widget.selectedIndex;
    }
  }

  Widget _defaultTooltip(List<Color> palette) {
    final index = _hovered!;
    final section = widget.sections[index];
    final total = widget.sections
        .asMap()
        .entries
        .where((entry) => !_hidden.contains(entry.key))
        .fold<double>(0, (sum, entry) => sum + entry.value.value);
    final color = section.color ?? palette[index % palette.length];
    return HyperChartTooltipContent(
      title: section.label,
      rows: [
        HyperChartTooltipRow(
          label: '数值',
          value:
              widget.valueFormatter?.call(section.value) ??
              hyperChartNumber(section.value),
          color: color,
        ),
        HyperChartTooltipRow(
          label: '占比',
          value: '${(total == 0 ? 0 : section.value / total * 100).round()}%',
          color: color,
        ),
      ],
    );
  }

  @override
  void legendVisibilityChanged() {
    _hovered = null;
    _tooltipPosition = null;
    _tooltipMessage = null;
  }

  @override
  Widget build(BuildContext context) {
    final chart = HyperChartTokens(context, widget.style);
    final theme = HyperTheme.of(context);
    final palette = hyperChartPalette(chart, theme.colors, widget.palette);
    syncChartLegend([
      for (var index = 0; index < widget.sections.length; index++)
        (
          label: widget.sections[index].label,
          color:
              widget.sections[index].color ?? palette[index % palette.length],
        ),
    ]);
    var total = 0.0;
    for (var index = 0; index < widget.sections.length; index++) {
      if (!_hidden.contains(index)) total += widget.sections[index].value;
    }
    final empty = widget.sections.isEmpty || total == 0;
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
                    if (widget.showLegend) ...<Widget>[
                      HyperChartLegend(
                        items: <HyperChartLegendData>[
                          for (
                            var index = 0;
                            index < widget.sections.length;
                            index++
                          )
                            HyperChartLegendData(
                              label: widget.sections[index].label,
                              color:
                                  widget.sections[index].color ??
                                  palette[index % palette.length],
                            ),
                        ],
                        hidden: _hidden,
                        onToggle: _toggleSection,
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
                        builder: (context, _) =>
                            widget.tooltipWidgetBuilder?.call(
                              context,
                              HyperPieChartHit(
                                index: _hovered!,
                                section: widget.sections[_hovered!],
                              ),
                            ) ??
                            _defaultTooltip(palette),
                        onExit: _clearPointerHover,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final base =
                                widget.dataBuilder?.call(
                                  _data(theme, chart, palette, total),
                                ) ??
                                _data(theme, chart, palette, total);
                            final hole = base.centerSpaceRadius.isFinite
                                ? base.centerSpaceRadius
                                : 0.0;
                            final extent = math.min(
                              constraints.maxWidth,
                              constraints.maxHeight,
                            );
                            final maxRadius =
                                extent * (widget.showLeaderLabels ? .28 : .46);
                            final requested = base.sections.fold<double>(
                              0,
                              (m, section) =>
                                  math.max(m, section.radius + hole),
                            );
                            final scale = requested > maxRadius && requested > 0
                                ? maxRadius / requested
                                : 1.0;
                            final data = base.copyWith(
                              centerSpaceRadius: hole * scale,
                              sections: [
                                for (final section in base.sections)
                                  section.copyWith(
                                    radius: section.radius * scale,
                                  ),
                              ],
                            );
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                PieChart(
                                  data,
                                  duration:
                                      MediaQuery.maybeOf(context)
                                              ?.disableAnimations ==
                                          true
                                      ? Duration.zero
                                      : chart.pieAnimationDuration,
                                ),
                                if (widget._donut)
                                  IgnorePointer(
                                    child: _centerLabel(theme, total),
                                  ),
                                if (widget.showLeaderLabels)
                                  Positioned.fill(
                                    child: IgnorePointer(
                                      child: HyperPieLeaderLabels(
                                        sections: widget.sections,
                                        hidden: _hidden,
                                        total: total,
                                        radius: requested * scale,
                                        formatter: widget.leaderLabelFormatter,
                                        style:
                                            (theme.textTheme.labelSmall ??
                                                    const TextStyle())
                                                .copyWith(
                                                  fontSize: chart.labelFontSize,
                                                  color: theme
                                                      .colors
                                                      .textSecondary,
                                                ),
                                        strokeWidth: HyperTheme.sizesOf(context)
                                            .divider
                                            .thickness,
                                        gap: chart.legendSpacing,
                                        scaler: MediaQuery.textScalerOf(
                                          context,
                                        ),
                                        direction: Directionality.of(context),
                                      ),
                                    ),
                                  ),
                              ],
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

  PieChartData _data(
    HyperThemeData theme,
    HyperChartTokens chart,
    List<Color> palette,
    double total,
  ) => PieChartData(
    centerSpaceRadius: widget._donut ? chart.donutHoleRadius : 0,
    centerSpaceColor: theme.colors.background,
    sectionsSpace: chart.pieSectionSpacing,
    startDegreeOffset: -90,
    sections: <PieChartSectionData>[
      for (var index = 0; index < widget.sections.length; index++)
        _section(index, theme, chart, palette, total),
    ],
    pieTouchData: PieTouchData(
      enabled: widget.interactive,
      mouseCursorResolver: (_, response) =>
          response?.touchedSection?.touchedSectionIndex != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      touchCallback: _handleTouch,
    ),
  );

  PieChartSectionData _section(
    int index,
    HyperThemeData theme,
    HyperChartTokens chart,
    List<Color> palette,
    double total,
  ) {
    final item = widget.sections[index];
    final hidden = _hidden.contains(index);
    final active = _hovered == index || _selected == index;
    final hasActive = _hovered != null || _selected != null;
    final base = item.color ?? palette[index % palette.length];
    final color = base.withValues(
      alpha: hidden ? 0 : (hasActive && !active ? chart.inactiveOpacity : 1),
    );
    final percent = total == 0 ? 0 : item.value / total * 100;
    return PieChartSectionData(
      value: hidden ? 0 : item.value,
      color: color,
      radius: chart.pieRadius * (active ? chart.hoverScale : 1),
      cornerRadius: chart.radius,
      showTitle:
          widget.showValues && !hidden && percent >= chart.pieLabelMinPercent,
      title: '${percent.round()}%',
      titleStyle: (theme.textTheme.labelSmall ?? const TextStyle()).copyWith(
        color: _foregroundFor(base),
        fontWeight: FontWeight.w600,
      ),
      titlePositionPercentageOffset: widget._donut ? 0.55 : 0.62,
    );
  }

  Widget _centerLabel(HyperThemeData theme, double total) {
    final index = _hovered ?? _selected;
    final label = index == null ? '总计' : widget.sections[index].label;
    final value = index == null ? total : widget.sections[index].value;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          widget.valueFormatter?.call(value) ?? hyperChartNumber(value),
          style: (theme.textTheme.titleLarge ?? const TextStyle()).copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: (theme.textTheme.labelSmall ?? const TextStyle()).copyWith(
            color: theme.colors.textSecondary,
          ),
        ),
      ],
    );
  }

  void _toggleSection(int index) {
    if (!_hidden.contains(index) &&
        _hidden.length == widget.sections.length - 1) {
      return;
    }
    setState(() {
      toggleLegendIndex(index);
    });
  }

  void _handleTouch(FlTouchEvent event, PieTouchResponse? response) {
    final touched = response?.touchedSection?.touchedSectionIndex;
    final next = touched == null || touched < 0 ? null : touched;
    final tooltipMessage = next == null || !widget.showTooltip
        ? null
        : _tooltipFor(next);
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
    });
  }

  void _activate(int next) {
    if (widget.selectionEnabled) {
      final changed = _selected == next ? null : next;
      if (!_controlled) setState(() => _internalSelected = changed);
      widget.onSelectionChanged?.call(changed);
    }
    widget.onSectionTap?.call(
      HyperPieChartHit(index: next, section: widget.sections[next]),
    );
  }

  List<int> get _keyboardItems => <int>[
    for (var index = 0; index < widget.sections.length; index++)
      if (!_hidden.contains(index) && widget.sections[index].value > 0) index,
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
    if (!_controlled) {
      setState(() {
        _hovered = null;
        _tooltipPosition = null;
        _tooltipMessage = null;
        _internalSelected = null;
      });
    } else {
      setState(() {
        _hovered = null;
        _tooltipPosition = null;
        _tooltipMessage = null;
      });
    }
    widget.onSelectionChanged?.call(null);
  }

  String _tooltipFor(int index) {
    final visibleTotal = widget.sections
        .asMap()
        .entries
        .where((entry) => !_hidden.contains(entry.key))
        .fold<double>(0, (sum, entry) => sum + entry.value.value);
    final section = widget.sections[index];
    final percent = visibleTotal == 0 ? 0 : section.value / visibleTotal * 100;
    return '${section.label}\n${widget.valueFormatter?.call(section.value) ?? hyperChartNumber(section.value)} · ${percent.round()}%';
  }
}

Color _foregroundFor(Color color) =>
    color.computeLuminance() > 0.48 ? const Color(0xff111827) : Colors.white;
