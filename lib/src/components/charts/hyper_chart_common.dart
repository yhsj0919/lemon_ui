// Adapted from local lemon_shadcn chart implementations.
import 'hyper_chart_tokens.dart';

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum HyperChartNullPolicy { gap, zero, skip }

enum HyperChartSamplingStrategy { none, largestTriangleThreeBuckets }

@immutable
class HyperChartNumericScale {
  const HyperChartNumericScale(this.min, this.max, this.interval);

  final double min, max, interval;

  Iterable<double> get ticks sync* {
    yield min;
    final first = (min / interval).floor() + 1;
    final last = (max / interval).ceil() - 1;
    for (var index = first; index <= last; index++) {
      final value = index * interval;
      if (value > min && value < max) yield value == 0 ? 0.0 : value;
    }
    yield max;
  }
}

/// Resolves readable numeric bounds while preserving explicit axis limits.
HyperChartNumericScale hyperChartNumericScale(
  double dataMin,
  double dataMax,
  HyperChartAxis axis, {
  bool includeZero = true,
}) {
  var low = dataMin;
  var high = dataMax;
  if (axis.includeZero ?? includeZero) {
    low = math.min(0, low);
    high = math.max(0, high);
  }
  low = axis.min ?? low;
  high = axis.max ?? high;
  if (high <= low) {
    final extent = low == 0 ? 1.0 : low.abs() * .1;
    if (axis.min == null) low -= extent;
    if (axis.max == null) high += extent;
  }
  final interval = axis.interval ?? hyperChartNiceInterval(low, high);
  if (!low.isFinite ||
      !high.isFinite ||
      high <= low ||
      !interval.isFinite ||
      interval <= 0) {
    throw ArgumentError(
      'Numeric axis requires finite increasing bounds and a positive interval.',
    );
  }
  return HyperChartNumericScale(
    axis.min ?? (low / interval).floorToDouble() * interval,
    axis.max ?? (high / interval).ceilToDouble() * interval,
    interval,
  );
}

int hyperChartLoopIndex(int current, int delta, int length) {
  assert(length > 0);
  return (current + delta + length) % length;
}

/// Rounds an automatic value-axis maximum up to a readable 1/2/5-based tick.
double hyperChartNiceMaximum(
  double min,
  double max, {
  double? interval,
  int targetTicks = 5,
}) {
  assert(targetTicks > 0);
  if (max <= min) return min + (interval ?? 1);
  final step =
      interval ?? hyperChartNiceInterval(min, max, targetTicks: targetTicks);
  return (max / step).ceilToDouble() * step;
}

/// Returns an even, readable 1/2/5-based interval for a numeric axis.
double hyperChartNiceInterval(double min, double max, {int targetTicks = 5}) {
  assert(targetTicks > 0);
  return _hyperChartNiceStep((max - min).abs() / targetTicks);
}

double _hyperChartNiceStep(double roughStep) {
  if (!roughStep.isFinite || roughStep <= 0) return 1;
  final magnitude = math.pow(10, (math.log(roughStep) / math.ln10).floor());
  final normalized = roughStep / magnitude;
  final factor = normalized <= 1
      ? 1
      : normalized <= 2
      ? 2
      : normalized <= 5
      ? 5
      : 10;
  return factor * magnitude.toDouble();
}

