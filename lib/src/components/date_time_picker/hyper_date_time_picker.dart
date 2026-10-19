import '../number_input/hyper_number_input.dart';
import '../select/hyper_selection_layout.dart';
import '../wheel_picker/hyper_wheel_picker_style.dart';

import '../button/hyper_button_theme.dart';

import '../../foundation/hyper_device_type.dart';

import 'package:flutter/material.dart';

import '../../theme/core/hyper_theme.dart';
import '../card/hyper_card_style.dart';
import '../select/hyper_dropdown.dart';
import '../select/hyper_select_model.dart';
import '../select/hyper_selection_style.dart';
import '../select/hyper_selection_theme.dart';
import '../select/hyper_select_theme.dart';
import '../calendar/hyper_calendar.dart';
import '../wheel_picker/hyper_wheel_picker.dart';
import '../select/hyper_select_style.dart';

enum HyperDateTimePickerMode { date, time, dateTime }

double _timePanelWidth(BuildContext context) {
  final sizes = HyperTheme.sizesOf(context);
  var width = sizes.menu.padding * 2;
  for (final entry in [
    (HyperButtonVariant.text, '清空'),
    (HyperButtonVariant.outlined, '取消'),
    (HyperButtonVariant.filled, '确定'),
  ]) {
    final style = HyperButtonTheme.of(context).resolve(entry.$1);
    final painter = TextPainter(
      text: TextSpan(
        text: entry.$2,
        style:
            (HyperTheme.of(context).textTheme.labelLarge ?? const TextStyle())
                .merge(style.textStyle),
      ),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
    )..layout();
    final contentWidth =
        painter.width +
        (style.padding ?? sizes.button.padding)
            .resolve(Directionality.of(context))
            .horizontal;
    painter.dispose();
    final minimum = style.minimumSize?.width ?? sizes.button.minimumSize.width;
    width +=
        style.width ??
        sizes.button.width ??
        (contentWidth > minimum ? contentWidth : minimum);
  }
  return width > sizes.select.width ? width.ceilToDouble() : sizes.select.width;
}

// Editing panels need the dialog's content inset rather than the compact
// option-list inset. Explicit menu, selection and instance padding still win.
HyperCardStyle? _pickerSurface(
  BuildContext context,
  HyperSelectStyle? style,
  HyperCardStyle? instance,
) {
  if (HyperTheme.sizesOf(context).deviceType != HyperDeviceType.desktop) {
    return instance;
  }
  final select =
      (HyperSelectTheme.of(context).style ?? const HyperSelectStyle()).merge(
        style,
      );
  final selection = HyperSelectionTheme.of(context).style
      .merge(select.selectionStyle);
  final menu = selection.menuStyle;
  return HyperCardStyle(
    padding: menu?.surfacePadding == null
        ? hyperSelectionPadding(context, editing: true)
        : EdgeInsets.all(menu!.surfacePadding!),
  ).merge(menu?.surfaceStyle).merge(selection.surfaceStyle).merge(instance);
}

/// 受控的民用日期时间选择器，精度为分钟，不执行时区换算。
///
/// 日期上下限包含端点；时间模式仅比较上下限的时、分。
/// 选择过程使用草稿，确认后才通知调用方，取消不改变值。
/// 外观、尺寸及设备呈现复用 Select 的强类型主题。
class HyperDateTimePicker extends StatelessWidget {
  const HyperDateTimePicker({
    super.key,
    required this.value,
    required this.onChanged,
    this.mode = HyperDateTimePickerMode.dateTime,
    this.minimum,
    this.maximum,
    this.minuteInterval = 1,
    this.showSeconds = false,
    this.enabled = true,
    this.placeholder,
    this.presentation,
    this.style,
    this.surfaceStyle,
    this.labelBuilder,
  }) : assert(minuteInterval > 0 && 60 % minuteInterval == 0);

