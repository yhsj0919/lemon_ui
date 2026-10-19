import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import '../../gallery/demo_section.dart';

class HyperDateTimePickerPage extends StatefulWidget {
  const HyperDateTimePickerPage({super.key});
  @override
  State<HyperDateTimePickerPage> createState() => _State();
}

class _State extends State<HyperDateTimePickerPage> {
  DateTime? date, dateTime, boundedDateTime;
  TimeOfDay? time;
  DateTimeRange? timeRange, dateRange, dateTimeRange;
  @override
  Widget build(BuildContext context) => ListView(
    padding: EdgeInsets.all(HyperTheme.sizesOf(context).pageHorizontalPadding),
    children: [
      const HyperText('未确认：日期使用日历，时间使用时分滚轮，日期时间组合两者。面板内编辑草稿，确定后提交，取消保留原值。'),
      DemoSection(
        title: '日期选择 · 默认主题',
        child: HyperDatePicker(
          value: date,
          onChanged: (v) => setState(() => date = v),
        ),
      ),
      DemoSection(
        title: '时间选择 · 默认主题',
        child: HyperTimePicker(
          value: time,
          onChanged: (v) => setState(() => time = v),
        ),
      ),
      DemoSection(
        title: '时间段 · 单面板',
        child: HyperDateTimeRangePicker(
          value: timeRange,
          mode: HyperDateTimePickerMode.time,
          minuteInterval: 15,
          onChanged: (v) => setState(() => timeRange = v),
        ),
      ),
      DemoSection(
        title: '日期区间 · 单面板',
        child: HyperDateTimeRangePicker(
          value: dateRange,
          mode: HyperDateTimePickerMode.date,
          onChanged: (v) => setState(() => dateRange = v),
        ),
      ),
      DemoSection(
        title: '日期时间区间 · 单面板',
        child: HyperDateTimeRangePicker(
          value: dateTimeRange,
          minuteInterval: 15,
          onChanged: (v) => setState(() => dateTimeRange = v),
        ),
      ),
      DemoSection(
        title: '日期和时间 · 默认主题',
        child: HyperDateTimePicker(
          value: dateTime,
          showSeconds: true,
          onChanged: (v) => setState(() => dateTime = v),
        ),
      ),
      DemoSection(
        title: '限定日期与 15 分钟步进',
        child: HyperDateTimePicker(
          value: boundedDateTime,
          minimum: DateTime(2026, 10, 19, 9),
          maximum: DateTime(2026, 10, 23, 18),
          minuteInterval: 15,
          onChanged: (v) => setState(() => boundedDateTime = v),
        ),
      ),
      const DemoSection(
        title: '禁用',
        child: HyperTimePicker(value: null, onChanged: null),
      ),
    ],
  );
}