/// Returns source indices selected with Largest-Triangle-Three-Buckets (LTTB).
/// The first and last values are always retained, and callbacks continue to
/// address the original data because no replacement points are synthesized.
List<int> hyperChartSampleIndices<T>(
  List<T> values, {
  required int maxPoints,
  required double Function(T value) x,
  required double Function(T value) y,
  HyperChartSamplingStrategy strategy =
      HyperChartSamplingStrategy.largestTriangleThreeBuckets,
}) {
  assert(maxPoints >= 3);
  if (strategy == HyperChartSamplingStrategy.none ||
      values.length <= maxPoints) {
    return List<int>.generate(values.length, (index) => index);
  }

  final sampled = <int>[0];
  final every = (values.length - 2) / (maxPoints - 2);
  var selected = 0;
  for (var bucket = 0; bucket < maxPoints - 2; bucket++) {
    final averageStart = ((bucket + 1) * every).floor() + 1;
    final averageEnd = math.min(
      ((bucket + 2) * every).floor() + 1,
      values.length,
    );
    var averageX = 0.0;
    var averageY = 0.0;
    final averageLength = math.max(averageEnd - averageStart, 1);
    for (var index = averageStart; index < averageEnd; index++) {
      averageX += x(values[index]);
      averageY += y(values[index]);
    }
    if (averageStart >= values.length) {
      averageX = x(values.last);
      averageY = y(values.last);
    } else {
      averageX /= averageLength;
      averageY /= averageLength;
    }

    final rangeStart = (bucket * every).floor() + 1;
    final rangeEnd = math.min(
      ((bucket + 1) * every).floor() + 1,
      values.length - 1,
    );
    final selectedX = x(values[selected]);
    final selectedY = y(values[selected]);
    var largestArea = -1.0;
    var next = rangeStart;
    for (var index = rangeStart; index < rangeEnd; index++) {
      final area =
          ((selectedX - averageX) * (y(values[index]) - selectedY) -
                  (selectedX - x(values[index])) * (averageY - selectedY))
              .abs();
      if (area > largestArea) {
        largestArea = area;
        next = index;
      }
    }
    sampled.add(next);
    selected = next;
  }
  sampled.add(values.length - 1);
  return sampled;
}

typedef HyperChartValueFormatter = String Function(double value);

@immutable
class HyperChartAxis {
  const HyperChartAxis({
    this.show = true,
    this.title,
    this.min,
    this.max,
    this.interval,
    this.includeZero,
    this.reservedSize,
    this.formatter,
    this.autoLabelInterval = true,
    this.minLabelSpacing = 8,
    this.labelRotation = 0,
  }) : assert(minLabelSpacing >= 0);

  final bool show;
  final String? title;
  final double? min;
  final double? max;
  final double? interval;

  /// Whether automatic numeric bounds include zero. Defaults to true for
  /// line/bar value axes and false for scatter/price axes. Explicit bounds win.
  final bool? includeZero;
  final double? reservedSize;
  final HyperChartValueFormatter? formatter;

  /// Automatically hides overlapping category labels when [interval] is not
  /// specified. Labels are retained at a uniform stride; a trailing label
  /// that does not align with that stride is omitted.
  final bool autoLabelInterval;

  /// Minimum horizontal space between automatically sampled labels.
  final double minLabelSpacing;

  /// 折线、面积及阶梯图的横轴标签角度，单位为度。
  final double labelRotation;
}

@immutable
class HyperChartReferenceLine {
  const HyperChartReferenceLine({
    required this.value,
    this.label,
    this.color,
    this.width = 1,
    this.dash = const <int>[5, 4],
  });

  final double value;
  final String? label;
  final Color? color;
  final double width;
  final List<int>? dash;
}

@immutable
class HyperChartSelection {
  const HyperChartSelection(this.groupIndex, this.seriesIndex);

  final int groupIndex;
  final int seriesIndex;

  @override
  bool operator ==(Object other) =>
      other is HyperChartSelection &&
      other.groupIndex == groupIndex &&
      other.seriesIndex == seriesIndex;

  @override
  int get hashCode => Object.hash(groupIndex, seriesIndex);
}

List<Color> hyperChartPalette(
  HyperChartTokens chart,
  HyperColorScheme colors, [
  List<Color>? local,
]) {
  if (local != null && local.isNotEmpty) return local;
  if (chart.palette.isNotEmpty) return chart.palette;
  return <Color>[
    colors.primary,
    colors.success,
    colors.warning,
    colors.error,
    Color.lerp(colors.primary, colors.success, .5)!,
    Color.lerp(colors.primary, colors.error, .5)!,
  ];
}