  final DateTime? value;
  final ValueChanged<DateTime?>? onChanged;
  final HyperDateTimePickerMode mode;
  final DateTime? minimum, maximum;
  final int minuteInterval;
  final bool showSeconds;
  final bool enabled;
  final String? placeholder;
  final HyperSelectPresentation? presentation;
  final HyperSelectStyle? style;
  final HyperCardStyle? surfaceStyle;
  final String Function(DateTime)? labelBuilder;

  @override
  Widget build(BuildContext context) {
    final bounds = _Bounds(
      mode,
      minimum,
      maximum,
      minuteInterval,
      seconds: showSeconds,
    );
    String format(DateTime date) {
      final day = '${date.year}年${date.month}月${date.day}日';
      final minute =
          date.minute.toString().padLeft(2, '0') +
          (showSeconds ? ':${date.second.toString().padLeft(2, '0')}' : '');
      final time = MediaQuery.alwaysUse24HourFormatOf(context)
          ? '${date.hour.toString().padLeft(2, '0')}:$minute'
          : '${date.hour < 12 ? '上午' : '下午'}${date.hour % 12 == 0 ? 12 : date.hour % 12}:$minute';
      return switch (mode) {
        HyperDateTimePickerMode.date => day,
        HyperDateTimePickerMode.time => time,
        HyperDateTimePickerMode.dateTime => '$day $time',
      };
    }

    return HyperDropdown(
      enabled: enabled && onChanged != null,
      presentation: presentation,
      style: HyperSelectStyle(
        selectionStyle: HyperSelectionStyle(
          width: mode == HyperDateTimePickerMode.time
              ? _timePanelWidth(context)
              : HyperTheme.sizesOf(context).calendar.width,
          // Date content is not a list of options: let its intrinsic height
          // size the panel, with the overlay/window providing the hard bound.
          maxPanelHeight:
              HyperSelectTheme.of(context)
                  .style
                  ?.selectionStyle
                  ?.maxPanelHeight ??
              HyperSelectionTheme.of(context).style.maxPanelHeight ??
              double.infinity,
        ),
      ).merge(style),
      surfaceStyle: _pickerSurface(context, style, surfaceStyle),
      label: Text(
        value == null
            ? placeholder ??
                  switch (mode) {
                    HyperDateTimePickerMode.date => '选择日期',
                    HyperDateTimePickerMode.time => '选择时间',
                    HyperDateTimePickerMode.dateTime => '选择日期和时间',
                  }
            : (labelBuilder ?? format)(value!),
      ),
      panelBuilder: (context, close) => _PickerPanel(
        bounds: bounds,
        initial: value ?? DateTime.now(),
        onCancel: close,
        onClear: value == null
            ? null
            : () {
                close();
                onChanged?.call(null);
              },
        onConfirm: (date) {
          close();
          onChanged?.call(date);
        },
      ),
    );
  }
}

/// 只选择日期，返回本地日期的零点。
class HyperDatePicker extends StatelessWidget {
  const HyperDatePicker({
    super.key,
    required this.value,
    required this.onChanged,
    this.firstDate,
    this.lastDate,
    this.enabled = true,
    this.presentation,
    this.style,
    this.surfaceStyle,
  });
  final DateTime? value, firstDate, lastDate;
  final ValueChanged<DateTime?>? onChanged;
  final bool enabled;
  final HyperSelectPresentation? presentation;
  final HyperSelectStyle? style;
  final HyperCardStyle? surfaceStyle;
  @override
  Widget build(BuildContext context) => HyperDateTimePicker(
    value: value,
    onChanged: onChanged,
    mode: HyperDateTimePickerMode.date,
    minimum: firstDate,
    maximum: lastDate,
    enabled: enabled,
    presentation: presentation,
    style: style,
    surfaceStyle: surfaceStyle,
  );
}

