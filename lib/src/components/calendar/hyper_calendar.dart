import '../../foundation/hyper_icons.dart';

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/core/hyper_theme.dart';
import '../../foundation/hyper_device_type.dart';
import '../../interaction/hyper_pressable.dart';
import '../../foundation/hyper_control_state.dart';
import '../button/hyper_button_theme.dart';
import '../button/hyper_button.dart';
import '../button/hyper_button_style.dart';
import 'hyper_calendar_style.dart';
import 'hyper_calendar_theme.dart';

DateTime _date(DateTime d) => DateTime(d.year, d.month, d.day);
bool _same(DateTime? a, DateTime b) =>
    a != null && a.year == b.year && a.month == b.month && a.day == b.day;

/// 内嵌公历日历。普通模式选单日，range 模式选包含端点的日期区间。
/// 日期以本地年月日处理，不换算时区；空回调表示只读。
enum HyperCalendarPanels { adaptive, single, doubleMonth }

class HyperCalendar extends StatefulWidget {
  const HyperCalendar({
    super.key,
    required this.value,
    required this.onChanged,
    this.firstDate,
    this.lastDate,
    this.initialMonth,
    this.selectableDayPredicate,
    this.firstDayOfWeek,
    this.useChineseLabels = true,
    this.currentDate,
    this.style,
    this.onDisplayedMonthChanged,
    this.panels = HyperCalendarPanels.adaptive,
  }) : range = false,
       rangeValue = null,
       onRangeChanged = null;
  const HyperCalendar.range({
    super.key,
    required DateTimeRange? value,
    required ValueChanged<DateTimeRange>? onChanged,
    this.firstDate,
    this.lastDate,
    this.initialMonth,
    this.selectableDayPredicate,
    this.firstDayOfWeek,
    this.useChineseLabels = true,
    this.currentDate,
    this.style,
    this.onDisplayedMonthChanged,
    this.panels = HyperCalendarPanels.adaptive,
  }) : range = true,
       rangeValue = value,
       onRangeChanged = onChanged,
       value = null,
       onChanged = null;
  final bool range;
  final HyperCalendarPanels panels;

  /// 默认中文标题、星期和导航；false 时使用宿主 MaterialLocalizations。
  final bool useChineseLabels;
  final DateTime? value, firstDate, lastDate, initialMonth, currentDate;
  final DateTimeRange? rangeValue;
  final ValueChanged<DateTime>? onChanged, onDisplayedMonthChanged;
  final ValueChanged<DateTimeRange>? onRangeChanged;
  final bool Function(DateTime)? selectableDayPredicate;

  /// 0 为周日，1 为周一；省略时跟随 MaterialLocalizations。
  final int? firstDayOfWeek;
  final HyperCalendarStyle? style;
  @override
  State<HyperCalendar> createState() => _HyperCalendarState();
}

class _HyperCalendarState extends State<HyperCalendar> {
  late DateTime month;
  DateTime? pending;
  int _view = 0; // 0 days, 1 months, 2 years
  int _yearPage = 0;
  DateTime get first => _date(widget.firstDate ?? DateTime(1900));
  DateTime get last => _date(widget.lastDate ?? DateTime(2100, 12, 31));
  bool get enabled =>
      widget.range ? widget.onRangeChanged != null : widget.onChanged != null;
  @override
  void initState() {
    super.initState();
    _validate();
    month = _month(
      widget.initialMonth ??
          widget.value ??
          widget.rangeValue?.start ??
          widget.currentDate ??
          DateTime.now(),
    );
  }

  void _validate() {
    if (first.isAfter(last)) throw ArgumentError('firstDate 不能晚于 lastDate');
    if (widget.firstDayOfWeek != null &&
        (widget.firstDayOfWeek! < 0 || widget.firstDayOfWeek! > 6)) {
      throw ArgumentError('firstDayOfWeek 须为 0–6');
    }
  }

  DateTime _month(DateTime d) {
    final day = d.isBefore(first)
        ? first
        : d.isAfter(last)
        ? last
        : d;
    return DateTime(day.year, day.month);
  }

  @override
  void didUpdateWidget(HyperCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _validate();
    month = _month(month);
    if (oldWidget.range != widget.range ||
        oldWidget.rangeValue != widget.rangeValue ||
        oldWidget.firstDate != widget.firstDate ||
        oldWidget.lastDate != widget.lastDate ||
        oldWidget.selectableDayPredicate != widget.selectableDayPredicate ||
        !enabled) {
      pending = null;
    }
  }

