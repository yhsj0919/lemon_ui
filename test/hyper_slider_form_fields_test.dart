import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  testWidgets('slider adapters validate update and reset', (t) async {
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
                  HyperSliderFormField(
                    name: 'single',
                    min: 0,
                    max: 100,
                    initialValue: 20,
                    validator: (v) => v! < 30 ? '至少 30' : null,
                  ),
                  HyperRangeSliderFormField(
                    name: 'range',
                    min: 0,
                    max: 100,
                    initialValue: const RangeValues(20, 80),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await t.pumpAndSettle();
    expect(await c.validate(), false);
    await t.pumpAndSettle();
    await t.drag(find.byType(HyperSlider), const Offset(220, 0));
    await t.pumpAndSettle();
    expect(c.value<double>('single'), greaterThan(20));
    t.widget<HyperRangeSlider>(find.byType(HyperRangeSlider)).onChanged!(
      const RangeValues(30, 70),
    );
    await t.pumpAndSettle();
    expect(c.value<RangeValues>('range'), const RangeValues(30, 70));
    expect(c.isDirty, true);
    expect(await c.validate(), true);
    c.reset();
    await t.pumpAndSettle();
    expect(t.widget<HyperSlider>(find.byType(HyperSlider)).value, 20);
    expect(
      t.widget<HyperRangeSlider>(find.byType(HyperRangeSlider)).values,
      const RangeValues(20, 80),
    );
    expect(c.isDirty, false);
    expect(t.takeException(), isNull);
  });

  testWidgets('disabled sliders retain defaults and skip validators', (
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
                  HyperSliderFormField(
                    name: 'single',
                    enabled: false,
                    min: 10,
                    max: 20,
                    validator: (_) => '不应校验',
                  ),
                  HyperRangeSliderFormField(
                    name: 'range',
                    enabled: false,
                    min: 10,
                    max: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await t.pumpAndSettle();
    expect(t.widget<HyperSlider>(find.byType(HyperSlider)).onChanged, isNull);
    expect(
      t.widget<HyperRangeSlider>(find.byType(HyperRangeSlider)).onChanged,
      isNull,
    );
    expect(c.value<double>('single'), 10);
    expect(c.value<RangeValues>('range'), const RangeValues(10, 20));
    expect(await c.validate(), true);
    expect(t.takeException(), isNull);
  });

  test('invalid slider initial values and bounds reject', () {
    expect(() => HyperSliderFormField(min: 2, max: 1), throwsArgumentError);
    expect(() => HyperSliderFormField(initialValue: 2), throwsArgumentError);
    expect(() => HyperSliderFormField(divisions: 0), throwsArgumentError);
    expect(
      () => HyperRangeSliderFormField(initialValue: const RangeValues(.8, .2)),
      throwsArgumentError,
    );
  });
}