/// 只选择时、分，默认遵循系统的 12/24 小时显示偏好。
class HyperTimePicker extends StatelessWidget {
  const HyperTimePicker({
    super.key,
    required this.value,
    required this.onChanged,
    this.minimum,
    this.maximum,
    this.minuteInterval = 1,
    this.enabled = true,
    this.presentation,
    this.style,
    this.surfaceStyle,
  });
  final TimeOfDay? value, minimum, maximum;
  final ValueChanged<TimeOfDay?>? onChanged;
  final int minuteInterval;
  final bool enabled;
  final HyperSelectPresentation? presentation;
  final HyperSelectStyle? style;
  final HyperCardStyle? surfaceStyle;
  DateTime? _date(TimeOfDay? time) =>
      time == null ? null : DateTime(2000, 1, 1, time.hour, time.minute);
  @override
  Widget build(BuildContext context) => HyperDateTimePicker(
    value: _date(value),
    onChanged: onChanged == null
        ? null
        : (v) => onChanged!(v == null ? null : TimeOfDay.fromDateTime(v)),
    mode: HyperDateTimePickerMode.time,
    minimum: _date(minimum),
    maximum: _date(maximum),
    minuteInterval: minuteInterval,
    showSeconds: false,
    enabled: enabled,
    presentation: presentation,
    style: style,
    surfaceStyle: surfaceStyle,
  );
}

// Civil components are compared in a UTC surrogate to avoid DST affecting
// month lengths, minute intervals or date bounds. Results are local values.
DateTime _civil(DateTime d) =>
    DateTime.utc(d.year, d.month, d.day, d.hour, d.minute, d.second);
DateTime _day(DateTime d) => DateTime.utc(d.year, d.month, d.day);

class _Bounds {
  _Bounds(
    this.mode,
    DateTime? minimum,
    DateTime? maximum,
    this.step, {
    this.seconds = false,
  }) {
    if (step <= 0 || 60 % step != 0) {
      throw ArgumentError.value(step, 'minuteInterval', '必须为 60 的正整数约数');
    }
    if (mode == HyperDateTimePickerMode.time) {
      min = DateTime.utc(
        2000,
        1,
        1,
        minimum?.hour ?? 0,
        minimum?.minute ?? 0,
        seconds ? minimum?.second ?? 0 : 0,
      );
      max = DateTime.utc(
        2000,
        1,
        1,
        maximum?.hour ?? 23,
        maximum?.minute ?? 59,
        seconds ? maximum?.second ?? 59 : 0,
      );
    } else if (mode == HyperDateTimePickerMode.date) {
      min = _day(minimum ?? DateTime(1900));
      max = _day(maximum ?? DateTime(2100, 12, 31));
    } else {
      min = _civil(minimum ?? DateTime(1900));
      if (!seconds &&
          minimum != null &&
          (minimum.second != 0 ||
              minimum.millisecond != 0 ||
              minimum.microsecond != 0)) {
        min = min.add(const Duration(minutes: 1));
      }
      max = _civil(maximum ?? DateTime(2100, 12, 31, 23, 59, seconds ? 59 : 0));
    }
    if (mode != HyperDateTimePickerMode.date) {
      if (!seconds) {
        min = DateTime.utc(min.year, min.month, min.day, min.hour, min.minute);
        max = DateTime.utc(max.year, max.month, max.day, max.hour, max.minute);
      }
      if (seconds &&
          minimum != null &&
          (minimum.millisecond != 0 || minimum.microsecond != 0)) {
        min = min.add(const Duration(seconds: 1));
      }
      if (seconds && min.minute % step != 0) {
        min = DateTime.utc(
          min.year,
          min.month,
          min.day,
          min.hour,
          min.minute + step - min.minute % step,
        );
      } else {
        min = min.add(Duration(minutes: (step - min.minute % step) % step));
      }
      if (seconds && max.minute % step != 0) {
        max = DateTime.utc(
          max.year,
          max.month,
          max.day,
          max.hour,
          max.minute - max.minute % step,
          59,
        );
      } else {
        max = max.subtract(Duration(minutes: max.minute % step));
      }
    }
    if (min.isAfter(max)) throw ArgumentError('所选范围内没有可用的日期时间');
  }
  final HyperDateTimePickerMode mode;
  final int step;
  final bool seconds;
  late DateTime min, max;
  bool get hasDate => mode != HyperDateTimePickerMode.time;
  bool get hasTime => mode != HyperDateTimePickerMode.date;