String hyperChartNumber(double value) => value == value.roundToDouble()
    ? value.toInt().toString()
    : value.toStringAsFixed(1);

TextStyle hyperChartAxisStyle(HyperThemeData theme, HyperChartTokens chart) =>
    (theme.textTheme.labelSmall ?? const TextStyle()).copyWith(
      fontSize: chart.labelFontSize,
      color: theme.colors.textSecondary,
    );

double hyperChartAxisReservedWidth(
  Iterable<String> labels,
  TextStyle style,
  HyperChartTokens chart,
) {
  var widest = 0.0;
  final painter = TextPainter(maxLines: 1, textDirection: TextDirection.ltr);
  for (final label in labels) {
    painter.text = TextSpan(text: label, style: style);
    painter.layout(maxWidth: chart.axisMaxReservedSize);
    widest = math.max(widest, painter.width);
  }
  painter.dispose();
  return (widest + 12).clamp(
    chart.axisMinReservedSize,
    chart.axisMaxReservedSize,
  );
}

int hyperChartLabelStride(
  Iterable<String> labels,
  double availableExtent,
  TextStyle style, {
  double minSpacing = 8,
}) {
  final values = labels.toList(growable: false);
  if (values.length < 2 || !availableExtent.isFinite || availableExtent <= 0) {
    return 1;
  }
  var widest = 0.0;
  final painter = TextPainter(maxLines: 1, textDirection: TextDirection.ltr);
  for (final label in values) {
    painter.text = TextSpan(text: label, style: style);
    painter.layout();
    widest = math.max(widest, painter.width);
  }
  painter.dispose();
  final slot = availableExtent / values.length;
  return math.max(1, ((widest + minSpacing) / slot).ceil());
}

bool hyperChartShowSampledLabel(int index, int count, int stride) {
  if (index < 0 || index >= count || count <= 0) return false;
  if (stride <= 1) return true;
  return index % stride == 0;
}

List<String> hyperChartValueAxisLabels(
  double min,
  double max,
  HyperChartValueFormatter? formatter,
) {
  final values = <double>{min, max, 0, (min + max) / 2};
  String label(double value) =>
      formatter?.call(value) ?? hyperChartNumber(value);
  return <String>[for (final value in values) label(value)];
}

class HyperChartLegend extends StatelessWidget {
  const HyperChartLegend({
    super.key,
    required this.items,
    required this.hidden,
    required this.onToggle,
  });

  final List<HyperChartLegendData> items;
  final Set<int> hidden;
  final ValueChanged<int> onToggle;

  @override
  Widget build(BuildContext context) {
    final options = HyperChartLayout.of(context);
    final sizes = HyperTheme.sizesOf(context);
    final children = <Widget>[
      for (var index = 0; index < items.length; index++)
        options.itemBuilder?.call(
              context,
              items[index].label,
              items[index].color,
              hidden.contains(index),
              () => onToggle(index),
            ) ??
            _HyperChartLegendItem(
              data: items[index],
              hidden: hidden.contains(index),
              onTap: () => onToggle(index),
            ),
    ];
    if (options.direction == Axis.vertical) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: options.alignment == WrapAlignment.end
            ? CrossAxisAlignment.end
            : options.alignment == WrapAlignment.center
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: children,
      );
    }
    return Wrap(
      alignment: options.alignment ?? WrapAlignment.start,
      spacing: sizes.compactSectionSpacing,
      runSpacing: sizes.navigationItemSpacing,
      children: children,
    );
  }
}

class HyperChartKeyboardRegion extends StatefulWidget {
  const HyperChartKeyboardRegion({
    super.key,
    required this.child,
    required this.semanticLabel,
    required this.onPrevious,
    required this.onNext,
    required this.onActivate,
    required this.onClear,
    this.onLeft,
    this.onRight,
    this.onUp,
    this.onDown,
    this.enabled = true,
    this.autofocus = false,
  });