  bool available(DateTime d) =>
      !d.isBefore(first) &&
      !d.isAfter(last) &&
      (widget.selectableDayPredicate?.call(d) ?? true);
  bool validRange(DateTime a, DateTime b) {
    final start = a.isBefore(b) ? a : b, end = a.isBefore(b) ? b : a;
    if (widget.selectableDayPredicate == null) return true;
    for (
      var d = start;
      !d.isAfter(end);
      d = DateTime(d.year, d.month, d.day + 1)
    ) {
      if (!available(d)) return false;
    }
    return true;
  }

  void select(DateTime d) {
    if (!enabled || !available(d)) return;
    if (!widget.range) {
      widget.onChanged!(d);
      return;
    }
    if (pending == null) {
      setState(() => pending = d);
      return;
    }
    if (!validRange(pending!, d)) {
      setState(() => pending = d);
      return;
    }
    final start = pending!.isBefore(d) ? pending! : d;
    final end = pending!.isBefore(d) ? d : pending!;
    setState(() => pending = null);
    widget.onRangeChanged!(DateTimeRange(start: start, end: end));
  }

  void _showMonth(DateTime date, {bool keepView = false}) {
    final next = _month(date);
    setState(() {
      month = next;
      if (!keepView) _view = 0;
    });
    widget.onDisplayedMonthChanged?.call(next);
  }

