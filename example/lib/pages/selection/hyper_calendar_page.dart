import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import '../../gallery/demo_section.dart';

class HyperCalendarPage extends StatefulWidget {
  const HyperCalendarPage({super.key});
  @override
  State<HyperCalendarPage> createState() => _State();
}

class _State extends State<HyperCalendarPage> {
  DateTime? value;
  DateTimeRange? range, dualRange;
  @override
  Widget build(BuildContext context) => ListView(
    padding: EdgeInsets.all(HyperTheme.sizesOf(context).pageHorizontalPadding),
    children: [
      DemoSection(
        title: '普通日历 · 默认主题',
        child: HyperCalendar(
          value: value,
          onChanged: (v) => setState(() => value = v),
        ),
      ),
      DemoSection(
        title: '日期区间 · 默认主题',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HyperText('先选择起点，再选择终点；支持反向、跨月与同日区间。'),
            if (range != null)
              HyperText(
                '${MaterialLocalizations.of(context).formatMediumDate(range!.start)} — ${MaterialLocalizations.of(context).formatMediumDate(range!.end)}',
              ),
            HyperCalendar.range(
              value: range,
              onChanged: (v) => setState(() => range = v),
            ),
          ],
        ),
      ),
      DemoSection(
        title: '双月日期区间',
        child: HyperCalendar.range(
          value: dualRange,
          panels: HyperCalendarPanels.doubleMonth,
          onChanged: (v) => setState(() => dualRange = v),
        ),
      ),
      DemoSection(
        title: '限定范围与禁用周末',
        child: HyperCalendar(
          value: value,
          initialMonth: DateTime(2026, 10),
          firstDate: DateTime(2026, 10, 5),
          lastDate: DateTime(2026, 11, 20),
          selectableDayPredicate: (d) => d.weekday < 6,
          onChanged: (v) => setState(() => value = v),
        ),
      ),
    ],
  );
}
