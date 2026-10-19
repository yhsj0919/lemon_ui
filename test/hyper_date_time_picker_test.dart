import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

Widget host(
  Widget child, {
  double scale = 1,
  double width = 320,
  HyperDeviceType device = HyperDeviceType.desktop,
}) => MaterialApp(
  home: HyperDeviceDetector(
    deviceType: device,
    builder: (context, resolvedDevice, unused) => HyperTheme(
      data: HyperThemeData.light(),

      child: MediaQuery(
        data: MediaQueryData(
          size: const Size(800, 600),
          textScaler: TextScaler.linear(scale),
        ),
        child: Scaffold(
          body: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(width: width, child: child),
          ),
        ),
      ),
    ),
  ),
);

Future<void> open(
  WidgetTester tester,
  Widget widget, {
  double scale = 1,
  HyperDeviceType device = HyperDeviceType.phone,
}) async {
  await tester.pumpWidget(host(widget, scale: scale, device: device));
  await tester.pumpAndSettle();
  await tester.tap(find.byType(HyperDropdown));
  await tester.pumpAndSettle();
}

Future<void> confirm(WidgetTester tester) async {
  await tester.ensureVisible(find.text('确定'));
  await tester.tap(find.text('确定'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('desktop time actions fit one row by default', (tester) async {
    await open(
      tester,
      HyperTimePicker(
        value: const TimeOfDay(hour: 16, minute: 45),
        onChanged: (_) {},
      ),
      device: HyperDeviceType.desktop,
    );
    final cancelY = tester.getCenter(find.text('取消')).dy;
    expect(tester.getCenter(find.text('确定')).dy, closeTo(cancelY, .01));
    expect(tester.getCenter(find.text('清空')).dy, closeTo(cancelY, .01));
    expect(tester.takeException(), isNull);
  });
  testWidgets(
    'desktop picker padding uses editing inset and preserves explicit override',
    (tester) async {
      for (final explicit in [false, true]) {
        await open(
          tester,
          HyperDateTimePicker(
            value: DateTime(2026, 10, 19),
            onChanged: (_) {},
            surfaceStyle: explicit
                ? HyperCardStyle(padding: const EdgeInsets.all(3))
                : null,
          ),
          device: HyperDeviceType.desktop,
        );
        final context = tester.element(find.byType(HyperDropdown));
        expect(
          tester.widget<HyperCard>(find.byType(HyperCard)).style!.padding,
          explicit
              ? const EdgeInsets.all(3)
              : HyperTheme.sizesOf(context).dialog.padding
                    .resolve(Directionality.of(context))
                    .copyWith(
                      left: HyperTheme.sizesOf(context).menu.padding,
                      right: HyperTheme.sizesOf(context).menu.padding,
                    ),
        );
        await tester.tap(find.text('取消'));
        await tester.pumpAndSettle();
      }
    },
  );
  testWidgets('mobile invalid range hint stays in modal title', (tester) async {
    await open(
      tester,
      HyperDateTimeRangePicker(
        value: DateTimeRange(
          start: DateTime(2000, 1, 1, 9),
          end: DateTime(2000, 1, 1, 10),
        ),
        mode: HyperDateTimePickerMode.time,
        onChanged: (_) {},
      ),
    );
    final start = find.byKey(const ValueKey('range-start'));
    tester
        .widget<HyperWheelPicker<int>>(
          find.descendant(
            of: start,
            matching: find.byKey(const ValueKey('picker-时')),
          ),
        )
        .onChanged!(11);
    await tester.pumpAndSettle();
    final hint = find.text('结束不能早于开始');
    expect(hint, findsOneWidget);
    final sheet = tester.widget<HyperBottomSheet>(
      find.byType(HyperBottomSheet),
    );
    expect(
      find.descendant(of: find.byWidget(sheet.title!), matching: hint),
      findsOneWidget,
    );
    tester
        .widget<HyperWheelPicker<int>>(
          find.descendant(
            of: start,
            matching: find.byKey(const ValueKey('picker-时')),
          ),
        )
        .onChanged!(9);
    await tester.pumpAndSettle();
    expect(hint, findsNothing);
  });
  for (final scale in [1.0, 1.3, 2.0]) {
    testWidgets('mobile six wheel columns preserve seconds at scale $scale', (
      tester,
    ) async {
      DateTime? result;
      await open(
        tester,
        HyperDateTimePicker(
          value: DateTime(2024, 1, 31, 9, 30, 25),
          showSeconds: true,
          onChanged: (v) => result = v,
        ),
        scale: scale,
      );
      expect(find.byType(HyperCalendar), findsNothing);
      expect(find.byType(HyperWheelPicker<int>), findsNWidgets(6));
      tester
          .widget<HyperWheelPicker<int>>(find.byKey(const ValueKey('picker-月')))
          .onChanged!(2);
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<HyperWheelPicker<int>>(
              find.byKey(const ValueKey('picker-日')),
            )
            .value,
        29,
      );
      tester
          .widget<HyperWheelPicker<int>>(find.byKey(const ValueKey('picker-秒')))
          .onChanged!(42);
      await tester.pumpAndSettle();
      await confirm(tester);
      expect(result, DateTime(2024, 2, 29, 9, 30, 42));
      expect(tester.takeException(), isNull);
    });
  }
  for (final mode in HyperDateTimePickerMode.values) {
    testWidgets('single range popup commits both endpoints for $mode', (
      tester,
    ) async {
      DateTimeRange? result;
      final initial = DateTimeRange(
        start: DateTime(2026, 10, 19, 9, 0),
        end: DateTime(2026, 10, 20, 18, 0),
      );
      await open(
        tester,
        HyperDateTimeRangePicker(
          value: initial,
          mode: mode,
          onChanged: (v) => result = v,
        ),
        device: HyperDeviceType.desktop,
      );
      if (mode == HyperDateTimePickerMode.date) {
        final calendar = tester.widget<HyperCalendar>(
          find.byType(HyperCalendar),
        );
        expect(calendar.range, isTrue);
        expect(calendar.panels, HyperCalendarPanels.doubleMonth);
        final selected = DateTimeRange(
          start: DateTime(2026, 10, 25),
          end: DateTime(2026, 11, 5),
        );
        calendar.onRangeChanged!(selected);
        await tester.pumpAndSettle();
      } else {
        expect(find.text('开始'), findsOneWidget);
        expect(find.text('结束'), findsOneWidget);
      }
      expect(find.text('确定'), findsOneWidget);
      expect(find.byType(HyperDropdown), findsOneWidget);
      expect(result, isNull);
      await confirm(tester);
      expect(result, isNotNull);
      expect(result!.start.isAfter(result!.end), isFalse);
      if (mode == HyperDateTimePickerMode.date) {
        expect(result!.start, DateTime(2026, 10, 25));
        expect(result!.end, DateTime(2026, 11, 5));
      }
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets(
    'clear submits null and restores placeholder for all picker modes',
    (tester) async {
      for (final mode in HyperDateTimePickerMode.values) {
        DateTime? value = DateTime(2026, 10, 19, 9, 30);
        var calls = 0;
        await tester.pumpWidget(
          host(
            StatefulBuilder(
              builder: (context, setState) => HyperDateTimePicker(
                value: value,
                mode: mode,
                onChanged: (v) {
                  calls++;
                  setState(() => value = v);
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byType(HyperDropdown));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('清空'));
        await tester.tap(find.text('清空'));
        await tester.pumpAndSettle();
        expect(value, isNull);
        expect(calls, 1);
        expect(find.text('确定'), findsNothing);
        expect(
          find.text(switch (mode) {
            HyperDateTimePickerMode.date => '选择日期',
            HyperDateTimePickerMode.time => '选择时间',
            HyperDateTimePickerMode.dateTime => '选择日期和时间',
          }),
          findsOneWidget,
        );
      }
    },
  );
  for (final scale in [1.0, 1.3, 2.0]) {
    testWidgets('desktop datetime numeric layout scales $scale', (
      tester,
    ) async {
      await open(
        tester,
        HyperDateTimePicker(
          value: DateTime(2026, 10, 19, 9, 30),
          onChanged: (_) {},
        ),
        device: HyperDeviceType.desktop,
        scale: scale,
      );
      expect(find.byType(HyperCalendar), findsOneWidget);
      expect(find.byType(HyperTextField), findsNWidgets(2));
      expect(find.byType(HyperWheelPicker<int>), findsNothing);
      await confirm(tester);
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets('desktop uses compact numeric time inputs with step controls', (
    tester,
  ) async {
    TimeOfDay? result;
    await open(
      tester,
      HyperTimePicker(
        value: const TimeOfDay(hour: 9, minute: 30),
        minuteInterval: 15,
        onChanged: (v) => result = v,
      ),
      device: HyperDeviceType.desktop,
    );
    expect(find.byType(HyperWheelPicker<int>), findsNothing);
    expect(find.byType(HyperTextField), findsNWidgets(2));
    expect(find.byType(HyperNumberInput), findsNWidgets(2));
    await tester.tap(
      find.descendant(
        of: find.byKey(const ValueKey('picker-number-分')),
        matching: find.byIcon(Icons.keyboard_arrow_up),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      tester.widget<TextField>(find.byType(TextField).last).controller!.text,
      '45',
    );
    await tester.enterText(find.byType(TextField).first, '14');
    await tester.pumpAndSettle();
    await confirm(tester);
    expect(result, const TimeOfDay(hour: 14, minute: 45));
    expect(tester.takeException(), isNull);
  });
  testWidgets('selected field values default to Chinese even in English host', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(HyperDatePicker(value: DateTime(2026, 10, 22), onChanged: (_) {})),
    );
    await tester.pumpAndSettle();
    expect(find.text('2026年10月22日'), findsOneWidget);
    await tester.pumpWidget(
      host(
        HyperTimePicker(
          value: const TimeOfDay(hour: 15, minute: 5),
          onChanged: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('下午3:05'), findsOneWidget);
    await tester.pumpWidget(
      host(
        HyperDateTimePicker(
          value: DateTime(2026, 10, 22, 9, 5),
          onChanged: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('2026年10月22日 上午9:05'), findsOneWidget);
  });
  testWidgets(
    'default date panel shows full calendar and actions without list-height clipping',
    (tester) async {
      await open(
        tester,
        HyperDatePicker(value: DateTime(2026, 10, 19), onChanged: (_) {}),
      );
      expect(find.byType(HyperCard), findsNothing);
      final cardRect = tester.getRect(find.byType(HyperBottomSheet).first);
      final lastDay = tester.getRect(find.byKey(const ValueKey('picker-日')));
      final action = tester.getRect(find.text('确定'));
      expect(lastDay.bottom, lessThanOrEqualTo(cardRect.bottom));
      expect(action.bottom, lessThanOrEqualTo(cardRect.bottom));
      await tester.tap(find.text('确定'));
      await tester.pumpAndSettle();
      expect(find.byType(HyperCalendar), findsNothing);
    },
  );
  testWidgets('date calendar drafts before confirmation', (tester) async {
    DateTime? result;
    await open(
      tester,
      HyperDatePicker(
        value: DateTime(2024, 2, 10),
        onChanged: (v) => result = v,
      ),
    );
    expect(find.byType(HyperCalendar), findsNothing);
    expect(find.byType(HyperWheelPicker<int>), findsNWidgets(3));
    tester
        .widget<HyperWheelPicker<int>>(find.byKey(const ValueKey('picker-日')))
        .onChanged!(29);
    await tester.pumpAndSettle();
    expect(result, isNull);
    await confirm(tester);
    expect(result, DateTime(2024, 2, 29));
  });
  testWidgets('time wheels commit and cancel resets draft', (tester) async {
    TimeOfDay? result;
    final widget = HyperTimePicker(
      value: const TimeOfDay(hour: 9, minute: 30),
      minuteInterval: 15,
      onChanged: (v) => result = v,
    );
    await open(tester, widget);
    tester
        .widget<HyperWheelPicker<int>>(find.byKey(const ValueKey('picker-分')))
        .onChanged!(45);
    await tester.pumpAndSettle();
    expect(result, isNull);
    await tester.ensureVisible(find.text('取消'));
    await tester.tap(find.text('取消'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(HyperDropdown));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<HyperWheelPicker<int>>(find.byKey(const ValueKey('picker-分')))
          .value,
      30,
    );
    tester
        .widget<HyperWheelPicker<int>>(find.byKey(const ValueKey('picker-时')))
        .onChanged!(10);
    await tester.pumpAndSettle();
    await confirm(tester);
    expect(result, const TimeOfDay(hour: 10, minute: 30));
  });
  testWidgets('datetime calendar and wheels filter boundary minutes', (
    tester,
  ) async {
    DateTime? result;
    await open(
      tester,
      HyperDateTimePicker(
        value: DateTime(2026, 10, 19, 8),
        minimum: DateTime(2026, 10, 19, 9, 7),
        maximum: DateTime(2026, 10, 20, 10, 44),
        minuteInterval: 15,
        onChanged: (v) => result = v,
      ),
    );
    expect(find.byType(HyperCalendar), findsNothing);
    var minutes = tester.widget<HyperWheelPicker<int>>(
      find.byKey(const ValueKey('picker-分')),
    );
    expect(minutes.value, 15);
    expect(minutes.items, [15, 30, 45]);
    tester
        .widget<HyperWheelPicker<int>>(find.byKey(const ValueKey('picker-日')))
        .onChanged!(20);
    await tester.pumpAndSettle();
    tester
        .widget<HyperWheelPicker<int>>(find.byKey(const ValueKey('picker-时')))
        .onChanged!(10);
    await tester.pumpAndSettle();
    minutes = tester.widget<HyperWheelPicker<int>>(
      find.byKey(const ValueKey('picker-分')),
    );
    expect(minutes.items, [0, 15, 30]);
    await confirm(tester);
    expect(result, DateTime(2026, 10, 20, 10, 15));
  });
  for (final scale in [1.0, 1.3, 2.0]) {
    testWidgets('datetime scale $scale scrolls to actions', (tester) async {
      await open(
        tester,
        HyperDateTimePicker(
          value: DateTime(2026, 10, 19, 9, 30),
          onChanged: (_) {},
        ),
        scale: scale,
      );
      expect(find.byType(HyperCalendar), findsNothing);
      expect(find.byType(HyperWheelPicker<int>), findsNWidgets(5));
      await confirm(tester);
      expect(tester.takeException(), isNull);
    });
  }
  for (final device in [
    HyperDeviceType.phone,
    HyperDeviceType.tablet,
    HyperDeviceType.watch,
  ]) {
    testWidgets('adaptive time $device', (tester) async {
      await open(
        tester,
        HyperTimePicker(
          value: const TimeOfDay(hour: 9, minute: 30),
          onChanged: (_) {},
        ),
        device: device,
      );
      expect(find.byType(HyperWheelPicker<int>), findsNWidgets(2));
      await confirm(tester);
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets('instance empty shadows retained', (tester) async {
    await open(
      tester,
      HyperDatePicker(
        value: DateTime(2026, 10, 19),
        onChanged: (_) {},
        surfaceStyle: HyperCardStyle(boxShadow: []),
      ),
    );
    expect(
      tester
          .widget<HyperBottomSheet>(find.byType(HyperBottomSheet).first)
          .style!
          .boxShadow,
      isEmpty,
    );
  });
}