  DateTime clamp(DateTime date) {
    var d = mode == HyperDateTimePickerMode.time
        ? DateTime.utc(
            2000,
            1,
            1,
            date.hour,
            date.minute,
            seconds ? date.second : 0,
          )
        : hasTime
        ? _civil(date)
        : _day(date);
    if (hasTime && !seconds) {
      d = DateTime.utc(d.year, d.month, d.day, d.hour, d.minute);
    }
    if (hasTime) d = d.subtract(Duration(minutes: d.minute % step));
    return d.isBefore(min)
        ? min
        : d.isAfter(max)
        ? max
        : d;
  }

  List<int> minutes(DateTime date, int hour) => [
    for (var m = 0; m < 60; m += step)
      if (!DateTime.utc(
            date.year,
            date.month,
            date.day,
            hour,
            m,
            seconds ? 59 : 0,
          ).isBefore(min) &&
          !DateTime.utc(date.year, date.month, date.day, hour, m).isAfter(max))
        m,
  ];
}

class _PickerPanel extends StatefulWidget {
  const _PickerPanel({
    this.showCalendar = true,
    super.key,
    required this.bounds,
    required this.initial,
    required this.onCancel,
    required this.onConfirm,
    this.onClear,
    this.showActions = true,
    this.onDraftChanged,
  });
  final _Bounds bounds;
  final DateTime initial;
  final VoidCallback onCancel;
  final VoidCallback? onClear;
  final bool showActions;
  final bool showCalendar;
  final ValueChanged<DateTime>? onDraftChanged;
  final ValueChanged<DateTime> onConfirm;
  @override
  State<_PickerPanel> createState() => _PickerPanelState();
}

class _PickerPanelState extends State<_PickerPanel> {
  late DateTime draft = widget.bounds.clamp(widget.initial);
  _Bounds get bounds => widget.bounds;

  @override
  void didUpdateWidget(_PickerPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    draft = bounds.clamp(draft);
  }

  void change({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
  }) {
    final y = year ?? draft.year, m = month ?? draft.month;
    final lastDay = DateTime.utc(y, m + 1, 0).day;
    setState(
      () => draft = bounds.clamp(
        DateTime.utc(
          y,
          m,
          (day ?? draft.day).clamp(1, lastDay),
          hour ?? draft.hour,
          minute ?? draft.minute,
          second ?? draft.second,
        ),
      ),
    );
    widget.onDraftChanged?.call(draft);
  }