  final Widget child;
  final String semanticLabel;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onActivate;
  final VoidCallback onClear;
  final VoidCallback? onLeft;
  final VoidCallback? onRight;
  final VoidCallback? onUp;
  final VoidCallback? onDown;
  final bool enabled;
  final bool autofocus;

  @override
  State<HyperChartKeyboardRegion> createState() =>
      _HyperChartKeyboardRegionState();
}

class _HyperChartKeyboardRegionState extends State<HyperChartKeyboardRegion> {
  bool _focused = false;
  bool _showFocusRing = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final chart = HyperChartTokens(context);
    return Semantics(
      label: widget.semanticLabel,
      focusable: widget.enabled,
      focused: _focused,
      onTap: widget.enabled ? widget.onActivate : null,
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (_) {
          if (widget.enabled) {
            if (_showFocusRing) setState(() => _showFocusRing = false);
            _focusNode.requestFocus();
          }
        },
        child: Focus(
          focusNode: _focusNode,
          autofocus: widget.autofocus,
          canRequestFocus: widget.enabled,
          onFocusChange: (value) => setState(() {
            _focused = value;
            if (!value) _showFocusRing = false;
          }),
          onKeyEvent: _onKeyEvent,
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              widget.child,
              if (_focused && _showFocusRing)
                Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.fromBorderSide(
                          BorderSide(
                            color: theme.colors.primary.withValues(alpha: 0.65),
                            width: chart.keyboardFocusWidth,
                            strokeAlign: BorderSide.strokeAlignOutside,
                          ),
                        ),
                        borderRadius: BorderRadius.circular(
                          HyperTheme.sizesOf(context).controlRadius,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    if (!widget.enabled || event is! KeyDownEvent) {
      return KeyEventResult.ignored;
    }
    if (!_showFocusRing) setState(() => _showFocusRing = true);
    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.arrowLeft) {
      (widget.onLeft ?? widget.onPrevious)();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowUp) {
      (widget.onUp ?? widget.onPrevious)();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowRight) {
      (widget.onRight ?? widget.onNext)();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowDown) {
      (widget.onDown ?? widget.onNext)();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.space) {
      widget.onActivate();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.escape) {
      widget.onClear();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }
}

@immutable
class HyperChartLegendData {
  const HyperChartLegendData({required this.label, required this.color});

  final String label;
  final Color color;
}

class _HyperChartLegendItem extends StatefulWidget {
  const _HyperChartLegendItem({
    required this.data,
    required this.hidden,
    required this.onTap,
  });

  final HyperChartLegendData data;
  final bool hidden;
  final VoidCallback onTap;

  @override
  State<_HyperChartLegendItem> createState() => _HyperChartLegendItemState();
}

class _HyperChartLegendItemState extends State<_HyperChartLegendItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final chart = HyperChartTokens(context);
    final duration = MediaQuery.maybeOf(context)?.disableAnimations == true
        ? Duration.zero
        : chart.animationDuration;
    final colors = theme.colors;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: duration,
          padding: EdgeInsets.all(
            HyperTheme.sizesOf(context).navigationItemSpacing,
          ),
          decoration: BoxDecoration(
            color: _hovered ? colors.surfaceMuted : Colors.transparent,
            borderRadius: BorderRadius.circular(
              HyperTheme.sizesOf(context).controlRadius,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AnimatedContainer(
                duration: duration,
                width: HyperTheme.sizesOf(context).icon.size / 2,
                height: HyperTheme.sizesOf(context).icon.size / 2,
                decoration: BoxDecoration(
                  color: widget.hidden ? Colors.transparent : widget.data.color,
                  border: Border.all(color: widget.data.color),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              SizedBox(
                width: HyperTheme.sizesOf(context).navigationItemSpacing,
              ),
              Flexible(
                child: Text(
                  widget.data.label,
                  style: (theme.textTheme.labelSmall ?? const TextStyle())
                      .copyWith(
                        color: widget.hidden
                            ? colors.textSecondary
                            : colors.textPrimary,
                        decoration: widget.hidden
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