  void navigate(int delta) {
    final next = _month(DateTime(month.year, month.month + delta));
    if (next == month) return;
    setState(() {
      month = next;
    });
    widget.onDisplayedMonthChanged?.call(month);
  }

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context),
        sizes = HyperTheme.sizesOf(context).calendar;
    final style = HyperCalendarTheme.of(context).style.merge(widget.style);
    final l = MaterialLocalizations.of(context),
        today = _date(widget.currentDate ?? DateTime.now());
    final start = pending ?? widget.rangeValue?.start,
        end = pending ?? widget.rangeValue?.end;
    final firstWeekday =
        widget.firstDayOfWeek ??
        (widget.useChineseLabels ? 1 : l.firstDayOfWeekIndex);
    final spacing = style.spacing ?? sizes.spacing;
    final textStyle = (theme.textTheme.bodyMedium ?? const TextStyle()).merge(
      style.textStyle,
    );
    Widget panel(DateTime month) {
      final offset = (month.weekday % 7 - firstWeekday + 7) % 7;
      final days = DateTime(month.year, month.month + 1, 0).day;
      final rows = ((offset + days) / 7).ceil();
      return LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.constrainWidth(style.width ?? sizes.width);
          final cellWidth = math.max(0.0, (width - spacing * 6) / 7);
          double heightFor(String label, TextStyle text) {
            final painter = TextPainter(
              text: TextSpan(text: label, style: text),
              textDirection: Directionality.of(context),
              textScaler: MediaQuery.textScalerOf(context),
            )..layout(maxWidth: math.max(1, cellWidth));
            final h = painter.height.ceilToDouble();
            painter.dispose();
            return h;
          }

          final selectionExtent = math.min(
            cellWidth,
            style.selectionSize ?? sizes.selectionSize ?? sizes.dayMinHeight,
          );
          var dayHeight = style.dayMinHeight ?? sizes.dayMinHeight;
          for (var d = 1; d <= 31; d++) {
            dayHeight = math.max(
              dayHeight,
              heightFor(l.formatDecimal(d), textStyle),
            );
          }
          final radius = (style.radius ?? sizes.radius).clamp(
            0.0,
            selectionExtent / 2,
          );
          Widget cell(DateTime d) {
            final selected = widget.range
                ? _same(start, d) || _same(end, d)
                : _same(widget.value, d);
            final inRange =
                widget.range &&
                start != null &&
                end != null &&
                !d.isBefore(_date(start)) &&
                !d.isAfter(_date(end));
            final allowed = available(d);
            final color = selected
                ? style.selectedForegroundColor ?? theme.colors.onPrimary
                : !allowed
                ? style.disabledColor ?? theme.colors.disabled
                : style.foregroundColor ?? theme.colors.textPrimary;
            return HyperPressable(
              key: ValueKey('calendar-${d.year}-${d.month}-${d.day}'),
              enabled: enabled && allowed,
              onTap: () => select(d),
              semanticLabel: widget.useChineseLabels
                  ? '${d.year}年${d.month}月${d.day}日'
                  : l.formatFullDate(d),
              builder: (context, states, child) {
                final button = HyperButtonTheme.of(context)
                    .resolve(HyperButtonVariant.text);
                final metrics = HyperTheme.sizesOf(context).button;
                final alpha = states.contains(HyperControlState.pressed)
                    ? button.pressOverlayOpacity ?? metrics.pressOverlayOpacity
                    : states.contains(HyperControlState.focused)
                    ? button.focusOverlayOpacity ?? metrics.focusOverlayOpacity
                    : states.contains(HyperControlState.hovered)
                    ? button.hoverOverlayOpacity ?? metrics.hoverOverlayOpacity
                    : 0.0;
                final fill = selected
                    ? style.selectedColor ?? theme.colors.primary
                    : Colors.transparent;
                final duration = MediaQuery.disableAnimationsOf(context)
                    ? Duration.zero
                    : theme.motion.fastDuration;
                return SizedBox(
                  width: cellWidth,
                  height: dayHeight,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      IgnorePointer(
                        child: SizedBox.square(
                          dimension: selectionExtent,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: inRange
                                  ? style.rangeColor ??
                                        theme.colors.surfaceMuted
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(radius),
                            ),
                            child: AnimatedContainer(
                              duration: duration,
                              curve: theme.motion.fastCurve,
                              decoration: BoxDecoration(
                                color: fill,
                                borderRadius: BorderRadius.circular(radius),
                                border: _same(today, d)
                                    ? Border.all(
                                        color:
                                            style.todayColor ??
                                            theme.colors.primary,
                                      )
                                    : null,
                              ),
                              foregroundDecoration: BoxDecoration(
                                color:
                                    (button.overlayColor ??
                                            theme.colors.stateLayer)
                                        .withValues(alpha: alpha),
                                borderRadius: BorderRadius.circular(radius),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Semantics(
                        selected: selected,
                        child: Text(
                          l.formatDecimal(d.day),
                          textAlign: TextAlign.center,
                          style: textStyle.copyWith(color: color),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }

          return SizedBox(
            width: width,
            child: ColoredBox(
              color: style.backgroundColor ?? Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      HyperButton.text(
                        key: const ValueKey('calendar-previous'),
                        onPressed: _view == 2
                            ? (_yearPage > first.year
                                  ? () => setState(
                                      () => _yearPage = math.max(
                                        first.year,
                                        _yearPage - 12,
                                      ),
                                    )
                                  : null)
                            : _view == 1
                            ? (month.year > first.year
                                  ? () => _showMonth(
                                      DateTime(month.year - 1, month.month),
                                      keepView: true,
                                    )
                                  : null)
                            : (month.isAfter(DateTime(first.year, first.month))
                                  ? () => navigate(-1)
                                  : null),
                        style: HyperButtonStyle(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.square(
                            HyperTheme.sizesOf(context)
                                .minimumInteractiveDimension,
                          ),
                          minimumTapTargetSize: Size.zero,
                        ),
                        child: Semantics(
                          label: widget.useChineseLabels
                              ? (_view == 0 ? '上个月' : '上一页')
                              : l.previousMonthTooltip,
                          child: Icon(
                            HyperIcons.chevronLeft,
                            size: HyperTheme.sizesOf(context).iconSize,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            HyperButton.text(
                              key: const ValueKey('calendar-year-heading'),
                              onPressed: () => setState(() {
                                _yearPage = math.max(
                                  first.year,
                                  month.year - month.year % 12,
                                );
                                _view = _view == 2 ? 0 : 2;
                              }),
                              style: HyperButtonStyle(
                                padding: EdgeInsets.symmetric(
                                  horizontal: spacing,
                                ),
                                minimumSize: Size.zero,
                                minimumTapTargetSize: Size.zero,
                                textStyle:
                                    (theme.textTheme.titleMedium ??
                                            const TextStyle())
                                        .merge(style.headerTextStyle),
                              ),
                              child: Text(
                                _view == 2
                                    ? '$_yearPage–${math.min(last.year, _yearPage + 11)}'
                                    : widget.useChineseLabels
                                    ? '${month.year}年'
                                    : '${month.year}',
                              ),
                            ),
                            if (_view != 2)
                              HyperButton.text(
                                key: const ValueKey('calendar-month-heading'),
                                onPressed: () =>
                                    setState(() => _view = _view == 1 ? 0 : 1),
                                style: HyperButtonStyle(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: spacing,
                                  ),
                                  minimumSize: Size.zero,
                                  minimumTapTargetSize: Size.zero,
                                  textStyle:
                                      (theme.textTheme.titleMedium ??
                                              const TextStyle())
                                          .merge(style.headerTextStyle),
                                ),
                                child: Text(
                                  widget.useChineseLabels
                                      ? '${month.month}月'
                                      : l.formatMonthYear(month),
                                ),
                              ),
                          ],
                        ),
                      ),
                      HyperButton.text(
                        key: const ValueKey('calendar-next'),
                        onPressed: _view == 2
                            ? (_yearPage + 11 < last.year
                                  ? () => setState(() => _yearPage += 12)
                                  : null)
                            : _view == 1
                            ? (month.year < last.year
                                  ? () => _showMonth(
                                      DateTime(month.year + 1, month.month),
                                      keepView: true,
                                    )
                                  : null)
                            : (month.isBefore(DateTime(last.year, last.month))
                                  ? () => navigate(1)
                                  : null),
                        style: HyperButtonStyle(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.square(
                            HyperTheme.sizesOf(context)
                                .minimumInteractiveDimension,
                          ),
                          minimumTapTargetSize: Size.zero,
                        ),
                        child: Semantics(
                          label: widget.useChineseLabels
                              ? (_view == 0 ? '下个月' : '下一页')
                              : l.nextMonthTooltip,
                          child: Icon(
                            HyperIcons.chevronRight,
                            size: HyperTheme.sizesOf(context).iconSize,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_view != 0)
                    Wrap(
                      spacing: spacing,
                      runSpacing: spacing,
                      children: [
                        for (var i = 0; i < 12; i++)
                          SizedBox(
                            width: math.max(0, (width - spacing * 2) / 3),
                            child: HyperButton.text(
                              key: ValueKey(
                                _view == 2
                                    ? 'calendar-year-${_yearPage + i}'
                                    : 'calendar-month-${i + 1}',
                              ),
                              onPressed: _view == 2
                                  ? (_yearPage + i <= last.year
                                        ? () => _showMonth(
                                            DateTime(
                                              _yearPage + i,
                                              month.month,
                                            ),
                                          )
                                        : null)
                                  : (!DateTime(
                                              month.year,
                                              i + 2,
                                              0,
                                            ).isBefore(first) &&
                                            !DateTime(
                                              month.year,
                                              i + 1,
                                            ).isAfter(last)
                                        ? () => _showMonth(
                                            DateTime(month.year, i + 1),
                                          )
                                        : null),
                              style: HyperButtonStyle(
                                minimumSize: Size(0, dayHeight),
                                textStyle: textStyle,
                              ),
                              child: Text(
                                _view == 2
                                    ? '${_yearPage + i}'
                                    : widget.useChineseLabels
                                    ? '${i + 1}月'
                                    : l.formatMonthYear(
                                        DateTime(month.year, i + 1),
                                      ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  if (_view == 0) ...[
                    SizedBox(height: spacing),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var i = 0; i < 7; i++) ...[
                          if (i > 0) SizedBox(width: spacing),
                          SizedBox(
                            width: cellWidth,
                            child: Text(
                              (widget.useChineseLabels
                                  ? const ['日', '一', '二', '三', '四', '五', '六']
                                  : l.narrowWeekdays)[(firstWeekday + i) % 7],
                              textAlign: TextAlign.center,
                              style: textStyle
                                  .merge(style.weekdayTextStyle)
                                  .copyWith(
                                    color:
                                        style.weekdayColor ??
                                        theme.colors.textSecondary,
                                  ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    for (var row = 0; row < rows; row++) ...[
                      SizedBox(height: spacing),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var col = 0; col < 7; col++) ...[
                            if (col > 0) SizedBox(width: spacing),
                            if (row * 7 + col - offset + 1 case final day
                                when day >= 1 && day <= days)
                              cell(DateTime(month.year, month.month, day))
                            else
                              SizedBox(width: cellWidth, height: dayHeight),
                          ],
                        ],
                      ),
                    ],
                  ],
                ],
              ),
            ),
          );
        },
      );
    }

    final dual =
        widget.panels == HyperCalendarPanels.doubleMonth ||
        (widget.panels == HyperCalendarPanels.adaptive &&
            widget.range &&
            HyperTheme.sizesOf(context).deviceType == HyperDeviceType.desktop);
    final nextMonth = DateTime(month.year, month.month + 1);
    if (!dual || nextMonth.isAfter(DateTime(last.year, last.month))) {
      return panel(month);
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final desired = style.width ?? sizes.width;
        final panelWidth = constraints.hasBoundedWidth
            ? math.min(desired, constraints.maxWidth)
            : desired;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            SizedBox(width: panelWidth, child: panel(month)),
            SizedBox(width: panelWidth, child: panel(nextMonth)),
          ],
        );
      },
    );
  }
}