  Widget timeField(
    String label,
    int value,
    List<int> values,
    ValueChanged<int> changed,
  ) => Expanded(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (HyperTheme.sizesOf(context).deviceType != HyperDeviceType.desktop)
          Text(label),
        if (HyperTheme.sizesOf(context).deviceType == HyperDeviceType.desktop)
          _TimeNumberField(
            key: ValueKey('picker-number-$label'),
            label: label,
            value: value,
            values: values,
            onChanged: changed,
          )
        else
          HyperWheelPicker<int>(
            key: ValueKey('picker-$label'),
            style: HyperWheelPickerStyle(
              horizontalPadding: HyperTheme.sizesOf(context).menu.padding / 2,
            ),
            items: values,
            value: value,
            labelBuilder: (v) => v.toString().padLeft(2, '0'),
            onChanged: changed,
          ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final gap = HyperTheme.sizesOf(context).menu.padding;
    final fields = <Widget>[];
    final mobile =
        HyperTheme.sizesOf(context).deviceType != HyperDeviceType.desktop;
    if (mobile) {
      final columns = <Widget>[];
      void add(
        String label,
        int value,
        List<int> values,
        ValueChanged<int> changed,
      ) => columns.add(timeField(label, value, values, changed));
      if (bounds.hasDate) {
        add('年', draft.year, [
          for (var y = bounds.min.year; y <= bounds.max.year; y++) y,
        ], (v) => change(year: v));
        add('月', draft.month, [
          for (var m = 1; m <= 12; m++)
            if (!DateTime.utc(
                  draft.year,
                  m + 1,
                  0,
                  23,
                  59,
                  59,
                ).isBefore(bounds.min) &&
                !DateTime.utc(draft.year, m).isAfter(bounds.max))
              m,
        ], (v) => change(month: v));
        add('日', draft.day, [
          for (
            var d = 1;
            d <= DateTime.utc(draft.year, draft.month + 1, 0).day;
            d++
          )
            if (!DateTime.utc(
                  draft.year,
                  draft.month,
                  d,
                  23,
                  59,
                  59,
                ).isBefore(bounds.min) &&
                !DateTime.utc(draft.year, draft.month, d).isAfter(bounds.max))
              d,
        ], (v) => change(day: v));
      }
      if (bounds.hasTime) {
        add('时', draft.hour, [
          for (var h = 0; h < 24; h++)
            if (bounds.minutes(draft, h).isNotEmpty) h,
        ], (v) => change(hour: v));
        add(
          '分',
          draft.minute,
          bounds.minutes(draft, draft.hour),
          (v) => change(minute: v),
        );
        if (bounds.seconds) {
          add('秒', draft.second, [
            for (var sec = 0; sec < 60; sec++)
              if (!DateTime.utc(
                    draft.year,
                    draft.month,
                    draft.day,
                    draft.hour,
                    draft.minute,
                    sec,
                  ).isBefore(bounds.min) &&
                  !DateTime.utc(
                    draft.year,
                    draft.month,
                    draft.day,
                    draft.hour,
                    draft.minute,
                    sec,
                  ).isAfter(bounds.max))
                sec,
          ], (v) => change(second: v));
        }
      }
      fields.add(
        LayoutBuilder(
          builder: (context, constraints) {
            final text = HyperTheme.of(context).textTheme.bodyLarge!;
            final painter = TextPainter(
              text: TextSpan(text: '0000', style: text),
              textDirection: Directionality.of(context),
              textScaler: MediaQuery.textScalerOf(context),
            )..layout();
            final minimumColumn =
                painter.width + HyperTheme.sizesOf(context).menu.padding;
            painter.dispose();
            final width =
                (minimumColumn * columns.length + gap * (columns.length - 1))
                    .clamp(constraints.maxWidth, double.infinity);
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < columns.length; i++) ...[
                      if (i > 0) SizedBox(width: gap),
                      columns[i],
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      );
    }
    if (bounds.hasDate && !mobile && widget.showCalendar) {
      fields.add(
        HyperCalendar(
          value: DateTime(draft.year, draft.month, draft.day),
          initialMonth: DateTime(draft.year, draft.month),
          firstDate: DateTime(
            bounds.min.year,
            bounds.min.month,
            bounds.min.day,
          ),
          lastDate: DateTime(bounds.max.year, bounds.max.month, bounds.max.day),
          panels: HyperCalendarPanels.single,
          onChanged: (d) => change(year: d.year, month: d.month, day: d.day),
        ),
      );
    }
    if (bounds.hasTime && !mobile) {
      fields.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            timeField('时', draft.hour, [
              for (var h = 0; h < 24; h++)
                if (bounds.minutes(draft, h).isNotEmpty) h,
            ], (v) => change(hour: v)),
            if (HyperTheme.sizesOf(context).deviceType ==
                HyperDeviceType.desktop)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: gap),
                child: Text(
                  '：',
                  style: HyperTheme.of(context).textTheme.titleMedium,
                ),
              )
            else
              SizedBox(width: gap),
            timeField(
              '分',
              draft.minute,
              bounds.minutes(draft, draft.hour),
              (v) => change(minute: v),
            ),
            if (bounds.seconds) ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: gap),
                child: const Text('：'),
              ),
              timeField('秒', draft.second, [
                for (var sec = 0; sec < 60; sec++)
                  if (!DateTime.utc(
                        draft.year,
                        draft.month,
                        draft.day,
                        draft.hour,
                        draft.minute,
                        sec,
                      ).isBefore(bounds.min) &&
                      !DateTime.utc(
                        draft.year,
                        draft.month,
                        draft.day,
                        draft.hour,
                        draft.minute,
                        sec,
                      ).isAfter(bounds.max))
                    sec,
              ], (v) => change(second: v)),
            ],
          ],
        ),
      );
    }
    if (bounds.hasTime &&
        HyperTheme.sizesOf(context).deviceType == HyperDeviceType.desktop) {
      fields.add(
        Row(
          children: [
            Expanded(
              child: Text(
                '时',
                style: HyperTheme.of(context).textTheme.bodySmall,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: gap),
              child: Text(
                '：',
                style: HyperTheme.of(context).textTheme.titleMedium
                    ?.copyWith(color: Colors.transparent),
              ),
            ),
            Expanded(
              child: Text(
                '分',
                style: HyperTheme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final f in fields) ...[f, SizedBox(height: gap)],
        if (widget.showActions)
          HyperSelectionActions(
            onClear: widget.onClear,
            onCancel: widget.onCancel,
            onConfirm: () => widget.onConfirm(
              DateTime(
                draft.year,
                draft.month,
                draft.day,
                draft.hour,
                draft.minute,
                draft.second,
              ),
            ),
          ),
      ],
    );
  }
}

class _TimeNumberField extends StatelessWidget {
  const _TimeNumberField({
    super.key,
    required this.label,
    required this.value,
    required this.values,
    required this.onChanged,
  });
  final String label;
  final int value;
  final List<int> values;
  final ValueChanged<int> onChanged;
  @override
  Widget build(BuildContext context) => HyperNumberInput(
    value: value.toDouble(),
    minimum: values.first.toDouble(),
    maximum: values.last.toDouble(),
    precision: 0,
    minimumIntegerDigits: 2,
    step: values.length > 1 ? (values[1] - values[0]).toDouble() : 1,
    semanticLabel: label,
    onChanged: (n) {
      if (n == null) return;
      final nearest = values.reduce(
        (a, b) => (a - n).abs() <= (b - n).abs() ? a : b,
      );
      onChanged(nearest);
    },
  );
}

/// 一个触发器和一个编辑面板，统一提交开始、结束值。
/// time 模式以同一天的时分比较，不支持跨午夜区间。
class HyperDateTimeRangePicker extends StatefulWidget {
  const HyperDateTimeRangePicker({
    super.key,
    required this.value,
    required this.onChanged,
    this.mode = HyperDateTimePickerMode.dateTime,
    this.minimum,
    this.maximum,
    this.minuteInterval = 1,
    this.showSeconds = false,
    this.presentation,
    this.style,
    this.surfaceStyle,
    this.enabled = true,
  });
  final DateTimeRange? value;
  final ValueChanged<DateTimeRange?>? onChanged;
  final HyperDateTimePickerMode mode;
  final DateTime? minimum, maximum;
  final int minuteInterval;
  final bool showSeconds;
  final HyperSelectPresentation? presentation;
  final HyperSelectStyle? style;
  final HyperCardStyle? surfaceStyle;
  final bool enabled;
  String format(DateTime d) {
    final date = '${d.year}年${d.month}月${d.day}日';
    final time =
        '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
    return switch (mode) {
      HyperDateTimePickerMode.date => date,
      HyperDateTimePickerMode.time => time,
      HyperDateTimePickerMode.dateTime => '$date $time',
    };
  }

  @override
  State<HyperDateTimeRangePicker> createState() => _RangePickerHostState();
}

class _RangePickerHostState extends State<HyperDateTimeRangePicker> {
  final _valid = ValueNotifier<bool>(true);
  @override
  void dispose() {
    _valid.dispose();
    super.dispose();
  }

  HyperDateTimePickerMode get mode => widget.mode;
  DateTime? get minimum => widget.minimum;
  DateTime? get maximum => widget.maximum;
  int get minuteInterval => widget.minuteInterval;
  bool get showSeconds => widget.showSeconds;
  bool get enabled => widget.enabled;
  DateTimeRange? get value => widget.value;
  ValueChanged<DateTimeRange?>? get onChanged => widget.onChanged;
  HyperSelectPresentation? get presentation => widget.presentation;
  HyperSelectStyle? get style => widget.style;
  HyperCardStyle? get surfaceStyle => widget.surfaceStyle;
  String format(DateTime d) => widget.format(d);
  @override
  Widget build(BuildContext context) {
    final bounds = _Bounds(
      mode,
      minimum,
      maximum,
      minuteInterval,
      seconds: showSeconds,
    );
    return HyperDropdown(
      modalTitle: ValueListenableBuilder<bool>(
        valueListenable: _valid,
        builder: (context, valid, _) => Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: HyperTheme.sizesOf(context).menu.padding,
          children: [
            const Text('选择'),
            if (!valid)
              Semantics(
                liveRegion: true,
                child: Text(
                  '结束不能早于开始',
                  style: HyperTheme.of(context).textTheme.bodySmall
                      ?.copyWith(color: HyperTheme.of(context).colors.error),
                ),
              ),
          ],
        ),
      ),
      enabled: enabled && onChanged != null,
      presentation: presentation,
      style: HyperSelectStyle(
        selectionStyle: HyperSelectionStyle(
          width:
              HyperTheme.sizesOf(context).deviceType == HyperDeviceType.desktop
              ? (mode == HyperDateTimePickerMode.time
                            ? HyperTheme.sizesOf(context).select.width
                            : HyperTheme.sizesOf(context).calendar.width) *
                        2 +
                    HyperTheme.sizesOf(context).menu.padding
              : HyperTheme.sizesOf(context).calendar.width,
          maxPanelHeight:
              HyperSelectTheme.of(context)
                  .style
                  ?.selectionStyle
                  ?.maxPanelHeight ??
              HyperSelectionTheme.of(context).style.maxPanelHeight ??
              double.infinity,
        ),
      ).merge(style),
      surfaceStyle: _pickerSurface(context, style, surfaceStyle),
      label: Text(
        value == null
            ? switch (mode) {
                HyperDateTimePickerMode.date => '选择日期区间',
                HyperDateTimePickerMode.time => '选择时间段',
                HyperDateTimePickerMode.dateTime => '选择日期时间区间',
              }
            : '${format(value!.start)} — ${format(value!.end)}',
      ),
      panelBuilder: (context, close) => _RangePanel(
        bounds: bounds,
        value: value,
        onValidationChanged: (valid) => _valid.value = valid,
        onCancel: close,
        onClear: value == null
            ? null
            : () {
                close();
                onChanged?.call(null);
              },
        onConfirm: (range) {
          close();
          onChanged?.call(range);
        },
      ),
    );
  }
}

