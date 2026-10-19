import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  testWidgets('date and time adapters clear validate and reset together', (
    t,
  ) async {
    final c = HyperFormController();
    final date = DateTime(2026, 10, 19);
    final range = DateTimeRange(
      start: date,
      end: date.add(const Duration(days: 1)),
    );
    await t.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: Scaffold(
            body: HyperForm(
              controller: c,
              child: HyperFormSection(
                children: [
                  HyperDateFormField(
                    name: 'date',
                    initialValue: date,
                    validator: (v) => v == null ? '请选择日期' : null,
                  ),
                  HyperTimeFormField(
                    name: 'time',
                    initialValue: const TimeOfDay(hour: 10, minute: 15),
                  ),
                  HyperDateTimeFormField(name: 'dateTime', initialValue: date),
                  HyperDateTimeRangeFormField(
                    name: 'range',
                    initialValue: range,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await t.pumpAndSettle();
    t.widget<HyperDatePicker>(find.byType(HyperDatePicker)).onChanged!(null);
    t.widget<HyperTimePicker>(find.byType(HyperTimePicker)).onChanged!(null);
    final fullPicker = find.byWidgetPredicate(
      (w) =>
          w is HyperDateTimePicker &&
          w.mode == HyperDateTimePickerMode.dateTime,
    );
    t.widget<HyperDateTimePicker>(fullPicker).onChanged!(null);
    t
        .widget<HyperDateTimeRangePicker>(find.byType(HyperDateTimeRangePicker))
        .onChanged!(null);
    await t.pumpAndSettle();
    expect(c.values.values, everyElement(isNull));
    expect(c.dirtyFields.length, 4);
    expect(await c.validate(), false);
    await t.pumpAndSettle();
    expect(find.byTooltip('请选择日期'), findsOneWidget);
    c.reset();
    await t.pumpAndSettle();
    expect(c.values['date'], date);
    expect(c.values['range'], range);
    expect(c.isDirty, false);
    expect(await c.validate(), true);
    expect(t.takeException(), isNull);
  });

  testWidgets('disabled picker adapters retain values and disable controls', (
    t,
  ) async {
    final c = HyperFormController();
    await t.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: Scaffold(
            body: HyperForm(
              controller: c,
              child: HyperFormSection(
                children: [
                  HyperDateFormField(enabled: false, validator: (_) => '跳过'),
                  HyperTimeFormField(enabled: false),
                  HyperDateTimeFormField(enabled: false),
                  HyperDateTimeRangeFormField(enabled: false),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await t.pumpAndSettle();
    for (final picker in t.widgetList<HyperDateTimePicker>(
      find.byType(HyperDateTimePicker),
    )) {
      expect(picker.enabled, false);
      expect(picker.onChanged, isNull);
    }
    expect(
      t
          .widget<HyperDateTimeRangePicker>(
            find.byType(HyperDateTimeRangePicker),
          )
          .onChanged,
      isNull,
    );
    expect(await c.validate(), true);
    expect(t.takeException(), isNull);
  });
}