class _RangePanel extends StatefulWidget {
  const _RangePanel({
    required this.bounds,
    required this.value,
    required this.onCancel,
    required this.onClear,
    required this.onConfirm,
    required this.onValidationChanged,
  });
  final _Bounds bounds;
  final DateTimeRange? value;
  final VoidCallback onCancel;
  final VoidCallback? onClear;
  final ValueChanged<DateTimeRange> onConfirm;
  final ValueChanged<bool> onValidationChanged;
  @override
  State<_RangePanel> createState() => _RangePanelState();
}

class _RangePanelState extends State<_RangePanel> {
  late DateTime start = widget.bounds.clamp(
    widget.value?.start ?? DateTime.now(),
  );
  late DateTime end = widget.bounds.clamp(widget.value?.end ?? start);
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onValidationChanged(!start.isAfter(end));
    });
  }

  DateTime local(DateTime d) =>
      DateTime(d.year, d.month, d.day, d.hour, d.minute, d.second);
  @override
  Widget build(BuildContext context) {
    final gap = HyperTheme.sizesOf(context).menu.padding;
    final valid = !start.isAfter(end);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!valid &&
            HyperTheme.sizesOf(context).deviceType == HyperDeviceType.desktop)
          Text(
            '结束不能早于开始',
            style: HyperTheme.of(context).textTheme.bodySmall
                ?.copyWith(color: HyperTheme.of(context).colors.error),
          ),
        if (widget.bounds.hasDate &&
            HyperTheme.sizesOf(context).deviceType == HyperDeviceType.desktop)
          HyperCalendar.range(
            key: const ValueKey('range-calendar'),
            value: DateTimeRange(
              start: local(start),
              end: local(end.isBefore(start) ? start : end),
            ),
            firstDate: local(widget.bounds.min),
            lastDate: local(widget.bounds.max),
            panels: HyperCalendarPanels.doubleMonth,
            onChanged: (range) {
              setState(() {
                start = widget.bounds.clamp(
                  DateTime.utc(
                    range.start.year,
                    range.start.month,
                    range.start.day,
                    start.hour,
                    start.minute,
                    start.second,
                  ),
                );
                end = widget.bounds.clamp(
                  DateTime.utc(
                    range.end.year,
                    range.end.month,
                    range.end.day,
                    end.hour,
                    end.minute,
                    end.second,
                  ),
                );
              });
              widget.onValidationChanged(!start.isAfter(end));
            },
          ),
        if (widget.bounds.mode != HyperDateTimePickerMode.date ||
            HyperTheme.sizesOf(context).deviceType != HyperDeviceType.desktop)
          LayoutBuilder(
            builder: (context, constraints) {
              final sizes = HyperTheme.sizesOf(context);
              final panelWidth =
                  widget.bounds.mode == HyperDateTimePickerMode.time
                  ? sizes.select.width
                  : sizes.calendar.width;
              final horizontal =
                  sizes.deviceType == HyperDeviceType.desktop &&
                  constraints.maxWidth >= panelWidth * 2 + gap;
              final panels = <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('开始'),
                    _PickerPanel(
                      key:
                          widget.bounds.hasDate &&
                              sizes.deviceType == HyperDeviceType.desktop
                          ? ValueKey((
                              'range-start',
                              start.year,
                              start.month,
                              start.day,
                            ))
                          : const ValueKey('range-start'),
                      showCalendar: false,
                      bounds: widget.bounds,
                      initial: start,
                      onCancel: () {},
                      onConfirm: (_) {},
                      showActions: false,
                      onDraftChanged: (v) {
                        setState(() => start = v);
                        widget.onValidationChanged(!start.isAfter(end));
                      },
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('结束'),
                    _PickerPanel(
                      key:
                          widget.bounds.hasDate &&
                              sizes.deviceType == HyperDeviceType.desktop
                          ? ValueKey((
                              'range-end',
                              end.year,
                              end.month,
                              end.day,
                            ))
                          : const ValueKey('range-end'),
                      showCalendar: false,
                      bounds: widget.bounds,
                      initial: end,
                      onCancel: () {},
                      onConfirm: (_) {},
                      showActions: false,
                      onDraftChanged: (v) {
                        setState(() => end = v);
                        widget.onValidationChanged(!start.isAfter(end));
                      },
                    ),
                  ],
                ),
              ];
              return horizontal
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: panels[0]),
                        SizedBox(width: gap),
                        Expanded(child: panels[1]),
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        panels[0],
                        SizedBox(height: gap),
                        panels[1],
                      ],
                    );
            },
          ),
        SizedBox(height: gap),
        HyperSelectionActions(
          onClear: widget.onClear,
          onCancel: widget.onCancel,
          onConfirm: valid
              ? () => widget.onConfirm(
                  DateTimeRange(start: local(start), end: local(end)),
                )
              : null,
        ),
      ],
    );
  }
}
